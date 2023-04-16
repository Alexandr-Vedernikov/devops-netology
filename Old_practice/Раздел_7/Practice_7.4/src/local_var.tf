locals {
  ssh_user = "ubuntu"
  #description = "User name for VM_web"
}

locals {
  ssh_key = file("/home/home/.ssh/id_rsa.pub")
  #description = "Link in file public ssh key"
}
