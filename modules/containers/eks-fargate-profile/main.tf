locals {
  enabled = var.enabled
  tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
  )
}

data "aws_iam_policy_document" "assume_role" {
  count = local.enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "default" {
  count              = local.enabled ? 1 : 0
  name               = "${var.eks_node_name}${var.iam_role_kubernetes_namespace_delimiter}${var.kubernetes_namespace}"
  assume_role_policy = join("", data.aws_iam_policy_document.assume_role.*.json)
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "amazon_eks_fargate_pod_execution_role_policy" {
  count      = local.enabled ? 1 : 0
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_eks_fargate_profile" "default" {
  count                  = local.enabled ? 1 : 0
  cluster_name           = var.eks_cluster_name
  fargate_profile_name   = var.eks_node_name
  pod_execution_role_arn = join("", aws_iam_role.default.*.arn)
  subnet_ids             = var.subnet_ids
  tags                   = local.tags

  selector {
    namespace = var.kubernetes_namespace
    labels    = var.kubernetes_labels
  }
}