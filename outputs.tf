output "resource_group_name" {
  description = "List of resource group names"
  value       = var.resource_group_name
  depends_on  = [data.ibm_resource_group.resource_group]
}

#output "admin_group_name" {
#  description = "List of admin access group names"
#  value       = data.ibm_iam_access_group.admins.access_group_name
#  depends_on  = [
#    ibm_iam_access_group_policy.admin_policy_1,
#    ibm_iam_access_group_policy.admin_policy_2,
#    ibm_iam_access_group_policy.admin_policy_3,
#    ibm_iam_access_group_policy.admin_policy_4
#  ]
#}
#
#output "edit_group_name" {
#  description = "List of editor access group names"
#  value       = data.ibm_iam_access_group.editors.access_group_name
#  depends_on  = [
#    ibm_iam_access_group_policy.edit_policy_1,
#    ibm_iam_access_group_policy.edit_policy_2,
#    ibm_iam_access_group_policy.edit_policy_3,
#    ibm_iam_access_group_policy.edit_policy_4
#  ]
#}
#
#output "view_group_name" {
#  description = "List of viewer access group names"
#  value       = data.ibm_iam_access_group.viewers.access_group_name
#  depends_on  = [
#    ibm_iam_access_group_policy.view_policy_1,
#    ibm_iam_access_group_policy.view_policy_2,
#    ibm_iam_access_group_policy.view_policy_3,
#    ibm_iam_access_group_policy.view_policy_4
#  ]
#}
