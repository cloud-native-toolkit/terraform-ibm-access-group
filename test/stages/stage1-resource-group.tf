module "resource_groups" {
  source = "https://github.com/ibm-garage-cloud/terraform-ibm-resource-group.git"

  resourceGroupNames = var.new_resource_group
}
