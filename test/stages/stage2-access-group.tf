module "access_groups" {
  source = "./module"

  region = var.region
  resourceGroupNames = var.new_resource_group
}
