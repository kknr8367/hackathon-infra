# Project Summary - Region-Restricted Hackathon Lab Environment

## What Was Built

A complete Terraform infrastructure-as-code solution for managing AWS IAM users and groups for hackathons/interviews with **region restriction** capabilities.

## Key Requirements Met ✅

### 1. Dynamic User Creation
- ✅ Create 1 to N IAM users based on participant list
- ✅ Flexible participant count per event
- ✅ Console and programmatic access (passwords + access keys)

### 2. Automatic Grouping
- ✅ Participants grouped by skill set (DevOps, AI Engineer, Full Stack, etc.)
- ✅ Groups of 3 participants (configurable)
- ✅ If 1 participant: single user in dedicated group
- ✅ If N participants: multiple groups created automatically

### 3. Structured Naming
- ✅ Groups: `<skillset>-group<number>` (e.g., `devops-group1`, `devops-group2`)
- ✅ Users: `<name>-<skillset>-group<number>-user<number>` (e.g., `kamal-devops-group1-user1`)

### 4. Admin Permissions
- ✅ All users get AdministratorAccess policy
- ✅ Full access to create AWS resources
- ✅ Can set up OIDC providers
- ✅ Can manage IAM roles and policies

### 5. **Region Restriction (NEW)** 🔒
- ✅ Users locked to single AWS region per event
- ✅ Cannot access or switch to other regions
- ✅ Cannot create resources outside allowed region
- ✅ Console and CLI both enforced
- ✅ Easy region switching between events
- ✅ Global services (IAM, CloudFront, Route53) still accessible

## Project Structure

```
dec-28th-hackathon/
├── main.tf                          # Main orchestration
├── variables.tf                     # Input variables
├── outputs.tf                       # Output definitions
├── terraform.tfvars                 # Configuration (CUSTOMIZE THIS)
├── backend.tf                       # Remote state (optional)
├── .gitignore                       # Git ignore rules
│
├── modules/
│   ├── iam-users/                   # User creation module
│   │   ├── main.tf                  # User resources
│   │   ├── variables.tf             # User variables
│   │   └── outputs.tf               # User outputs
│   │
│   ├── iam-groups/                  # Group creation module
│   │   ├── main.tf                  # Group resources
│   │   ├── variables.tf             # Group variables
│   │   └── outputs.tf               # Group outputs
│   │
│   └── iam-region-policy/           # Region restriction module (NEW)
│       ├── main.tf                  # Policy creation
│       ├── variables.tf             # Policy variables
│       ├── outputs.tf               # Policy outputs
│       └── README.md                # Module documentation
│
├── examples/                        # Example configurations
│   ├── single-participant.tfvars    # 1 user scenario
│   ├── multi-track-hackathon.tfvars # Multiple skill sets
│   ├── large-scale-hackathon.tfvars # 50+ participants
│   ├── region-locked-west.tfvars    # us-west-2 example
│   └── README.md                    # Examples guide
│
├── scripts/
│   ├── extract_credentials.sh       # Extract user credentials
│   └── test_region_restriction.sh   # Test region locks
│
└── docs/
    ├── README.md                    # Complete user guide
    ├── ARCHITECTURE.md              # Architecture diagrams
    └── PARTICIPANT_GUIDE.md         # Participant quick start
```

## How Region Restriction Works

### Policy Mechanism

The solution creates an IAM policy with three key statements:

1. **Allow Specified Region**
   ```json
   {
     "Effect": "Allow",
     "Action": "*",
     "Resource": "*",
     "Condition": {
       "StringEquals": {
         "aws:RequestedRegion": "us-east-1"
       }
     }
   }
   ```

2. **Allow Global Services**
   - IAM, CloudFront, Route53, Organizations, etc.
   - These don't have regional restrictions

3. **Deny Other Regions**
   ```json
   {
     "Effect": "Deny",
     "Action": "*",
     "Resource": "*",
     "Condition": {
       "StringNotEquals": {
         "aws:RequestedRegion": "us-east-1"
       }
     }
   }
   ```

### Policy Attachment

The region restriction policy is attached to:
- ✅ All IAM users
- ✅ All IAM groups

This provides **defense in depth** - restrictions apply at both levels.

## Usage Scenarios

### Scenario 1: Single Interview Candidate (us-east-1)

```hcl
aws_region = "us-east-1"
participants = {
  "devops" = ["john"]
}
```

**Result:**
- 1 user: `john-devops-group1-user1`
- 1 group: `devops-group1`
- Region: Locked to `us-east-1` only

### Scenario 2: Multi-Track Hackathon (us-east-1)

```hcl
aws_region = "us-east-1"
participants = {
  "devops"      = ["kamal", "abdul", "john", "jane", "mike", "sarah"]
  "ai-engineer" = ["alex", "emma", "chris"]
  "fullstack"   = ["david", "lisa"]
}
```

**Result:**
- 11 users across 3 skill sets
- 5 groups total (devops: 2, ai-engineer: 1, fullstack: 1)
- All locked to `us-east-1`

### Scenario 3: Different Event, Different Region (us-west-2)

```hcl
aws_region = "us-west-2"  # Changed from us-east-1
participants = {
  "devops" = ["alice", "bob", "charlie"]
}
```

**Result:**
- New users created
- All locked to `us-west-2` only
- Previous event's us-east-1 users unaffected (if not destroyed)

## Deployment Workflow

```bash
# 1. Initialize Terraform
terraform init

# 2. Review planned changes
terraform plan

# 3. Deploy infrastructure
terraform apply

# 4. Extract credentials
./extract_credentials.sh > event-credentials.txt

# 5. Distribute credentials securely to participants

# 6. (Optional) Test region restrictions
./test_region_restriction.sh [access-key] [secret-key] [region]

# 7. After event, clean up
terraform destroy
```

## Testing Region Restrictions

### Automated Testing

```bash
# Get credentials from output
ACCESS_KEY=$(terraform output -json user_access_keys | jq -r '.["user1"].access_key_id')
SECRET_KEY=$(terraform output -json user_access_keys | jq -r '.["user1"].secret_access_key')

# Run test script
./test_region_restriction.sh $ACCESS_KEY $SECRET_KEY us-east-1
```

### Manual Testing

```bash
# Configure user profile
aws configure --profile hackathon-user

# Test allowed region (should work)
aws ec2 describe-instances --region us-east-1 --profile hackathon-user

# Test forbidden region (should fail)
aws ec2 describe-instances --region us-west-2 --profile hackathon-user
# Expected: AccessDenied error
```

## Security Features

1. **Region Isolation**
   - Users cannot access resources outside allowed region
   - Prevents accidental costs in other regions
   - Compliance boundary enforcement

2. **Admin Access Within Boundaries**
   - Full admin rights within allowed region
   - Can create any AWS resource
   - Can set up OIDC, IAM roles, etc.

3. **Credential Management**
   - Temporary passwords (reset required on first login)
   - Access keys for CLI/SDK
   - Outputs marked as sensitive

4. **Clean Teardown**
   - `terraform destroy` removes all resources
   - No orphaned users or groups
   - Cost control at event end

## Cost Considerations

### Minimal Infrastructure Costs

- IAM users: FREE
- IAM groups: FREE
- IAM policies: FREE
- Total cost: **$0 for IAM infrastructure**

### Participant Resource Costs

- Costs depend on what participants create
- Region restriction helps prevent unexpected costs in other regions
- Recommend setting AWS Budgets/Alerts

## Multi-Event Management

### Event 1: December (us-east-1)
```bash
# terraform.tfvars
aws_region = "us-east-1"
environment = "hackathon-dec-2024"

terraform apply
# Event runs
terraform destroy
```

### Event 2: January (us-west-2)
```bash
# terraform.tfvars
aws_region = "us-west-2"
environment = "interview-jan-2025"

terraform apply
# Event runs
terraform destroy
```

Each event is completely independent and region-isolated.

## Documentation

- **README.md**: Complete setup and usage guide
- **ARCHITECTURE.md**: System architecture and diagrams
- **PARTICIPANT_GUIDE.md**: Quick start for participants
- **modules/iam-region-policy/README.md**: Region policy details
- **examples/README.md**: Configuration examples

## Key Benefits

1. ✅ **Scalability**: 1 to 1000+ users
2. ✅ **Flexibility**: Multiple skill sets and group sizes
3. ✅ **Security**: Region-locked access
4. ✅ **Cost Control**: Prevent multi-region sprawl
5. ✅ **Automation**: Infrastructure as Code
6. ✅ **Repeatability**: Easy multi-event deployment
7. ✅ **Clean**: Complete teardown capability

## Future Enhancements (Optional)

- [ ] AWS Organizations SCP integration
- [ ] Cost allocation tags
- [ ] CloudWatch monitoring integration
- [ ] Automated budget alerts per user
- [ ] Custom permission boundaries
- [ ] SSO integration

---

**Project Complete! Ready for hackathon/interview deployment.**
