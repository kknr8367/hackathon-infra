variable "groups" {
  description = "Map of IAM groups to create"
  type = map(object({
    name        = string
    description = optional(string, "")
  }))
}

variable "attach_custom_policy" {
  description = "Whether to attach custom inline policy to groups"
  type        = bool
  default     = false
}

variable "custom_policy_json" {
  description = "JSON policy document for custom inline policy"
  type        = string
  default     = ""
}

variable "attach_region_restriction" {
  description = "Whether to attach region restriction policy to groups"
  type        = bool
  default     = true
}

variable "region_restriction_policy_arn" {
  description = "ARN of the region restriction policy to attach to groups"
  type        = string
  default     = ""
}

variable "role_based_policies" {
  description = "Map of role-based custom policy ARNs to attach to groups by skill set"
  type = map(object({
    policy_arns = list(string)
  }))
  default = {}

  # Example:
  # {
  #   "devops" = {
  #     policy_arns = ["arn:aws:iam::aws:policy/job-function/SystemAdministrator"]
  #   }
  #   "ai-engineer" = {
  #     policy_arns = ["arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"]
  #   }
  # }
}

variable "use_admin_policy" {
  description = "Whether to attach AdministratorAccess policy to all groups"
  type        = bool
  default     = true
}
