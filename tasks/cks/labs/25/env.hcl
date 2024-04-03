locals {
  region = "asia-east2-a"
  prefix = "cks-mock"
  tags = {
    "env_name"        = "cks-lab"
    "env_type"        = "dev"
    "manage"          = "terraform"
    "cost_allocation" = "dev"
    "owner"           = "viktoruj@gmail.com"
  }
  k8_version           = "1.28.0"
  runtime              = "containerd" # docker  , cri-o  , containerd ( need test it )
  machine_type        = "e2-medium"
  machine_type_worker = "e2-medium"
  ubuntu_version       = "20.04"
  ssh = {
    private_key = ""
    pub_key     = ""
  }
}
