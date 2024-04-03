include {
  path = find_in_parent_folders()
}

locals {
  vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
}

terraform {
  source = "../../..//modules/vpc/"
}

inputs = {
  region           = local.vars.locals.region
  prefix           = local.vars.locals.prefix
  tags_common      = local.vars.locals.tags
  app_name         = "network"

  }

}
