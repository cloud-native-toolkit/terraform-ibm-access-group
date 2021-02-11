#!/usr/bin/env bash

set -e

ibmcloud login --apikey "${IBMCLOUD_API_KEY}" -r us-east

RESOURCE_GROUP=$(cat ./terrform.tfvars | grep "new_resource_group" | sed -E "s/.*=//g" | sed 's/"//g')

ACCESS_GROUP_BASE=$(echo "${RESOURCE_GROUP}" | sed "s/-/_/g" | tr '[:lower:]' '[:upper:]')
ADMIN_ACCESS_GROUP="${ACCESS_GROUP_BASE}-ADMIN"
EDIT_ACCESS_GROUP="${ACCESS_GROUP_BASE}-EDIT"
VIEW_ACCESS_GROUP="${ACCESS_GROUP_BASE}-VIEW"

GROUPS="${ADMIN_ACCESS_GROUP} ${EDIT_ACCESS_GROUP} ${VIEW_ACCESS_GROUP}"

for group in $GROUPS; do
  if ! ibmcloud iam access-group "${group}"; then
    echo "Access group not found: ${group}"
    exit 1
  fi
done
