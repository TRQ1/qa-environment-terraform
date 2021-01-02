variable "aws_asg_name" {
    type    = string
}

variable "aws_health_check_grace_period" {
    type    = number
    default = 30
}

variable "aws_asg_max_size" {
    type    = number
}

variable "aws_asg_min_size" {
    type    = number
}

variable "aws_asg_health_check_type" {
    type    = string
}

variable "aws_target_group_arns" {
    type    = list(string)
    default = []
}

variable "aws_vpc_zone" {
    type    = list(string)
}

variable "aws_launch_template_id" {
    type    = string
}

variable "aws_launch_template_version" {
    type    = string
}

variable "aws_asg_sch_name" {
    type    = string
}

variable "aws_desired_capacity" {
    type    = number
    default = 0
}

variable "aws_asg_sch_min_size" {
    type    = number
}

variable "aws_asg_sch_max_size" {
    type    = number
}

variable "aws_asg_sch_start_time" {
    type    = string
}

variable "aws_asg_sch_end_time" {
    type    = string
}