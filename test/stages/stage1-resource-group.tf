module "resource_group" {
  source = "github.com/cloud-native-toolkit/terraform-ibm-resource-group.git"

  resource_group_name = "rg-${random_string.rg_name.result}"
  ibmcloud_api_key    = var.ibmcloud_api_key
}
