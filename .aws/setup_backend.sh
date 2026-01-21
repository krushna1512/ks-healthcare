#!/bin/bash
set -e

REGION="us-east-1"
BUCKET_NAME="kms-terraform-state-26"
DYNAMODB_TABLE="terraform-locks"

echo "Creating S3 Bucket for Terraform State: $BUCKET_NAME..."
aws s3api create-bucket --bucket $BUCKET_NAME --region $REGION

echo "Enabling Versioning on Bucket..."
aws s3api put-bucket-versioning --bucket $BUCKET_NAME --versioning-configuration Status=Enabled

echo "Creating DynamoDB Table for State Locking..."

if aws dynamodb describe-table --table-name $DYNAMODB_TABLE --region $REGION > /dev/null 2>&1; then
    echo "DynamoDB table $DYNAMODB_TABLE already exists. Skipping."
else
    aws dynamodb create-table \
        --table-name $DYNAMODB_TABLE \
        --attribute-definitions AttributeName=LockID,AttributeType=S \
        --key-schema AttributeName=LockID,KeyType=HASH \
        --billing-mode PAY_PER_REQUEST \
        --region $REGION
fi

echo "----------------------------------------------------------------"
echo "Backend Setup Complete!"
echo "----------------------------------------------------------------"
echo "Please update your provider.tf files with the following block:"
echo ""
echo "backend \"s3\" {"
echo "  bucket         = \"$BUCKET_NAME\""
echo "  key            = \"infrastructure.tfstate\" # OR \"services.tfstate\""
echo "  region         = \"$REGION\""
echo "  dynamodb_table = \"$DYNAMODB_TABLE\""
echo "  encrypt        = true"
echo "}"
echo ""
