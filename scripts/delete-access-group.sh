#!/usr/bin/env bash

set -e

ACCESS_GROUP="$1"
DESCRIPTION="$2"

export PATH="$BIN_DIR:$PATH"

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "JQ command not found" >&2
  exit 1
fi

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY must be provided as an environment variable" >&2
  exit 1
fi

IAM_TOKEN=$(curl -s -X POST "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${IBMCLOUD_API_KEY}" | jq -r '.access_token')

# check if access group exists

RESULT=$(curl -s --url "https://iam.cloud.ibm.com/v2/groups/${ACCESS_GROUP}" \
  --header "Authorization: Bearer $IAM_TOKEN" \
  --header 'Content-Type: application/json')

CURRENT_DESCRIPTION=$(echo "${RESULT}" | jq -r '.description')
ACCESS_GROUP_ID=$(echo "${RESULT}" | jq -r '.id')

if [[ "${CURRENT_DESCRIPTION}" != "${DESCRIPTION}" ]]; then
  echo "The access group was provisioned elsewhere: ${CURRENT_DESCRIPTION}"
  exit 0
fi

echo "Deleting access group ${ACCESS_GROUP}..."

# Submit request to IAM policy service
RESULT=$(curl -s --request DELETE --url "https://iam.cloud.ibm.com/v2/groups/${ACCESS_GROUP_ID}")

echo "Access group deleted: ${ACCESS_GROUP}"
