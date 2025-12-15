variable "aws_region" {
  description = "AWS region for resource deployment"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "Environment name (e.g., hackathon, interview, dev)"
  type        = string
  default     = "hackathon"
}

variable "participants" {
  description = "Map of skill sets to list of participant names"
  type        = map(list(string))

  # Example:
  # {
  #   "devops"     = ["kamal", "abdul", "john", "jane", "mike", "sarah"]
  #   "ai-engineer" = ["alex", "emma"]
  #   "fullstack"  = ["david"]
  # }
}

variable "group_size" {
  description = "Number of participants per group"
  type        = number
  default     = 3

  validation {
    condition     = var.group_size > 0
    error_message = "Group size must be greater than 0."
  }
}

variable "password_reset_required" {
  description = "Require users to reset password on first login"
  type        = bool
  default     = true
}

variable "create_access_keys" {
  description = "Create access keys for programmatic access"
  type        = bool
  default     = true
}

variable "additional_tags" {
  description = "Additional tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "use_custom_roles" {
  description = "Use custom role-based policies instead of AdministratorAccess"
  type        = bool
  default     = false
}

variable "enable_custom_role_policies" {
  description = "Map of skill sets to enable custom policy creation"
  type        = map(bool)
  default = {
    devops      = false
    ai-engineer = false
    fullstack   = false
  }
}
