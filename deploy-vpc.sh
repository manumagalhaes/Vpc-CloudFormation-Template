#!/usr/bin/env bash

set -eo pipefail

##
# Deploys the servers for automated testing with its autoscaling group.
##
echo "Hello, let's check your credentials."
if ! aws sts get-caller-identity; then
	>&2 echo "Authentication has failed, have you set \$AWS_PROFILE or \$AWS_SESSION_TOKEN or \$AWS_ACCESS_KEY_ID et al?"
	exit 14
fi

readonly TEMPLATE=$(dirname "${BASH_SOURCE[0]}")/vpc.yml
readonly BATCH="batch${RANDOM}"
readonly NOW=$(date +%Y-%m-%dT%H:%M:%S)

readonly STACK_NAME="must-be-lower-case"
readonly OWNER="owner@email.com"
readonly TAGS=("Name=${STACK_NAME}" "Batch=${BATCH}" "DateCreation=${NOW}" "StackName=${STACK_NAME}" "Compliance=no" "Owner=${OWNER}")

AWS_DEFAULT_REGION="eu-central-1"

# Ensure that the VPC CIDR range is agreed with your network administrator
  readonly VPC_CIDR="10.91.1.0/24"
  readonly PUB_SUBNET_A_CIDR="10.91.1.0/26"
  readonly PUB_SUBNET_B_CIDR="10.91.1.64/26"
  readonly PRI_SUBNET_A_CIDR="10.91.1.128/26"
  readonly PRI_SUBNET_B_CIDR="10.91.1.192/26"
  readonly FLOW_LOG_BUCKET_NAME="${STACK_NAME}-flow-log"

  AVAILABILITY_ZONE="${AWS_DEFAULT_REGION}a,${AWS_DEFAULT_REGION}b"
echo "Deploying network infrastructure in ${AWS_DEFAULT_REGION}"

# deploys and updates
aws cloudformation deploy \
  --template-file "${TEMPLATE}" \
  --stack-name "${STACK_NAME}" \
  --capabilities CAPABILITY_NAMED_IAM \
  --tags "${TAGS[@]}" \
  --no-fail-on-empty-changeset \
  --parameter-overrides \
    VpcCidr="${VPC_CIDR}" \
    PubSubnetACidr="${PUB_SUBNET_A_CIDR}" \
    PubSubnetBCidr="${PUB_SUBNET_B_CIDR}" \
    PriSubnetACidr="${PRI_SUBNET_A_CIDR}" \
    PriSubnetBCidr="${PRI_SUBNET_B_CIDR}" \
    FlowLogBucketName="${FLOW_LOG_BUCKET_NAME}" \
    AvailabilityZone="${AVAILABILITY_ZONE}" \
  --region "${AWS_DEFAULT_REGION}"