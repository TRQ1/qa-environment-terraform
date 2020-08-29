resource "aws_lb_target_group" "aws_lb_tg" {
  name     = var.aws_tg_name
  port     = var.aws_tg_port
  protocol = "HTTP"
  vpc_id   = var.aws_vpc_id

 health_check {
    interval          = var.interval
    path              = var.path
    timeout           = var.timeout
    healthy_threshold = var.healthy_threshold
    port              = var.port
    protocol          = var.protocol
    matcher           = var.matcher
  }
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  listener_arn = var.aws_alb_arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.aws_lb_tg.arn
  }

  condition {
    host_header {
      values = var.aws_lb_domain_url
    }
  }
}