
locals {
  resourceGroupNames = var.resourceGroups
  adminGroupNames    = [
    for name in var.resourceGroups:
      "${replace(upper(name), "-", "_")}_ADMIN"
  ]
  userGroupNames     = [
    for name in var.resourceGroups:
      "${replace(upper(name), "-", "_")}_USER"
  ]
}

data "ibm_resource_group" "resource_group" {
  count = length(var.resourceGroups)

  name  = var.resourceGroups[count.index]
}

/*** Create Access Groups for Admins and Users ***/

resource "ibm_iam_access_group" "admins" {
  count = length(local.adminGroupNames)

  name  = local.adminGroupNames[count.index]
}

resource "ibm_iam_access_group" "users" {
  count = length(local.userGroupNames)

  name  = local.userGroupNames[count.index]
}

/*** Import resource groups for the Admins Access Groups ***/

/*** Admins Access Groups Policies ***/

resource "ibm_iam_access_group_policy" "admin_policy_1" {
  count = length(local.adminGroupNames)

  access_group_id = element(ibm_iam_access_group.admins.*.id, count.index)
  roles           = ["Editor", "Manager"]
  resources {
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
  }
}

resource "ibm_iam_access_group_policy" "admin_policy_2" {
  count           = length(local.adminGroupNames)

  access_group_id = element(ibm_iam_access_group.admins.*.id, count.index)
  roles           = ["Viewer"]
  resources {
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
    attributes        = { "resourceType" = "resource-group", "resource" = local.resourceGroupNames[count.index] }
  }
}

resource "ibm_iam_access_group_policy" "admin_policy_3" {
  count           = length(local.adminGroupNames)

  access_group_id = element(ibm_iam_access_group.admins.*.id, count.index)
  roles           = ["Administrator", "Manager"]
  resources {
    service           = "containers-kubernetes"
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
  }
}

resource "ibm_iam_access_group_policy" "admin_policy_4" {
  count           = length(local.adminGroupNames)

  access_group_id = element(ibm_iam_access_group.admins.*.id, count.index)
  roles           = ["Administrator", "Manager"]
  resources {
    service = "container-registry"
  }
}

/*** Users Access Groups Policies ***/

resource "ibm_iam_access_group_policy" "user_policy_1" {
  count = length(local.userGroupNames)

  access_group_id = element(ibm_iam_access_group.users.*.id, count.index)
  roles           = ["Viewer", "Manager"]
  resources {
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
  }
}

resource "ibm_iam_access_group_policy" "user_policy_2" {
  count = length(local.userGroupNames)

  access_group_id = element(ibm_iam_access_group.users.*.id, count.index)
  roles           = ["Viewer"]
  resources {
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
    attributes        = { "resourceType" = "resource-group", "resource" = local.resourceGroupNames[count.index] }
  }
}

resource "ibm_iam_access_group_policy" "user_policy_3" {
  count = length(local.userGroupNames)

  access_group_id = element(ibm_iam_access_group.users.*.id, count.index)
  roles           = ["Editor", "Writer"]
  resources {
    service           = "containers-kubernetes"
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
  }
}

resource "ibm_iam_access_group_policy" "user_policy_4" {
  count = length(local.userGroupNames)

  access_group_id = element(ibm_iam_access_group.users.*.id, count.index)
  roles           = ["Reader", "Writer"]
  resources {
    resource_type     = "namespace"
    resource_group_id = element(data.ibm_resource_group.resource_group.*.id, count.index)
    service           = "container-registry"
    region            = var.region
  }
}
