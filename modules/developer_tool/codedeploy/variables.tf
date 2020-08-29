variable "aws_codedeploy_app_name" {
    type = string
}

variable "aws_cd_iam_arn" {
    type = string
}

variable "alb_target_group" {
    type = string
    default = null
}

variable "enable_bluegreen" {
    type = bool
    default = false
}

variable "bluegreen_timeout_action" {
    type = string
    default = "CONTINUE_DEPLOYMENT"
}

variable "blue_termination_behavior" {
    type = string
    default = "TERMINATE"
}

variable "green_provisioning_asg" {
    type = bool
    default = false
}

variable "aws_cd_ec2_instance_tag" {
    type = string
}

variable "cd_rollback_enabled" {
    type = bool
    default = false
}