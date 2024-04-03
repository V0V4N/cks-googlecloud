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

dependency "ssh-keys" {
  config_path = "../ssh-keys"
}

inputs = {
  region       = local.vars.locals.region3
  prefix       = "cluster9"
  tags_common  = local.vars.locals.tags
  app_name     = "k8s"
  cluster_name = "k8s9"
  ssh_password_enable =local.vars.locals.ssh_password_enable

  k8s_master = {
    k8_version         = local.vars.locals.k8_version
    runtime            = local.vars.locals.runtime # docker  , cri-o  , containerd ( need test it )
    runtime_script     = "template/runtime.sh"
    machine_type      = local.vars.locals.machine_type
    ubuntu_version     = local.vars.locals.ubuntu_version
    user_data_template = "template/master.sh"
    pod_network_cidr   = "10.0.0.0/16"
    utils_enable       = "true"
    task_script_url    = "https://raw.githubusercontent.com/ViktorUJ/cks/master/tasks/cks/mock/01/k8s-9/scripts/master.sh"
    calico_url         = "https://raw.githubusercontent.com/projectcalico/calico/v3.25.0/manifests/calico.yaml"
    ssh = {
      private_key = dependency.ssh-keys.outputs.private_key
      pub_key     = dependency.ssh-keys.outputs.pub_key
    }
  }
  k8s_worker = {


  }
}
