locals {
  ssh_key_varible_vm = file("~/.ssh/id_rsa.pub")
}

# Create virtual machines based on the instance_configs variable
resource "yandex_compute_instance" "vm" {
  depends_on = [yandex_compute_instance.vm-const]
  for_each = { for cfg in var.vms_varible : cfg.vm_name => cfg }

  name        = each.value.vm_name
  platform_id = var.default_platform_id

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
      type = "network-hdd"
      size = each.value.disk
    }
  }

  metadata = {
    #ssh-keys = "ubuntu:${var.public_key}"
    ssh-keys_varible_vm = "ubuntu:${local.ssh_key_varible_vm}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}