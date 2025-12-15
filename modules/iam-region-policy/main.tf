# IAM Region Restriction Policy Module
# Creates policies to restrict IAM users/groups to a specific AWS region

# Create the region restriction policy document
data "aws_iam_policy_document" "region_restriction" {
  # Allow all actions ONLY in the specified region
  statement {
    sid       = "AllowOnlySpecifiedRegion"
    effect    = "Allow"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = [var.allowed_region]
    }
  }

  # Allow global services (IAM, CloudFront, Route53, etc.) that don't have regions
  statement {
    sid    = "AllowGlobalServices"
    effect = "Allow"
    actions = [
      "iam:*",
      "organizations:*",
      "account:*",
      "aws-portal:*",
      "budgets:*",
      "ce:*",
      "cloudfront:*",
      "globalaccelerator:*",
      "importexport:*",
      "route53:*",
      "route53domains:*",
      "support:*",
      "trustedadvisor:*",
      "waf:*",
      "shield:*",
      "health:*"
    ]
    resources = ["*"]
  }

  # Explicitly deny access to other regions
  statement {
    sid       = "DenyOtherRegions"
    effect    = "Deny"
    actions   = ["*"]
    resources = ["*"]

    condition {
      test     = "StringNotEquals"
      variable = "aws:RequestedRegion"
      values   = concat([var.allowed_region], var.excluded_services_regions)
    }

    condition {
      test     = "StringNotEquals"
      variable = "aws:PrincipalServiceName"
      values   = var.excluded_services
    }
  }

  # Allow console login and session management (region-independent)
  statement {
    sid    = "AllowConsoleAccess"
    effect = "Allow"
    actions = [
      "sts:GetSessionToken",
      "sts:GetCallerIdentity",
      "sts:GetAccessKeyInfo",
      "sts:DecodeAuthorizationMessage"
    ]
    resources = ["*"]
  }
}

# Create the IAM policy
resource "aws_iam_policy" "region_restriction" {
  name        = "${var.policy_name_prefix}-region-restriction-${var.allowed_region}"
  path        = var.policy_path
  description = "Restricts access to ${var.allowed_region} region only for ${var.environment}"

  policy = data.aws_iam_policy_document.region_restriction.json

  tags = merge(
    {
      Name          = "${var.policy_name_prefix}-region-restriction"
      AllowedRegion = var.allowed_region
      Environment   = var.environment
      ManagedBy     = "Terraform"
    },
    var.tags
  )
}
