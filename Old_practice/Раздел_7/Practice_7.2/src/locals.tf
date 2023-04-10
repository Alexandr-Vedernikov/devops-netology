locals {
#  family_vm_db = "ubuntu-2004-lts"
#  name_vm_db = "netology-develop-platform-db"
#  planform_id_vm_db = "standard-v1"

#  family_vm_web = "ubuntu-2004-lts"
#  name_vm_web = "netology-develop-platform-web"
#  planform_id_vm_web= "standard-v1"

  vm_web = "${ var.vm_web_name }-${ var.vm_web_platform_id }"
  vm_db= "${ var.vm_db_name }-${ var.vm_db_platform_id }"
}

