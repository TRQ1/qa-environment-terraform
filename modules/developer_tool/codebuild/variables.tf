variable "source_repo" {
    type        = string
}

variable "name" {
    type        = string
}

variable "tags" {
    type        = map(string)
    default     = {}
}

variable "delimiter" {
    type        = string
}

variable "cache_type" {
    type        = string
}

variable "aws_service_role" {
    type        = string
}

variable "badge_enabled" {
    type        = bool
    default     = false
}

variable "local_cache_modes" {
    type        = list(string)
    default     = []
}

variable "build_timeout" {
    type        = string
}

variable "source_version" {
    type        = string
    default     = ""
}

variable "artifact_type" {
    type        = string
    default     = "NO_ARTIFACTS"
}

variable "build_compute_type" {
    type        = string
    default     = "BUILD_GENERAL1_LARGE"
}

variable "build_image" {
    type        = string
    default     = "aws/codebuild/standard:4.0"
}

variable "build_type" {
    type        = string
    default     = "LINUX_CONTAINER"
}

variable "privileged_mode" {
    type        = bool
    default     = true
}

variable "buildspec" {
    type        = string
    default     = "NO_SOURCE"
}

variable "source_type" {
    type        = string
}

variable "report_build_status" {
    type        = string
    default     = false
}

variable "git_clone_depth" {
    type        = string
}

variable "private_repository" {
    type        = bool
    default     = false
}

variable "fetch_git_submodules" {
    type        = string
    default     = true
}

variable "vpc_id" {
    type        = string
}

variable "subnets" {
    type        = list(string)
}

variable "security_group_ids" {
    type        = list(string)
}

variable "logs_config" {
    type    = object({
       key  = string
    })
}

variable "cache_bucket_prifix" {
    type    = string
}

variable "develop_hook_pattern" {
    type    = string
    default = "refs/heads/develop"
}

variable "master_hook_pattern" {
    type    = string
    default = "^refs/tags/.*"
}

variable "hotfix_hook_pattern" {
    type    = string
    default = "^refs/tags/.*"
}
