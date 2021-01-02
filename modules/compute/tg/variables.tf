variable "tg_enabled" {
    type    = bool
    default = false
}

variable "aws_tg_name" {
    type    = string
}

variable "aws_tg_port" {
    type    = number
}

variable "aws_vpc_id" {
    type    = string
}

variable "interval" {
    type    = number
    default = 60
}

variable "path" {
    type    = string
}

variable "timeout" {
    type    = number
    default = 10
}

variable "healthy_threshold" {
    type    = number
    default = 2
}

variable "port" {
    type    = number
}

variable "protocol" {
    type    = string
    default = "HTTP"
}

variable "matcher" {
    type    = string
    default = "200~399"
}
variable "stickiness" {
    type    = object({
        cookie_duration = number
        enabled         = bool
    })
    default = null
}

variable "lb_listener_rule_enabled" {
    type    = bool
    default = false
}

variable "aws_alb_arn" {
    type    = string
}

variable "lb_listener_rule_condition" {
    type    = list(map(list(string)))
    default = []
}
