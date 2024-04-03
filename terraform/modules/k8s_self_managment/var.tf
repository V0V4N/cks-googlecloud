variable "region" {}
variable "prefix" {}
variable "tags_common" {
  type = map(string)
}
variable "USER_ID" {
  type    = string
  default = "defaultUser"
}
variable "ENV_ID" {
  type    = string
  default = "defaultId"
}
variable "app_name" {}
# k8_version    https://packages.cloud.google.com/apt/dists/kubernetes-xenial/main/binary-amd64/Packages
variable "cluster_name" { type = string }
variable "time_sleep" {
  default = "30s"
}
variable "ssh_password_enable" {
  default = "true"
}

variable "project" {
  default = "hazel-field-418402"
}

variable "k8s_master" {
  type = object({
    machine_type      = string
    ubuntu_version     = string
    user_data_template = string
    k8_version         = string
    runtime            = string
    runtime_script     = string
    utils_enable       = string
    pod_network_cidr   = string
    calico_url         = string
    task_script_url    = string # url for run additional script
    ssh = object({
      private_key = string
      pub_key     = string
    })
  })
}

variable "k8s_worker" {
  type = map(object({
    machine_type      = string
    ubuntu_version     = string
    user_data_template = string
    k8_version         = string
    runtime            = string
    runtime_script     = string
    task_script_url    = string # url for run additional script
    node_labels        = string
    ssh = object({
      private_key = string
      pub_key     = string
    })
  }))
}

variable "STACK_NAME" {
  type    = string
  default = ""
}

variable "STACK_TASK" {
  type    = string
  default = ""
}
