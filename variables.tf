variable "resourceGroupNames" {
  type        = list(string)
  description = "List of resource group names that should be created"
}

variable "region" {
  type        = string
  description = "The region where the container registry should be set up"
}

variable "createResourceGroups" {
  type        = bool
  description = "Flag indicating that the resource groups should be created"
  default     = false
}
