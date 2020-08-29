variable "aws_region" {
    type = string
    default = "ap-northeast-2"

}

variable "aws_lt_name" {
    type = string
}

variable "aws_lt_iam_profile_id" {
    type = string
}

variable "aws_lt_instance_type" {
    type = string
}

variable "aws_lt_key_name" {
    type = string
}

variable "aws_lt_iam_instance_profile" {
    type = string
}

variable "aws_lt_user_data" {
    type = string
    default = ""
}

variable "aws_lt_placement" {
    type = object({
        affinity          = string
        availability_zone = string
        group_name        = string
        host_id           = string
        tenancy           = string
    })
    default = null
}

variable "aws_security_group_id" {
    type = list(string)
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Add tags (e.g. `map(`Name`,`XYZ`)"
}

variable "aws_asg_name" {
    type = string
}

variable "aws_asg_max_size" {
    type = number
}

variable "aws_asg_min_size" {
    type = number
}

variable "aws_asg_health_check_type" {
    type = string
}

variable "this_aws_lt_name" {
    type = string
}

variable "aws_vpc_zone" {
    type = list(string)
}

variable "aws_asg_sch" {
  type        = map(object({
    min_size          = number,
    max_size          = number,
    desired_capacity  = number,
    recurrence        = string
  }))
  default     = {}
}