module "access_groups" {
  source = "./module"

  resource_group_name = module.resource_group.name
  ibmcloud_api_key    = var.ibmcloud_api_key
  page_limit          = 5
}

resource local_file rg_name {
  filename = ".resource_group"

  content = module.access_groups.resource_group_name
}
