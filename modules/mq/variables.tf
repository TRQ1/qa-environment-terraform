variable "aws_mq_name" {
    type = string
}

variable "aws_mq_engin_version" {
    type = string
}

variable "aws_mq_engin_instance_type" {
    type = string
}

variable "aws_security_group_id" {
    type = list(string)
}

variable "aws_mq_subnet_id" {
    type = list(string)
}

variable "aws_mq_development_mode" {
    type = string
}

variable "aws_mq_general_log" {
    type = bool
    default = true
}

variable "aws_mq_audit_log" {
    type = bool
    default = true
}

variable "aws_mq_admin_user" {
    type = string
}

variable "aws_mq_admin_password" {
    type = string
    default = ""
}

variable "aws_mq_application_user" {
    type = string
}

variable "aws_mq_application_password" {
    type = string
    default = ""
}
