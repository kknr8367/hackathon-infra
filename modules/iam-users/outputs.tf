output "user_names" {
  description = "List of created IAM user names"
  value       = [for user in aws_iam_user.user : user.name]
}

output "user_arns" {
  description = "Map of user ARNs"
  value       = { for key, user in aws_iam_user.user : key => user.arn }
}

output "user_passwords" {
  description = "Map of user passwords (sensitive)"
  value       = { for key, profile in aws_iam_user_login_profile.user_login : key => profile.password }
  sensitive   = true
}

output "user_access_keys" {
  description = "Map of user access key IDs"
  value       = { for key, access_key in aws_iam_access_key.user_key : key => access_key.id }
}

output "user_secret_keys" {
  description = "Map of user secret access keys (sensitive)"
  value       = { for key, access_key in aws_iam_access_key.user_key : key => access_key.secret }
  sensitive   = true
}

output "user_details" {
  description = "Complete user details including username and group"
  value = {
    for key, user in aws_iam_user.user : key => {
      username  = user.name
      arn       = user.arn
      group     = var.users[key].group
      unique_id = user.unique_id
    }
  }
}
