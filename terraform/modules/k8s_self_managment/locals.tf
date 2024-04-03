locals {
  prefix       = "${var.prefix}"
  tags_app = {
    "Name"     = "${local.prefix}-${var.app_name}"
    "app_name" = var.app_name
  }
  tags_all = merge(var.tags_common, local.tags_app)
  tags_k8_master = {
    "k8_node_type" = "master"
    "Name"         = "${local.prefix}-${var.app_name}-master"
  }
  tags_all_k8_master = merge(local.tags_all, local.tags_k8_master)

  tags_k8_worker = {
    "k8_node_type" = "worker"
    "Name"         = "${local.prefix}-${var.app_name}-worker"
  }
  tags_all_k8_worker = merge(local.tags_all, local.tags_k8_worker)
  worker_join        = "${var.s3_k8s_config}/config/${var.cluster_name}-${local.target_time_stamp}/worker_join"
  k8s_config         = "${var.s3_k8s_config}/config/${var.cluster_name}-${local.target_time_stamp}/config"

  worker_nodes = {
    for key, instance in google_compute_instance.worker :
    key => {
      private_ip     = instance.network_interface.0.network_ip
      public_ip      = instance.network_interface.0.access_config.0.nat_ip
      runtime        = var.k8s_worker[key].runtime
      labels         = var.k8s_worker[key].node_labels
      id             = instance.id
      ubuntu_version = var.k8s_worker["${key}"].ubuntu_version
      machine_type  = var.k8s_worker["${key}"].machine_type
    }
  }

  k8s_worker = var.k8s_worker

  worker_node_ids         = join(" ", [for node in local.worker_nodes : node.id])
  worker_node_ips_public  = join(" ", [for node in local.worker_nodes : node.public_ip])
  worker_node_ips_private = join(" ", [for node in local.worker_nodes : node.private_ip])

  master_ip            = google_compute_instance.master.network_interface.0.access_config.0.nat_ip
  master_ip_public     = google_compute_instance.master.network_interface.0.access_config.0.nat_ip

  master_instance_id   = google_compute_instance.master.id
  master_local_ip      = google_compute_instance.master.network_interface.0.network_ip
  master_machine_type = var.k8s_master.machine_type

  hosts_worker_node = [for key, value in local.worker_nodes : "${var.cluster_name}_node_${key}=${value.private_ip}"]
  hosts_master_node = ["${var.cluster_name}_controlPlane_1=${local.master_local_ip}"]
  hosts             = concat(local.hosts_master_node, local.hosts_worker_node)
}
