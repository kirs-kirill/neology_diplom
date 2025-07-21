data "yandex_compute_image" "ubuntu" {
  family = var.family
}

resource "yandex_compute_instance" "foreach_vms" {
  for_each    = var.vms
  zone        = each.value.zone
  name        = each.value.name
  platform_id = each.value.platform_id
  description = each.value.description
  hostname    = each.value.name

  resources {
    cores         = each.value.cpu
    memory        = each.value.ram
    core_fraction = each.value.core_fraction
  }

  boot_disk {
    initialize_params {
      image_id = data.yandex_compute_image.ubuntu.image_id
      size     = each.value.disk_volume
    }
  }

  scheduling_policy {
    preemptible = each.value.preemptible
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.subnet[each.value.subnet_key].id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}