data "yandex_compute_image" "lighthouse_image" {
  family = "${local.server_settings.lighthouse.image}"
}

resource "yandex_compute_instance" "group_vm_server_lighthouse" {
  count        = "${local.count_lighthouse}"
  name         = "${local.name_group_list[2]}-${count.index}"
  platform_id  = var.vm_server_platform_id

  resources {
    cores         = local.server_settings.lighthouse.cpu
    memory        = local.server_settings.lighthouse.ram
    core_fraction = local.server_settings.lighthouse.core_fraction
  }
  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.lighthouse_image.id
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
    serial-port-enable = 1
    ssh-keys           = "${var.default_user_name}:${local.ssh_key}"
  }
  connection {
    type        = "ssh"
    user        = var.default_user_name
    private_key = local.private_key
    host        = self.network_interface[0].nat_ip_address
  }
  provisioner "remote-exec" {
    inline = ["sudo yum install -y python3"]
  }
}

#data "template_file" "configlighthouse" {
# template = file("./config.yml")
# vars = {
# ssh_key = local.ssh_key
# }
#}