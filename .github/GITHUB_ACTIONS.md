# GitHub Actions CI/CD for Terraform

This repository includes automated GitHub Actions workflows for Terraform operations.

## Workflows

### Terraform CI/CD (`.github/workflows/terraform.yml`)

Automated pipeline for validating, planning, and applying Terraform infrastructure.

## Required Secrets

Configure these secrets in your GitHub repository:

1. Go to **Settings** → **Secrets and variables** → **Actions**
2. Add the following secrets:

| Secret Name | Description | Required |
|-------------|-------------|----------|
| `AWS_ACCESS_KEY_ID` | AWS access key with IAM permissions | Yes |
| `AWS_SECRET_ACCESS_KEY` | AWS secret access key | Yes |

### IAM Permissions Required

Your AWS credentials need these permissions:
```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "iam:*",
        "sts:GetCallerIdentity"
      ],
      "Resource": "*"
    }
  ]
}
```

## Workflow Triggers

### Automatic Triggers

- **Push to `main`**: Runs validation + apply
- **Push to `develop`**: Runs validation only
- **Pull Request**: Runs validation + plan (with PR comment)

### Manual Trigger

- **Workflow Dispatch**: Can be used to run destroy operation

## Jobs

### 1. `terraform-validate`

Runs on every push and PR:
- ✅ Format check (`terraform fmt`)
- ✅ Initialization (`terraform init`)
- ✅ Validation (`terraform validate`)

### 2. `terraform-plan`

Runs on Pull Requests:
- Creates execution plan
- Posts plan output as PR comment
- Uploads plan artifact

### 3. `terraform-apply`

Runs on push to `main` branch:
- Applies infrastructure changes
- Extracts user credentials
- Uploads credentials as artifact (7-day retention)

### 4. `security-scan`

Runs on every push:
- Scans with `tfsec` (Terraform security scanner)
- Scans with `Checkov` (policy-as-code scanner)
- Both set to soft-fail (won't block pipeline)

### 5. `terraform-destroy`

Manual workflow dispatch only:
- Destroys all infrastructure
- Requires manual approval (production-destroy environment)

## Environments

Configure these environments in GitHub:

### `production`
- Required for `terraform apply`
- **Recommended**: Add protection rules
- **Recommended**: Require manual approval

### `production-destroy`
- Required for `terraform destroy`
- **Required**: Add protection rules
- **Required**: Require manual approval

**Setup**: Settings → Environments → New environment

## Usage Examples

### Deploying Changes

```bash
# 1. Create feature branch
git checkout -b feature/add-users

# 2. Update terraform.tfvars
# Add new participants

# 3. Commit and push
git add terraform.tfvars
git commit -m "Add new hackathon participants"
git push origin feature/add-users

# 4. Create Pull Request
# GitHub Actions will automatically run validation and plan

# 5. Review plan in PR comments

# 6. Merge to main
# GitHub Actions will automatically apply changes
```

### Manual Destroy

1. Go to **Actions** tab
2. Select **Terraform CI/CD** workflow
3. Click **Run workflow**
4. Select branch: `main`
5. Click **Run workflow**
6. Approve in production-destroy environment

## Artifacts

### Credentials Artifact

After successful apply:
- **Name**: `user-credentials`
- **Content**: User passwords and access keys
- **Retention**: 7 days
- **Location**: Actions → Workflow Run → Artifacts

**Download**:
1. Go to workflow run
2. Scroll to **Artifacts** section
3. Download `user-credentials`

⚠️ **Security**: Credentials are sensitive! Download and store securely.

## Local Development

Test before pushing:

```bash
# Format
terraform fmt -recursive

# Validate
terraform init -backend=false
terraform validate

# Plan
terraform plan
```

## Troubleshooting

### Issue: Validation Fails

**Check**:
- Terraform formatting: Run `terraform fmt -recursive`
- Syntax errors: Review error message
- Variable definitions: Ensure all required variables exist

### Issue: AWS Credentials Error

**Check**:
- Secrets configured correctly in GitHub
- AWS credentials have required IAM permissions
- Region matches configuration

### Issue: Plan/Apply Fails

**Check**:
- AWS resource limits not exceeded
- No conflicting resources exist
- Backend state is accessible

### Issue: Security Scan Failures

**Action**: Review findings
- `tfsec` and `Checkov` are set to soft-fail
- Won't block pipeline but should be reviewed
- Address critical findings

## Best Practices

### 1. Branch Protection

Enable branch protection on `main`:
- Require PR reviews
- Require status checks to pass
- No direct pushes to main

### 2. Environment Protection

Configure environments:
- Require manual approval for production
- Limit deployment branches to `main`
- Add required reviewers

### 3. Secret Rotation

- Rotate AWS credentials regularly
- Use AWS IAM roles when possible
- Limit credential scope to minimum required

### 4. State Management

For production use:
- Configure S3 backend in `backend.tf`
- Use state locking with DynamoDB
- Enable versioning on S3 bucket

### 5. Notifications

Set up notifications:
- GitHub email notifications
- Slack integration
- Discord webhooks

## Security Considerations

### Credentials in Artifacts

- Artifacts are encrypted at rest
- Only repository collaborators can access
- 7-day retention (adjust in workflow)
- Consider using GitHub Secrets for storage

### AWS Permissions

- Use least-privilege IAM policies
- Consider using OIDC for GitHub Actions (no static credentials)
- Enable CloudTrail for audit logging

### Code Security

- Security scans run automatically
- Review findings before merging
- Keep Terraform and providers updated

## Advanced: OIDC Authentication

Eliminate static AWS credentials:

```yaml
- name: Configure AWS Credentials
  uses: aws-actions/configure-aws-credentials@v4
  with:
    role-to-assume: arn:aws:iam::ACCOUNT:role/GitHubActionsRole
    aws-region: ${{ env.AWS_REGION }}
```

Setup: [AWS OIDC Guide](https://docs.github.com/en/actions/deployment/security-hardening-your-deployments/configuring-openid-connect-in-amazon-web-services)

## Customization

### Change Terraform Version

```yaml
env:
  TF_VERSION: '1.6.0'  # Update version
```

### Add Notifications

```yaml
- name: Slack Notification
  uses: 8398a7/action-slack@v3
  with:
    status: ${{ job.status }}
    webhook_url: ${{ secrets.SLACK_WEBHOOK }}
```

### Adjust Artifact Retention

```yaml
- name: Upload Credentials
  uses: actions/upload-artifact@v3
  with:
    retention-days: 3  # Change from 7 to 3 days
```

## Workflow Status Badge

Add to README.md:

```markdown
[![Terraform CI/CD](https://github.com/YOUR_ORG/YOUR_REPO/actions/workflows/terraform.yml/badge.svg)](https://github.com/YOUR_ORG/YOUR_REPO/actions/workflows/terraform.yml)
```

## Support

- **GitHub Actions Docs**: https://docs.github.com/actions
- **Terraform Cloud**: Consider for advanced state management
- **HashiCorp Learn**: https://learn.hashicorp.com/terraform

---

**Status**: ✅ Ready for use
**Last Updated**: November 2025
