###cloud vars
variable "docker_username" {
  type        = string
  description = "See in documentation for terraform provider"
}

variable "docker_password" {
  type        = string
  description = "See in documentation for terraform provider"
}

variable "docker_address" {
  type        = string
  #default     = "https://index.docker.io/v1"
  default     = "https://docker.io"
  description = "See in documentation for dockerhub"
}
