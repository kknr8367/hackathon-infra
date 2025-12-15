# 📚 Documentation Index

Quick navigation to all documentation files in this project.

## 🚀 Getting Started

Start here if this is your first time:

1. **[README.md](README.md)** - Main documentation with complete setup guide
2. **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Step-by-step deployment checklist
3. **[terraform.tfvars](terraform.tfvars)** - Configuration file (CUSTOMIZE THIS)

## 👥 For Different Audiences

### For Organizers/Admins

- **[README.md](README.md)** - Complete setup and usage guide
- **[DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)** - Pre/during/post deployment tasks
- **[PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)** - High-level project overview
- **[ARCHITECTURE.md](ARCHITECTURE.md)** - System architecture and diagrams

### For Participants

- **[PARTICIPANT_GUIDE.md](PARTICIPANT_GUIDE.md)** - Quick start guide for hackathon participants

### For Developers

- **[ARCHITECTURE.md](ARCHITECTURE.md)** - Technical architecture details
- **[modules/iam-region-policy/README.md](modules/iam-region-policy/README.md)** - Region restriction module docs

## 📁 Project Files

### Core Configuration

| File | Purpose | Customize? |
|------|---------|-----------|
| `main.tf` | Main orchestration logic | No |
| `variables.tf` | Variable definitions | No |
| `outputs.tf` | Output definitions | No |
| `terraform.tfvars` | **Your configuration** | **YES** |
| `backend.tf` | Remote state config | Optional |

### Modules

| Module | Purpose | Files |
|--------|---------|-------|
| `modules/iam-users/` | Create IAM users | main.tf, variables.tf, outputs.tf |
| `modules/iam-groups/` | Create IAM groups | main.tf, variables.tf, outputs.tf |
| `modules/iam-region-policy/` | Region restriction | main.tf, variables.tf, outputs.tf, README.md |

### Helper Scripts

| Script | Purpose | Usage |
|--------|---------|-------|
| `extract_credentials.sh` | Extract user credentials | `./extract_credentials.sh` |
| `test_region_restriction.sh` | Test region locks | `./test_region_restriction.sh <key> <secret> <region>` |

### Examples

| Example File | Scenario | Users |
|--------------|----------|-------|
| `examples/single-participant.tfvars` | Single interview | 1 |
| `examples/multi-track-hackathon.tfvars` | Multi-track hackathon | 21 |
| `examples/large-scale-hackathon.tfvars` | Large event | 50+ |
| `examples/region-locked-west.tfvars` | us-west-2 region | 5 |

## 🔍 Documentation by Topic

### Region Restriction

- [README.md - Permissions & Restrictions](README.md#permissions--restrictions)
- [README.md - Testing Region Restrictions](README.md#testing-region-restrictions)
- [modules/iam-region-policy/README.md](modules/iam-region-policy/README.md)
- [ARCHITECTURE.md - Security Boundaries](ARCHITECTURE.md)

### User Management

- [README.md - User Access](README.md#user-access)
- [README.md - Usage Examples](README.md#usage-examples)
- [PARTICIPANT_GUIDE.md](PARTICIPANT_GUIDE.md)

### Deployment

- [README.md - Quick Start](README.md#quick-start)
- [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
- [README.md - Example Workflow](README.md#example-workflow)

### Configuration

- [README.md - Configuration Options](README.md#configuration-options)
- [README.md - Advanced Usage](README.md#advanced-usage)
- [examples/README.md](examples/README.md)

### Troubleshooting

- [README.md - Troubleshooting](README.md#troubleshooting)
- [DEPLOYMENT_CHECKLIST.md - Troubleshooting Checklist](DEPLOYMENT_CHECKLIST.md#troubleshooting-checklist)

## 🎯 Quick Links by Task

### I want to...

**Deploy for the first time**
→ [README.md - Quick Start](README.md#quick-start)
→ [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

**Understand how it works**
→ [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
→ [ARCHITECTURE.md](ARCHITECTURE.md)

**Configure participants**
→ [terraform.tfvars](terraform.tfvars)
→ [README.md - Configure Participants](README.md#2-configure-participants)

**Change regions**
→ [README.md - Change Region for Different Events](README.md#change-region-for-different-events)
→ [examples/region-locked-west.tfvars](examples/region-locked-west.tfvars)

**Extract credentials**
→ `./extract_credentials.sh`
→ [README.md - Retrieve User Credentials](README.md#6-retrieve-user-credentials)

**Test region restrictions**
→ `./test_region_restriction.sh`
→ [README.md - Testing Region Restrictions](README.md#testing-region-restrictions)

**Help participants get started**
→ [PARTICIPANT_GUIDE.md](PARTICIPANT_GUIDE.md)

**Clean up after event**
→ [DEPLOYMENT_CHECKLIST.md - Post-Event Cleanup](DEPLOYMENT_CHECKLIST.md#post-event-cleanup)
→ `terraform destroy`

**Troubleshoot issues**
→ [README.md - Troubleshooting](README.md#troubleshooting)
→ [DEPLOYMENT_CHECKLIST.md - Troubleshooting Checklist](DEPLOYMENT_CHECKLIST.md#troubleshooting-checklist)

## 📊 File Structure Overview

```
dec-28th-hackathon/
│
├── 📖 Documentation
│   ├── README.md                    ⭐ Start here
│   ├── DEPLOYMENT_CHECKLIST.md      ⭐ Deploy checklist
│   ├── PARTICIPANT_GUIDE.md         👥 For participants
│   ├── PROJECT_SUMMARY.md           📊 Overview
│   ├── ARCHITECTURE.md              🏗️ Architecture
│   └── INDEX.md                     📚 This file
│
├── ⚙️ Terraform Configuration
│   ├── main.tf                      Main logic
│   ├── variables.tf                 Variable definitions
│   ├── outputs.tf                   Outputs
│   ├── terraform.tfvars             ⭐ Configure here
│   └── backend.tf                   State management
│
├── 📦 Modules
│   ├── iam-users/                   User creation
│   ├── iam-groups/                  Group creation
│   └── iam-region-policy/           Region restriction
│
├── 📝 Examples
│   ├── single-participant.tfvars
│   ├── multi-track-hackathon.tfvars
│   ├── large-scale-hackathon.tfvars
│   ├── region-locked-west.tfvars
│   └── README.md
│
└── 🔧 Scripts
    ├── extract_credentials.sh       Get credentials
    └── test_region_restriction.sh   Test restrictions
```

## 🎓 Learning Path

### Beginner Path

1. Read [README.md](README.md) introduction
2. Review [terraform.tfvars](terraform.tfvars) example
3. Follow [README.md - Quick Start](README.md#quick-start)
4. Use [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)

### Intermediate Path

1. Study [ARCHITECTURE.md](ARCHITECTURE.md)
2. Explore module documentation
3. Review [examples/](examples/)
4. Customize for your use case

### Advanced Path

1. Deep dive into [PROJECT_SUMMARY.md](PROJECT_SUMMARY.md)
2. Study policy mechanisms in [modules/iam-region-policy/](modules/iam-region-policy/)
3. Modify modules for custom requirements
4. Implement additional security controls

## 🆘 Need Help?

1. **Common issues?** → [README.md - Troubleshooting](README.md#troubleshooting)
2. **Deployment problems?** → [DEPLOYMENT_CHECKLIST.md](DEPLOYMENT_CHECKLIST.md)
3. **Understanding architecture?** → [ARCHITECTURE.md](ARCHITECTURE.md)
4. **Configuration help?** → [README.md - Configuration Options](README.md#configuration-options)

## 📋 Cheat Sheet

```bash
# Initialize
terraform init

# Plan
terraform plan

# Deploy
terraform apply

# Get credentials
./extract_credentials.sh

# Test region restriction
./test_region_restriction.sh <access-key> <secret-key> <region>

# Cleanup
terraform destroy
```

## 🔄 Version Information

- **Terraform Version**: 1.0+
- **AWS Provider**: 5.0+
- **Last Updated**: November 2025

---

**Ready to get started? → [README.md](README.md)**
