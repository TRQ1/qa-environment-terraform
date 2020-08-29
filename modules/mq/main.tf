locals {
  mq_admin_user = var.aws_mq_admin_user
  mq_admin_password = length(var.aws_mq_admin_password) > 0 ? var.aws_mq_admin_password : random_string.password.result
  mq_application_user = var.aws_mq_application_user
  mq_application_password = length(var.aws_mq_admin_password) > 0 ? var.aws_mq_admin_password : random_string.password.result
}

resource "random_string" "password" {
  length = 20
  special = false
}

resource "aws_mq_broker" "aws_mq" {
  broker_name = var.aws_mq_name

  engine_type        = "ActiveMQ"
  engine_version     = var.aws_mq_engin_version
  host_instance_type = var.aws_mq_engin_instance_type
  security_groups    = var.aws_security_group_id
  subnet_ids         = var.aws_mq_subnet_id
  deployment_mode    = var.aws_mq_development_mode

  logs {
    general = var.aws_mq_general_log
    audit   = var.aws_mq_audit_log
  }

  user {
    username = local.mq_admin_user
    password = local.mq_admin_password
    groups = ["admin"]
    console_access = true
  }

  user {
    username = local.mq_application_user
    password = local.mq_application_password
  }
}