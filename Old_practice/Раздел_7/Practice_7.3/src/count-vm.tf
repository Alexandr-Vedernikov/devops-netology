locals {
  ssh_key_const_vm = file("~/.ssh/id_rsa.pub")
}

# Create virtual machines based on constant instance_configs
resource "yandex_compute_instance" "vm-const" {
  name        = "vm-const-${count.index}"
  platform_id = var.default_platform_id

  count = 2

  resources {
    cores  = var.vms_const.cpu
    memory = var.vms_const.ram
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type = "network-hdd"
      size = var.vms_const.disk
    }
  }

  metadata = {
    #ssh-keys = "ubuntu:${var.public_key}"
    ssh-keys_const_vm = "ubuntu:${local.ssh_key_const_vm}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}
