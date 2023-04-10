
resource "local_file" "hosts_cfg" {
  content = templatefile("${path.module}/hosts.tftpl",
    {
      webservers  = yandex_compute_instance.vm-const
      webservers1 = yandex_compute_instance.vm
    }
  )
  filename = "${abspath(path.module)}/hosts.cfg"
}
