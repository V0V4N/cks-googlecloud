resource "google_service_account" "default" {
  account_id   = "my-custom-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_compute_instance_template" "master" {
  for_each      = toset(var.work_pc.node_type == "spot" ? ["enable"] : [])

  name         = "${local.prefix}-${var.app_name}"
  machine_type = var.work_pc.machine_type
  zone         = var.region

  metadata = {
    ssh-keys = "ubuntu:${file("./gcp_instance_ssh_key.pub")}"
    startup-script = <<-EOF
    ${templatefile("template/boot_zip.sh", {
    boot_zip = base64gzip(templatefile(var.work_pc.user_data_template, {
      clusters_config     = join(" ", [for key, value in var.work_pc.clusters_config : "${key}=${value}"])
      kubectl_version     = var.work_pc.util.kubectl_version
      ssh_private_key     = var.work_pc.ssh.private_key
      ssh_pub_key         = var.work_pc.ssh.pub_key
      exam_time_minutes   = var.work_pc.exam_time_minutes
      test_url            = var.work_pc.test_url
      task_script_url     = var.work_pc.task_script_url
      ssh_password        = random_string.ssh.result
      ssh_password_enable = var.ssh_password_enable
      hosts               = local.hosts
    }))
    })}
    EOF
  }

  tags     = local.tags_all_k8_master

  network_interface {
    network = "default"

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