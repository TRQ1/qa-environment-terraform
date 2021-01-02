output "targetgroup_arn" {
    value = join("", aws_lb_target_group.aws_lb_tg.*.arn)
}

output "targetgroup_name" {
    value = join("", aws_lb_target_group.aws_lb_tg.*.name)
}