
/*** Create Access Groups for Admins and Users ***/
locals {
  roles = ["admin", "edit", "view"]
}

module "clis" {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"

  clis = ["jq"]
}

resource "null_resource" "print_names" {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
}

resource "random_uuid" "tag" {
}

resource null_resource create_access_groups {
  count = length(local.roles)

  triggers = {
    bin_dir        = module.clis.bin_dir
    description    = "${local.roles[count.index]} group for ${var.resource_group_name} [${random_uuid.tag.result}]"
    group          = upper("${var.resource_group_name}_${local.roles[count.index]}")
    ibmcloud_api_key = var.ibmcloud_api_key
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group.sh ${self.triggers.group} ${self.triggers.description}"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = self.triggers.ibmcloud_api_key
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group.sh ${self.triggers.group} ${self.triggers.description}"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = self.triggers.ibmcloud_api_key
    }
  }
}

data ibm_resource_group resource_group {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

data ibm_iam_access_group admins {
  depends_on = [null_resource.create_access_groups]

  access_group_name = upper("${var.resource_group_name}_${local.roles[0]}")
}

data ibm_iam_access_group editors {
  depends_on = [null_resource.create_access_groups]

  access_group_name = upper("${var.resource_group_name}_${local.roles[1]}")
}

data ibm_iam_access_group viewers {
  depends_on = [null_resource.create_access_groups]

  access_group_name = upper("${var.resource_group_name}_${local.roles[2]}")
}

/*** Import resource groups for the Admins Access Groups ***/

/*** Admins Access Groups Policies ***/

resource ibm_iam_access_group_policy admin_policy_1 {
  access_group_id = data.ibm_iam_access_group.admins.id
  roles           = ["Editor", "Manager"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy admin_policy_2 {
  access_group_id = data.ibm_iam_access_group.admins.id
  roles           = ["Viewer"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
    attributes        = { "resourceType" = "resource-group", "resource" = var.resource_group_name }
  }
}

resource ibm_iam_access_group_policy admin_policy_3 {
  access_group_id = data.ibm_iam_access_group.admins.id
  roles           = ["Administrator", "Manager"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy admin_policy_4 {
  access_group_id = data.ibm_iam_access_group.admins.id
  roles           = ["Administrator", "Manager"]

  resources {
    service = "container-registry"
  }
}

/*** Editor Access Groups Policies ***/

resource ibm_iam_access_group_policy edit_policy_1 {
  access_group_id = data.ibm_iam_access_group.editors.id
  roles           = ["Viewer", "Manager"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy edit_policy_2 {
  access_group_id = data.ibm_iam_access_group.editors.id
  roles           = ["Viewer"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
    attributes        = { "resourceType" = "resource-group", "resource" = var.resource_group_name }
  }
}

resource ibm_iam_access_group_policy edit_policy_3 {
  access_group_id = data.ibm_iam_access_group.editors.id
  roles           = ["Editor", "Writer"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy edit_policy_4 {
  access_group_id = data.ibm_iam_access_group.editors.id
  roles           = ["Reader", "Writer"]

  resources {
    resource_type     = "namespace"
    resource_group_id = data.ibm_resource_group.resource_group.id
    service           = "container-registry"
  }
}


/*** Viewer Access Groups Policies ***/

resource ibm_iam_access_group_policy view_policy_1 {
  access_group_id = data.ibm_iam_access_group.viewers.id
  roles           = ["Viewer", "Reader"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy view_policy_2 {
  access_group_id = data.ibm_iam_access_group.viewers.id
  roles           = ["Viewer"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
    attributes        = { "resourceType" = "resource-group", "resource" = var.resource_group_name }
  }
}

resource ibm_iam_access_group_policy view_policy_3 {
  access_group_id = data.ibm_iam_access_group.viewers.id
  roles           = ["Viewer", "Reader"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy view_policy_4 {
  access_group_id = data.ibm_iam_access_group.viewers.id
  roles           = ["Viewer", "Reader"]

  resources {
    resource_type     = "namespace"
    resource_group_id = data.ibm_resource_group.resource_group.id
    service           = "container-registry"
  }
}
