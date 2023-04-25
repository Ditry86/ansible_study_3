resource "yandex_vpc_network" "netology_net" {
}

resource "yandex_vpc_subnet" "ansible_03_subnet" {
  name           = "ansible-03-lan"
  zone           = var.zone
  network_id     = yandex_vpc_network.netology_net.id
  v4_cidr_blocks = local.lans.default
}