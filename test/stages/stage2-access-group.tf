module "access_groups" {
  source = "./module"

  resourceGroupNames   = split(",", var.new_resource_group)
  createResourceGroups = true
}
