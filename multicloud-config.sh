#!/bin/bash

# === Variable Section ===
# Define Environment Settings
ENVIRONMENT="staging"
APP_NAME="web-api"

# AWS Settings
AWS_REGION="eu-north-1"
AWS_BUCKET="myapp-backup-$ENVIRONMENT"

# AZURE Settings
AZURE_REGION="northeurope"
AZURE_RESOURCE_GROUP="rg-$APP_NAME-$ENVIRONMENT"

# GCP Settings
GCP_REGION="europe-north1"
GCP_PROJECT="myapp-$ENVIRONMENT"

# === OUTPUT SECTION ===
echo "=== Multicloud Deployment Configuration ==="
echo ""
echo "Application: $APP_NAME"
echo "Environment: $ENVIRONMENT"
echo ""
echo "AWS Configuration:"
echo "  Region: $AWS_REGION"
echo "  S3 Bucket: $AWS_BUCKET"
echo ""
echo "Azure Configuration:"
echo "  Region: $AZURE_REGION"
echo "  Resource Group: $AZURE_RESOURCE_GROUP"
echo ""
echo "GCP Configuration:"
echo "  Region: $GCP_REGION"
echo "  Project: $GCP_PROJECT"
echo ""
echo "==========================================="
