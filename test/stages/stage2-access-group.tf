module "access_groups" {
  source = "./module"

  region         = var.region
  resourceGroups = var.resource_group_name
  createResourceGroups = true
}
