variable "resource_group_name" {
  type        = string
  description = "The name of the resource group for which the access groups will be created"
}

variable "provision" {
  description = "Flag indicating that the service authorization should be created"
  type        = bool
  default     = true
}
