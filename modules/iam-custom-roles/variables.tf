variable "policy_name_prefix" {
  description = "Prefix for IAM policy names"
  type        = string
  default     = "hackathon"
}

variable "policy_path" {
  description = "Path for IAM policies"
  type        = string
  default     = "/"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "hackathon"
}

variable "tags" {
  description = "Additional tags for policies"
  type        = map(string)
  default     = {}
}

variable "enable_devops_policy" {
  description = "Create DevOps role policy"
  type        = bool
  default     = false
}

variable "enable_ai_engineer_policy" {
  description = "Create AI Engineer role policy"
  type        = bool
  default     = false
}

variable "enable_fullstack_policy" {
  description = "Create Full Stack Engineer role policy"
  type        = bool
  default     = false
}
