resource "aws_lb" "aws_alb" {

  name = var.aws_alb_name
  load_balancer_type = "application"
  internal           = true
  subnets            = var.aws_alb_subnet_id
  security_groups    = var.aws_alb_sg_id

}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_302"
    }
  }
}
resource "aws_lb_listener" "backend" {
  load_balancer_arn = aws_lb.aws_alb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = var.aws_ssl_certification_arn

  default_action {
    type = "forward"
    target_group_arn = var.alb_target_group
    }
}