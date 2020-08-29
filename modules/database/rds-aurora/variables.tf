variable "aws_rds_cluster_id" {
    type = string
}

variable "aws_rds_engin_name" {
    type = string
    default = "aurora-mysql"
}

variable "aws_rds_engin_version" {
    type = string
}

variable "aws_rds_subnet_group_id" {
    type = string
}

variable "aws_rds_sg_id" {
    type = list(string)
}

variable "aws_rds_cluster_parm_group_name" {
    type = string
}

variable "aws_rds_database_name" {
    type = string
}

variable "aws_rds_master_username" {
    type = string
}

variable "aws_rds_master_password" {
    type = string
}

variable "aws_rds_backup_period" {
    type = number
}

variable "aws_rds_backup_window" {
    type = string
}

variable "replica_scale_enabled" {
    type = bool
}

variable "aws_rds_instance_class" {
    type = string
}

variable "aws_rds_replica_scale_max" {
    type = number
}

variable "aws_rds_replica_scale_min" {
    type = number
}

variable "aws_rds_replica_count" {
    type = number
}