output "alb_arn" {
    value = aws_lb.aws_alb.arn
}

output "alb_backend_arn" {
    value = aws_lb_listener.backend.arn
}

output "alb_dns_name" {
    value = aws_lb.aws_alb.dns_name
}
