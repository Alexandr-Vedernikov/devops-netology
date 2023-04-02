resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}


data "yandex_compute_image" "ubuntu" {
  #family = "ubuntu-2004-lts"
  #family = var.vm_web_family
  family = "${local.family_vm_web}"
}
resource "yandex_compute_instance" "platform" {
  #name        = "netology-develop-platform-web"
  #name        = var.vm_web_name
  name         = "${local.name_vm_web}"
  #platform_id = "standard-v1"
  #platform_id = var.vm_web_platform_id
  platform_id = "${local.planform_id_vm_web}"

  resources {
    #cores         = 2
    cores         =  tonumber(var.vm_web_resources.cores)
    #memory        = 1
    memory        = tonumber(var.vm_web_resources.memory)
    #core_fraction = 5
    core_fraction = tonumber(var.vm_web_resources.core_fraction)
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
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
