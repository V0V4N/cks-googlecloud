include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../..//modules/k8s_self_managment/"

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }

}

inputs = {
  region       = local.vars.locals.region
  prefix       = local.vars.locals.prefix
  tags_common  = local.vars.locals.tags
  app_name     = "k8s"
  cluster_name = "k8s1"
  k8s_master = {
    k8_version         = local.vars.locals.k8_version
    runtime            = "containerd" # docker  , cri-o  , containerd ( need test it )
    runtime_script     = "template/runtime.sh"
    machine_type      = local.vars.locals.machine_type
    ubuntu_version     = local.vars.locals.ubuntu_version
    user_data_template = "template/master.sh"
    pod_network_cidr   = "10.0.0.0/16"
    utils_enable       = "false"
    task_script_url    = "https://raw.githubusercontent.com/V0V4N/cks-googlecloud/gcloud-v2/tasks/cks/labs/03/k8s-1/scripts/master.sh"
    calico_url         = "https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml"
    ssh = {
      private_key = ""
      pub_key     = ""
    }
  }
  k8s_worker = {
  }
}
