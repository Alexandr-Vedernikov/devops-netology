### Создание inventory файл для работы Ansible.
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      clickhouse  = yandex_compute_instance.group_vm_server_clickhouse
      vector      = yandex_compute_instance.group_vm_server_vector
      lighthouse  = yandex_compute_instance.group_vm_server_lighthouse
    }
  )
  filename = "../${path.module}/playbook/inventory/prod.yml"
}