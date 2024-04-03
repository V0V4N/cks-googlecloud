resource "google_compute_instance" "master" {
  for_each      = toset(var.work_pc.node_type == "spot" ? ["enable"] : [])

  name         = "${local.prefix}-${var.app_name}"
  machine_type = var.k8s_master.machine_type
  zone         = var.region

  metadata = {
    ssh-keys = "ubuntu:${file("./gcp_instance_ssh_key.pub")}"
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

  tags     = local.tags_all_k8_master

  network_interface {
    network = "default"
    subnetwork = local.subnets[var.work_pc.subnet_number]

    access_config {
      // Ephemeral public IP
    }
  }

  disk {
    source_image      = "ubuntu-os-cloud/ubuntu-2004-lts"
    auto_delete       = true
    boot              = true
  }


  lifecycle {
    create_before_destroy = true
  }
}