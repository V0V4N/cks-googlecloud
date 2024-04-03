resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance" "worker" {
  for_each                    = local.k8s_worker_ondemand
  name         = "${local.prefix}-${var.app_name}"
  machine_type = var.k8s_master.machine_type
  zone         = var.region

  tags = local.tags_all

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.default.email
    scopes = ["cloud-platform"]
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"
    subnetwork = ""

    access_config {
      // Ephemeral public IP
    }
  }
  
  metadata = {
    startup-script = <<-EOF
    ${templatefile("template/boot_zip.sh", {
    boot_zip = base64gzip(templatefile(var.k8s_master.user_data_template, {
      worker_join         = local.worker_join
      k8s_config          = local.k8s_config
      external_ip         = local.external_ip
      k8_version          = var.k8s_master.k8_version
      runtime             = var.k8s_master.runtime
      utils_enable        = var.k8s_master.utils_enable
      pod_network_cidr    = var.k8s_master.pod_network_cidr
      runtime_script      = file(var.k8s_master.runtime_script)
      task_script_url     = var.k8s_master.task_script_url
      calico_url          = var.k8s_master.calico_url
      ssh_private_key     = var.k8s_master.ssh.private_key
      ssh_pub_key         = var.k8s_master.ssh.pub_key
      ssh_password        = random_string.ssh.result
      ssh_password_enable = var.ssh_password_enable
    }))
    })}
    EOF
  }
  lifecycle {
    ignore_changes = [
      machine_type,
      boot_disk,
      metadata
    ]
  }

}
