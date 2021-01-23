module "access_groups" {
  source = "./module"

  region               = var.region
  resourceGroupNames   = var.resource_group_name
  createResourceGroups = true
}
