resource "yandex_vpc_network" "diplom_network" {
  name      = "diplom-network"
  folder_id = var.folder_id
}

resource "yandex_vpc_subnet" "subnet" {
  for_each       = var.networks_zone
  name           = each.value.name
  zone           = each.value.zone
  v4_cidr_blocks = each.value.cidr
  network_id     = yandex_vpc_network.diplom_network.id
}
