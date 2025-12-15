# Deployment Checklist - Hackathon Lab Environment

## Current Configuration Summary

### ✅ Access Control: **Admin Access for Everyone**
- **Status**: All users get full `AdministratorAccess` policy
- **Reason**: Maximum flexibility for hackathon participants
- **Setting**: `use_custom_roles = false` (in `terraform.tfvars`)

### ✅ Region Restriction: **Locked to Single Region**
- **Status**: Enabled with explicit DENY policy
- **Region**: `us-east-1` (configurable in `terraform.tfvars`)
- **Effect**: Users cannot access or switch to other AWS regions

### 🔮 Future Planning: **Role-Based Access Ready**
- **Status**: Infrastructure supports custom roles (DevOps, AI Engineer, Full Stack)
- **Activation**: Change `use_custom_roles = true` when needed
- **Documentation**: See `REGION_AND_ROLES_GUIDE.md`

---

# Deployment Checklist

Use this checklist to ensure smooth deployment of the hackathon lab environment.

## Pre-Deployment

### 1. AWS Account Setup
- [ ] AWS account with admin access configured
- [ ] AWS CLI installed and configured (`aws --version`)
- [ ] AWS credentials set up (`aws sts get-caller-identity`)
- [ ] Sufficient IAM user creation quota (check limits)

### 2. Terraform Setup
- [ ] Terraform installed (version 1.0+): `terraform version`
- [ ] jq installed (for credential extraction): `which jq`
- [ ] Project cloned/downloaded to local machine

### 3. Configuration Review
- [ ] Reviewed `terraform.tfvars`
- [ ] Set correct `aws_region` for this event
- [ ] Added all participant names
- [ ] Verified skill set categories
- [ ] Set appropriate `group_size`
- [ ] Updated `environment` name

### 4. Optional: Remote State
- [ ] S3 bucket created for state storage
- [ ] DynamoDB table created for state locking
- [ ] `backend.tf` configured (if using)

## Deployment Steps

### Step 1: Initialize
```bash
cd /path/to/dec-28th-hackathon
terraform init
```
- [ ] Terraform initialized successfully
- [ ] All modules downloaded
- [ ] Provider plugins installed

### Step 2: Validate
```bash
terraform validate
```
- [ ] Configuration is valid
- [ ] No syntax errors
- [ ] All variables defined

### Step 3: Plan
```bash
terraform plan -out=tfplan
```
- [ ] Review planned resources
- [ ] Verify user count matches expectations
- [ ] Verify group count is correct
- [ ] Check region restriction policy
- [ ] Confirm no unexpected changes

**Expected Resources:**
- IAM users: [Expected count]
- IAM groups: [Expected count]
- IAM policies: 1 (region restriction)
- IAM policy attachments: users + groups
- Login profiles: [user count]
- Access keys: [user count] (if enabled)

### Step 4: Apply
```bash
terraform apply tfplan
```
- [ ] Apply completed successfully
- [ ] No errors reported
- [ ] All resources created

### Step 5: Extract Credentials
```bash
./extract_credentials.sh > credentials/event-$(date +%Y%m%d).txt
```
- [ ] Credentials extracted successfully
- [ ] File created and readable
- [ ] Contains all expected users

### Step 6: Verify Region Restriction (Optional)
```bash
# Get first user's credentials
ACCESS_KEY=$(terraform output -json user_access_keys | jq -r '.[keys[0]].access_key_id')
SECRET_KEY=$(terraform output -json user_access_keys | jq -r '.[keys[0]].secret_access_key')

# Test
./test_region_restriction.sh $ACCESS_KEY $SECRET_KEY [your-region]
```
- [ ] Test passed
- [ ] Allowed region works
- [ ] Other regions blocked

## Post-Deployment

### 1. Documentation
- [ ] Credentials file secured (encrypted/password-protected)
- [ ] Participant guide prepared (`PARTICIPANT_GUIDE.md`)
- [ ] Console URL documented
- [ ] Support contact information added

### 2. Participant Communication
- [ ] Credentials distributed securely (NOT via plain email)
- [ ] Participant guide sent to all users
- [ ] Event schedule communicated
- [ ] Region restriction explained
- [ ] Support channels established

### 3. Monitoring Setup
- [ ] AWS CloudWatch alarms configured (optional)
- [ ] AWS Budgets set up (recommended)
- [ ] Cost alerts enabled
- [ ] Tag-based cost tracking configured

### 4. Backup
- [ ] Terraform state backed up
- [ ] Configuration files versioned (Git)
- [ ] Credentials backup created (secure location)

## During Event

### Daily Checks
- [ ] Monitor AWS costs
- [ ] Check for resource creation anomalies
- [ ] Respond to user access issues
- [ ] Verify users staying within region

### User Support
- [ ] Track support requests
- [ ] Document common issues
- [ ] Update FAQ as needed

## Post-Event Cleanup

### 1. Export Artifacts (if needed)
- [ ] User-created resources documented
- [ ] Important data backed up
- [ ] Screenshots/reports saved

### 2. Cost Review
```bash
# Get cost report from AWS Console
# Cost Explorer → Filter by tags
```
- [ ] Final costs calculated
- [ ] Per-user costs analyzed
- [ ] Budget vs actual compared

### 3. Destroy Infrastructure
```bash
# CAREFUL: This deletes everything
terraform plan -destroy
terraform destroy
```
- [ ] Preview destroy plan carefully
- [ ] Confirm all users are done
- [ ] Backup any needed data first
- [ ] Destroy completed successfully

### 4. Verification
```bash
# Verify cleanup
aws iam list-users --query 'Users[?contains(UserName, `hackathon`)].UserName'
aws iam list-groups --query 'Groups[?contains(GroupName, `group`)].GroupName'
```
- [ ] All IAM users removed
- [ ] All IAM groups removed
- [ ] No orphaned resources

### 5. Documentation
- [ ] Event notes documented
- [ ] Lessons learned captured
- [ ] Issues/improvements noted
- [ ] Cost analysis completed

## Troubleshooting Checklist

### Issue: Terraform Apply Fails

**Checks:**
- [ ] AWS credentials valid?
- [ ] IAM permissions sufficient?
- [ ] User name conflicts?
- [ ] Resource limits not exceeded?
- [ ] Network connectivity to AWS?

### Issue: Users Can't Access Resources

**Checks:**
- [ ] User logged in with correct credentials?
- [ ] Password reset completed?
- [ ] User in correct region?
- [ ] Region restriction policy attached?
- [ ] AdministratorAccess policy attached?

### Issue: Users Can Access Other Regions

**Checks:**
- [ ] Region restriction policy created?
- [ ] Policy attached to users?
- [ ] Policy attached to groups?
- [ ] User re-authenticated after policy change?
- [ ] Console cache cleared?

### Issue: Credentials Not Working

**Checks:**
- [ ] Access keys generated?
- [ ] Secret key copied correctly?
- [ ] No extra spaces in credentials?
- [ ] Region set correctly in AWS config?
- [ ] User active (not disabled)?

## Security Checklist

- [ ] Credentials stored securely
- [ ] Credentials transmitted securely (encrypted)
- [ ] MFA enabled on admin account (your account)
- [ ] CloudTrail enabled for audit
- [ ] No credentials in Git repository
- [ ] `.gitignore` configured properly
- [ ] Terraform state secured (encrypted)
- [ ] IAM users deactivated after event

## Cost Control Checklist

- [ ] Region restriction enforced
- [ ] AWS Budgets configured
- [ ] Cost alerts active
- [ ] Users educated on costs
- [ ] Cleanup scheduled
- [ ] Orphaned resources checked
- [ ] Final cost report generated

## Best Practices Applied

- [ ] Infrastructure as Code (Terraform)
- [ ] Modular design
- [ ] Version control (Git)
- [ ] Documentation complete
- [ ] Security boundaries enforced
- [ ] Cost controls in place
- [ ] Cleanup automation ready

## Sign-Off

**Deployment Date:** _______________

**Event Name:** _______________

**Deployed By:** _______________

**Region:** _______________

**User Count:** _______________

**Verified By:** _______________

**Cleanup Date:** _______________

**Cleanup Verified By:** _______________

---

**Notes:**

_________________________________

_________________________________

_________________________________
