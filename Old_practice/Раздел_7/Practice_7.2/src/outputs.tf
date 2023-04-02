output external_ip_address_vm_web_name {
  value = "${var.vm_db_name} = ${yandex_compute_instance.platform.network_interface.0.nat_ip_address}"
}

output external_ip_address_vm_db_name {
  value = "${var.vm_db_name} = ${yandex_compute_instance.platform_db.network_interface.0.nat_ip_address}"
}