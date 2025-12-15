# Hackathon Participant Quick Start Guide

## Your Account Information

- **Username**: `[provided by organizer]`
- **Temporary Password**: `[provided by organizer]`
- **AWS Console URL**: `https://[account-id].signin.aws.amazon.com/console`
- **Allowed Region**: `[us-east-1/us-west-2/etc.]`
- **Group**: `[your-group-name]`

## First Login Steps

### 1. Console Access

1. Go to the AWS Console URL provided
2. Enter your username and temporary password
3. You'll be prompted to set a new password
4. Choose a strong password and save it securely

### 2. Configure AWS CLI (Optional)

```bash
# Install AWS CLI if not already installed
# macOS: brew install awscli
# Linux: pip install awscli
# Windows: Download from aws.amazon.com/cli

# Configure your profile
aws configure --profile hackathon

# Enter your credentials when prompted:
# AWS Access Key ID: [from organizer]
# AWS Secret Access Key: [from organizer]
# Default region: [us-east-1 or specified region]
# Default output format: json

# Test your access
aws sts get-caller-identity --profile hackathon
```

## Important: Region Restriction ⚠️

**You can ONLY access resources in: [SPECIFIED REGION]**

### ✅ What You CAN Do:
- Create and manage resources in your assigned region
- Access all AWS services within your region
- Use IAM, CloudFront, Route53 (global services)
- Switch between console and CLI

### ❌ What You CANNOT Do:
- Access or create resources in other regions
- Switch to other regions in the console
- Use CLI commands with other regions
- View resources outside your assigned region

### Example:

```bash
# ✅ This works (allowed region)
aws ec2 describe-instances --region us-east-1 --profile hackathon

# ❌ This fails (other region)
aws ec2 describe-instances --region us-west-2 --profile hackathon
# Error: You are not authorized to perform this operation
```

## Your Permissions

You have **Administrator Access** within your allowed region, which means:

- ✅ Create/Delete EC2 instances
- ✅ Create/Delete S3 buckets
- ✅ Set up Lambda functions
- ✅ Configure VPCs and networking
- ✅ Create RDS databases
- ✅ Deploy containers (ECS/EKS)
- ✅ Set up OIDC providers
- ✅ Create IAM roles and policies
- ✅ Use CloudFormation/CDK
- ✅ Access all AWS services

## Common Tasks

### Create an EC2 Instance (Console)

1. Go to EC2 service (make sure you're in the correct region!)
2. Click "Launch Instance"
3. Follow the wizard to configure your instance
4. **Important**: Resources will only appear in your allowed region

### Create an S3 Bucket (CLI)

```bash
# Create a bucket in your allowed region
aws s3 mb s3://your-unique-bucket-name --region us-east-1 --profile hackathon

# Upload a file
aws s3 cp file.txt s3://your-unique-bucket-name/ --profile hackathon

# List buckets
aws s3 ls --profile hackathon
```

### Deploy a Lambda Function (CLI)

```bash
# Create a deployment package
zip function.zip lambda_function.py

# Create the function
aws lambda create-function \
  --function-name my-hackathon-function \
  --runtime python3.11 \
  --role arn:aws:iam::[account-id]:role/lambda-role \
  --handler lambda_function.lambda_handler \
  --zip-file fileb://function.zip \
  --region us-east-1 \
  --profile hackathon
```

### Check Your Current Identity

```bash
# Who am I?
aws sts get-caller-identity --profile hackathon

# Expected output:
# {
#     "UserId": "AIDAXXXXXXXXXXXXXXXXX",
#     "Account": "123456789012",
#     "Arn": "arn:aws:iam::123456789012:user/your-username"
# }
```

## Troubleshooting

### Issue: "Access Denied" Error

**Check these:**
1. Are you in the correct region? (Check console region selector)
2. Using the right AWS profile? (`--profile hackathon`)
3. Trying to access another region? (Not allowed)

### Issue: Can't See My Resources

**Solution:**
- Make sure you're viewing the correct region in the console
- Click the region dropdown (top-right) and select your allowed region
- Resources created in your region will only show there

### Issue: Forgot Password

**Solution:**
- Contact the hackathon organizer
- They can reset your password using Terraform

### Issue: Access Keys Not Working

**Solution:**
1. Double-check you copied the full access key and secret
2. Make sure there are no extra spaces
3. Verify the region in your AWS config
4. Test with: `aws sts get-caller-identity --profile hackathon`

## Best Practices

### 💰 Cost Management
- Delete resources when not in use
- Stop EC2 instances instead of leaving them running
- Clean up at the end of each day
- Use t2.micro/t3.micro for testing (free tier eligible)

### 🔐 Security
- Don't share your credentials
- Don't commit access keys to Git repositories
- Use IAM roles for applications (not hardcoded keys)
- Enable MFA on your account if possible

### 🏷️ Resource Naming
- Use descriptive names: `hackathon-[your-name]-[purpose]`
- Example: `hackathon-kamal-web-server`
- Tag your resources with your name
- This helps organizers track resource usage

### 📝 Documentation
- Document what you create
- Keep track of resource IDs
- Note any special configurations
- This helps with cleanup later

## Need Help?

- **Technical Issues**: Contact hackathon organizer
- **AWS Service Questions**: Use AWS documentation (docs.aws.amazon.com)
- **Region Restriction Questions**: This is by design for cost control
- **Access Issues**: Contact organizer immediately

## End of Event Cleanup

At the end of the hackathon:
- Delete all resources you created
- Or notify organizers (they will run `terraform destroy`)
- Download any work you want to keep
- Your account will be deactivated after the event

---

**Happy Hacking! 🚀**

Remember: You have full admin access in your region - use it wisely!
