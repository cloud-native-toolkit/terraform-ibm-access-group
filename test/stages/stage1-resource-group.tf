module "access_groups" {
  source = "https://github.com/ibm-garage-cloud/terraform-ibm-resource-group"

  resourceGroupNames = var.new_resource_group
}
