###cloud vars
variable "token" {
  type        = string
  description = "OAuth-token; https://cloud.yandex.ru/docs/iam/concepts/authorization/oauth-token"
}

variable "cloud_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/cloud/get-id"
}

variable "folder_id" {
  type        = string
  description = "https://cloud.yandex.ru/docs/resource-manager/operations/folder/get-id"
}

variable "default_zone" {
  type        = string
  default     = "ru-central1-a"
  description = "https://cloud.yandex.ru/docs/overview/concepts/geo-scope"
}
variable "default_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24"]
  description = "https://cloud.yandex.ru/docs/vpc/operations/subnet-create"
}

variable "vpc_name" {
  type        = string
  default     = "develop"
  description = "VPC network & subnet name"
}

###ssh vars

#variable "vms_ssh_root_key" {
#  type        = string
#  default     = "(vms_ssh_root_key)"
#  description = "ssh-keygen -t ed25519"
#}
#
###vm_web vars

variable "vm_web_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Distribution name"
}
variable "vm_web_name" {
  type        = string
  default     = "netology-develop-platform-web"
  description = "Name VM"
}
variable "vm_web_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "The name of the platform that determines the configuration of computing resources"
}

###vm_db vars

variable "vm_db_family" {
  type        = string
  default     = "ubuntu-2004-lts"
  description = "Distribution name"
}
variable "vm_db_name" {
  type        = string
  default     = "netology-develop-platform-db"
  description = "Name VM"
}
variable "vm_db_platform_id" {
  type        = string
  default     = "standard-v1"
  description = "The name of the platform that determines the configuration of computing resources"
}

###resource vars

variable "vm_web_resources" {
  type = map
  default = {
    cores         = 2
    memory        = 1
    core_fraction = 5
  }
}

variable "vm_db_resources" {
  type = map
  default = {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }
}

variable "vm_metadate_resources" {
  type = map
  default = {
    serial-port-enable = 1
    #ssh-keys           = "home:$${vms_ssh_root_key}"
    ssh-keys           = "home:'$(var.vms_ssh_root_key)'"
  }
}
