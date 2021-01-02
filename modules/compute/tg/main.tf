resource "aws_lb_target_group" "aws_lb_tg" {
  count               = var.tg_enabled ? 1 : 0
  name                = var.aws_tg_name
  port                = var.aws_tg_port
  protocol            = "HTTP"
  vpc_id              = var.aws_vpc_id

  health_check {
    interval          = var.interval
    path              = var.path
    timeout           = var.timeout
    healthy_threshold = var.healthy_threshold
    port              = var.port
    protocol          = var.protocol
    matcher           = var.matcher
  }

  dynamic "stickiness" {
    for_each          = var.stickiness == null ? [] : [var.stickiness]
    content {
      type            = "lb_cookie"
      cookie_duration = stickiness.value.cookie_duration
      enabled         = var.target_group_protocol == "TCP" ? false : stickiness.value.enabled
    }
  }
}

resource "aws_lb_listener_rule" "host_based_weighted_routing" {
  
  count              = var.lb_listener_rule_enabled ? 1 : 0
  listener_arn       = var.aws_alb_arn

  action {
    type             = "forward"
    target_group_arn = join("", aws_lb_target_group.aws_lb_tg.*.arn)
  }

  dynamic "condition" {
    for_each = [var.lb_listener_rule_condition[count.index]]
    content {
      dynamic "host_header" {
        for_each = join("", lookup(condition.value, "field")) != "host_header" ? [] : lookup(condition.value, "field", null)
        content {
          values = lookup(condition.value, "values")
        }
      }

      dynamic "path_pattern"  {
        for_each = join("", lookup(condition.value, "field")) != "path_pattern" ? [] : lookup(condition.value, "field", null)
        content {
          values = lookup(condition.value, "values")
        }
      }
    }
  }
}
