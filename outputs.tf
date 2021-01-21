output "resourceGroupNames" {
  description = "List of resource group names"
  value       = local.resourceGroupNames
  depends_on  = [data.ibm_resource_group.resource_group]
}

output "adminGroupNames" {
  description = "List of admin access group names"
  value       = local.adminGroupNames
  depends_on  = [
    ibm_iam_access_group_policy.admin_policy_1,
    ibm_iam_access_group_policy.admin_policy_2,
    ibm_iam_access_group_policy.admin_policy_3,
    ibm_iam_access_group_policy.admin_policy_4
  ]
}

output "userGroupNames" {
  description = "List of user access group names"
  value       = local.userGroupNames
  depends_on  = [
    ibm_iam_access_group_policy.user_policy_1,
    ibm_iam_access_group_policy.user_policy_2,
    ibm_iam_access_group_policy.user_policy_3,
    ibm_iam_access_group_policy.user_policy_4
  ]
}
