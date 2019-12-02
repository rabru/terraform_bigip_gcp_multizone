
resource "google_compute_forwarding_rule" "application" {
  name                  = "${var.prefix}-${var.name}-frule"
  region                = var.region

  load_balancing_scheme = "EXTERNAL"
  target                = google_compute_target_pool.bigips.self_link
  port_range            = "80-8080"
  ip_protocol           = "TCP"

}


resource "google_compute_target_pool" "bigips" {
  name = "${var.prefix}-${var.name}-bigip-pool"

  instances = var.instances
  health_checks = [
    "${google_compute_http_health_check.bigip.name}",
  ]
  session_affinity = "CLIENT_IP"
}

resource "google_compute_http_health_check" "bigip" {
  name               = "${var.prefix}-${var.name}-health-check"
  timeout_sec        = 1
  check_interval_sec = 1
  port               = "80"
  request_path       = "/"
}

output "externIP" {
  value = google_compute_forwarding_rule.application.ip_address
}

