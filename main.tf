terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "Hackathon-Lab"
      ManagedBy   = "Terraform"
      Environment = var.environment
    }
  }
}

# Local variables for organizing participants into groups
locals {
  # Process participants and assign to groups based on skill set
  participants_by_skill = {
    for skill_set, participants in var.participants : skill_set => [
      for idx, name in participants : {
        name      = name
        skill_set = skill_set
        # Calculate group number (groups of 3)
        group_num = floor(idx / var.group_size) + 1
        # Calculate user number within group
        user_num = (idx % var.group_size) + 1
      }
    ]
  }

  # Flatten and create group names
  all_participants = flatten([
    for skill_set, participants in local.participants_by_skill : [
      for participant in participants : {
        name       = participant.name
        skill_set  = participant.skill_set
        group_name = "${participant.skill_set}-group${participant.group_num}"
        user_num   = participant.user_num
        # Create full username: <name>-<skillset>-group<num>-user<num>
        username = "${participant.name}-${participant.skill_set}-group${participant.group_num}-user${participant.user_num}"
      }
    ]
  ])

  # Create map of users for module input
  users_map = {
    for participant in local.all_participants :
    participant.username => {
      username = participant.username
      group    = participant.group_name
    }
  }

  # Create map of unique groups
  groups_map = {
    for group_name in distinct([for p in local.all_participants : p.group_name]) :
    group_name => {
      name        = group_name
      description = "Group for ${group_name} participants"
    }
  }

  # Create user-group memberships
  user_group_memberships = {
    for participant in local.all_participants :
    participant.username => {
      username   = participant.username
      group_name = participant.group_name
    }
  }
}

# Create Region Restriction Policy
module "region_restriction_policy" {
  source = "./modules/iam-region-policy"

  allowed_region     = var.aws_region
  policy_name_prefix = var.environment
  environment        = var.environment
  tags               = var.additional_tags
}

# Create Custom Role Policies (if enabled)
module "custom_role_policies" {
  source = "./modules/iam-custom-roles"

  policy_name_prefix        = var.environment
  environment               = var.environment
  enable_devops_policy      = lookup(var.enable_custom_role_policies, "devops", false)
  enable_ai_engineer_policy = lookup(var.enable_custom_role_policies, "ai-engineer", false)
  enable_fullstack_policy   = lookup(var.enable_custom_role_policies, "fullstack", false)
  tags                      = var.additional_tags
}

# Prepare role-based policy mappings for groups
locals {
  # Map skill sets to their custom policy ARNs (only if use_custom_roles is true)
  role_based_policy_map = var.use_custom_roles ? {
    for group_name, group in local.groups_map : group_name => {
      policy_arns = compact([
        contains(keys(local.participants_by_skill), "devops") && can(regex("devops", group_name)) ? module.custom_role_policies.devops_policy_arn : "",
        contains(keys(local.participants_by_skill), "ai-engineer") && can(regex("ai-engineer", group_name)) ? module.custom_role_policies.ai_engineer_policy_arn : "",
        contains(keys(local.participants_by_skill), "fullstack") && can(regex("fullstack", group_name)) ? module.custom_role_policies.fullstack_policy_arn : ""
      ])
    }
  } : {}
}

# Create IAM Groups
module "iam_groups" {
  source = "./modules/iam-groups"

  groups                        = local.groups_map
  attach_custom_policy          = false
  attach_region_restriction     = true
  region_restriction_policy_arn = module.region_restriction_policy.policy_arn
  use_admin_policy              = !var.use_custom_roles
  role_based_policies           = local.role_based_policy_map

  depends_on = [module.region_restriction_policy, module.custom_role_policies]
}

# Create IAM Users
module "iam_users" {
  source = "./modules/iam-users"

  users                         = local.users_map
  environment                   = var.environment
  password_reset_required       = var.password_reset_required
  create_access_keys            = var.create_access_keys
  attach_region_restriction     = true
  region_restriction_policy_arn = module.region_restriction_policy.policy_arn

  tags = var.additional_tags

  depends_on = [module.iam_groups, module.region_restriction_policy]
}
