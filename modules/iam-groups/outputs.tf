output "group_names" {
  description = "List of created IAM group names"
  value       = [for group in aws_iam_group.group : group.name]
}

output "group_arns" {
  description = "Map of group ARNs"
  value       = { for key, group in aws_iam_group.group : key => group.arn }
}

output "group_details" {
  description = "Complete group details"
  value = {
    for key, group in aws_iam_group.group : key => {
      name      = group.name
      arn       = group.arn
      unique_id = group.unique_id
    }
  }
}
