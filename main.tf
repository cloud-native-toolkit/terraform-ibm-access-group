
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
    group          = upper("${replace(var.resource_group_name, "-", "_")}_${local.roles[count.index]}")
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group.sh ${self.triggers.group} '${self.triggers.description}'"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group.sh ${self.triggers.group} '${self.triggers.description}'"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
    }
  }
}

data ibm_resource_group resource_group {
  depends_on = [null_resource.print_names]

  name = var.resource_group_name
}

data ibm_iam_access_group admins {
  depends_on = [null_resource.create_access_groups]

  access_group_name = upper("${replace(var.resource_group_name, "-", "_")}_${local.roles[0]}")
}

data ibm_iam_access_group editors {
  depends_on = [null_resource.create_access_groups]

  access_group_name = upper("${replace(var.resource_group_name, "-", "_")}_${local.roles[1]}")
}

data ibm_iam_access_group viewers {
  depends_on = [null_resource.create_access_groups]

  access_group_name = upper("${replace(var.resource_group_name, "-", "_")}_${local.roles[2]}")
}

/*** Import resource groups for the Admins Access Groups ***/

/*** Admins Access Groups Policies ***/

resource null_resource admin_policy_1 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.admins.groups.0.id
    description    = "admin_policy_1 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\" }"
    roles = "[\"Editor\", \"Manager\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource admin_policy_2 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.admins.groups.0.id
    description    = "admin_policy_2 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\":\"resourceType\", \"value\": \"resource-group\"}, {\"name\": \"resource\", \"value\": \"${var.resource_group_name}\" }"
    roles = "[\"Viewer\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource admin_policy_3 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.admins.groups.0.id
    description    = "admin_policy_3 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"serviceName\",  \"value\":\"containers-kubernetes\"}, { \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\"}"
    roles = "[\"Administrator\", \"Manager\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource admin_policy_4 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.admins.groups.0.id
    description    = "admin_policy_4 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"serviceName\", \"value\": \"container-registry\" }"
    roles = "[\"Administrator\", \"Manager\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}



#
#/*** Editor Access Groups Policies ***/
#

resource null_resource edit_policy_1 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.editors.groups.0.id
    description    = "edit_policy_1 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\" }"
    roles = "[\"Viewer\", \"Manager\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource edit_policy_2 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.editors.groups.0.id
    description    = "edit_policy_2 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\":\"resourceType\", \"value\": \"resource-group\"}, {\"name\": \"resource\", \"value\": \"${var.resource_group_name}\" }"
    roles = "[\"Viewer\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource edit_policy_3 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.editors.groups.0.id
    description    = "edit_policy_3 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"serviceName\",  \"value\":\"containers-kubernetes\"}, { \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\"}"
    roles = "[\"Editor\", \"Writer\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource edit_policy_4 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.editors.groups.0.id
    description    = "edit_policy_4 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\":\"resourceType\", \"value\": \"namespace\"}, { \"name\": \"serviceName\", \"value\": \"container-registry\" }, { \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\"}"
    roles = "[\"Reader\", \"Writer\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}



#
#/*** Viewer Access Groups Policies ***/
#

resource null_resource view_policy_1 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.viewers.groups.0.id
    description    = "view_policy_1 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\" }"
    roles = "[\"Viewer\", \"Reader\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource view_policy_2 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.viewers.groups.0.id
    description    = "view_policy_2 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\":\"resourceType\", \"value\": \"resource-group\"}, {\"name\": \"resource\", \"value\": \"${var.resource_group_name}\" }"
    roles = "[\"Viewer\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource view_policy_3 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.viewers.groups.0.id
    description    = "view_policy_3 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\": \"serviceName\",  \"value\":\"containers-kubernetes\"}, { \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\"}"
    roles = "[\"Viewer\", \"Reader\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}

resource null_resource view_policy_4 {

  triggers = {
    bin_dir        = module.clis.bin_dir
    access_group_id = data.ibm_iam_access_group.viewers.groups.0.id
    description    = "view_policy_4 group for [${random_uuid.tag.result}]"
    ibmcloud_api_key = base64encode(var.ibmcloud_api_key)
    attributes = "{ \"name\":\"resourceType\", \"value\": \"namespace\"}, { \"name\": \"serviceName\", \"value\": \"container-registry\" }, { \"name\": \"resourceGroupId\", \"value\": \"${data.ibm_resource_group.resource_group.id}\"}"
    roles = "[\"Viewer\", \"Reader\"]"
  }

  provisioner "local-exec" {
    command = "${path.module}/scripts/create-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
      RESOURCE_ATTRIBUTES = self.triggers.attributes
      ROLES = self.triggers.roles
    }
  }

  provisioner "local-exec" {
    when = destroy
    command = "${path.module}/scripts/delete-access-group-policy.sh"

    environment = {
      BIN_DIR = self.triggers.bin_dir
      IBMCLOUD_API_KEY = base64decode(self.triggers.ibmcloud_api_key)
      ACCESS_GROUP_ID = self.triggers.access_group_id
      DESCRIPTION = self.triggers.description
    }
  }
}