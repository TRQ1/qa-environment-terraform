locals {
    name                = var.name
    tags                = var.tags
    delimiter           = var.delimiter
    cache_enabled       = var.cache_type
    cache_bucket        = var.cache_bucket_prifix
    cache_option = {
      "S3" = {
          type      = "S3"
          location  = local.cache_bucket
      },
      "LOCAL" =  {
          type      = "LOCAL"
          modes     = var.local_cache_modes
      },
      "NO_CACHE" = {
          type      = "NO_CACHE"
      }
    }
    vpc_config = {
          vpc_id = var.vpc_id
          subnets = var.subnets
          security_group_ids = var.security_group_ids
    }
    # Set map seleted from cache_option
    cache = local.cache_option[var.cache_type]

}

resource "aws_codebuild_project" "cb_project" {
  name           = local.name
  service_role   = var.aws_service_role
  badge_enabled  = var.badge_enabled
  build_timeout  = var.build_timeout
  source_version = var.source_version != "" ? var.source_version : null
  tags = {
    for name, value in local.tags :
    name => value
    if length(value) > 0
  }

  artifacts {
    type = var.artifact_type
  }

  cache {
    type     = lookup(local.cache, "type", null)
    location = lookup(local.cache, "location", null)
    modes    = lookup(local.cache, "modes", null)
  }

  environment {
    compute_type    = var.build_compute_type
    image           = var.build_image
    type            = var.build_type
    privileged_mode = var.privileged_mode
  }

  source {
    buildspec           = var.buildspec
    type                = var.source_type
    location            = var.source_repo
    report_build_status = var.report_build_status
    git_clone_depth     = var.git_clone_depth != null ? var.git_clone_depth : null

    dynamic "auth" {
      for_each = var.private_repository ? [""] : []
      content {
        type     = "OAUTH"
        resource = join("", aws_codebuild_source_credential.authorization.*.id)
      }
    }

    dynamic "git_submodules_config" {
      for_each = var.fetch_git_submodules ? [""] : []
      content {
        fetch_submodules = false
      }
    }
  }

  vpc_config {
    vpc_id             = lookup(local.vpc_config, "vpc_id", null)
    subnets            = lookup(local.vpc_config, "subnets", null)
    security_group_ids = lookup(local.vpc_config, "security_group_ids", null)
  }

  dynamic "logs_config" {
    for_each = length(var.logs_config) > 0 ? [""] : []
    content {
      dynamic "cloudwatch_logs" {
        for_each = contains(keys(var.logs_config), "cloudwatch_logs") ? { key = var.logs_config["cloudwatch_logs"] } : {}
        content {
          status      = lookup(cloudwatch_logs.value, "status", null)
          group_name  = lookup(cloudwatch_logs.value, "group_name", null)
          stream_name = lookup(cloudwatch_logs.value, "stream_name", null)
        }
      }

      dynamic "s3_logs" {
        for_each = contains(keys(var.logs_config), "s3_logs") ? { key = var.logs_config["s3_logs"] } : {}
        content {
          status              = lookup(s3_logs.value, "status", null)
          location            = lookup(s3_logs.value, "location", null)
          encryption_disabled = lookup(s3_logs.value, "encryption_disabled", null)
        }
      }
    }
  }
}

resource "aws_codebuild_webhook" "cb_hook" {
  project_name = aws_codebuild_project.cb_project.name

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.develop_hook_pattern
    }
  }

  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.master_hook_pattern
    }
  }
  
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "PUSH"
    }

    filter {
      type    = "HEAD_REF"
      pattern = var.hotfix_hook_pattern
    }
  }

}