#!/usr/bin/env bash

set -e

ibmcloud login --apikey "${IBMCLOUD_API_KEY}" -r us-east

RESOURCE_GROUP=$(cat ./terraform.tfvars | grep "new_resource_group" | sed -E "s/.*=//g" | sed 's/"//g')

echo "Resource group: ${RESOURCE_GROUP}"

ACCESS_GROUP_BASE=$(echo "${RESOURCE_GROUP}" | sed "s/-/_/g" | tr '[:lower:]' '[:upper:]')

echo "Access group base: ${ACCESS_GROUP_BASE}"

ADMIN_ACCESS_GROUP="${ACCESS_GROUP_BASE}_ADMIN"
EDIT_ACCESS_GROUP="${ACCESS_GROUP_BASE}_EDIT"
VIEW_ACCESS_GROUP="${ACCESS_GROUP_BASE}_VIEW"

ACCESS_GROUPS="${ADMIN_ACCESS_GROUP} ${EDIT_ACCESS_GROUP} ${VIEW_ACCESS_GROUP}"

echo "Groups: ${ACCESS_GROUPS}"

for group in ${ACCESS_GROUPS}; do
  echo "Checking for group: ${group}"

  if ! ibmcloud iam access-group "${group}"; then
    echo "Access group not found: ${group}"
    exit 1
  fi
done
