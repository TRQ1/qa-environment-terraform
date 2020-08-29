variable "aws_es_redis_name" {
    type = string
}

variable "aws_es_rg_id" {
    type = string
}

variable "aws_es_sg_id" {
}

variable "aws_es_subnet_name" {
    type = string
}

variable "cluster_mode_enabled" {
    type = bool
}

variable "aws_es_node_type" {
    type = string
}

variable "aws_es_number_cache_clusters_enable" {
    type = bool
}

variable "aws_es_redis_parameter_group_name" {
    type = string
}

variable "aws_es_engine_version" {
    type = string
}

variable "aws_cluster_mode_replicas_per_node_group" {
    type = number
}

variable "aws_cluster_mode_num_node_groups" {
    type = number


}