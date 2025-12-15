# Example: Custom Role-Based Permissions
# Different skill sets get different AWS permissions

aws_region  = "us-east-1"
environment = "hackathon-role-based"

# Enable custom role-based policies instead of admin access
use_custom_roles = true

# Enable specific role policies
enable_custom_role_policies = {
  devops      = true
  ai-engineer = true
  fullstack   = true
}

# Participants organized by skill set
participants = {
  "devops" = [
    "kamal",
    "abdul",
    "john"
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

group_size              = 3
password_reset_required = true
create_access_keys      = true

additional_tags = {
  Event         = "Role-Based-Hackathon"
  AccessType    = "Custom-Roles"
  SecurityLevel = "Restricted"
}

# RESULT:
# -------
# DevOps groups get:
#   - Full EC2, ECS, EKS, Lambda access
#   - Full networking (VPC, ELB, Route53)
#   - CI/CD tools (CodePipeline, CodeBuild, etc.)
#   - Monitoring (CloudWatch, X-Ray)
#   - NO full IAM access
#
# AI Engineer groups get:
#   - Full SageMaker, Bedrock, Rekognition access
#   - ML services (Comprehend, Translate, etc.)
#   - Data processing (Glue, Athena, EMR)
#   - S3 for ML datasets
#   - NO EC2/networking beyond what's needed for ML
#
# Full Stack groups get:
#   - Lambda, API Gateway, AppSync
#   - RDS, DynamoDB
#   - S3, CloudFront
#   - Cognito for auth
#   - NO heavy infrastructure tools
#
# ALL groups still get:
#   - Region restriction (us-east-1 only)
#   - Cannot access other regions
