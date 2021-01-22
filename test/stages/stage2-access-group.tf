module "access_groups" {
  source = "./module"

  region             = var.region
  resourceGroupNames = module.resource_groups.names
}
