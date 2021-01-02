variable "enabled" {
    type        = bool
    default     = null
}

variable "sg_name" {
    type        = string
}

variable "vpc_id" {
    type        = string
}

variable "subnet_ids" {
    type        = list(string)
}

variable "allowed_security_groups" {
    type        = list(string)
    default     = []
}

variable "allowed_cidr_blocks" {
    type        = list(string)
    default     = []
}

variable "eks_iam_name" {
    type        = string
}

variable "eks_iam_policy_name" {
    type        = string
}

variable "enabled_eks_cluster_log_types" {
    type        = list(string)
    default     = []
}

variable "cluster_log_retention_period" {
    type        = number
    default     = 3
}

variable "eks_cluster_name" {
    type        = string
}

variable "kubernetes_version" {
    type        = string
    default     = 1.17
}

variable "cluster_encryption_config_enabled" {
    type        = bool
    default     = false
}

variable "endpoint_private_access" {
    type        = bool
    default     = true
}

variable "endpoint_public_access" {
    type        = bool
    default     = false
}

variable "oidc_provider_enabled" {
    type        = bool
    default     = false
}

variable "public_access_cidrs" {
    type        = list(string)
    default     = ["0.0.0.0/0"]
}

variable "cluster_encryption_config_kms_key_id" {
    type        = string
    default     = ""
}

variable "cluster_encryption_config_kms_key_enable_key_rotation" {
    type        = bool
    default     = true
}

variable "cluster_encryption_config_kms_key_deletion_window_in_days" {
    type        = number
    default     = 10
}

variable "cluster_encryption_config_kms_key_policy" {
    type        = string
    default     = null
}

variable "cluster_encryption_config_resources" {
    type        = list
    default     = ["secrets"]
}