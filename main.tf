
provider "google" {
#  credentials = "${file("~/.gcp/f5_GCS_4261_SALES_EMEA_DACH-88868ff46728.json")}"
  credentials = "${file("${var.gcp_credentials}")}"
  project = "${var.project}"
  region  = "${var.region}"
  zone    = "${var.zone}"
}



