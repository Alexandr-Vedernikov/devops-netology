resource "yandex_compute_disk" "virtual_disk" {
  count = 3
  name  = "virtual-disk-${count.index}"
  size  = 5
  type  = "network-hdd"
  zone  = var.default_zone
}


resource "yandex_compute_instance" "virtual_machine" {
  depends_on = [yandex_compute_instance.vm]
  name = "host-disk-storage"
  zone = var.default_zone
  #platform_id = var.default_platform_id
  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu-2004-lts.image_id
    }
  }

  dynamic "secondary_disk" {
    for_each = yandex_compute_disk.virtual_disk
    content {
      device_name = "disk-${secondary_disk.key}"
      disk_id     = yandex_compute_disk.virtual_disk[secondary_disk.key].id
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
    #security_group_ids = [yandex_vpc_security_group.example.id]
  }
  allow_stopping_for_update = true

}
