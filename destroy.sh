#!/bin/bash
set -e

VPC_ID=$(terraform output -raw vpc_id 2>/dev/null || aws ec2 describe-vpcs --filters "Name=tag:Name,Values=my-vpc" --query "Vpcs[0].VpcId" --output text)

if [ "$VPC_ID" == "None" ] || [ -z "$VPC_ID" ]; then
  echo "VPC not found, skipping endpoint cleanup"
else
  echo "Cleaning up VPC endpoints in $VPC_ID..."
  ENDPOINTS=$(aws ec2 describe-vpc-endpoints --filters "Name=vpc-id,Values=$VPC_ID" --query "VpcEndpoints[].VpcEndpointId" --output text)

  if [ -n "$ENDPOINTS" ] && [ "$ENDPOINTS" != "None" ]; then
    for EP in $ENDPOINTS; do
      echo "Deleting endpoint: $EP"
      aws ec2 delete-vpc-endpoints --vpc-endpoint-ids "$EP"
    done
    echo "Waiting for endpoints to delete..."
    sleep 10
  else
    echo "No VPC endpoints found"
  fi
fi

echo "Running terraform destroy..."
terraform destroy -auto-approve
