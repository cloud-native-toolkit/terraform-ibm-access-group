module "resource_groups" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-resource-group.git?ref=output-ids"

  resourceGroupNames = var.new_resource_group
}
