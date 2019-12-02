resource "google_compute_instance" "ubuntu" {
  project = var.project
  zone    = var.zone
  name    = "${var.prefix}-ubuntu"

  machine_type = "f1-micro"
  boot_disk {
    initialize_params {
      image = "ubuntu-1804-bionic-v20191113"
    }
  }
  metadata_startup_script = data.template_file.server_setup.rendered

  #  metadata_startup_script = <<-EOF
  #              #!/bin/bash
  #              apt-get update -y
  #              apt-get install -y docker.io
  #              docker run -d -p 80:80 --net=host --restart unless-stopped -e F5DEMO_APP=website -e F5DEMO_NODENAME='F5 GCP' -e F5DEMO_COLOR=ffd734 -e F5DEMO_NODENAME_SSL='F5 GCP (SSL)' -e F5DEMO_COLOR_SSL=a0bf37 chen23/f5-demo-app:ssl
  #              EOF

  network_interface {
    network    = google_compute_network.ext_network.name
    subnetwork = google_compute_subnetwork.ext_network_subnetwork.name
    access_config {
    }
  }
}

# Setup server_setup scripts
data "template_file" "server_setup" {
  template = file("${path.module}/templates/server_setup.tpl")

  vars = {
    rpassword = var.rpassword
  }
}

# Only stor the file for debugging
resource "local_file" "server_setup_file" {
  content  = data.template_file.server_setup.rendered
  filename = "${path.module}/tmp/server_setup.sh"
}

output "Public_IP_of_Server" {
  value = google_compute_instance.ubuntu.network_interface[0].access_config[0].nat_ip
}

