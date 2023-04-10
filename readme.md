# Домашнее задание к занятию 7.3 "Управляющие конструкции в коде Terraform"

---

## Задание 1

1) Изучите проект.  
2) Заполните файл personal.auto.tfvars  
3) Инициализируйте проект, выполните код (он выполнится даже если доступа к preview нет).  
Примечание: Если у вас не активирован preview доступ к функционалу "Группы безопасности" в Yandex Cloud - запросите 
доступ у поддержки облачного провайдера. Обычно его выдают в течении 24-х часов.  
Приложите скриншот входящих правил "Группы безопасности" в ЛК Yandex Cloud или скриншот отказа в предоставлении 
доступа к preview версии.    

Решение:

Получил доступ к группам безопасности. Заполнил файл с секретными персональными данными. Выполнил проект.  
Запустил проект. Скриншот ниже:  

![1.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.3%2F1.png)


## Задание 2

1) Создайте файл count-vm.tf. Опишите в нем создание двух одинаковых виртуальных машин с минимальными параметрами, 
используя мета-аргумент count loop.
2) Создайте файл for_each-vm.tf. Опишите в нем создание 2 разных по cpu/ram/disk виртуальных машин, используя 
мета-аргумент for_each loop. Используйте переменную типа list(object({ vm_name=string, cpu=number, ram=number, 
disk=number })). При желании внесите в переменную все возможные параметры.
3) ВМ из пункта 2.2 должны создаваться после создания ВМ из пункта 2.1.
4) Используйте функцию file в local переменной для считывания ключа ~/.ssh/id_rsa.pub и его последующего 
использования в блоке metadata, взятому из ДЗ №2.
5) Инициализируйте проект, выполните код.

Решение:

Для выполнения задания были созданы 2-а файла (count-vm.tf, for_each-vm.tf) и внесены доп-е блоки в файл variables.tf

<details><summary>Дополнения в файле variables.tf init</summary>

````
variable "vms_varible" {
  type = list(object({
    vm_name = string
    cpu     = number
    ram     = number
    disk    = number
  }))
  default = [
    {
      vm_name = "vm-1"
      cpu     = 2
      ram     = 2
      disk    = 10
    },
    {
      vm_name = "vm-2"
      cpu     = 4
      ram     = 4
      disk    = 15
    }
  ]
}
````
</details>

Ниже приведены тексты модулей (count-vm.tf, for_each-vm.tf) для создания ВМ.  

<details><summary>Модуль создания одинаковых ВМ, count-vm.tf init</summary>

````
locals {
  ssh_key_const_vm = file("~/.ssh/id_rsa.pub")
}

# Create virtual machines based on constant instance_configs
resource "yandex_compute_instance" "vm-const" {
  name        = "vm-const-${count.index}"
  platform_id = "standard-v1"

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
````
</details>


<details><summary>Модуль создания ВМ с различными параметрами, for_each-vm.tf init</summary>

````
locals {
  ssh_key_varible_vm = file("~/.ssh/id_rsa.pub")
}

# Create virtual machines based on the instance_configs variable
resource "yandex_compute_instance" "vm" {
  depends_on = [yandex_compute_instance.vm-const]
  for_each = { for cfg in var.vms_varible : cfg.vm_name => cfg }

  name        = each.value.vm_name
  platform_id = "standard-v1"

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
````
</details>

Ниже представлен скриншот из личного кабинета с запущенными ВМ с учетом очередности.

![2_final.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.3%2F2_final.png)

Ниже представлен скриншот выполнения команды terraform apply, показывающий очередность создания ВМ.  

![2.3_create.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.3%2F2.3_create.png)


## Задание 3

1) Создайте 3 одинаковых виртуальных диска, размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count.  
2) Создайте одну любую ВМ. Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения 
созданных вами дополнительных дисков.  
3) Назначьте ВМ созданную в 1-м задании группу безопасности.  

Решение:

1) Создайте 3 одинаковых виртуальных диска, размером 1 Гб с помощью ресурса yandex_compute_disk и мета-аргумента count.

````
resource "yandex_compute_disk" "virtual_disk" {
  count = 3
  name  = "virtual-disk-${count.index}"
  size  = 5
  type  = "network-hdd"
  zone  = var.default_zone
}
````

2) Создайте одну любую ВМ. Используйте блок dynamic secondary_disk{..} и мета-аргумент for_each для подключения 
созданных вами дополнительных дисков.
3) Назначьте ВМ созданную в 1-м задании группу безопасности.  

<details><summary>Модуль создания ВМ с применением гр. безопасности и подключении дисков </summary>

````
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
    ssh-keys_varible_vm = "ubuntu:${local.ssh_key_varible_vm}"
  }

  scheduling_policy { preemptible = true }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }
  allow_stopping_for_update = true
}

````
</details>

Ниже скриншот успешного запуска проекта с применением в ВМ правил безопасности и подключение 3-х дисков.

![3_all.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.3%2F3_all.png)


## Задание 4

1) Создайте inventory-файл для ansible. Используйте функцию tepmplatefile и файл-шаблон для создания 
ansible inventory-файла из лекции. Готовый код возьмите из демонстрации к лекции demonstration2. Передайте в него 
в качестве переменных имена и внешние ip-адреса ВМ из задания 2.1 и 2.2.  
2) Выполните код. Приложите скриншот получившегося файла.  
Для общего зачета создайте в вашем GitHub репозитории новую ветку terraform-03. Закомитьте в эту ветку свой 
финальный код проекта, пришлите ссылку на коммит.  
Удалите все созданные ресурсы.  

Решение:



<details><summary>Модуль создания c функцией tepmplatefile для создания inventory-файла.</summary>

````
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers  = yandex_compute_instance.vm-const
      webservers1 = yandex_compute_instance.vm
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}
````
</details>

<details><summary>Файл-шаблон для создания ansible inventory-файла.</summary>

````
[webservers]

%{~ for i in webservers ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} 
%{~ endfor ~}

%{~ for i in webservers1 ~}

${i["name"]}   ansible_host=${i["network_interface"][0]["nat_ip_address"]} 
%{~ endfor ~}
````
</details>

Скриншот созданного файла, после выполнения кода проекта.

![4_all.png](Old_practice%2F%D0%A0%D0%B0%D0%B7%D0%B4%D0%B5%D0%BB_7%2FPractice_7.3%2F4_all.png)