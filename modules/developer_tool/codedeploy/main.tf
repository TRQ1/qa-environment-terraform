resource "aws_codedeploy_app" "cd_app" {
  compute_platform = "Server"
  name             = var.aws_codedeploy_app_name
}

resource "aws_codedeploy_deployment_group" "cd_group" {
  app_name               = aws_codedeploy_app.cd_app.name
  deployment_group_name  = aws_codedeploy_app.cd_app.name
  service_role_arn       = var.aws_cd_iam_arn
  
  deployment_style {
    deployment_option = var.alb_target_group == null ? "WITHOUT_TRAFFIC_CONTROL" : "WITH_TRAFFIC_CONTROL"
    deployment_type   = var.enable_bluegreen == false ? "IN_PLACE" : "BLUE_GREEN"
  }

  dynamic "blue_green_deployment_config" {
    for_each = var.enable_bluegreen == true ? [1] : []
    content {
      deployment_ready_option {
        action_on_timeout = var.bluegreen_timeout_action
      }

      terminate_blue_instances_on_deployment_success {
        action = var.blue_termination_behavior
        termination_wait_time_in_minutes = 10

      }
      green_fleet_provisioning_option {
        action = var.green_provisioning_asg == true ? "COPY_AUTO_SCALING_GROUP" : "DISCOVER_EXISTING"
      }
    }
  }

  dynamic "load_balancer_info" {
    for_each = var.alb_target_group == null ? [] : [var.alb_target_group]
    content {
      target_group_info {
        name = var.alb_target_group
      }
    }
  }

  ec2_tag_filter {
    key   = "appName"
    type  = "KEY_AND_VALUE"
    value =  var.aws_cd_ec2_instance_tag
  }

  auto_rollback_configuration {
    enabled = var.cd_rollback_enabled
    events  = var.cd_rollback_enabled == true ? ["DEPLOYMENT_FAILURE"] : []
  }

}