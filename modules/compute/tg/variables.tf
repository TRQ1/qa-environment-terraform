variable "aws_tg_name" {
    type = string
}

variable "aws_tg_port" {
    type = number
}

variable "aws_vpc_id" {
    type = string
}

variable "interval" {
    type = number
    default = 60
}

variable "path" {
    type = string
    default = "/ping"
}

variable "timeout" {
    type = number
    default = 10
}

variable "healthy_threshold" {
    type = number
    default = 2
}

variable "port" {
    type = number
    default = 80
}

variable "protocol" {
    type = string
    default = "HTTP"
}

variable "matcher" {
    type = string
    default = "200~399"
}

variable "aws_alb_arn" {
    type = string
}

variable "aws_lb_domain_url" {
    type = list(string)
}
