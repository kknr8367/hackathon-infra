output "created_groups" {
  description = "List of all created IAM groups"
  value       = module.iam_groups.group_names
}

output "created_users" {
  description = "List of all created IAM users"
  value       = module.iam_users.user_names
}

output "user_details" {
  description = "Detailed information about all created users"
  value       = module.iam_users.user_details
}

output "user_credentials" {
  description = "User login credentials (passwords) - SENSITIVE"
  value = {
    for username, password in module.iam_users.user_passwords :
    username => {
      username    = username
      password    = password
      console_url = "https://${data.aws_caller_identity.current.account_id}.signin.aws.amazon.com/console"
    }
  }
  sensitive = true
}

output "user_access_keys" {
  description = "User programmatic access credentials - SENSITIVE"
  value = {
    for username in keys(module.iam_users.user_access_keys) :
    username => {
      access_key_id     = module.iam_users.user_access_keys[username]
      secret_access_key = module.iam_users.user_secret_keys[username]
    }
  }
  sensitive = true
}

output "group_assignments" {
  description = "Map showing which users are assigned to which groups"
  value = {
    for group_name in module.iam_groups.group_names :
    group_name => [
      for username, details in module.iam_users.user_details :
      username if details.group == group_name
    ]
  }
}

output "participant_summary" {
  description = "Summary of participant organization"
  value = {
    total_users    = length(module.iam_users.user_names)
    total_groups   = length(module.iam_groups.group_names)
    allowed_region = module.region_restriction_policy.allowed_region
    users_by_group = {
      for group_name in module.iam_groups.group_names :
      group_name => length([
        for username, details in module.iam_users.user_details :
        username if details.group == group_name
      ])
    }
  }
}

output "region_restriction" {
  description = "Information about region restriction policy"
  value = {
    policy_name    = module.region_restriction_policy.policy_name
    policy_arn     = module.region_restriction_policy.policy_arn
    allowed_region = module.region_restriction_policy.allowed_region
  }
}

# Data source to get AWS account ID
data "aws_caller_identity" "current" {}
