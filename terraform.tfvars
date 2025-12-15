# AWS Region Configuration
# This region is used for:
# 1. Resource deployment
# 2. Region restriction - users can ONLY access this region
aws_region = "us-east-1"

# Environment Name
environment = "hackathon-dec-2024"

# Participants organized by skill set
# Each skill set contains a list of participant names
participants = {
  "devops" = [
    "kamal",
    "abdul",
    "john",
    "jane",
    "mike",
    "sarah"
  ]

  "ai-engineer" = [
    "alex",
    "emma",
    "chris"
  ]

  "fullstack" = [
    "david",
    "lisa"
  ]
}

# Number of participants per group (default: 3)
group_size = 3

# Password settings (password is set to "user@567" for all users)
password_reset_required = false

# Create access keys for programmatic access
create_access_keys = true

# Additional tags for resources
additional_tags = {
  CostCenter = "Engineering"
  Event      = "December-Hackathon"
}

# ========================================
# ACCESS CONTROL CONFIGURATION
# ========================================

# Current Configuration: Admin Access for Everyone
# All users get full AdministratorAccess (use_custom_roles = false)
use_custom_roles = false

# Future Planning: Role-Based Access Control
# When ready to switch to role-based permissions, change use_custom_roles to true
# and enable the specific roles you need:
#
# use_custom_roles = true
# enable_custom_role_policies = {
#   devops      = true   # EC2, ECS, EKS, Lambda, VPC, CI/CD, monitoring
#   ai-engineer = true   # SageMaker, Bedrock, ML services, data processing
#   fullstack   = true   # Lambda, API Gateway, RDS, DynamoDB, Cognito
# }
#
# See REGION_AND_ROLES_GUIDE.md for detailed permission breakdown
