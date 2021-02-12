variable "resourceGroupNames" {
  type        = list(string)
  description = "List of resource group names that should be created"
}

variable "createResourceGroups" {
  type        = bool
  description = "Flag indicating that the resource groups should be created"
  default     = false
}
