locals {
  tags_list = {
    tags = var.tags
  }
  launch_template_info = {
    id  = join("", aws_launch_template.launch_template.*.id)
  }

  schedules = flatten([
    for schedule_key, schedule_value in var.aws_asg_sch: [
      {
        scheduled_action_name   = schedule_key
        min_size                = schedule_value.min_size,
        max_size                = schedule_value.max_size,
        desired_capacity        = schedule_value.desired_capacity,
        recurrence              = schedule_value.recurrence
      }
    ]
  ])
}

resource "aws_launch_template" "launch_template" {
  name = var.aws_lt_name
  image_id = var.aws_lt_iam_profile_id
  instance_type = var.aws_lt_instance_type
  key_name = var.aws_lt_key_name

  monitoring {
    enabled = true
  }


  iam_instance_profile {
    name = var.aws_lt_iam_instance_profile
  }

  dynamic "placement" {
    for_each = var.aws_lt_placement != null ? [var.aws_lt_placement] : []
    content {
      affinity          = lookup(placement.value, "affinity", null)
      availability_zone = lookup(placement.value, "availability_zone", null)
      group_name        = lookup(placement.value, "group_name", null)
      host_id           = lookup(placement.value, "host_id", null)
      tenancy           = lookup(placement.value, "tenancy", null)
    }
  }

  vpc_security_group_ids = var.aws_security_group_id

  tag_specifications {
    resource_type = "instance"
    tags          = local.tags_list.tags
  }

  tags = local.tags_list.tags

  user_data = var.aws_lt_user_data

}

resource "aws_autoscaling_group" "aws_asg" {
  name                      = var.aws_asg_name
  max_size                  = var.aws_asg_max_size
  min_size                  = var.aws_asg_min_size
  health_check_grace_period = 60
  health_check_type         = var.aws_asg_health_check_type
  desired_capacity          = var.aws_asg_max_size
  force_delete              = true
  vpc_zone_identifier       = var.aws_vpc_zone

  launch_template {
    id      = local.launch_template_info.id
    version = "$Default"
  }
}

resource "aws_autoscaling_schedule" "aws_asg_schdule" {
  for_each = {
    for aws_asg_schdule in local.schedules : "${aws_asg_schdule.scheduled_action_name}" => aws_asg_schdule
  }
  scheduled_action_name  = each.value.scheduled_action_name
  min_size               = each.value.min_size 
  max_size               = each.value.max_size
  desired_capacity       = each.value.desired_capacity
  recurrence             = each.value.recurrence
  autoscaling_group_name = aws_autoscaling_group.aws_asg.name
}