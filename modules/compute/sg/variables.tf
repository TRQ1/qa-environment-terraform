variable "aws_region" {
    type = string
    default = "ap-northeast-2"

}

variable "aws_security_group_name" {
    type = string
}

variable "aws_vpc_id" {
    type = string
}

variable "ingress_ports" {
    type = list(number)
}
