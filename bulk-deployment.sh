#!/bin/bash

# === VARIABLES: Define what we're deploying ===
APP_NAME="web-api-v4"
ENVIRONMENT="production"

# AWS regions to deploy to
AWS_REGIONS=("eu-north-1" "eu-west-1" "eu-central-1" "us-east-1" "us-west-1" "eu-north-2" "eu-west-2")

# Azure regions to deploy to
AZURE_REGIONS=("northeurope" "westeurope" "eastus" "westus")

# GCP regions to deploy to
GCP_REGIONS=("europe-north1" "europe-west1" "us-east1" "us-west1")

# === FUNCTION: Deploy to AWS region ===
deploy_to_aws() {
	local region=$1
	echo "Deploying $APP_NAME to AWS $region..."
	sleep 0.5
	echo "AWS $region deployment complete"
}

# === FUNCTION: Deploy to Azure region ===
deploy_to_azure() {
	local region=$1
	echo "Deploying $APP_NAME to Azure $region..."
	sleep 0.5
	echo "Azure $region deployment complete "
}	

# === FUNCTION: Deploy to GCP region ===
deploy_to_gcp() { 
        local region=$1
	echo "Deployment $APP_NAME to GCP $region..."
	sleep 0.5
	echo "GCP $region deployment complete"
}

# === MAIN SCRIPT ===
echo "=== BULK MULTICLOUD DEPLOYMENT ==="
echo "Application: $APP_NAME"
echo "Environment: $ENVIRONMENT"
echo "=================================="
echo ""

# === FOR LOOP: Deploy to ALL AWS regions ===
echo "AWS Deployments:"
echo "----------------------------------"
for region in "${AWS_REGIONS[@]}"; do
	deploy_to_aws "$region"
done

echo ""
echo "Azure Deployments:"
echo "----------------------------------"
for region in "${AZURE_REGIONS[@]}"; do 
	deploy_to_azure "$region"
done

echo ""
echo "GCP Deployments:" 
echo "----------------------------------"
for region in "${GCP_REGIONS[@]}"; do
	deploy_to_gcp "$region"
done

echo""
echo "----------------------------------"
echo "🎉 ALL BULK DEPLOYMENTS COMPLETE!"
echo "Total AWS regions: ${#AWS_REGIONS[@]}"
echo "Total Azure regions: ${#AZURE_REGIONS[@]}"
echo "Total GCP regions: ${#GCP_REGIONS[@]}"
echo "TOTAL REGIONS: $((${#AWS_REGIONS[@]} + ${#AZURE_REGIONS[@]} + ${#GCP_REGIONS[@]}))" 
