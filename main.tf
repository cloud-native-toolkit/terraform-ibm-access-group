
/*** Create Access Groups for Admins and Users ***/
locals {
  admin_name  = "${replace(upper(var.resource_group_name), "-", "_")}_ADMIN"
  editor_name = "${replace(upper(var.resource_group_name), "-", "_")}_EDIT"
  viewer_name = "${replace(upper(var.resource_group_name), "-", "_")}_VIEW"
}

resource "null_resource" "print_names" {
  provisioner "local-exec" {
    command = "echo 'Resource group: ${var.resource_group_name}'"
  }
  provisioner "local-exec" {
    command = "echo 'Admin access group: ${local.admin_name}'"
  }
  provisioner "local-exec" {
    command = "echo 'Editor access group: ${local.editor_name}'"
  }
  provisioner "local-exec" {
    command = "echo 'Viewer access group: ${local.viewer_name}'"
  }
}

data ibm_resource_group resource_group {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

resource ibm_iam_access_group admins {
  name = local.admin_name
}

resource ibm_iam_access_group editors {
  name = local.editor_name
}

resource ibm_iam_access_group viewers {
  name = local.viewer_name
}

/*** Import resource groups for the Admins Access Groups ***/

/*** Admins Access Groups Policies ***/

resource ibm_iam_access_group_policy admin_policy_1 {

  access_group_id = ibm_iam_access_group.admins.id
  roles           = ["Editor", "Manager"]

  resources {
    resource_group_id = data.ibm_resource_group.resource_group.id
  }
}

resource ibm_iam_access_group_policy admin_policy_2 {

  access_group_id = ibm_iam_access_group.admins.id
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
