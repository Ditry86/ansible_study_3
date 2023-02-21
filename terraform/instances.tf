resource "yandex_compute_instance" "netology_ansible_03" {
  for_each = local.instances
  name = "${each.key}-01"
  platform_id = each.value.platform
  resources {
    cores  = each.value.cores
    memory = each.value.memory
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.centos7.id
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.ansible_03_subnet.id
    nat       = true
  }

  metadata = {
    ssh-keys = "yc-user:ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIF3lb1s6Z2aqQlzXz6iSx7M2R+BocMqLdql9iY5wWgdl ditry@home-pc"
  }
}
