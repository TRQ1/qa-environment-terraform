locals {
  enabled = var.enabled
  cluster_encryption_config = {
    resources        = var.cluster_encryption_config_resources
    provider_key_arn = local.enabled && var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? join("", aws_kms_key.eks_cluster.*.arn) : var.cluster_encryption_config_kms_key_id
  }
}


// Create Assume Role 
data "aws_iam_policy_document" "assume_role" {
  count = local.enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "cluster_elb_service_role" {
  count = local.enabled ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeAddresses",
      "ec2:DescribeInternetGateways",
      "elasticloadbalancing:SetIpAddressType",
      "elasticloadbalancing:SetSubnets"
    ]
    resources = ["*"]
  }
}

data "tls_certificate" "default" {
  url = aws_eks_cluster.eks_cluster[0].identity[0].oidc[0].issuer
}

data "aws_partition" "current" {
  count = local.enabled ? 1 : 0
}

resource "aws_security_group" "default" {
  count       = local.enabled ? 1 : 0
  name        = var.sg_name
  description = "Security Group for EKS cluster"
  vpc_id      = var.vpc_id
  tags = {
    Name = var.sg_name
  }
}

resource "aws_security_group_rule" "egress" {
  count             = local.enabled ? 1 : 0
  description       = "Allow all egress traffic"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "egress"
}

resource "aws_security_group_rule" "ingress_security_groups" {
  count                    = local.enabled ? length(var.allowed_security_groups) : 0
  from_port                = 0
  to_port                  = 65535
  protocol                 = "-1"
  source_security_group_id = var.allowed_security_groups[count.index]
  security_group_id        = join("", aws_security_group.default.*.id)
  type                     = "ingress"
}

resource "aws_security_group_rule" "ingress_cidr_blocks" {
  count             = local.enabled && length(var.allowed_cidr_blocks) > 0 ? 1 : 0
  from_port         = 0
  to_port           = 65535
  protocol          = "-1"
  cidr_blocks       = var.allowed_cidr_blocks
  security_group_id = join("", aws_security_group.default.*.id)
  type              = "ingress"
}

// Create IAM Role
resource "aws_iam_role" "eks_iam" {
  count              = local.enabled ? 1 : 0
  name               = var.eks_iam_name
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  count      = local.enabled ? 1 : 0
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSClusterPolicy", join("", data.aws_partition.current.*.partition))
  role       = join("", aws_iam_role.eks_iam.*.name)
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  count      = local.enabled ? 1 : 0
  policy_arn = format("arn:%s:iam::aws:policy/AmazonEKSServicePolicy", join("", data.aws_partition.current.*.partition))
  role       = join("", aws_iam_role.eks_iam.*.name)
}


resource "aws_iam_role_policy" "eks_cluster_elb_service_role" {
  count  = local.enabled ? 1 : 0
  name   = var.eks_iam_policy_name
  role   = join("", aws_iam_role.eks_iam.*.name)
  policy = join("", data.aws_iam_policy_document.cluster_elb_service_role.*.json)
}


resource "aws_cloudwatch_log_group" "eks_log_group" {
  count             = local.enabled && length(var.enabled_eks_cluster_log_types) > 0 ? 1 : 0
  name              = "/aws/eks/${var.eks_cluster_name}/cluster"
  retention_in_days = var.cluster_log_retention_period
}

resource "aws_kms_key" "eks_cluster" {
  count                   = local.enabled && var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  enable_key_rotation     = var.cluster_encryption_config_kms_key_enable_key_rotation
  deletion_window_in_days = var.cluster_encryption_config_kms_key_deletion_window_in_days
  policy                  = var.cluster_encryption_config_kms_key_policy
}

resource "aws_kms_alias" "esk_cluster" {
  count         = local.enabled && var.cluster_encryption_config_enabled && var.cluster_encryption_config_kms_key_id == "" ? 1 : 0
  name          = format("alias/%v", var.eks_cluster_name)
  target_key_id = join("", aws_kms_key.eks_cluster.*.key_id)
}


resource "aws_eks_cluster" "eks_cluster" {
  count                     = local.enabled ? 1 : 0
  name                      = var.eks_cluster_name
  role_arn                  = join("", aws_iam_role.eks_iam.*.arn)
  version                   = var.kubernetes_version
  enabled_cluster_log_types = var.enabled_eks_cluster_log_types

  dynamic "encryption_config" {
    for_each = var.cluster_encryption_config_enabled ? [local.cluster_encryption_config] : []
    content {
      resources = lookup(encryption_config.value, "resources")
      provider {
        key_arn = lookup(encryption_config.value, "provider_key_arn")
      }
    }
  }

  vpc_config {
    security_group_ids      = [join("", aws_security_group.default.*.id)]
    subnet_ids              = var.subnet_ids
    endpoint_private_access = var.endpoint_private_access
    endpoint_public_access  = var.endpoint_public_access
    public_access_cidrs     = var.public_access_cidrs
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_service_policy,
    aws_cloudwatch_log_group.eks_log_group
  ]
}

resource "aws_iam_openid_connect_provider" "eks_iam_copenid_connect_provier" {
  count   = (local.enabled && var.oidc_provider_enabled) ? 1 : 0
  url     = join("", aws_eks_cluster.eks_cluster.*.identity[0].oidc[0].issuer)

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.default.certificates[0].sha1_fingerprint]
}