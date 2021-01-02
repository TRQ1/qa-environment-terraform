variable "enabled" {
    type    = bool
    default = true
}

variable "aws_ec_rg_id" {
    type    = string
    default = ""
}

variable "cluster_size" {
    type    = number
    default = 1
}

variable "aws_ec_sg_id" {
}

variable "family" {
    type    = string
    default = "redis6.x"
}

variable "parameter" {
    type    = list(object({
      name  = string
      value = string
    }))
    default = []
}

variable "aws_ec_subnet_name" {
    type    = string
}

variable "cluster_mode_enabled" {
    type    = bool
    default = false
}

variable "aws_ec_automatic_failover_enabled" {
    type    = bool
    default = false 
}

variable "aws_ec_node_type" {
    type    = string
}

variable "aws_ec_redis_parameter_group_name" {
    type    = string
}

variable "aws_ec_replication_group_desciption" {
    type    = string
    default = ""
}

variable "aws_ec_engine_version" {
    type    = string
}

variable "aws_cluster_mode_replicas_per_node_group" {
    type    = number
}

variable "cluster_mode_replicas_per_node_group" {
    type      = number
    default   = 0
}

variable "cluster_mode_num_node_groups" {
    type      = number
    default   = 0
}