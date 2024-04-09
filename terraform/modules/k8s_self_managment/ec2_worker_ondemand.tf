resource "google_service_account" "worker" {
  account_id   = "${local.prefix}-${var.app_name}-worker-sa"
  display_name = "Custom SA for VM Instance"
}

resource "google_storage_bucket_iam_member" "worker" {
  bucket = var.s3_k8s_config
  role   = "roles/storage.admin"
  member = "serviceAccount:${google_service_account.worker.email}"
}

resource "google_compute_instance" "worker" {
  for_each     = local.k8s_worker
  name         = "${local.prefix}-${var.app_name}-worker"
  machine_type = each.value.machine_type
  zone         = var.region
  
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral public IP
    }
  }

  service_account {
    # Google recommends custom service accounts that have cloud-platform scope and permissions granted via IAM Roles.
    email  = google_service_account.worker.email
    scopes = ["cloud-platform"]
  }

  lifecycle {
    ignore_changes = [
      machine_type,
      boot_disk,
      metadata
    ]
  }

  metadata = {
    startup-script = <<-EOF
    ${templatefile("template/boot_zip.sh", {
    boot_zip = base64gzip(templatefile(each.value.user_data_template, {
      worker_join         = local.worker_join
      k8s_config          = local.k8s_config
      k8_version          = each.value.k8_version
      runtime             = each.value.runtime
      runtime_script      = file(each.value.runtime_script)
      task_script_url     = each.value.task_script_url
      node_name           = each.key
      node_labels         = each.value.node_labels
      ssh_private_key     = each.value.ssh.private_key
      ssh_pub_key         = each.value.ssh.pub_key
      ssh_password        = random_string.ssh.result
      ssh_password_enable = var.ssh_password_enable
    }))
    })}
    EOF
  }
}