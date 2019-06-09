
####  Application Deployment LB

resource "google_compute_forwarding_rule" "App_04" {
  name                  = "${var.prefix}-app04-frule"
  region                = "${var.region}"

  load_balancing_scheme = "EXTERNAL"
  target                = "${google_compute_target_pool.bigips.self_link}"
  port_range            = "80-8080"
  ip_protocol           = "TCP"

#  lifecycle {
#    ignore_changes = [ "google_compute_forwarding_rule.App_04.id" ]
#  }
}


resource "google_compute_target_pool" "bigips" {
  name = "${var.prefix}-bigip-pool"

  instances = [
     "${google_compute_instance.bigip.*.self_link}"
  ]
  health_checks = [
    "${google_compute_http_health_check.bigip.name}",
  ]
  session_affinity = "CLIENT_IP"
}

resource "google_compute_http_health_check" "bigip" {
  name               = "${var.prefix}-app04-health-check"
  timeout_sec        = 1
  check_interval_sec = 1
  port               = "80"
  request_path       = "/"
}


### AS3 ###


data "template_file" "App_04_json" {
  depends_on    = ["null_resource.DO-run-REST", "google_compute_forwarding_rule.App_04" ]
  template = "${file("${path.module}/AS3/App_04.tpl")}"

  vars {
    #Uncomment the following line for BYOL
    vip         = "${google_compute_forwarding_rule.App_04.ip_address}"
    zone        = "${lookup( var.bigip[count.index], "zone" )}"
  }
  count         = "${length(var.bigip)}"
}

resource "local_file" "App_04_file" {
  content     = "${element(data.template_file.App_04_json.*.rendered, count.index)}"
  filename    = "${path.module}/tmp/App_04-${count.index}.json"
  count       = "${length(var.bigip)}"
}


#data "template_file" "App_04_json" {
#  depends_on    = ["null_resource.DO-run-REST", "google_compute_forwarding_rule.App_04" ]
#  template = "${file("${path.module}/AS3/App_04.tpl")}"
#
#  vars {
#    #Uncomment the following line for BYOL
#    vip         = "${google_compute_forwarding_rule.App_04.ip_address}"
#    zone        = "${var.zone}"
#  }
#  count         = "${length(var.bigip)}"
#}
#
#
#resource "local_file" "App_04_file" {
#  content     = "${element( data.template_file.App_04_json.*.rendered, count.index )}"
#  filename    = "${path.module}/tmp/App_04.json"
#}


resource "null_resource" "App-run-REST" {
  depends_on = [ "local_file.App_04_file" ]
  # Running AS3 REST API
  provisioner "local-exec" {
    command = <<-EOF
      #!/bin/bash
#      sleep 15

      curl -k -X ${var.rest_as3_method} https://${element(google_compute_instance.bigip.*.network_interface.0.access_config.0.nat_ip, count.index)}:${var.rest_port}${var.rest_as3_uri} \
              -u ${var.uname}:${var.upassword} \
              -d @${element( local_file.App_04_file.*.filename, count.index) }

    EOF
  }
  count                   = "${length(var.bigip)}"
}



#### Output ####

output "App04 IP" {
 value = "${google_compute_forwarding_rule.App_04.ip_address}"
}

