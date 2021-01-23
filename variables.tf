variable "resourceGroups" {
  type        = list(object({
    id   = string
    name = string
  }))
  description = "List of resource group names that should be created"
}

variable "region" {
  type        = string
  description = "The region where the container registry should be set up"
}
