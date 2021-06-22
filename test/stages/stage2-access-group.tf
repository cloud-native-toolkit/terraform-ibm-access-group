module "access_groups" {
  source = "./module"

  resource_group_name = module.resource_group.name
  provision           = true
  ibmcloud_api_key    = var.ibmcloud_api_key
}
