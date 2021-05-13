terraform {
  required_providers {
    docker = {
      source = "kreuzwerker/docker"
    }
  }
}

variable "postgres_password" {
  type = string
}

provider "docker" {}

resource "docker_image" "postgres" {
  name         = "postgres:latest"
  keep_locally = true
}

resource "docker_container" "postgres" {
  image = docker_image.postgres.latest
  name  = "postgres-backend"
  env = [
    "POSTGRES_PASSWORD=${var.postgres_password}"
  ]
  ports {
    internal = 5432
    external = 5432
    ip       = "127.0.0.1"
  }
}

output "container_ip" {
  value = docker_container.postgres.ip_address
}
