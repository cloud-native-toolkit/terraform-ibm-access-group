
/*** Create Access Groups for Admins and Users ***/
locals {
  resourceGroupCount = 1
  resourceGroupNames = [var.resource_group_name]
}

resource "null_resource" "print_resource_group" {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
}

data ibm_resource_group resource_group {
  depends_on = [null_resource.print_resource_group]

  name = var.resource_group_name
}

resource ibm_iam_access_group admins {
  name  = "${replace(upper(var.resource_group_name), "-", "_")}_ADMIN"
}

resource ibm_iam_access_group editors {
  name  = "${replace(upper(var.resource_group_name), "-", "_")}_EDIT"
}

resource ibm_iam_access_group viewers {
  name  = "${replace(upper(var.resource_group_name), "-", "_")}_VIEW"
}

/*** Import resource groups for the Admins Access Groups ***/

/*** Admins Access Groups Policies ***/

resource ibm_iam_access_group_policy admin_policy_1 {

  access_group_id = element(ibm_iam_access_group.admins.id, count.index)
  roles           = ["Editor", "Manager"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy admin_policy_2 {

  access_group_id = element(ibm_iam_access_group.admins.*.id, count.index)
  roles           = ["Viewer"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
    attributes        = { "resourceType" = "resource-group", "resource" = var.resource_group_name }
  }
}

resource ibm_iam_access_group_policy admin_policy_3 {

  access_group_id = ibm_iam_access_group.admins.id
  roles           = ["Administrator", "Manager"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy admin_policy_4 {

  access_group_id = ibm_iam_access_group.admins.id
  roles           = ["Administrator", "Manager"]

  resources {
    service = "container-registry"
  }
}

/*** Editor Access Groups Policies ***/

resource ibm_iam_access_group_policy edit_policy_1 {

  access_group_id = ibm_iam_access_group.editors.id
  roles           = ["Viewer", "Manager"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy edit_policy_2 {

  access_group_id = ibm_iam_access_group.editors.id
  roles           = ["Viewer"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
    attributes        = { "resourceType" = "resource-group", "resource" = var.resource_group_name }
  }
}

resource ibm_iam_access_group_policy edit_policy_3 {

  access_group_id = ibm_iam_access_group.editors.id
  roles           = ["Editor", "Writer"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy edit_policy_4 {

  access_group_id = ibm_iam_access_group.editors.id
  roles           = ["Reader", "Writer"]

  resources {
    resource_type     = "namespace"
    resource_group_id = data.ibm_resource_group.resource_group.id
    service           = "container-registry"
  }
}


/*** Viewer Access Groups Policies ***/

resource ibm_iam_access_group_policy view_policy_1 {

  access_group_id = ibm_iam_access_group.viewers.id
  roles           = ["Viewer", "Reader"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy view_policy_2 {

  access_group_id = ibm_iam_access_group.viewers.id
  roles           = ["Viewer"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
    attributes        = { "resourceType" = "resource-group", "resource" = var.resource_group_name }
  }
}

resource ibm_iam_access_group_policy view_policy_3 {

  access_group_id = ibm_iam_access_group.viewers.id
  roles           = ["Viewer", "Reader"]

  resources {
    service           = "containers-kubernetes"
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy view_policy_4 {

  access_group_id = ibm_iam_access_group.viewers.id
  roles           = ["Viewer", "Reader"]

  resources {
    resource_type     = "namespace"
    resource_group_id = data.ibm_resource_group.resource_group.id
    service           = "container-registry"
  }
}
