module "access_groups" {
  source = "./module"

  region               = var.region
  resourceGroupNames   = split(",", var.new_resource_group)
  createResourceGroups = true
}
