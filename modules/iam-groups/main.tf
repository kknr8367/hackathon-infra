# IAM Groups Module
# Creates IAM groups and assigns users to them

resource "aws_iam_group" "group" {
  for_each = var.groups

  name = each.value.name
  path = "/"
}

# Attach AdministratorAccess policy to groups (if enabled)
resource "aws_iam_group_policy_attachment" "admin_access" {
  for_each = var.use_admin_policy ? var.groups : {}

  group      = aws_iam_group.group[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach region restriction policy to groups
resource "aws_iam_group_policy_attachment" "region_restriction" {
  for_each = var.attach_region_restriction ? var.groups : {}

  group      = aws_iam_group.group[each.key].name
  policy_arn = var.region_restriction_policy_arn
}

# Attach role-based custom policies to groups
resource "aws_iam_group_policy_attachment" "role_based_policies" {
  for_each = {
    for combo in flatten([
      for group_key, group in var.groups : [
        for idx, policy_arn in lookup(
          lookup(var.role_based_policies, group.name, { policy_arns = [] }),
          "policy_arns",
          []
          ) : {
          key        = "${group_key}-${idx}"
          group_name = group.name
          policy_arn = policy_arn
        }
      ]
    ]) : combo.key => combo
  }

  group      = each.value.group_name
  policy_arn = each.value.policy_arn
}

# Optional: Attach custom inline policy to groups
resource "aws_iam_group_policy" "custom_policy" {
  for_each = var.attach_custom_policy ? var.groups : {}

  name  = "${each.value.name}-custom-policy"
  group = aws_iam_group.group[each.key].name

  policy = var.custom_policy_json
}
