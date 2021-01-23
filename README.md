# IBM Cloud Access Group creation module

Terraform module to provision ADMIN and USER access groups for the resource groups provided. The resource groups are optionally
created as well.

## Software dependencies

The module depends on the following software components:

### Command-line tools

- terraform - v12
- kubectl

### Terraform providers

- IBM Cloud provider >= 1.5.3

## Example usage

```hcl-terraform
module "access_groups" {
  source = "github.com/ibm-garage-cloud/terraform-ibm-access-groups.git?ref=v1.0.0"

  region               = var.region
  resourceGroupNames   = var.resource_group
  createResourceGroups = true
}
```

