variable "region" {}
variable "prefix" {}
variable "USER_ID" {
  type    = string
  default = "defaultUser"
}
variable "ENV_ID" {
  type    = string
  default = "defaultId"
}
variable "tags_common" {
  type = map(string)
}
variable "app_name" {}
variable "time_sleep" {
  default = "30s"
}
variable "aws_eks_cluster_eks_cluster_arn" {
  default = ""
}
variable "ssh_password_enable" {
  default = "true"
}
variable "debug_output" {
  default = "false" # false | true
}
variable "questions_list" {
  default = ""
}

variable "solutions_scripts" {
  default = ""
}

variable "solutions_video" {
  default = ""
}

variable "project" {
  default = "hazel-field-418402"
}

variable "work_pc" {
  type = object({
    clusters_config    = map(string)
    machine_type      = string
    ubuntu_version     = string
    user_data_template = string
    task_script_url    = string # url for run additional script
    test_url          = string
    exam_time_minutes = string
    ssh = object({
      private_key = string
      pub_key     = string
    })
    util = object({
      kubectl_version = string
    })
  })
}

variable "STACK_NAME" {
  type    = string
  default = ""
}

variable "STACK_TASK" {
  type    = string
  default = ""
}

variable "host_list" {
  type    = list(string)
  default = []
}
