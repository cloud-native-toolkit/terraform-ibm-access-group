module "access_groups" {
  source = "./module"

  resource_group_name = module.resource_group.name
  ibmcloud_api_key    = var.ibmcloud_api_key
}
