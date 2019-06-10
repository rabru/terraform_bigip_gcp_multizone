
resource "google_compute_instance" "bigip" {
  project = "${var.project}"
  zone    = "${lookup( var.bigip[count.index], "zone" )}"

  name = "${var.prefix}-bigip${count.index}"
  machine_type = "n1-standard-4"
  boot_disk {
    initialize_params {
      image = "https://www.googleapis.com/compute/v1/projects/f5-7626-networks-public/global/images/f5-byol-bigip-13-1-1-0-0-4-all-2slot"
    }
  }
  network_interface {
    network = "${google_compute_network.ext_network.name}"
    subnetwork = "${element(google_compute_subnetwork.ext_network_subnetwork.*.name, count.index)}"
     access_config {
    }
  }
  metadata_startup_script = "${data.template_file.modify_root.rendered}"

  provisioner "remote-exec" {
    script = "${local_file.vm_onboard_file.filename}"
    connection {
      type        = "ssh"
#      host        = "${element(google_compute_instance.bigip.*.network_interface.0.access_config.0.nat_ip, count.index)}"
      user        = "root"
      password    = "${var.rpassword}"
      private_key = "${file("${var.ssh_private_key}")}"
      timeout     = "10m"
    }
  }
  count                   = "${length(var.bigip)}"

}

# Setup root password scripts
data "template_file" "modify_root" {
  template = "${file("${path.module}/templates/modify_root.tpl")}"

  vars {
    rpassword             = "${var.rpassword}"
  }
}
# Only stor the file for debugging
resource "local_file" "modify_root_file" {
  content     = "${data.template_file.modify_root.rendered}"
  filename    = "${path.module}/tmp/modify_root.sh"
}


# Setup Onboarding scripts
data "template_file" "vm_onboard" {
  template = "${file("${path.module}/templates/onboard.tpl")}"

  vars {
    uname                 = "${var.uname}"
    upassword             = "${var.upassword}"
    DO_onboard_URL        = "${var.DO_onboard_URL}"
    AS3_URL               = "${var.AS3_URL}"
    restPort              = "${var.rest_port}"
    libs_dir              = "${var.libs_dir}"
    onboard_log           = "${var.onboard_log}"
  }
}
resource "local_file" "vm_onboard_file" {
  content     = "${data.template_file.vm_onboard.rendered}"
  filename    = "${path.module}/tmp/vm_onboard_file.sh"
}



### Declarative Onboarding ###

data "template_file" "DO_json" {

  template = "${file("${path.module}/templates/DO.tpl")}"
  vars {
    #Uncomment the following line for BYOL
    local_sku       = "${lookup( var.bigip[count.index], "license" )}"
    local_host      = "${var.bigip_host_name}${count.index}.${var.bigip_domain}"
    dns_server      = "${var.dns_server}"
    dns_search      = "${var.dns_search}"
    ntp_server      = "${var.ntp_server}"
    timezone        = "${var.timezone}"
  }
  count             = "${length(var.bigip)}"
}


resource "local_file" "DO_file" {
  content     = "${data.template_file.DO_json.*.rendered[count.index]}"
  filename    = "${path.module}/tmp/DO${count.index}.json"
  count       = "${length(var.bigip)}"
}


### REST call for Declarative Onboarding ###
resource "null_resource" "DO-run-REST" {

  triggers = {
    json_code = "${data.template_file.DO_json.*.rendered[count.index]}"
  }

  # Running DO REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
      sleep 30
      curl -k -X GET https://${element(google_compute_instance.bigip.*.network_interface.0.access_config.0.nat_ip, count.index)}:${var.rest_port}${var.rest_do_uri} \
              -u ${var.uname}:${var.upassword}
#      sleep 10
      curl -k -X ${var.rest_do_method} https://${element(google_compute_instance.bigip.*.network_interface.0.access_config.0.nat_ip, count.index)}:${var.rest_port}${var.rest_do_uri} \
              -u ${var.uname}:${var.upassword} \
              -d @${local_file.DO_file.*.filename[count.index]}
    EOF
  }
  count = "${length(var.bigip)}"
}

##### Output ######


output "Public IP of BIG-IP:" {
 value = "${google_compute_instance.bigip.*.network_interface.0.access_config.0.nat_ip}"
}


