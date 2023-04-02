terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0.1"
    }
  }
  required_version = ">=0.13" /*Многострочный комментарий.
 Требуемая версия terraform */
}
provider "docker" {
  registry_auth {
    address = var.docker_address
    username = var.docker_username
    password = var.docker_password
  }
}
#однострочный комментарий

resource "random_password" "random_string" {
  length      = 16
  special     = false
  min_upper   = 1
  min_lower   = 1
  min_numeric = 1
}

resource "docker_image" "my_nginx" {
  name         = "nginx"
  keep_locally = true
}

resource "docker_container" "nginx_my" {
  image = docker_image.my_nginx.name
  #name  = "example_${random_password.random_string.result}"
  name  = "hello_world"
  ports {
    internal = 80
    external = 8000
  }
}
