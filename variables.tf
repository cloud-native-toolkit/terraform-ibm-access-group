
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for which the access groups will be created"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key used to access IBM Cloud"
}
