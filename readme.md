# Домашнее задание к занятию 7.4 "Продвинутые методы работы с Terraform"

---

## Задание 1

1) Возьмите из демонстрации к лекции готовый код для создания ВМ с помощью remote модуля.  
2) Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменные в блоке vars ={} . 
Воспользуйтесь примером. Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку!    
3) Добавьте в файл cloud-init.yml установку nginx.  
4) Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t.  

Решение:

2) Создайте 1 ВМ, используя данный модуль. В файле cloud-init.yml необходимо использовать переменные в блоке vars ={} . 
Воспользуйтесь примером. Обратите внимание, что ssh-authorized-keys принимает в себя список, а не строку!

````
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

data "template_file" "cloudinit" {
 template = file("./cloud-init.yml")
 vars = {
 ssh_key = local.ssh_key
 }
}
````

3) Добавьте в файл cloud-init.yml установку nginx. 

Содержание файла cloud-init.yml:

````
#cloud-config
users:
  - name: ubuntu
    groups: sudo
    shell: /bin/bash
    sudo: ['ALL=(ALL) NOPASSWD:ALL']
    ssh_authorized_keys:
      - ${ssh_key}
package_update: true
package_upgrade: false
packages:
    - nginx-full
````

4) Предоставьте скриншот подключения к консоли и вывод команды sudo nginx -t. 

![1.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.4%2F1.png)


## Задание 2

1) Напишите локальный модуль vpc, который будет создавать 2 ресурса: одну сеть и одну подсеть в зоне, объявленной 
при вызове модуля. например: ru-central1-a.
2) Модуль должен возвращать значения vpc.id и subnet.id
3) Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем.
4) Сгенерируйте документацию к модулю с помощью terraform-docs.

    Пример вызова:
````
module "vpc_dev" {
  source       = "./vpc"
  env_name     = "develop"
  zone = "ru-central1-a"
  cidr = "10.0.1.0/24"
}
````

Решение:

1) Напишите локальный модуль vpc, который будет создавать 2 ресурса: одну сеть и одну подсеть в зоне, объявленной 
при вызове модуля. например: ru-central1-a.

Содержание модуля ./vpc/main.tf:

````
terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">=0.13"
}

resource "yandex_vpc_network" "vpc" {
  name = var.vpc_name
}

resource "yandex_vpc_subnet" "subnet" {
  name           = var.subnet_name
  zone           = var.zone
  network_id     = yandex_vpc_network.vpc.id
  v4_cidr_blocks = [var.subnet_cidr_block]
}
````

2) Модуль должен возвращать значения vpc.id и subnet.id

````
output "vpc_id" {
  value = yandex_vpc_network.vpc.id
}

output "subnet_id" {
  value = yandex_vpc_subnet.subnet.id
}
````

3) Замените ресурсы yandex_vpc_network и yandex_vpc_subnet, созданным модулем.

````
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
````

4) Сгенерируйте документацию к модулю с помощью terraform-docs.

Для генерации документации модуля vpc.tf использовал terraform-docs запустив в docker.
Ниже приведена команда запуска докер контейнера:

````
home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src/vpc$ docker run --rm \
--volume "$(pwd):/terraform-docs" -u $(id -u) quay.io/terraform-docs/terraform-docs:0.16.0  \
markdown /terraform-docs > doc.md
````

В результате выполнения сгенерирован [doc.md](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.4%2Fsrc%2Fvpc%2Fdoc.md).   

<details><summary>Содержание сгенерированной документации к модулю vpc.tf</summary>

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=0.13 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_yandex"></a> [yandex](#provider\_yandex) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [yandex_vpc_network.vpc](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_network) | resource |
| [yandex_vpc_subnet.subnet](https://registry.terraform.io/providers/yandex-cloud/yandex/latest/docs/resources/vpc_subnet) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_subnet_cidr_block"></a> [subnet\_cidr\_block](#input\_subnet\_cidr\_block) | n/a | `string` | n/a | yes |
| <a name="input_subnet_name"></a> [subnet\_name](#input\_subnet\_name) | n/a | `string` | n/a | yes |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | n/a | `string` | n/a | yes |
| <a name="input_zone"></a> [zone](#input\_zone) | n/a | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_subnet_id"></a> [subnet\_id](#output\_subnet\_id) | n/a |
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | n/a |

</details>


## Задание 3

1) Выведите список ресурсов в стейте.  
2) Удалите из стейта модуль vpc.  
3) Импортируйте его обратно. Проверьте terraform plan - изменений быть не должно. Приложите список выполненных команд 
и вывод.  

Решение:

1) Выведите список ресурсов в стейте.   

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ terraform state list
data.template_file.cloudinit
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]
module.vpc.yandex_vpc_network.vpc
module.vpc.yandex_vpc_subnet.subnet

````

![3.1.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.4%2F3.1.png)


2) Удалите из стейта модуль vpc. 

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ terraform state list | \
grep 'module.vpc' | xargs terraform state rm
Removed module.vpc.yandex_vpc_network.vpc
Removed module.vpc.yandex_vpc_subnet.subnet
Successfully removed 2 resource instance(s).

(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ terraform state list
data.template_file.cloudinit
module.test-vm.data.yandex_compute_image.my_image
module.test-vm.yandex_compute_instance.vm[0]

````

![3.2.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.4%2F3.2.png)

3) Импортируйте его обратно. Проверьте terraform plan - изменений быть не должно. Приложите список выполненных команд 
и вывод.

Для импорта обратно в state удаленных ресурсов пришлось "перемотать" историю в консоли. Во время выполнения 
terraform apply выводился список создаваемых ресурсов и их id. Ниже кусок вывода:

````
module.vpc.yandex_vpc_network.vpc: Creation complete after 0s [id=enp3pjbnc6cbrmfretm0]
module.vpc.yandex_vpc_subnet.subnet: Creating...
module.vpc.yandex_vpc_subnet.subnet: Creation complete after 0s [id=e9bjnejqa3igibpeafva]
module.test-vm.yandex_compute_instance.vm[0]: Creating...
````

Для импорта ресурса сети воспользуемся командой terraform import 'module.vpc.yandex_vpc_network.vpc' enp3pjbnc6cbrmfretm0

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ terraform import 'module.vpc.yandex_vpc_network.vpc' enp3pjbnc6cbrmfretm0
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=2536a516b2daf5ad4b60733dcac2aca9b3a1c395528c3cb68cd92245a4d63865]
module.vpc.yandex_vpc_network.vpc: Importing from ID "enp3pjbnc6cbrmfretm0"...
module.vpc.yandex_vpc_network.vpc: Import prepared!
  Prepared yandex_vpc_network for import
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_network.vpc: Refreshing state... [id=enp3pjbnc6cbrmfretm0]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 1s [id=fd80f8mhk83hmvp10vh2]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
````

Для импорта ресурса подсети воспользуемся командой terraform import 'module.vpc.yandex_vpc_subnet.subnet' e9bjnejqa3igibpeafva

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ terraform import 'module.vpc.yandex_vpc_subnet.subnet' e9bjnejqa3igibpeafva
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=2536a516b2daf5ad4b60733dcac2aca9b3a1c395528c3cb68cd92245a4d63865]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_subnet.subnet: Importing from ID "e9bjnejqa3igibpeafva"...
module.vpc.yandex_vpc_subnet.subnet: Import prepared!
  Prepared yandex_vpc_subnet for import
module.vpc.yandex_vpc_subnet.subnet: Refreshing state... [id=e9bjnejqa3igibpeafva]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 0s [id=fd80f8mhk83hmvp10vh2]

Import successful!

The resources that were imported are shown above. These resources are now in
your Terraform state and will henceforth be managed by Terraform.
````

Проверяем инфраструктуру. terraform plan

````
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ terraform plan
data.template_file.cloudinit: Reading...
data.template_file.cloudinit: Read complete after 0s [id=2536a516b2daf5ad4b60733dcac2aca9b3a1c395528c3cb68cd92245a4d63865]
module.test-vm.data.yandex_compute_image.my_image: Reading...
module.vpc.yandex_vpc_network.vpc: Refreshing state... [id=enp3pjbnc6cbrmfretm0]
module.test-vm.data.yandex_compute_image.my_image: Read complete after 0s [id=fd80f8mhk83hmvp10vh2]
module.vpc.yandex_vpc_subnet.subnet: Refreshing state... [id=e9bjnejqa3igibpeafva]
module.test-vm.yandex_compute_instance.vm[0]: Refreshing state... [id=fhmpecn0bq2q8r57b6tb]

No changes. Your infrastructure matches the configuration.

Terraform has compared your real infrastructure against your configuration and found no differences, so no changes are needed.
(venv) home@home:~/DevOps/Practice/devops-netology/Old_practice/Раздел_7/Practice_7.4/src$ 

````

![3.3.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.4%2F3.3.png)