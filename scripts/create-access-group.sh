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

ACCOUNT_ID=$(curl -s -X GET 'https://iam.cloud.ibm.com/v1/apikeys/details' \
  -H "Authorization: Bearer $IAM_TOKEN" -H "IAM-Apikey: ${IBMCLOUD_API_KEY}" \
  -H 'Content-Type: application/json' | jq -r '.account_id')

# check if access group already exists

ACCESS_GROUP_ID=""

url="/v2/groups?account_id=$ACCOUNT_ID"
while [[ -n "$url" ]] && [[ -z "$ACCESS_GROUP_ID" ]]
do
  #echo $url
  RESULT=$(curl -s -X GET "https://iam.cloud.ibm.com$url" \
    --header "Authorization: Bearer $IAM_TOKEN" \
    --header 'Content-Type: application/json')

  ACCESS_GROUP_ID="$(echo "${RESULT}" | jq -r --arg ACCESS_GROUP "${ACCESS_GROUP}" '.groups[] | select(.name == $ACCESS_GROUP).id')"
  url=$(echo "$RESULT" | jq '.next_url // empty' -r )
done

if [[ -n "$ACCESS_GROUP_ID" ]]; then
  echo "Access group ${ACCESS_GROUP} already exists"
  exit 0
fi

echo "Creating access group ${ACCESS_GROUP}..."

PAYLOAD=$(jq -n --arg NAME "${ACCESS_GROUP}" --arg DESC "${DESCRIPTION}" '{"name": $NAME, "description": $DESC}')
echo "$PAYLOAD"

# Submit request to IAM policy service
RESULT=$(curl -s --request POST  --url "https://iam.cloud.ibm.com/v2/groups?account_id=$ACCOUNT_ID"  \
  --header "Authorization: Bearer $IAM_TOKEN" \
  --header 'Content-Type: application/json' \
  --data "$PAYLOAD")

echo "$RESULT"

ACCESS_GROUP_ID=$(echo "$RESULT" | jq '.id' -r)

echo "Access group created: $ACCESS_GROUP_ID"
