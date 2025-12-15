# Custom Role Policies Module
# Creates custom IAM policies for different skill sets/roles

# DevOps Role Policy
data "aws_iam_policy_document" "devops_role" {
  count = var.enable_devops_policy ? 1 : 0

  statement {
    sid    = "DevOpsFullAccess"
    effect = "Allow"
    actions = [
      # Compute
      "ec2:*",
      "ecs:*",
      "eks:*",
      "lambda:*",
      "elasticbeanstalk:*",

      # Networking
      "vpc:*",
      "elasticloadbalancing:*",
      "route53:*",
      "cloudfront:*",

      # Storage
      "s3:*",
      "ebs:*",
      "efs:*",

      # Database
      "rds:*",
      "dynamodb:*",
      "elasticache:*",

      # Monitoring & Logging
      "cloudwatch:*",
      "logs:*",
      "xray:*",

      # Infrastructure as Code
      "cloudformation:*",
      "ssm:*",

      # CI/CD
      "codepipeline:*",
      "codebuild:*",
      "codecommit:*",
      "codedeploy:*",

      # Containers
      "ecr:*",

      # Security
      "secretsmanager:*",
      "kms:*",

      # IAM (limited)
      "iam:GetRole",
      "iam:GetRolePolicy",
      "iam:ListRoles",
      "iam:PassRole",
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "devops_role" {
  count = var.enable_devops_policy ? 1 : 0

  name        = "${var.policy_name_prefix}-devops-role"
  path        = var.policy_path
  description = "Custom policy for DevOps engineers - ${var.environment}"

  policy = data.aws_iam_policy_document.devops_role[0].json

  tags = merge(
    {
      Name        = "${var.policy_name_prefix}-devops-role"
      Role        = "DevOps"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# AI Engineer Role Policy
data "aws_iam_policy_document" "ai_engineer_role" {
  count = var.enable_ai_engineer_policy ? 1 : 0

  statement {
    sid    = "AIEngineerFullAccess"
    effect = "Allow"
    actions = [
      # ML Services
      "sagemaker:*",
      "comprehend:*",
      "rekognition:*",
      "textract:*",
      "translate:*",
      "polly:*",
      "transcribe:*",
      "lex:*",
      "forecast:*",
      "personalize:*",
      "kendra:*",

      # Bedrock (Generative AI)
      "bedrock:*",

      # Data Processing
      "glue:*",
      "athena:*",
      "emr:*",

      # Storage for ML
      "s3:*",

      # Compute for ML
      "ec2:Describe*",
      "ec2:CreateTags",
      "ec2:RunInstances",
      "ec2:TerminateInstances",
      "lambda:*",

      # Notebooks & IDEs
      "cloud9:*",

      # Data Lakes
      "lakeformation:*",

      # Monitoring
      "cloudwatch:*",
      "logs:*",

      # IAM (limited)
      "iam:GetRole",
      "iam:ListRoles",
      "iam:PassRole",
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "ai_engineer_role" {
  count = var.enable_ai_engineer_policy ? 1 : 0

  name        = "${var.policy_name_prefix}-ai-engineer-role"
  path        = var.policy_path
  description = "Custom policy for AI Engineers - ${var.environment}"

  policy = data.aws_iam_policy_document.ai_engineer_role[0].json

  tags = merge(
    {
      Name        = "${var.policy_name_prefix}-ai-engineer-role"
      Role        = "AI-Engineer"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# Full Stack Engineer Role Policy
data "aws_iam_policy_document" "fullstack_role" {
  count = var.enable_fullstack_policy ? 1 : 0

  statement {
    sid    = "FullStackFullAccess"
    effect = "Allow"
    actions = [
      # Compute
      "ec2:*",
      "lambda:*",
      "elasticbeanstalk:*",
      "lightsail:*",

      # Containers
      "ecs:*",
      "ecr:*",
      "eks:*",

      # API & Application
      "apigateway:*",
      "appsync:*",
      "amplify:*",

      # Storage
      "s3:*",

      # Database
      "rds:*",
      "dynamodb:*",
      "elasticache:*",
      "neptune:*",
      "timestream:*",

      # Authentication
      "cognito-idp:*",
      "cognito-identity:*",

      # Networking
      "elasticloadbalancing:*",
      "route53:*",
      "cloudfront:*",

      # CDN & Media
      "cloudfront:*",
      "mediaconvert:*",
      "mediastore:*",

      # Messaging & Events
      "sns:*",
      "sqs:*",
      "eventbridge:*",

      # Monitoring
      "cloudwatch:*",
      "logs:*",
      "xray:*",

      # Infrastructure as Code
      "cloudformation:*",

      # Security
      "secretsmanager:*",
      "kms:Describe*",
      "kms:List*",

      # IAM (limited)
      "iam:GetRole",
      "iam:ListRoles",
      "iam:PassRole",
      "iam:CreateServiceLinkedRole"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "fullstack_role" {
  count = var.enable_fullstack_policy ? 1 : 0

  name        = "${var.policy_name_prefix}-fullstack-role"
  path        = var.policy_path
  description = "Custom policy for Full Stack Engineers - ${var.environment}"

  policy = data.aws_iam_policy_document.fullstack_role[0].json

  tags = merge(
    {
      Name        = "${var.policy_name_prefix}-fullstack-role"
      Role        = "FullStack"
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}
