#!/usr/bin/env bash

set -e


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

ACCOUNT_ID=$(curl -s -X GET 'https://iam.cloud.ibm.com/v1/apikeys/details' \
  -H "Authorization: Bearer $IAM_TOKEN" -H "IAM-Apikey: ${IBMCLOUD_API_KEY}" \
  -H 'Content-Type: application/json' | jq -r '.account_id')

#find access policies for the access group

POLICIES=$(curl -s -X GET "https://iam.cloud.ibm.com/v1/policies?account_id=$ACCOUNT_ID&access_group_id=$ACCESS_GROUP_ID" \
  -H "Authorization: Bearer $IAM_TOKEN" \
  -H "Content-Type: application/json")

POLICY=$(echo $POLICIES | jq ".policies[] | select(.description==\"$DESCRIPTION\")" -r)
POLICY_ID=$(echo $POLICY | jq '.id' -r )


if [ -z "$POLICY" ]; then
  echo "Policy not found."
  exit
fi

#delete the policy
echo "Deleting policy: $POLICY_ID..."
curl -s -X DELETE "https://iam.cloud.ibm.com/v1/policies/$POLICY_ID" \
  -H "Authorization: Bearer $IAM_TOKEN" \
  -H "Content-Type: application/json"

echo "Deleted"