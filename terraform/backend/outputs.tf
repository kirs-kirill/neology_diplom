output "ips" {
  value = {
    for name, vm in yandex_compute_instance.foreach_vms :
    name => vm.network_interface[0].nat_ip_address
  }
}