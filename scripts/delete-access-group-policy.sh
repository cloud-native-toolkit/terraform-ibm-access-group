#!/usr/bin/env bash

if [[ -n "${BIN_DIR}" ]]; then
  export PATH="$BIN_DIR:$PATH"
fi

if ! command -v jq 1> /dev/null 2> /dev/null; then
  echo "JQ command not found" >&2
  exit 1
fi

if [[ -z "${IBMCLOUD_API_KEY}" ]]; then
  echo "IBMCLOUD_API_KEY must be provided as an environment variable" >&2
  exit 1
fi

if [[ -z "${ACCESS_GROUP_ID}" ]]; then
  echo "ACCESS_GROUP_ID must be provided as an environment variable" >&2
  exit 1
fi

IAM_TOKEN=$(curl -s -X POST "https://iam.cloud.ibm.com/identity/token" \
  -H "Content-Type: application/x-www-form-urlencoded" \
  -d "grant_type=urn:ibm:params:oauth:grant-type:apikey&apikey=${IBMCLOUD_API_KEY}" | jq -r '.access_token')

ACCOUNT_ID=$(curl -s -X GET 'https://iam.cloud.ibm.com/v1/apikeys/details' \
  -H "Authorization: Bearer $IAM_TOKEN" -H "IAM-Apikey: ${IBMCLOUD_API_KEY}" \
  -H 'Content-Type: application/json' | jq -r '.account_id')

if [[ -z "${ACCOUNT_ID}" ]]; then
  echo "ACCOUNT_ID not found" >&2
  exit 0
fi

POLICIES=$(curl -s -X GET "https://iam.cloud.ibm.com/v1/policies?account_id=${ACCOUNT_ID}&access_group_id=${ACCESS_GROUP_ID}" \
  -H "Authorization: Bearer $IAM_TOKEN" \
  -H "Content-Type: application/json")

if [[ -z "${POLICIES}" ]]; then
  echo "Error retrieving policies: account_id=${ACCOUNT_ID}, access_group=${ACCESS_GROUP_ID}" >&2
  exit 0
fi

POLICY_ID=$(echo "${POLICIES}" | jq --arg DESCRIPTION "${DESCRIPTION}" '.policies[] | select(.description != null) | select(.description == $DESCRIPTION) | .id // empty' -r)

if [[ -z "${POLICY_ID}" ]]; then
  echo "Policy with description not found: ${DESCRIPTION}" >&2
  exit 0
fi

echo "Deleting policy: ${POLICY_ID}..."
curl -s -X DELETE "https://iam.cloud.ibm.com/v1/policies/$POLICY_ID" \
  -H "Authorization: Bearer $IAM_TOKEN" \
  -H "Content-Type: application/json"

echo "Policy deleted: ${POLICY_ID}"
