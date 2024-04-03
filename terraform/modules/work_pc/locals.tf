locals {
  USER_ID       = var.USER_ID == "" ? "defaultUser" : var.USER_ID
  ENV_ID        = var.ENV_ID == "" ? "defaultId" : var.ENV_ID
  prefix_id     = "${local.USER_ID}_${local.ENV_ID}"
  prefix        = "${local.prefix_id}_${var.prefix}"
  tags_app = {
    "Name"     = "${local.prefix}-${var.app_name}"
    "app_name" = var.app_name
  }
  tags_all = merge(var.tags_common, local.tags_app)
  tags_k8_master = {
    "k8_node_type" = "worker-pc"
    "Name"         = "${local.prefix}-${var.app_name}-worker-pc"
  }

  hosts        = join(" ", var.host_list)
}
