# IAM Users Module
# Creates IAM users with programmatic and console access

resource "aws_iam_user" "user" {
  for_each = var.users

  name = each.value.username
  path = "/"

  tags = merge(
    {
      Name        = each.value.username
      Group       = each.value.group
      Environment = var.environment
      ManagedBy   = "Terraform"
    },
    var.tags
  )
}

# Create login profile for console access
resource "aws_iam_user_login_profile" "user_login" {
  for_each = var.users

  user                    = aws_iam_user.user[each.key].name
  password_reset_required = var.password_reset_required

  lifecycle {
    ignore_changes = [
      password_reset_required,
    ]
  }
}

# Create access keys for programmatic access
resource "aws_iam_access_key" "user_key" {
  for_each = var.create_access_keys ? var.users : {}

  user = aws_iam_user.user[each.key].name
}

# Attach AdministratorAccess policy to users
resource "aws_iam_user_policy_attachment" "admin_access" {
  for_each = var.users

  user       = aws_iam_user.user[each.key].name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Attach region restriction policy to users
resource "aws_iam_user_policy_attachment" "region_restriction" {
  for_each = var.attach_region_restriction ? var.users : {}

  user       = aws_iam_user.user[each.key].name
  policy_arn = var.region_restriction_policy_arn
}

# Optional: Attach custom inline policy for additional permissions
resource "aws_iam_user_policy" "custom_policy" {
  for_each = var.attach_custom_policy ? var.users : {}

  name = "${each.value.username}-custom-policy"
  user = aws_iam_user.user[each.key].name

  policy = var.custom_policy_json
}
