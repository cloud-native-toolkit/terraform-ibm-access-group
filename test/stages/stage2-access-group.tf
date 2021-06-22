module "access_groups" {
  source = "./module"

  resource_group_name = module.resource_group.name
  provision           = module.resource_group.provision
  ibmcloud_api_key    = var.ibmcloud_api_key
}
