# IAM Region Restriction Policy Module

This module creates an IAM policy that restricts users and groups to a single AWS region.

## Purpose

Ensures that hackathon/interview participants can only access resources in the designated region, preventing accidental resource creation or access in other regions.

## Features

- **Single Region Access**: Users can only interact with resources in the specified region
- **Global Services Support**: Allows access to region-independent services (IAM, Route53, CloudFront, etc.)
- **Explicit Deny**: Uses deny rules to prevent region switching
- **Console & CLI Enforcement**: Works for both AWS Console and programmatic access

## Usage

```hcl
module "region_restriction_policy" {
  source = "./modules/iam-region-policy"
  
  allowed_region     = "us-east-1"
  policy_name_prefix = "hackathon"
  environment        = "hackathon-dec-2024"
  
  tags = {
    Event = "December-Hackathon"
  }
}

# Attach to users
resource "aws_iam_user_policy_attachment" "region_restriction" {
  user       = aws_iam_user.example.name
  policy_arn = module.region_restriction_policy.policy_arn
}

# Attach to groups
resource "aws_iam_group_policy_attachment" "region_restriction" {
  group      = aws_iam_group.example.name
  policy_arn = module.region_restriction_policy.policy_arn
}
```

## How It Works

The policy uses three statements:

1. **Allow Specified Region**: Permits all actions in the allowed region
2. **Allow Global Services**: Permits access to region-independent AWS services
3. **Deny Other Regions**: Explicitly denies access to all other regions

## Variables

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| allowed_region | AWS region that users can access | string | - | yes |
| policy_name_prefix | Prefix for policy name | string | "hackathon" | no |
| policy_path | IAM policy path | string | "/" | no |
| environment | Environment name | string | "hackathon" | no |
| tags | Additional tags | map(string) | {} | no |
| excluded_services | Services excluded from restriction | list(string) | [global services] | no |
| excluded_services_regions | Additional regions to exclude | list(string) | [] | no |

## Outputs

| Name | Description |
|------|-------------|
| policy_arn | ARN of the region restriction policy |
| policy_id | ID of the region restriction policy |
| policy_name | Name of the region restriction policy |
| allowed_region | The allowed AWS region |
| policy_document | The complete policy document JSON |

## Examples

### Restrict to us-east-1

```hcl
module "region_restriction" {
  source = "./modules/iam-region-policy"
  
  allowed_region = "us-east-1"
  environment    = "interview"
}
```

### Restrict to eu-west-1

```hcl
module "region_restriction" {
  source = "./modules/iam-region-policy"
  
  allowed_region = "eu-west-1"
  environment    = "hackathon-europe"
}
```

## Testing Region Restriction

After applying, test with AWS CLI:

```bash
# This should work (allowed region)
aws ec2 describe-instances --region us-east-1

# This should be denied (other region)
aws ec2 describe-instances --region us-west-2
# Error: AccessDenied
```

## Notes

- Global services (IAM, CloudFront, Route53) remain accessible
- Users can still view the AWS Console but cannot access other regions
- STS operations (authentication) are not restricted
- The policy works alongside AdministratorAccess - restrictions apply first

## Security Considerations

- This policy prevents accidental costs in other regions
- Users cannot bypass this restriction without policy modification
- Even with Administrator permissions, region access is denied
- Consider using AWS Organizations SCPs for additional enforcement
