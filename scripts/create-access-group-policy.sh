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


#RESOURCE_ATTRIBUTES JSON payload based on syntax https://cloud.ibm.com/apidocs/iam-policy-management#create-policy

ROLES_PAYLOAD=""
for role in $(echo "$ROLES" | jq -r '.[]'); do
  if [ ! -z "$ROLES_PAYLOAD" ]; then
    ROLES_PAYLOAD="$ROLES_PAYLOAD,"
  fi
  ROLE_CRN=""
  case "$role" in
    ("Writer") ROLE_CRN="crn:v1:bluemix:public:iam::::serviceRole:Writer" ;;
    ("Reader") ROLE_CRN="crn:v1:bluemix:public:iam::::serviceRole:Reader" ;;
    ("Manager") ROLE_CRN="crn:v1:bluemix:public:iam::::serviceRole:Manager" ;;
    ("Administrator") ROLE_CRN="crn:v1:bluemix:public:iam::::role:Administrator" ;;
    ("Operator") ROLE_CRN="crn:v1:bluemix:public:iam::::role:Operator" ;;
    ("Viewer") ROLE_CRN="crn:v1:bluemix:public:iam::::role:Viewer" ;;
    ("Editor") ROLE_CRN="crn:v1:bluemix:public:iam::::role:Editor" ;;
  esac

  ROLES_PAYLOAD="$ROLES_PAYLOAD{\"role_id\": \"$ROLE_CRN\"}"
done

if [ -z "$RESOURCE_ATTRIBUTES" ]; then
  echo "No resource attributes were specified."
  exit 1
fi


PAYLOAD='{
    "type": "access",
    "description": "'$DESCRIPTION'",
    "subjects": [
      {
        "attributes": [
          {
            "name": "access_group_id",
            "value": "'$ACCESS_GROUP_ID'"
          }
        ]
      }
    ],
    "roles":['$ROLES_PAYLOAD'],
    "resources":[
      {
        "attributes": [
          {
            "name": "accountId",
            "value": "'$ACCOUNT_ID'",
            "operator": "stringEquals"
          },
          '$RESOURCE_ATTRIBUTES'
        ]
      }
    ]
  }'

#echo $PAYLOAD

# create access group policy
RESULT=$(curl -s -X POST 'https://iam.cloud.ibm.com/v1/policies' \
  -H "Authorization: Bearer $IAM_TOKEN" \
  -H "Content-Type: application/json" \
  -d "$PAYLOAD")

STATUS=$(echo $RESULT | jq '.status_code // empty' -r)
echo $RESULT

if [ ! -z "$STATUS" ]; then
  echo "exiting $STATUS"
  exit 1
fi
