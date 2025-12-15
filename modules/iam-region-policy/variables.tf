variable "allowed_region" {
  description = "The AWS region that users/groups are allowed to access"
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z]+-[0-9]$", var.allowed_region))
    error_message = "The allowed_region must be a valid AWS region format (e.g., us-east-1, eu-west-1)."
  }
}

variable "policy_name_prefix" {
  description = "Prefix for the IAM policy name"
  type        = string
  default     = "hackathon"
}

variable "policy_path" {
  description = "Path for the IAM policy"
  type        = string
  default     = "/"
}

variable "environment" {
  description = "Environment name (e.g., hackathon, interview)"
  type        = string
  default     = "hackathon"
}

variable "tags" {
  description = "Additional tags to apply to the IAM policy"
  type        = map(string)
  default     = {}
}

variable "excluded_services" {
  description = "AWS services that should be excluded from region restriction (e.g., for cross-region replication)"
  type        = list(string)
  default = [
    "cloudfront.amazonaws.com",
    "route53.amazonaws.com",
    "iam.amazonaws.com",
    "organizations.amazonaws.com",
    "support.amazonaws.com",
    "trustedadvisor.amazonaws.com"
  ]
}

variable "excluded_services_regions" {
  description = "Additional regions to exclude from the deny rule (typically empty for strict enforcement)"
  type        = list(string)
  default     = []
}
