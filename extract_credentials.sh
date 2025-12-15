#!/bin/bash

# Script to extract and display user credentials in a readable format
# Usage: ./extract_credentials.sh

set -e

echo "========================================"
echo "Hackathon User Credentials"
echo "========================================"
echo ""

# Check if terraform is installed
if ! command -v terraform &> /dev/null; then
    echo "Error: Terraform is not installed or not in PATH"
    exit 1
fi

# Check if jq is installed
if ! command -v jq &> /dev/null; then
    echo "Warning: jq is not installed. Output will be in JSON format."
    echo "Install jq for better formatting: brew install jq"
    echo ""
    USE_JQ=false
else
    USE_JQ=true
fi

echo "Extracting user credentials..."
echo ""

# Get AWS Account ID
ACCOUNT_ID=$(terraform output -json user_credentials 2>/dev/null | jq -r 'to_entries[0].value.console_url' | grep -o '[0-9]\{12\}')
CONSOLE_URL="https://${ACCOUNT_ID}.signin.aws.amazon.com/console"

echo "AWS Console URL: $CONSOLE_URL"
echo ""
echo "========================================"
echo "Console Access Credentials"
echo "========================================"

if [ "$USE_JQ" = true ]; then
    terraform output -json user_credentials 2>/dev/null | jq -r '
        to_entries[] | 
        "
Username: \(.value.username)
Password: \(.value.password)
Console URL: \(.value.console_url)
----------------------------------------"
    '
else
    terraform output -json user_credentials
fi

echo ""
echo "========================================"
echo "Programmatic Access Keys"
echo "========================================"

if [ "$USE_JQ" = true ]; then
    terraform output -json user_access_keys 2>/dev/null | jq -r '
        to_entries[] | 
        "
Username: \(.key)
Access Key ID: \(.value.access_key_id)
Secret Access Key: \(.value.secret_access_key)
----------------------------------------"
    '
else
    terraform output -json user_access_keys
fi

echo ""
echo "========================================"
echo "Group Assignments"
echo "========================================"

if [ "$USE_JQ" = true ]; then
    terraform output -json group_assignments 2>/dev/null | jq -r '
        to_entries[] | 
        "
Group: \(.key)
Members: \(.value | join(", "))
----------------------------------------"
    '
else
    terraform output -json group_assignments
fi

echo ""
echo "========================================"
echo "Region Restriction Policy"
echo "========================================"

if [ "$USE_JQ" = true ]; then
    terraform output -json region_restriction 2>/dev/null | jq -r '
        "Policy Name: \(.policy_name)
Policy ARN: \(.policy_arn)
Allowed Region: \(.allowed_region)

⚠️  IMPORTANT: Users can ONLY access: \(.allowed_region)
   All other regions are blocked!"
    '
else
    terraform output -json region_restriction
fi

echo ""
echo "========================================"
echo "Summary"
echo "========================================"

terraform output -json participant_summary 2>/dev/null | if [ "$USE_JQ" = true ]; then
    jq -r '
        "Total Users: \(.total_users)
Total Groups: \(.total_groups)
Allowed Region: \(.allowed_region)

Users per Group:
\(.users_by_group | to_entries[] | "  \(.key): \(.value) users")"
    '
else
    cat
fi

echo ""
echo "========================================"
echo "⚠️  SECURITY WARNING"
echo "========================================"
echo "These credentials provide full admin access to AWS."
echo "Please distribute them securely and delete after use."
echo "========================================"
