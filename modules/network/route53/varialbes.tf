variable "aws_route53_zone_id" {
    type = string
}

variable "aws_route53_record_name" {
    type = string
}

variable "aws_route53_record_type" {
    type = string
}

variable "aws_route53_record_server" {
    type = list(string)
}