variable "enabled" {
  type        = bool
}

variable "eks_cluster_name" {
  type        = string
}

variable "eks_node_name" {
  type        = string
}

variable "subnet_ids" {
  type        = list(string)
}

variable "kubernetes_namespace" {
  type        = string
}

variable "kubernetes_labels" {
  type        = map(string)
  default     = {}
}

variable "iam_role_kubernetes_namespace_delimiter" {
  type        = string
  default     = "-"
}

variable "tags" {
  type        = map(string)
}