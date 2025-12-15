output "policy_arn" {
  description = "ARN of the region restriction IAM policy"
  value       = aws_iam_policy.region_restriction.arn
}

output "policy_id" {
  description = "ID of the region restriction IAM policy"
  value       = aws_iam_policy.region_restriction.id
}

output "policy_name" {
  description = "Name of the region restriction IAM policy"
  value       = aws_iam_policy.region_restriction.name
}

output "allowed_region" {
  description = "The AWS region that is allowed by this policy"
  value       = var.allowed_region
}

output "policy_document" {
  description = "The policy document JSON"
  value       = data.aws_iam_policy_document.region_restriction.json
}
