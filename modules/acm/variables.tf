variable "domain_name" {
  type        = string
}

variable "zone_domain_name" {
  type        = string
}

variable "subject_alternative_names" {
  type        = list(string)
  default     = []
}

variable "hosted_zone_id" {
  type        = string
  default     = ""
}

variable "validation_record_ttl" {
  type        = number
  default     = 300
}

variable "allow_validation_record_overwrite" {
  type        = bool
  default     = true
}
