#!/usr/bin/env bash

set -x

ibmcloud login --apikey "${IBMCLOUD_API_KEY}" -r us-east

source ./terraform.tfvars

ACCESS_GROUP_BASE=$(echo "${new_resource_group}" | sed "s/-/_/g" | tr '[:lower:]' '[:upper:]')
ADMIN_ACCESS_GROUP="${ACCESS_GROUP_BASE}-ADMIN"
EDIT_ACCESS_GROUP="${ACCESS_GROUP_BASE}-EDIT"
VIEW_ACCESS_GROUP="${ACCESS_GROUP_BASE}-VIEW"

declare -a GROUPS=(${ADMIN_ACCESS_GROUP} ${EDIT_ACCESS_GROUP} ${VIEW_ACCESS_GROUP})

for group in "${GROUPS[@]}"; do
  if ! ibmcloud iam access-group "${group}"; then
    echo "Access group not found: ${group}"
    exit 1
  fi
done
