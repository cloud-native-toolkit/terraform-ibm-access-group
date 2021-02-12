output "resourceGroupNames" {
  description = "List of resource group names"
  value       = var.resourceGroupNames
  depends_on  = [data.ibm_resource_group.resource_group]
}

output "adminGroupNames" {
  description = "List of admin access group names"
  value       = ibm_iam_access_group.admins.*.name
  depends_on  = [
    ibm_iam_access_group_policy.admin_policy_1,
    ibm_iam_access_group_policy.admin_policy_2,
    ibm_iam_access_group_policy.admin_policy_3,
    ibm_iam_access_group_policy.admin_policy_4
  ]
}

output "userGroupNames" {
  description = "List of editor access group names (**Deprecated** use editGroupNames instead"
  value       = ibm_iam_access_group.editors.*.name
  depends_on  = [
    ibm_iam_access_group_policy.edit_policy_1,
    ibm_iam_access_group_policy.edit_policy_2,
    ibm_iam_access_group_policy.edit_policy_3,
    ibm_iam_access_group_policy.edit_policy_4
  ]
}

output "editGroupNames" {
  description = "List of editor access group names"
  value       = ibm_iam_access_group.editors.*.name
  depends_on  = [
    ibm_iam_access_group_policy.edit_policy_1,
    ibm_iam_access_group_policy.edit_policy_2,
    ibm_iam_access_group_policy.edit_policy_3,
    ibm_iam_access_group_policy.edit_policy_4
  ]
}

output "viewGroupNames" {
  description = "List of viewer access group names"
  value       = ibm_iam_access_group.viewers.*.name
  depends_on  = [
    ibm_iam_access_group_policy.view_policy_1,
    ibm_iam_access_group_policy.view_policy_2,
    ibm_iam_access_group_policy.view_policy_3,
    ibm_iam_access_group_policy.view_policy_4
  ]
}
