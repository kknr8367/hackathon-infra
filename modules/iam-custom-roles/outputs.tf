output "devops_policy_arn" {
  description = "ARN of DevOps role policy"
  value       = var.enable_devops_policy ? aws_iam_policy.devops_role[0].arn : ""
}

output "ai_engineer_policy_arn" {
  description = "ARN of AI Engineer role policy"
  value       = var.enable_ai_engineer_policy ? aws_iam_policy.ai_engineer_role[0].arn : ""
}

output "fullstack_policy_arn" {
  description = "ARN of Full Stack Engineer role policy"
  value       = var.enable_fullstack_policy ? aws_iam_policy.fullstack_role[0].arn : ""
}

output "all_policy_arns" {
  description = "Map of all created policy ARNs by role"
  value = {
    devops      = var.enable_devops_policy ? aws_iam_policy.devops_role[0].arn : null
    ai-engineer = var.enable_ai_engineer_policy ? aws_iam_policy.ai_engineer_role[0].arn : null
    fullstack   = var.enable_fullstack_policy ? aws_iam_policy.fullstack_role[0].arn : null
  }
}
