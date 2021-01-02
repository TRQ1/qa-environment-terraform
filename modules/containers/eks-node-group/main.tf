locals {
  enabled                            = var.enabled

  //Set environment for launch_template
  features_require_ami               = var.launch_template_enabled
  generate_launch_template           = var.launch_template_enabled ? local.features_require_launch_template && length(local.configured_launch_template_name) == 0 : false
  use_launch_template                = var.launch_template_enabled ? local.features_require_launch_template || length(local.configured_launch_template_name) > 0 : false
  launch_template_ami                = var.launch_template_ami
  configured_launch_template_name    = var.launch_template_name == null ? "" : var.launch_template_name
  configured_launch_template_version = length(local.configured_launch_template_name) > 0 && length(compact([var.launch_template_version])) > 0 ? var.launch_template_version : ""
  launch_template_id                 = var.use_launch_template ? (length(local.configured_launch_template_name) > 0 ? data.aws_launch_template.this[0].id : aws_launch_template.default[0].id) : ""
  launch_template_version            = var.use_launch_template ? (
    length(local.configured_launch_template_version) > 0 ? local.configured_launch_template_version :
    (
      length(local.configured_launch_template_name) > 0 ? data.aws_launch_template.this[0].latest_version : aws_launch_template.default[0].latest_version
    )
  ) : ""
 // Set userdata for launch template 
  userdata_enabled                   = var.userdata_enabled
  need_userdata                     = local.userdata_enabled && var.userdata_override_base64 == null ? (length(local.userdata_vars.before_cluster_joining_userdata) > 0) || local.need_bootstrap : false
  need_bootstrap                    = local.userdata_enabled ? length(compact([local.kubelet_taint_args, var.kubelet_additional_options,
    local.userdata_vars.bootstrap_extra_args,
    local.userdata_vars.after_cluster_joining_userdata]
  )) > 0 : false

// Set environment for kubelet label and args
  kubelet_extra_args                = join(" ", compact([local.kubelet_label_args, local.kubelet_taint_args, var.kubelet_additional_options]))
  kubelet_label_settings = [for k, v in var.kubernetes_labels : format("%v=%v", k, v)]
  kubelet_taint_settings = [for k, v in var.kubernetes_taints : format("%v=%v", k, v)]
  kubelet_label_args = (length(local.kubelet_label_settings) == 0 ? "" :
    "--node-labels=${join(",", local.kubelet_label_settings)}"
  )
  kubelet_taint_args = (length(local.kubelet_taint_settings) == 0 ? "" :
    "--register-with-taints=${join(",", local.kubelet_taint_settings)}"
  )
  userdata                           = local.need_userdata ? base64encode(templatefile("${path.module}/userdata.tpl", merge(local.userdata_vars, local.cluster_data))) : var.userdata_override_base64
 
  get_cluster_data                   = local.enabled ? (var.need_cluster_kubernetes_version || local.need_remote_access_sg) : false
  cluster_data                       = {
    cluster_endpoint                 = local.get_cluster_data ? data.aws_eks_cluster.this[0].endpoint : null
    certificate_authority_data       = local.get_cluster_data ? data.aws_eks_cluster.this[0].certificate_authority[0].data : null
    cluster_name                     = local.get_cluster_data ? data.aws_eks_cluster.this[0].name : null
  } 
  
  configured_ami_image_id            = var.ami_image_id == null ? "" : var.ami_image_id
  need_ami_id                        = local.enabled ? local.features_require_ami && length(local.configured_ami_image_id) == 0 : false
  features_require_launch_template   = local.enabled ? length(var.resources_to_tag) > 0 || local.need_userdata || local.features_require_ami : false
  have_ssh_key                       = var.ec2_ssh_key != null && var.ec2_ssh_key != ""
  need_remote_access_sg              = local.enabled && local.have_ssh_key && local.generate_launch_template
  autoscaler_enabled                 = var.enable_cluster_autoscaler != null ? var.enable_cluster_autoscaler : var.cluster_autoscaler_enabled == true
  aws_policy_prefix                  = format("arn:%s:iam::aws:policy", join("", data.aws_partition.current.*.partition))

// Set autosacling 
  autoscaler_enabled_tags            = {
    "k8s.io/cluster-autoscaler/${var.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"             = "true"
  }
  autoscaler_kubernetes_label_tags   = {
    for label, value in var.kubernetes_labels : format("k8s.io/cluster-autoscaler/node-template/label/%v", label) => value
  }
  autoscaler_kubernetes_taints_tags  = {
    for label, value in var.kubernetes_taints : format("k8s.io/cluster-autoscaler/node-template/taint/%v", label) => value
  }
  autoscaler_tags = merge(local.autoscaler_enabled_tags, local.autoscaler_kubernetes_label_tags, local.autoscaler_kubernetes_taints_tags)

// Set nodegroup information
  node_group = {
    cluster_name    = var.eks_cluster_name
    node_role_arn   = join("", aws_iam_role.default.*.arn)
    subnet_ids      = var.subnet_ids
    disk_size       = local.use_launch_template ? null : var.disk_size
    instance_types  = local.use_launch_template ? null : var.instance_types
    ami_type        = local.launch_template_ami == "" ? var.ami_type : null
    labels          = var.kubernetes_labels == null ? {} : var.kubernetes_labels
    release_version = local.launch_template_ami == "" ? var.ami_release_version : null
    version         = length(compact([local.launch_template_ami, var.ami_release_version])) == 0 ? var.kubernetes_version : null
  }

  userdata_vars = {
    before_cluster_joining_userdata = var.before_cluster_joining_userdata == null ? "" : var.before_cluster_joining_userdata
    kubelet_extra_args              = local.kubelet_extra_args
    bootstrap_extra_args            = var.bootstrap_additional_options == null ? "" : var.bootstrap_additional_options
    after_cluster_joining_userdata  = var.after_cluster_joining_userdata == null ? "" : var.after_cluster_joining_userdata
  }

// Set Tag informantion
  nodes_tags = merge(
    var.tags,
    {
      "kubernetes.io/cluster/${var.eks_cluster_name}" = "owned"
    }
  )
  node_group_tags = merge(local.nodes_tags, local.autoscaler_enabled ? local.autoscaler_tags : {})

}

// Set EKS Cluster and Node Group Data form
data "aws_eks_cluster" "this" {
  count = local.get_cluster_data ? 1 : 0
  name  = var.eks_cluster_name
}

data "aws_partition" "current" {
  count = local.enabled ? 1 : 0
}

data "aws_iam_policy_document" "assume_role" {
  count = var.enabled ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

data "aws_launch_template" "this" {
  count = local.enabled && length(local.configured_launch_template_name) > 0 ? 1 : 0
  name = local.configured_launch_template_name
}

data "aws_iam_policy_document" "amazon_eks_node_autoscale_policy" {
  count = (local.enabled && var.worker_role_autoscale_iam_enabled) ? 1 : 0
  statement {
    sid = "AllowToScaleEKSNodeGroupAutoScalingGroup"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = [
      "*"
    ]
  }
}

// Set IAM Role
resource "aws_iam_policy" "amazon_eks_node_autoscale_policy" {
  count  = (local.enabled && var.worker_role_autoscale_iam_enabled) ? 1 : 0
  name   = "${var.eks_node_iam_name}-autoscale"
  policy = join("", data.aws_iam_policy_document.amazon_eks_node_autoscale_policy.*.json)
}

resource "aws_iam_role" "default" {
  count                = local.enabled ? 1 : 0
  name                 = var.eks_node_iam_name
  assume_role_policy   = join("", data.aws_iam_policy_document.assume_role.*.json)
  permissions_boundary = var.permissions_boundary
}

resource "aws_iam_role_policy_attachment" "amazon_eks_worker_node_policy" {
  count      = local.enabled ? 1 : 0
  policy_arn = format("%s/%s", local.aws_policy_prefix, "AmazonEKSWorkerNodePolicy")
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_node_autoscale_policy" {
  count      = (local.enabled && var.worker_role_autoscale_iam_enabled) ? 1 : 0
  policy_arn = join("", aws_iam_policy.amazon_eks_node_autoscale_policy.*.arn)
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_eks_cni_policy" {
  count      = local.enabled ? 1 : 0
  policy_arn = format("%s/%s", local.aws_policy_prefix, "AmazonEKS_CNI_Policy")
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "amazon_ec2_container_registry_read_only" {
  count      = local.enabled ? 1 : 0
  policy_arn = format("%s/%s", local.aws_policy_prefix, "AmazonEC2ContainerRegistryReadOnly")
  role       = join("", aws_iam_role.default.*.name)
}

resource "aws_iam_role_policy_attachment" "existing_policies_for_eks_workers_role" {
  for_each   = local.enabled ? toset(var.existing_workers_role_policy_arns) : []
  policy_arn = each.value
  role       = join("", aws_iam_role.default.*.name)
}

// Set Launch Template if use_launch_template is enabled
resource "aws_launch_template" "default" {
  count = local.use_launch_template ? 1 : 0

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = var.disk_size
      encrypted   = var.launch_template_disk_encryption_enabled
    }
  }

  name_prefix            = var.eks_node_name
  update_default_version = true

  instance_type = var.instance_types[0]
  image_id      = local.launch_template_ami == "" ? null : local.launch_template_ami
  key_name      = local.have_ssh_key ? var.ec2_ssh_key : null

  dynamic "tag_specifications" {
    for_each = var.resources_to_tag
    content {
      resource_type = tag_specifications.value
      tags          = local.node_tags
    }
  }

  metadata_options {
    http_put_response_hop_limit = 2
    http_endpoint = "enabled"
  }

  vpc_security_group_ids = var.launch_template_vpc_security_group_ids
  user_data              = local.userdata
  tags                   = local.nodes_tags
}

// Set EKS NodeGroup
resource "aws_eks_node_group" "default" {
  count           = local.enabled && ! var.create_before_destroy ? 1 : 0
  node_group_name = var.eks_node_name

  lifecycle {
    create_before_destroy = false
    ignore_changes        = [scaling_config[0].desired_size]
  }

  cluster_name    = local.node_group.cluster_name
  node_role_arn   = local.node_group.node_role_arn
  subnet_ids      = local.node_group.subnet_ids
  disk_size       = local.node_group.disk_size
  instance_types  = local.node_group.instance_types
  ami_type        = local.node_group.ami_type
  labels          = local.node_group.labels
  release_version = local.node_group.release_version
  version         = local.node_group.version

  tags = local.nodes_tags

  scaling_config {
    desired_size = var.scaling_config_desired_size
    max_size     = var.scaling_config_max_size
    min_size     = var.scaling_config_min_size
  }

  dynamic "launch_template" {
    for_each = local.use_launch_template ? ["true"] : []
    content {
      id      = local.launch_template_id
      version = local.launch_template_version
    }
  }

  dynamic "remote_access" {
    for_each = var.need_remote_access ? ["true"] : []
    content {
      ec2_ssh_key               = var.ec2_ssh_key
      source_security_group_ids = var.source_security_group_ids
    }
  }

  depends_on = [
    aws_iam_role_policy_attachment.amazon_eks_worker_node_policy,
    aws_iam_role_policy_attachment.amazon_eks_node_autoscale_policy,
    aws_iam_role_policy_attachment.amazon_eks_cni_policy,
    aws_iam_role_policy_attachment.amazon_ec2_container_registry_read_only
  ]
}
