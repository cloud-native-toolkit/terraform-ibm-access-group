module "access_groups" {
  source = "./module"

  region         = var.region
  resourceGroups = module.resource_groups.names
}
