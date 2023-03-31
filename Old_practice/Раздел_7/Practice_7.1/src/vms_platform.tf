data "yandex_compute_image" "ubuntu_db" {
  #family = "ubuntu-2004-lts"
  #family = var.vm_db_family
  family = "${local.family_vm_db}"
}

resource "yandex_compute_instance" "platform_db" {
  #name        = "netology-develop-platform-db"
  #name        = var.vm_db_name
  name         = "${local.name_vm_db}"
  #platform_id = "standard-v1"
  #platform_id = var.vm_db_platform_id
  platform_id = "${local.planform_id_vm_db}"
  resources {
    #cores         = 2
    cores         = tonumber(var.vm_db_resources.cores)
    #memory        = 2
    memory        = tonumber(var.vm_db_resources.memory)
    #core_fraction = 20
    core_fraction = tonumber(var.vm_db_resources.core_fraction)
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu_db.image_id
    }
  }
  scheduling_policy {
    preemptible = true
  }
  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    #serial-port-enable = 1
    serial-port-enable = tonumber(var.vm_metadate_resources.serial-port-enable)
    #ssh-keys           = "home:${var.vms_ssh_root_key}"
    ssh-keys           = var.vm_metadate_resources.ssh-keys
  }
}
