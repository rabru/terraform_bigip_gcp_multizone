
provider "google" {
  credentials = "${file("${var.gcp_credentials}")}"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}



