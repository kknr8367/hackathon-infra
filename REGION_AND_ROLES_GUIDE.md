# Region Restriction & Custom Roles Guide

## ✅ Region Restriction Implementation

### How It Works

The region restriction is implemented using **IAM policy conditions with EXPLICIT DENY**, which is the strongest form of access control in AWS.

### Policy Structure

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "AllowOnlySpecifiedRegion",
      "Effect": "Allow",
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    },
    {
      "Sid": "DenyOtherRegions",
      "Effect": "Deny",  ← EXPLICIT DENY (Cannot be overridden)
      "Action": "*",
      "Resource": "*",
      "Condition": {
        "StringNotEquals": {
          "aws:RequestedRegion": "us-east-1"
        }
      }
    }
  ]
}
```

### Why Users Cannot Switch Regions

1. **Explicit Deny Always Wins**
   - In AWS IAM, an explicit `Deny` **always** overrides any `Allow`
   - Even if a user has `AdministratorAccess`, the deny takes precedence

2. **Attached at Multiple Levels**
   - Policy attached to **IAM Users** directly
   - Policy attached to **IAM Groups**
   - Defense in depth - double protection

3. **Condition-Based Enforcement**
   - Uses `aws:RequestedRegion` condition key
   - AWS evaluates this for **every** API call
   - Works for Console, CLI, SDK, and API calls

4. **No Bypass Possible**
   - Users cannot modify their own policies
   - Users cannot detach the policy
   - Users cannot assume roles without this restriction (they don't have permission)

### Verification

#### Test 1: Console Access
```
1. User logs into AWS Console
2. Sees region selector dropdown
3. Can click other regions BUT
4. Services show "Access Denied" or empty lists
5. Cannot create resources in other regions
```

#### Test 2: CLI Access
```bash
# ✅ Allowed region - WORKS
aws ec2 describe-instances --region us-east-1
# Returns: Instance list

# ❌ Other region - FAILS
aws ec2 describe-instances --region us-west-2
# Returns: An error occurred (UnauthorizedOperation) when calling the DescribeInstances operation:
#          You are not authorized to perform this operation.
```

#### Test 3: SDK Access
```python
import boto3

# ✅ Allowed region - WORKS
ec2_east = boto3.client('ec2', region_name='us-east-1')
instances = ec2_east.describe_instances()  # Success

# ❌ Other region - FAILS
ec2_west = boto3.client('ec2', region_name='us-west-2')
instances = ec2_west.describe_instances()  # AccessDenied Exception
```

### Test Script Verification

Run the included test script:

```bash
# Extract credentials
ACCESS_KEY=$(terraform output -json user_access_keys | jq -r '.[keys[0]].access_key_id')
SECRET_KEY=$(terraform output -json user_access_keys | jq -r '.[keys[0]].secret_access_key')

# Test restrictions
./test_region_restriction.sh $ACCESS_KEY $SECRET_KEY us-east-1
```

Expected output:
```
✅ SUCCESS: Can access allowed region (us-east-1)
✅ SUCCESS: Access denied to forbidden region (us-west-2) as expected
```

## 🎭 Custom Role-Based Permissions

### Overview

Instead of giving everyone `AdministratorAccess`, you can assign **role-specific permissions** based on skill sets.

### Available Roles

#### 1. **DevOps Role**
**Focus**: Infrastructure, CI/CD, Monitoring

**Permissions**:
- ✅ Full EC2, ECS, EKS, Lambda
- ✅ VPC, Load Balancers, Route53
- ✅ RDS, DynamoDB, ElastiCache
- ✅ CloudFormation, Systems Manager
- ✅ CodePipeline, CodeBuild, CodeDeploy
- ✅ CloudWatch, X-Ray, Logs
- ✅ ECR, Secrets Manager, KMS
- ⚠️ Limited IAM (PassRole, GetRole only)

**Use Case**: Infrastructure engineers, Site Reliability Engineers

#### 2. **AI Engineer Role**
**Focus**: Machine Learning, Data Science, AI Services

**Permissions**:
- ✅ Full SageMaker, Bedrock (Generative AI)
- ✅ Rekognition, Comprehend, Translate, Textract
- ✅ Glue, Athena, EMR (Data Processing)
- ✅ S3 (for datasets)
- ✅ Limited EC2 (only for ML instances)
- ✅ Lambda (for ML inference)
- ✅ CloudWatch Logs
- ⚠️ Limited IAM (PassRole for SageMaker)

**Use Case**: Data Scientists, ML Engineers, AI Researchers

#### 3. **Full Stack Role**
**Focus**: Application Development, APIs, Databases

**Permissions**:
- ✅ Lambda, API Gateway, AppSync
- ✅ RDS, DynamoDB, ElastiCache
- ✅ S3, CloudFront
- ✅ Cognito (Authentication)
- ✅ ECS, ECR (Containers)
- ✅ SNS, SQS, EventBridge
- ✅ Amplify
- ✅ CloudWatch
- ⚠️ Limited IAM (PassRole for Lambda)

**Use Case**: Full Stack Developers, Backend/Frontend Engineers

### How to Enable Custom Roles

#### Configuration

Edit `terraform.tfvars`:

```hcl
# Switch from Admin to Custom Roles
use_custom_roles = true

# Enable role policies
enable_custom_role_policies = {
  devops      = true
  ai-engineer = true
  fullstack   = true
}

participants = {
  "devops"      = ["kamal", "abdul", "john"]
  "ai-engineer" = ["alex", "emma"]
  "fullstack"   = ["david", "lisa"]
}
```

#### What Happens

1. **Custom Policies Created**:
   - `hackathon-devops-role` policy
   - `hackathon-ai-engineer-role` policy
   - `hackathon-fullstack-role` policy

2. **Policies Attached to Groups**:
   - `devops-group1` gets DevOps policy
   - `ai-engineer-group1` gets AI Engineer policy
   - `fullstack-group1` gets Full Stack policy

3. **Region Restriction Still Applied**:
   - All users still locked to specified region
   - Custom roles + region restriction = **Double Security**

### Comparison

| Feature | Admin Access | Custom Roles |
|---------|-------------|--------------|
| **All AWS Services** | ✅ Yes | ⚠️ Role-specific |
| **Create IAM Users** | ✅ Yes | ❌ No |
| **Full IAM Access** | ✅ Yes | ❌ No |
| **Skill-Specific Tools** | ✅ Yes | ✅ Yes (optimized) |
| **Region Restriction** | ✅ Applied | ✅ Applied |
| **Security Level** | Medium | High |
| **Cost Risk** | Higher | Lower |

### When to Use Each

#### Use Admin Access When:
- ✅ Short hackathon (1-3 days)
- ✅ Experienced participants
- ✅ Need maximum flexibility
- ✅ Tight timeline
- ✅ Trust level is high

#### Use Custom Roles When:
- ✅ Longer events (1+ weeks)
- ✅ Mixed skill levels
- ✅ Cost control is critical
- ✅ Compliance requirements
- ✅ Want to prevent misconfigurations

### Future Role Customization

#### Adding New Roles

1. **Edit** `modules/iam-custom-roles/main.tf`
2. **Add new policy document**:
```hcl
data "aws_iam_policy_document" "data_engineer_role" {
  statement {
    actions = [
      "glue:*",
      "athena:*",
      "kinesis:*",
      # ... more permissions
    ]
    resources = ["*"]
  }
}
```

3. **Create policy resource**:
```hcl
resource "aws_iam_policy" "data_engineer_role" {
  name   = "${var.policy_name_prefix}-data-engineer-role"
  policy = data.aws_iam_policy_document.data_engineer_role.json
}
```

4. **Add variable**:
```hcl
variable "enable_data_engineer_policy" {
  type    = bool
  default = false
}
```

5. **Add output**:
```hcl
output "data_engineer_policy_arn" {
  value = var.enable_data_engineer_policy ? aws_iam_policy.data_engineer_role[0].arn : ""
}
```

#### Modifying Existing Roles

Edit the policy document in `modules/iam-custom-roles/main.tf`:

```hcl
# Add more permissions to DevOps role
data "aws_iam_policy_document" "devops_role" {
  statement {
    actions = [
      # ... existing actions
      "stepfunctions:*",  # Add Step Functions
      "batch:*"           # Add AWS Batch
    ]
    resources = ["*"]
  }
}
```

### Testing Custom Roles

```bash
# Deploy with custom roles
terraform apply -var-file="examples/custom-roles.tfvars"

# Test DevOps user
aws ec2 describe-instances --profile devops-user  # ✅ Works
aws sagemaker list-notebook-instances --profile devops-user  # ❌ Denied

# Test AI Engineer user
aws sagemaker list-notebook-instances --profile ai-user  # ✅ Works
aws ec2 describe-instances --profile ai-user  # ⚠️ Limited access

# Test Full Stack user
aws lambda list-functions --profile fullstack-user  # ✅ Works
aws ecs list-clusters --profile fullstack-user  # ⚠️ Limited
```

## 🔐 Security Best Practices

### 1. **Always Apply Region Restriction**
- Use in both Admin and Custom Role modes
- Prevents unexpected costs
- Enforces compliance boundaries

### 2. **Start with Custom Roles**
- Begin restrictive, expand if needed
- Easier to grant than revoke permissions
- Better audit trail

### 3. **Monitor Usage**
- Enable CloudTrail
- Review access patterns
- Identify permission gaps

### 4. **Least Privilege**
- Give minimum required permissions
- Use custom roles for production
- Reserve admin access for emergencies

### 5. **Regular Review**
- Review policies quarterly
- Remove unused permissions
- Update for new AWS services

## 📊 Permission Matrix

| AWS Service | DevOps | AI Engineer | Full Stack | Admin |
|------------|--------|-------------|------------|-------|
| EC2 | ✅ Full | ⚠️ Limited | ⚠️ Limited | ✅ Full |
| Lambda | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| RDS | ✅ Full | ❌ None | ✅ Full | ✅ Full |
| SageMaker | ❌ None | ✅ Full | ❌ None | ✅ Full |
| S3 | ✅ Full | ✅ Full | ✅ Full | ✅ Full |
| IAM | ⚠️ Limited | ⚠️ Limited | ⚠️ Limited | ✅ Full |
| VPC | ✅ Full | ❌ None | ⚠️ Limited | ✅ Full |
| DynamoDB | ✅ Full | ❌ None | ✅ Full | ✅ Full |
| API Gateway | ⚠️ Limited | ❌ None | ✅ Full | ✅ Full |
| CloudFormation | ✅ Full | ❌ None | ✅ Full | ✅ Full |

## 🎯 Quick Start

### Option 1: Admin Access (Current Default)
```hcl
use_custom_roles = false  # or omit this line
```

### Option 2: Custom Roles
```hcl
use_custom_roles = true
enable_custom_role_policies = {
  devops      = true
  ai-engineer = true
  fullstack   = true
}
```

### Option 3: Mixed (Future Enhancement)
```hcl
# Some groups get admin, others get custom roles
# This requires additional development
```

---

**Key Takeaway**: Region restriction is **always enforced** regardless of permission model. Custom roles provide **additional** security by limiting service access within the allowed region.
