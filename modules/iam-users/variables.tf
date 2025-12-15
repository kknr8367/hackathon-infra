variable "users" {
  description = "Map of users to create with their details"
  type = map(object({
    username = string
    group    = string
  }))
}

variable "environment" {
  description = "Environment name (e.g., hackathon, interview)"
  type        = string
  default     = "hackathon"
}

variable "tags" {
  description = "Additional tags to apply to IAM users"
  type        = map(string)
  default     = {}
}

variable "password_reset_required" {
  description = "Whether users must reset password on first login"
  type        = bool
  default     = true
}

variable "create_access_keys" {
  description = "Whether to create access keys for programmatic access"
  type        = bool
  default     = true
}

variable "attach_custom_policy" {
  description = "Whether to attach custom inline policy to users"
  type        = bool
  default     = false
}

variable "custom_policy_json" {
  description = "JSON policy document for custom inline policy"
  type        = string
  default     = ""
}

variable "region_restriction_policy_arn" {
  description = "ARN of the region restriction policy to attach to users"
  type        = string
  default     = ""
}
