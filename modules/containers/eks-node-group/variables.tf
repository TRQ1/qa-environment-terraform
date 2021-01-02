variable "enabled" {
  type    = bool
  default = null
}

variable "userdata_enabled" {
  type    = bool
  default = false
}

variable "launch_template_enabled" {
  type    = bool
  default = false
}

variable "need_cluster_kubernetes_version" {
  type    = bool
  default = false
}

variable "eks_node_name" {
  type    = string
}

variable "eks_node_iam_name" {
  type    = string
}

variable "enable_cluster_autoscaler" {
  type    = bool
  default = null
}

variable "cluster_autoscaler_enabled" {
  type    = bool
  default = null
}

variable "worker_role_autoscale_iam_enabled" {
  type    = bool
  default = false
}

variable "eks_cluster_name" {
  type = string
}

variable "create_before_destroy" {
  type    = bool
  default = false
}

variable "use_launch_template" {
  type    = bool
  default = false
}

variable "launch_template_ami" {
  type    = string
  default = ""
}

variable "launch_template_vpc_security_group_ids" {
  type    = list(string)
  default = []
}

variable "need_remote_access" {
  type    = bool
  default = true

}
variable "ec2_ssh_key" {
  type    = string
  default = null
}

variable "source_security_group_ids" {
  type    = list(string)
  default = []
}

variable "scaling_config_desired_size" {
  type = number
}

variable "scaling_config_max_size" {
  type = number
}

variable "scaling_config_min_size" {
  type = number
}

variable "subnet_ids" {
  type = list(string)
}

variable "existing_workers_role_policy_arns" {
  type    = list(string)
  default = []
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "existing_workers_role_policy_arns_count" {
  type        = number
  default     = 0
  description = "Obsolete and ignored. Allowed for backward compatibility."
}

variable "ami_type" {
  type    = string
  default = "AL2_x86_64"
  validation {
    condition = (
      contains(["AL2_x86_64", "AL2_x86_64_GPU", "AL2_ARM_64"], var.ami_type)
    )
    error_message = "Var ami_type must be one of \"AL2_x86_64\", \"AL2_x86_64_GPU\", and \"AL2_ARM_64\"."
  }
}

variable "disk_size" {
  type    = number
  default = 20
}

variable "instance_types" {
  type    = list(string)
  default = ["t3.medium"]
  validation {
    condition = (
      length(var.instance_types) == 1
    )
    error_message = "Per the EKS API, only a single instance type value is currently supported."
  }
}

variable "kubernetes_labels" {
  type    = map(string)
  default = {}
}

variable "kubernetes_taints" {
  type    = map(string)
  default = {}
}

variable "kubelet_additional_options" {
  type    = string
  default = ""
  validation {
    condition = (length(compact([var.kubelet_additional_options])) == 0 ? true :
      length(regexall("--node-labels", var.kubelet_additional_options)) == 0 &&
      length(regexall("--node-taints", var.kubelet_additional_options)) == 0
    )
    error_message = "Var kubelet_additional_options must not contain \"--node-labels\" or \"--node-taints\".  Use `kubernetes_labels` and `kubernetes_taints` to specify labels and taints."
  }
}

variable "ami_image_id" {
  type    = string
  default = null
}

variable "ami_release_version" {
  type    = string
  default = null
  validation {
    condition = (
      length(compact([var.ami_release_version])) == 0 ? true : length(regexall("^\\d+\\.\\d+\\.\\d+-\\d+$", var.ami_release_version)) == 1
    )
    error_message = "Var ami_release_version, if supplied, must be like  \"1.16.13-20200821\" (no \"v\")."
  }
}

variable "kubernetes_version" {
  type    = string
  default = null
  validation {
    condition = (
      length(compact([var.kubernetes_version])) == 0 ? true : length(regexall("^\\d+\\.\\d+$", var.kubernetes_version)) == 1
    )
    error_message = "Var kubernetes_version, if supplied, must be like \"1.18\" (no patch level)."
  }
}

variable "module_depends_on" {
  type    = any
  default = null
}

variable "launch_template_disk_encryption_enabled" {
  type    = bool
  default = false
}

variable "launch_template_name" {
  type    = string
  default = null
}

variable "launch_template_version" {
  type    = string
  default = null
}

variable "resources_to_tag" {
  type    = list(string)
  default = []
  validation {
    condition = (
      length(compact([for r in var.resources_to_tag : r if ! contains(["instance", "volume", "elastic-gpu", "spot-instances-request"], r)])) == 0
    )
    error_message = "Invalid resource type in `resources_to_tag`. Valid types are \"instance\", \"volume\", \"elastic-gpu\", \"spot-instances-request\"."
  }
}

variable "before_cluster_joining_userdata" {
  type        = string
  default     = ""
  description = "Additional `bash` commands to execute on each worker node before joining the EKS cluster (before executing the `bootstrap.sh` script)"
}

variable "after_cluster_joining_userdata" {
  type        = string
  default     = ""
  description = "Additional `bash` commands to execute on each worker node after joining the EKS cluster (after executing the `bootstrap.sh` script)"
}

variable "bootstrap_additional_options" {
  type        = string
  default     = ""
  description = "Additional options to bootstrap.sh. DO NOT include `--kubelet-additional-args`, use `kubelet_additional_args` var instead."
}

variable "userdata_override_base64" {
  type    = string
  default = null
}

variable "permissions_boundary" {
  type    = string
  default = null
}