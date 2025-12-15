#!/bin/bash

# Script to test region restriction policy
# Usage: ./test_region_restriction.sh <access-key-id> <secret-access-key> <allowed-region>

set -e

if [ $# -ne 3 ]; then
    echo "Usage: $0 <access-key-id> <secret-access-key> <allowed-region>"
    echo "Example: $0 AKIAIOSFODNN7EXAMPLE wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY us-east-1"
    exit 1
fi

ACCESS_KEY_ID=$1
SECRET_ACCESS_KEY=$2
ALLOWED_REGION=$3

# Set the forbidden region (different from allowed)
if [ "$ALLOWED_REGION" = "us-east-1" ]; then
    FORBIDDEN_REGION="us-west-2"
else
    FORBIDDEN_REGION="us-east-1"
fi

echo "========================================"
echo "Testing Region Restriction Policy"
echo "========================================"
echo ""
echo "Allowed Region: $ALLOWED_REGION"
echo "Forbidden Region: $FORBIDDEN_REGION"
echo ""

export AWS_ACCESS_KEY_ID=$ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY=$SECRET_ACCESS_KEY

echo "========================================"
echo "Test 1: Access to ALLOWED region"
echo "========================================"
echo "Testing: aws sts get-caller-identity --region $ALLOWED_REGION"
if aws sts get-caller-identity --region $ALLOWED_REGION 2>&1; then
    echo "✅ SUCCESS: Can access allowed region ($ALLOWED_REGION)"
else
    echo "❌ FAILED: Cannot access allowed region ($ALLOWED_REGION)"
fi
echo ""

echo "========================================"
echo "Test 2: List S3 buckets in ALLOWED region"
echo "========================================"
echo "Testing: aws s3api list-buckets --region $ALLOWED_REGION"
if aws s3api list-buckets --region $ALLOWED_REGION 2>&1 | head -10; then
    echo "✅ SUCCESS: Can list S3 buckets in allowed region"
else
    echo "❌ FAILED: Cannot list S3 buckets in allowed region"
fi
echo ""

echo "========================================"
echo "Test 3: Access to FORBIDDEN region"
echo "========================================"
echo "Testing: aws ec2 describe-instances --region $FORBIDDEN_REGION"
if aws ec2 describe-instances --region $FORBIDDEN_REGION 2>&1; then
    echo "❌ FAILED: Should NOT have access to forbidden region ($FORBIDDEN_REGION)"
    echo "WARNING: Region restriction is NOT working!"
else
    echo "✅ SUCCESS: Access denied to forbidden region ($FORBIDDEN_REGION) as expected"
fi
echo ""

echo "========================================"
echo "Test 4: Try to create resource in FORBIDDEN region"
echo "========================================"
echo "Testing: aws ec2 describe-vpcs --region $FORBIDDEN_REGION"
if aws ec2 describe-vpcs --region $FORBIDDEN_REGION 2>&1; then
    echo "❌ FAILED: Should NOT have access to forbidden region ($FORBIDDEN_REGION)"
    echo "WARNING: Region restriction is NOT working!"
else
    echo "✅ SUCCESS: Access denied to forbidden region ($FORBIDDEN_REGION) as expected"
fi
echo ""

echo "========================================"
echo "Test 5: Access to global services (IAM)"
echo "========================================"
echo "Testing: aws iam get-user"
if aws iam get-user 2>&1 | head -10; then
    echo "✅ SUCCESS: Can access global IAM service"
else
    echo "⚠️  WARNING: Cannot access IAM (might be expected depending on policy)"
fi
echo ""

echo "========================================"
echo "Summary"
echo "========================================"
echo "Region restriction policy test completed."
echo "✅ means test passed as expected"
echo "❌ means test failed - check your policy configuration"
echo "========================================"

# Cleanup environment variables
unset AWS_ACCESS_KEY_ID
unset AWS_SECRET_ACCESS_KEY
