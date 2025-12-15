# Hackathon Lab Environment - Terraform IAM Management

This Terraform project automates the creation and management of AWS IAM users and groups for hackathon or interview lab environments. It supports dynamic participant assignment with automatic grouping based on skill sets and **enforces region-based access restrictions**.

> 🔒 **New in this version**: Users are automatically restricted to a single AWS region. They cannot access or switch to other regions, ensuring cost control and compliance boundaries.

## Quick Visual Overview

```
┌─────────────────────────────────────────────────────────────┐
│  Input: terraform.tfvars                                     │
│  ├── aws_region: "us-east-1"  ← Region lock!               │
│  ├── participants: {                                         │
│  │     "devops": ["kamal", "abdul", "john", ...]           │
│  │     "ai-engineer": ["alex", "emma", ...]                │
│  │   }                                                       │
│  └── group_size: 3                                          │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│  Terraform Creates:                                          │
│  ├── 👥 Users: kamal-devops-group1-user1                    │
│  │             abdul-devops-group1-user2                    │
│  │             john-devops-group1-user3, ...                │
│  ├── 👨‍👨‍👦 Groups: devops-group1, devops-group2, ...          │
│  └── 🔒 Region Policy: Allow only us-east-1                 │
└─────────────────────────────────────────────────────────────┘
                         ↓
┌─────────────────────────────────────────────────────────────┐
│  Users Can:                    Users Cannot:                 │
│  ✅ Full admin in us-east-1    ❌ Access us-west-2          │
│  ✅ Create any AWS resource    ❌ Switch regions            │
│  ✅ Console & CLI access       ❌ View other regions        │
│  ✅ Set up OIDC providers      ❌ Create elsewhere          │
└─────────────────────────────────────────────────────────────┘
```

## Features

- ✅ **Dynamic User Creation**: Create 1 to N IAM users based on participant list
- ✅ **Automatic Grouping**: Participants automatically grouped by skill set (default: 3 per group)
- ✅ **Flexible Naming**: Users named as `<name>-<skillset>-group<num>-user<num>`
- ✅ **Admin Access**: All users get AdministratorAccess policy for full AWS access
- ✅ **Region Restriction**: Users locked to a single AWS region - cannot access other regions
- ✅ **Console & Programmatic Access**: Provides both passwords and access keys
- ✅ **Modular Design**: Reusable modules for easy customization
- ✅ **Multiple Skill Sets**: Support for DevOps, AI Engineer, Full Stack, etc.

## Project Structure

```
.
├── main.tf                    # Main configuration and resource orchestration
├── variables.tf               # Input variables
├── outputs.tf                 # Output definitions
├── terraform.tfvars           # Variable values (customize this)
├── backend.tf                 # Remote state configuration (optional)
├── .gitignore                 # Git ignore patterns
├── README.md                  # This file
└── modules/
    ├── iam-users/             # IAM Users module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    ├── iam-groups/            # IAM Groups module
    │   ├── main.tf
    │   ├── variables.tf
    │   └── outputs.tf
    └── iam-region-policy/     # Region restriction policy module
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Prerequisites

1. **Terraform**: Version 1.0 or higher
   ```bash
   terraform version
   ```

2. **AWS CLI**: Configured with appropriate credentials
   ```bash
   aws configure
   ```

3. **AWS Permissions**: Your AWS credentials need IAM permissions to:
   - Create/Delete IAM Users
   - Create/Delete IAM Groups
   - Attach IAM Policies
   - Create Access Keys
   - Create Login Profiles

## Quick Start

### 1. Clone or Navigate to Project Directory

```bash
cd /Users/kamalanadha.kallutla/Downloads/bayer-hackathon/dec-28th-hackathon
```

### 2. Configure Participants

Edit `terraform.tfvars` to define your participants:

```hcl
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

group_size = 3  # Participants per group
```

### 3. Initialize Terraform

```bash
terraform init
```

### 4. Preview Changes

```bash
terraform plan
```

### 5. Apply Configuration

```bash
terraform apply
```

Type `yes` when prompted to create the resources.

### 6. Retrieve User Credentials

After successful deployment, retrieve user credentials:

```bash
# View all outputs
terraform output

# Get user passwords (sensitive)
terraform output -json user_credentials | jq

# Get access keys (sensitive)
terraform output -json user_access_keys | jq

# Save credentials to file (SECURE THIS FILE!)
terraform output -json user_credentials > credentials.json
```

## Usage Examples

### Example 1: Single Participant

```hcl
participants = {
  "devops" = ["john"]
}
```

**Result**: Creates user `john-devops-group1-user1` in group `devops-group1`

### Example 2: Multiple Skill Sets

```hcl
participants = {
  "devops" = ["kamal", "abdul", "john", "jane"]
  "ai-engineer" = ["alex", "emma"]
  "fullstack" = ["david"]
}

group_size = 3
```

**Result**:
- DevOps: 
  - `devops-group1`: kamal, abdul, john (users 1-3)
  - `devops-group2`: jane (user 1)
- AI Engineer:
  - `ai-engineer-group1`: alex, emma (users 1-2)
- Full Stack:
  - `fullstack-group1`: david (user 1)

### Example 3: Large Team

```hcl
participants = {
  "devops" = ["user1", "user2", "user3", "user4", "user5", "user6", "user7", "user8", "user9"]
}

group_size = 3
```

**Result**: Creates 3 groups with 3 users each:
- `devops-group1`: user1, user2, user3
- `devops-group2`: user4, user5, user6
- `devops-group3`: user7, user8, user9

## Configuration Options

### Variables

| Variable | Description | Default | Required |
|----------|-------------|---------|----------|
| `aws_region` | AWS region for deployment AND restriction | `us-east-1` | No |
| `environment` | Environment name | `hackathon` | No |
| `participants` | Map of skill sets to participant names | - | **Yes** |
| `group_size` | Number of participants per group | `3` | No |
| `password_reset_required` | Require password reset on first login | `true` | No |
| `create_access_keys` | Create programmatic access keys | `true` | No |
| `additional_tags` | Additional resource tags | `{}` | No |

> **Note**: The `aws_region` variable serves dual purposes - it's both the deployment region AND the only region users can access. Users cannot switch to or access resources in other regions.

### Outputs

| Output | Description |
|--------|-------------|
| `created_groups` | List of all IAM groups created |
| `created_users` | List of all IAM users created |
| `user_details` | Detailed user information with group assignments |
| `user_credentials` | Console login credentials (sensitive) |
| `user_access_keys` | Programmatic access credentials (sensitive) |
| `group_assignments` | Map of groups to their members |
| `participant_summary` | Summary statistics including allowed region |
| `region_restriction` | Information about the region restriction policy |

## User Access

### Console Login

Each user receives:
- **Username**: Format `<name>-<skillset>-group<num>-user<num>`
- **Temporary Password**: Retrieved via `terraform output user_credentials`
- **Console URL**: `https://<account-id>.signin.aws.amazon.com/console`
- **Required Action**: Reset password on first login (if `password_reset_required = true`)

### Programmatic Access

Each user receives:
- **Access Key ID**: For AWS CLI/SDK usage
- **Secret Access Key**: Retrieved via `terraform output user_access_keys`

Users can configure AWS CLI:
```bash
aws configure
# Enter Access Key ID
# Enter Secret Access Key
# Enter region: us-east-1
# Enter output format: json
```

## Permissions & Restrictions

### Current Configuration: Admin Access for Everyone

**All users currently receive full IAM AdministratorAccess** with these capabilities:
- ✅ Full access to all AWS services within the allowed region
- ✅ OIDC provider setup capability
- ✅ Resource creation/deletion (EC2, S3, Lambda, RDS, etc.)
- ✅ IAM role creation and management
- ✅ Complete control over infrastructure

> **Future Planning**: The infrastructure supports role-based access control. When ready, you can switch to custom roles (DevOps, AI Engineer, Full Stack) by setting `use_custom_roles = true` in `terraform.tfvars`. See `REGION_AND_ROLES_GUIDE.md` for details.

### Region Restriction
Users and groups are automatically restricted to the region specified in `aws_region`:

**What's Restricted:**
- ❌ Cannot access resources in other regions
- ❌ Cannot create resources in other regions
- ❌ Cannot switch AWS Console to other regions
- ❌ CLI/SDK calls to other regions will be denied

**What's Allowed:**
- ✅ Full access to all services in the specified region (e.g., us-east-1)
- ✅ Access to global services (IAM, CloudFront, Route53, etc.)
- ✅ Console login and session management
- ✅ STS operations for authentication

**Example:** If `aws_region = "us-east-1"`:
- Users can create EC2 instances in us-east-1 ✅
- Users cannot create EC2 instances in us-west-2 ❌
- Users cannot even view resources in other regions ❌

### Changing Regions Between Events
To switch to a different region for a new event:

```hcl
# For us-west-1 event
aws_region = "us-west-1"
```

All newly created users will only have access to us-west-1.

To modify permissions, edit the policy attachment in:
- `modules/iam-users/main.tf`
- `modules/iam-groups/main.tf`
- `modules/iam-region-policy/main.tf` (for region restrictions)

## Security Best Practices

1. **Secure Credentials**: Never commit `credentials.json` or sensitive outputs
2. **Remote State**: Use S3 backend with encryption (see `backend.tf`)
3. **Temporary Access**: Delete resources after hackathon/interview completion
4. **Password Policy**: Enforce strong passwords and MFA for production
5. **Least Privilege**: Consider reducing permissions from Admin for specific use cases
6. **Audit**: Enable CloudTrail for user activity monitoring

## Maintenance

### Add New Participants

1. Edit `terraform.tfvars` and add names to the appropriate skill set
2. Run `terraform plan` to preview changes
3. Run `terraform apply` to create new users

### Remove Participants

1. Remove names from `terraform.tfvars`
2. Run `terraform plan` to preview deletions
3. Run `terraform apply` to remove users

### Clean Up All Resources

```bash
terraform destroy
```

⚠️ **Warning**: This will delete all IAM users, groups, and access keys.

## Testing Region Restrictions

### Automated Test Script

Use the included test script to verify region restrictions work correctly:

```bash
# Get user credentials from terraform output
ACCESS_KEY=$(terraform output -json user_access_keys | jq -r '.["username-devops-group1-user1"].access_key_id')
SECRET_KEY=$(terraform output -json user_access_keys | jq -r '.["username-devops-group1-user1"].secret_access_key')

# Run the test (replace username with actual user)
./test_region_restriction.sh $ACCESS_KEY $SECRET_KEY us-east-1
```

### Manual Testing

#### Test 1: Verify Access to Allowed Region

```bash
# Configure AWS CLI with user credentials
aws configure --profile hackathon-user
# Enter the access key and secret from terraform output
# Set region to the allowed region (e.g., us-east-1)

# This should work
aws ec2 describe-instances --profile hackathon-user --region us-east-1
aws s3 ls --profile hackathon-user --region us-east-1
```

#### Test 2: Verify Denial to Other Regions

```bash
# This should fail with AccessDenied error
aws ec2 describe-instances --profile hackathon-user --region us-west-2
aws s3api list-buckets --profile hackathon-user --region eu-west-1

# Expected error:
# An error occurred (UnauthorizedOperation) when calling the DescribeInstances operation:
# You are not authorized to perform this operation.
```

#### Test 3: Verify Global Services Work

```bash
# Global services should still work
aws iam get-user --profile hackathon-user
aws sts get-caller-identity --profile hackathon-user
```

### Console Testing

1. Log in to AWS Console with user credentials
2. Navigate to EC2 service
3. Try to switch region using the region selector
4. Attempt to view resources in other regions
5. **Expected behavior**: Resources in other regions won't load or show access denied errors

## Troubleshooting

### Issue: "User already exists"

**Solution**: Either use different usernames or destroy existing resources first.

### Issue: AWS credentials not found

**Solution**: Configure AWS CLI with `aws configure` or set environment variables:
```bash
export AWS_ACCESS_KEY_ID="your-access-key"
export AWS_SECRET_ACCESS_KEY="your-secret-key"
export AWS_DEFAULT_REGION="us-east-1"
```

### Issue: Insufficient IAM permissions

**Solution**: Ensure your AWS credentials have IAM administrative permissions or attach the `IAMFullAccess` policy.

### Issue: Access keys limit exceeded

**Solution**: AWS allows maximum 2 access keys per user. Delete old keys before creating new ones.

### Issue: Users can still access other regions

**Solution**: 
1. Verify the region restriction policy is attached: `terraform output region_restriction`
2. Check that users have logged out and back in (policy changes may require re-authentication)
3. For Console: Clear browser cache and cookies, then log in again
4. Run the test script to verify: `./test_region_restriction.sh`

### Issue: Users can't access ANY resources

**Solution**: 
1. Check the `aws_region` variable matches your intended region
2. Verify AdministratorAccess policy is attached alongside region restriction
3. Ensure global services like IAM still work: `aws iam get-user`

## Advanced Usage

### Custom Group Size

To create groups of 5 participants instead of 3:

```hcl
group_size = 5
```

### Change Region for Different Events

To run an event in a different region, simply change `aws_region`:

```hcl
# Event 1: East Coast (January)
aws_region = "us-east-1"
environment = "hackathon-jan-2025"

# Event 2: West Coast (February)
aws_region = "us-west-2"
environment = "hackathon-feb-2025"

# Event 3: Europe (March)
aws_region = "eu-west-1"
environment = "hackathon-mar-2025"
```

Each deployment creates users restricted to that specific region only.

### Disable Access Keys

To create users without programmatic access:

```hcl
create_access_keys = false
```

### Remote State Management

Uncomment and configure `backend.tf`:

```hcl
terraform {
  backend "s3" {
    bucket         = "your-terraform-state-bucket"
    key            = "hackathon/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-state-lock"
  }
}
```

### Custom Tags

Add custom tags for cost tracking:

```hcl
additional_tags = {
  CostCenter = "Engineering"
  Event      = "December-Hackathon"
  Owner      = "kamal"
}
```

## Example Workflow

```bash
# 1. Initialize project
terraform init

# 2. Validate configuration
terraform validate

# 3. Format code
terraform fmt -recursive

# 4. Preview changes
terraform plan -out=tfplan

# 5. Apply changes
terraform apply tfplan

# 6. Export credentials
terraform output -json user_credentials > credentials.json

# 7. Distribute credentials to participants
# (Use secure method - encrypted email, password manager, etc.)

# 8. After event, clean up
terraform destroy
```

## Support and Contribution

For issues or enhancements, please:
1. Review the troubleshooting section
2. Check AWS IAM documentation
3. Verify Terraform version compatibility

## License

This project is provided as-is for educational and organizational purposes.

---

**Created for Bayer Hackathon - December 2024**
