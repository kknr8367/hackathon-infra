# Hackathon Lab Environment - Examples

This directory contains example configuration files for different scenarios.

## Available Examples

### 1. Single Participant (`single-participant.tfvars`)
For interview sessions or testing with just one participant.

**Usage:**
```bash
terraform plan -var-file="examples/single-participant.tfvars"
terraform apply -var-file="examples/single-participant.tfvars"
```

**Output:**
- 1 user: `john-devops-group1-user1`
- 1 group: `devops-group1`

---

### 2. Multi-Track Hackathon (`multi-track-hackathon.tfvars`)
For hackathons with multiple skill tracks and moderate participant count.

**Usage:**
```bash
terraform plan -var-file="examples/multi-track-hackathon.tfvars"
terraform apply -var-file="examples/multi-track-hackathon.tfvars"
```

**Output:**
- 21 users across 4 skill sets
- 9 groups (devops: 3, ai-engineer: 2, fullstack: 1, data-engineer: 1)

---

### 3. Large Scale Hackathon (`large-scale-hackathon.tfvars`)
For enterprise-level hackathons with 50+ participants.

**Usage:**
```bash
terraform plan -var-file="examples/large-scale-hackathon.tfvars"
terraform apply -var-file="examples/large-scale-hackathon.tfvars"
```

**Output:**
- 50 users across 5 skill sets
- 17 groups total

---

### 4. Region-Locked West Coast (`region-locked-west.tfvars`)
Demonstrates region restriction to us-west-2 only.

**Usage:**
```bash
terraform plan -var-file="examples/region-locked-west.tfvars"
terraform apply -var-file="examples/region-locked-west.tfvars"
```

**Output:**
- Users restricted to us-west-2 region only
- Cannot access any other AWS regions
- 5 users across 2 skill sets

---

## How to Use Examples

1. **Choose an example** that matches your scenario
2. **Copy and customize** if needed:
   ```bash
   cp examples/multi-track-hackathon.tfvars my-event.tfvars
   # Edit my-event.tfvars with your participant names
   ```

3. **Apply the configuration**:
   ```bash
   terraform apply -var-file="my-event.tfvars"
   ```

4. **Extract credentials**:
   ```bash
   ./extract_credentials.sh > event-credentials.txt
   ```

## Customization Tips

- **Change group size**: Modify `group_size` parameter (default: 3)
- **Add skill sets**: Add new keys to `participants` map
- **Disable access keys**: Set `create_access_keys = false`
- **Custom tags**: Modify `additional_tags` for cost tracking
