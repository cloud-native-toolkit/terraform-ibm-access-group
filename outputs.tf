output "resource_group_name" {
  description = "List of resource group names"
  value       = local.resourceGroupNames[0]
  depends_on  = [data.ibm_resource_group.resource_group]
}

output "admin_group_name" {
  description = "List of admin access group names"
  value       = ibm_iam_access_group.admins.[0].name
  depends_on  = [
    ibm_iam_access_group_policy.admin_policy_1,
    ibm_iam_access_group_policy.admin_policy_2,
    ibm_iam_access_group_policy.admin_policy_3,
    ibm_iam_access_group_policy.admin_policy_4
  ]
}

output "edit_group_name" {
  description = "List of editor access group names"
  value       = ibm_iam_access_group.editors.[0].name
  depends_on  = [
    ibm_iam_access_group_policy.edit_policy_1,
    ibm_iam_access_group_policy.edit_policy_2,
    ibm_iam_access_group_policy.edit_policy_3,
    ibm_iam_access_group_policy.edit_policy_4
  ]
}

output "view_group_name" {
  description = "List of viewer access group names"
  value       = ibm_iam_access_group.viewers.[0].name
  depends_on  = [
    ibm_iam_access_group_policy.view_policy_1,
    ibm_iam_access_group_policy.view_policy_2,
    ibm_iam_access_group_policy.view_policy_3,
    ibm_iam_access_group_policy.view_policy_4
  ]
}
