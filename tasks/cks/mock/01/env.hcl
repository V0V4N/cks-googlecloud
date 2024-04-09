locals {
  questions_list = "https://github.com/ViktorUJ/cks/blob/master/tasks/cks/mock/01/README.MD"
  solutions_scripts="https://github.com/ViktorUJ/cks/tree/master/tasks/cks/mock/01/worker/files/solutions"
  solutions_video="https://youtu.be/I8CPwcGbrG8"
  debug_output   = "false"
  region         = "asia-east2-a"
  region2         = "asia-southeast1-a"
  region3         = "asia-southeast2-a"
  prefix         = "cks-mock"
  tags           = {
    "env_name"        = "cks-mock"
    "env_type"        = "dev"
    "manage"          = "terraform"
    "cost_allocation" = "dev"
    "owner"           = "viktoruj@gmail.com"
  }
  k8_version           = "1.29.0"
  runtime              = "containerd" # docker  , cri-o  , containerd ( need test it )
  machine_type        = "e2-medium"
  machine_type_worker = "e2-medium"
  ubuntu_version       = "20.04"
  ssh_password_enable  = "true" # false |  true
}
