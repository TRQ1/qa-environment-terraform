variable "aws_efs_encrypted" {
    type = bool
    default = false
}

variable "aws_efs_performance_mode" {
    type = string
    default = "generalPurpose"
}

variable "aws_efs_provisioned_throughput_in_mibps" {
    type = number
    default = 0
}

variable "aws_efs_throughput_mode" {
    type = string
    default = "bursting"
}

variable "aws_efs_transition_to_ia"{
    type = string
    default = ""
}

variable "aws_subnets" {
    type = string
}

variable "aws_efs_sg" {
    type = string
}