locals {
  region = "asia-east2-a"
  prefix = "cks-lab"
  tags = {
    "env_name"        = "cks-lab"
    "env_type"        = "dev"
    "manage"          = "terraform"
    "cost_allocation" = "dev"
    "owner"           = "viktoruj@gmail.com"
  }
  k8_version           = "1.28.0"
  node_type            = "spot"
  runtime              = "containerd" # docker  , cri-o  , containerd ( need test it )
  machine_type        = "e2-medium"
  machine_type_worker = "e2-medium"
  ubuntu_version       = "20.04"
}
