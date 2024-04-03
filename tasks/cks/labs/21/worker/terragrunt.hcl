include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../..//modules/work_pc/"

  extra_arguments "retry_lock" {
    commands  = get_terraform_commands_that_need_locking()
    arguments = ["-lock-timeout=20m"]
  }

}

inputs = {
  region      = local.vars.locals.region
  prefix      = local.vars.locals.prefix
  tags_common = local.vars.locals.tags
  app_name    = "k8s-worker"

  work_pc = {
    clusters_config    = {}
    machine_type      = local.vars.locals.machine_type_worker
    ubuntu_version     = local.vars.locals.ubuntu_version
    user_data_template = "template/worker.sh"
    util = {
      kubectl_version = local.vars.locals.k8_version
    }
    exam_time_minutes = "120"
    test_url          = ""
    task_script_url   = "https://raw.githubusercontent.com/ViktorUJ/cks/master/tasks/cks/labs/21/worker/files/worker.sh"
    ssh = {
      private_key = ""
      pub_key     = ""
    }
  }

}
