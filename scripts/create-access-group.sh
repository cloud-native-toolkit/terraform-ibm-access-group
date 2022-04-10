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

RESULT=$(curl -s -o /dev/null -w "%{http_code}" --url "https://iam.cloud.ibm.com/v2/groups/$ACCESS_GROUP" \
  --header "Authorization: Bearer $IAM_TOKEN" \
  --header 'Content-Type: application/json')

#todo: this needs to be fixed
#
#
#if [[ "${RESULT}" == "200" ]]; then
#  echo "Access group ${ACCESS_GROUP} already exists"
#  exit 0
#fi

echo "Creating access group ${ACCESS_GROUP}..."

ACCOUNT_ID=$(curl -s -X GET 'https://iam.cloud.ibm.com/v1/apikeys/details' \
  -H "Authorization: Bearer $IAM_TOKEN" -H "IAM-Apikey: ${IBMCLOUD_API_KEY}" \
  -H 'Content-Type: application/json' | jq -r '.account_id')

PAYLOAD="{\"name\": \"${ACCESS_GROUP}\", \"description\": \"$DESCRIPTION\"}"
echo "$PAYLOAD"

# Submit request to IAM policy service
RESULT=$(curl -s --request POST  --url "https://iam.cloud.ibm.com/v2/groups?account_id=$ACCOUNT_ID"  \
  --header "Authorization: Bearer $IAM_TOKEN" \
  --header 'Content-Type: application/json' \
  --data "$PAYLOAD")

echo "$RESULT"

ACCESS_GROUP_ID=$(echo "$RESULT" | jq '.id' -r)

echo "Access group created: $ACCESS_GROUP_ID"
