

resource "google_compute_network" "ext_network" {
  name                    = "${var.prefix}-network"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "ext_network_subnetwork" {
  name          = "${var.prefix}-subnetwork"
  region        = "${var.region}"
  network       = "${google_compute_network.ext_network.name}"
  ip_cidr_range = "10.1.81.0/24"
}


############ Firewall ######################


resource "google_compute_firewall" "web" {
  name    = "${var.prefix}-web-allow"
  network = "${google_compute_network.ext_network.name}"

  allow {
    protocol = "tcp"
    ports    = [ "443", "80", "8080", "1000-2000"]
  }

  source_ranges = ["0.0.0.0/0"]
}


resource "google_compute_firewall" "mgmt" {
  name    = "${var.prefix}-mgmt-allow"
  network = "${google_compute_network.ext_network.name}"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = [ "22", "8443", "4353"]
  }

  source_ranges = ["0.0.0.0/0"]
}

