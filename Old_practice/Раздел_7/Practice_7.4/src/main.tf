#resource "yandex_vpc_network" "develop" {
#  name = var.vpc_name
#}
#resource "yandex_vpc_subnet" "develop" {
#  name           = var.vpc_name
#  zone           = var.default_zone
#  network_id     = yandex_vpc_network.develop.id
#  v4_cidr_blocks = var.default_cidr
#}


module "vpc" {
  source = "./vpc"
  vpc_name = "test-vpc"
  subnet_name = "test-subnet"
  zone = var.default_zone
  subnet_cidr_block = var.default_cidr
}

module "test-vm" {
  source          = "git::https://github.com/udjin10/yandex_compute_instance.git?ref=main"
  env_name        = var.vpc_name
  network_id      = module.vpc.vpc_id
  subnet_zones    = [ var.default_zone ]
  subnet_ids      = [ module.vpc.subnet_id ]
  instance_name   = var.vm_web_name
  instance_count  = 1
  image_family    = "ubuntu-2004-lts"
  public_ip       = true

  metadata = {
      user-data          = data.template_file.cloudinit.rendered #Для демонстрации №3
      serial-port-enable = 1
  }
}

#Пример передачи cloud-config в ВМ для демонстрации №3
data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")
 vars = {
 ssh_key = local.ssh_key
 }
}
