
variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for which the access groups will be created"
}

variable "ibmcloud_api_key" {
  type        = string
  description = "The api key used to access IBM Cloud"
  sensitive   = true
}

variable "page_limit" {
  type = number
  description = "The number of access groups to return per request (this is mostly used for testing)"
  default = 50
}
