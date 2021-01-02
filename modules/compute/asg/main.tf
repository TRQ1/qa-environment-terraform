resource "aws_autoscaling_group" "aws_asg" {
  name                      = var.aws_asg_name
  max_size                  = var.aws_asg_max_size
  min_size                  = var.aws_asg_min_size
  health_check_grace_period = var.aws_health_check_grace_period
  health_check_type         = var.aws_asg_health_check_type
  target_group_arns         = var.aws_target_group_arns
  force_delete              = true
  vpc_zone_identifier       = var.aws_vpc_zone

  launch_template {
    id      = var.aws_launch_template_id
    version = var.aws_launch_template_version
  }
}

resource "aws_autoscaling_schedule" "aws_asg_schdule" {
  scheduled_action_name  = var.aws_asg_sch_name
  min_size               = var.aws_asg_sch_min_size 
  max_size               = var.aws_asg_sch_max_size
  desired_capacity       = var.aws_desired_capacity
  start_time             = var.aws_asg_sch_start_time
  end_time               = var.aws_asg_sch_end_time
  autoscaling_group_name = "${aws_autoscaling_group.aws_asg.name}"
}