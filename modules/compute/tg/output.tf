output "targetgroup_arn" {
    value = aws_lb_target_group.aws_lb_tg.arn
}

output "targetgroup_name" {
    value = aws_lb_target_group.aws_lb_tg.name
}