networks_zone = {
  a = {
    name = "subnet-a"
    zone = "ru-central1-a"
    cidr = ["10.10.10.0/24"]
  }
  b = {
    name = "subnet-b"
    zone = "ru-central1-b"
    cidr = ["10.10.20.0/24"]
  }
  d = {
    name = "subnet-d"
    zone = "ru-central1-d"
    cidr = ["10.10.30.0/24"]
  }
}

vms = {
  vm1 = {
    zone          = "ru-central1-a"
    name          = "master"
    description   = "VM in zone A"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk_volume   = 10
    platform_id   = "standard-v3"
    subnet_key    = "a"
    preemptible   = true
  }
  vm2 = {
    zone          = "ru-central1-b"
    name          = "node1"
    description   = "VM in zone B"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk_volume   = 10
    platform_id   = "standard-v3"
    subnet_key    = "b"
    preemptible   = true
  }
  vm3 = {
    zone          = "ru-central1-d"
    name          = "node2"
    description   = "VM in zone D"
    cpu           = 2
    ram           = 2
    core_fraction = 20
    disk_volume   = 10
    platform_id   = "standard-v3"
    subnet_key    = "d"
    preemptible   = true
  }
}