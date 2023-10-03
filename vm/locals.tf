locals {
  ### Список имен групп серверов
  name_group_list = ["clickhouse", "vector", "lighthouse"]
  path_ansible = "/home/home/DevOps/Practice/devops-netology/Old_practice/Раздел_8/Practice_8.3/source"
  ### Указание количеств серверов в каждой группе
  count_clickhouse = 1
  count_vector = 1
  count_lighthouse = 1
  #SSH ключ
  ssh_key = file("~/.ssh/id_rsa.pub")
  private_key = file("~/.ssh/id_rsa")

  ### параметры (физическаие и типы ОС) групп серверов.
  server_settings = {
    clickhouse = {
      cpu   = 2
      ram   = 4
      core_fraction = 5
      image = "centos-7"
      #"ubuntu-2004-lts"
    },
    vector = {
      cpu   = 2
      ram   = 4
      core_fraction = 5
      image = "centos-7"
    },
    lighthouse = {
      cpu   = 2
      ram   = 4
      core_fraction = 5
      image = "centos-7"
    }
  }
}


