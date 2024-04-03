locals {
  prefix        = "${var.prefix}"
  worker_pc_ssh = var.ssh_password_enable == "true" ? "   ssh ubuntu@${local.worker_pc_ip} password= ${random_string.ssh.result}   " : "   ssh ubuntu@${local.worker_pc_ip}   "
  tags_app = {
    "Name"     = "${local.prefix}-${var.app_name}"
    "app_name" = var.app_name
  }
  tags_all = merge(var.tags_common, local.tags_app)
  tags_k8_master = {
    "k8_node_type" = "worker-pc"
    "Name"         = "${local.prefix}-${var.app_name}-worker-pc"
  }
  tags_all_k8_master = merge(local.tags_all, local.tags_k8_master)

  worker_pc_ip = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
  worker_pc_id = google_compute_instance.master.id
  hosts        = join(" ", var.host_list)
}
