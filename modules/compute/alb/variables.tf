variable "aws_alb_name" {
    type = string
}

variable "aws_alb_subnet_id" {
    type = list(string)
}

variable "aws_alb_sg_id" {
    type = list(string)
}

variable "aws_ssl_certification_arn" {
    type = string 
}

variable "alb_target_group" {
    type = string
}
