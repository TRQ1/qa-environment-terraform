variable "aws_route53_zone_name" {
    type    = string
    default = null
}

variable "zone_enabled" {
    type    = bool
    default = false
}

variable "record_enabled" {
    type    = bool
    default = false
}

variable "aws_route53_zone_id" {
    type    = string
    default = null
}

variable "aws_route53_record_name" {
    type    = string
    default = null
}

variable "aws_route53_record_type" {
    type    = string
    default = null
}

variable "aws_route53_record_server" {
    type    = list(string)
    default = [] 
}