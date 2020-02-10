
module "ImpApp01" {
  source = "./modules/tier1LB"

# No capital letter in name!
  name   = "imp-app01"
  prefix = var.prefix
  region = var.region
#  instances = google_compute_instance.bigip.*.self_link
  instances = [google_compute_instance.bigip[0].self_link]
}

#provider "docker" {
#  host = "ssh://user@remote-host:22"
#}

#provider "docker" {
#
#  host = "ssh://${google_compute_instance.ubuntu.network_interface[0].access_config[0].nat_ip}:22"
##  private_key = file(var.ssh_private_key)
#
#}

#resource "docker_container" "f5server" {
#  image = docker_image.f5demo.latest
#  name = "f5-docker-demo"
#  must_run = true
#  publish_all_ports = true
#}

#resource "docker_image" "f5demo" {
#  name = "chen23/f5-demo-app:ssl"
#}


provider "bigip" {
#  address = google_compute_instance.bigip[count.index].network_interface.0.access_config.0.nat_ip
  address = "${google_compute_instance.bigip[0].network_interface.0.access_config.0.nat_ip}:8443"
  username = var.uname
  password = var.upassword
#  count = length(var.bigip)
}


resource "bigip_ltm_monitor" "monitor" {
  name = "/Common/terraform_monitor"
  parent = "/Common/http"
  send = "GET /\r\n"
  timeout = "76"
  interval = "25"
#  count = length(var.bigip)
}

resource "bigip_ltm_pool"  "pool" {
  name = "/Common/terraform-pool"
  load_balancing_mode = "round-robin"
  monitors = [bigip_ltm_monitor.monitor.name]
  allow_snat = "yes"
  allow_nat = "yes"
#  count = length(var.bigip)
}

resource "bigip_ltm_pool_attachment" "attach_node1" {
  pool = bigip_ltm_pool.pool.name
  node = "/Common/${google_compute_instance.ubuntu.network_interface[0].network_ip}:81"
#  count = length(var.bigip)
}

resource "bigip_ltm_pool_attachment" "attach_node2" {
  pool = bigip_ltm_pool.pool.name
  node = "/Common/${google_compute_instance.ubuntu.network_interface[0].network_ip}:82"
#  count = length(var.bigip)
}

resource "bigip_ltm_virtual_server" "http" {
  pool = bigip_ltm_pool.pool.name
  name = "/Common/terraform_vs_http"
  destination = module.ImpApp01.externIP
  port = 80
  source_address_translation = "automap"
#  count = length(var.bigip)
}



#### Output ####

output "ImpApp01" {
  value = module.ImpApp01.externIP
#  value = google_compute_forwarding_rule.App_04.ip_address
}

