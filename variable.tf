# The related public key must be uploaded on Google Cloud Platform Console at Compute Engine -> Metadata -> SSH Keys: 
variable "ssh_private_key"  { default = "~/.ssh/gcp_rsa" }
# Create on Google Cloud Platform Console at IAM & admin -> Service accounts for your Service Account a new Key and store it as json: 
variable "gcp_credentials"  { default = "~/.gcp/f5-gcs-4261-sales-emea-dach.json" }

# USER Setup
variable "uname"            { default = "ralf" }
variable "upassword"        { default = "Demo-123" }
# Will set the root password to:
variable "rpassword"        { default = "Demo-123" }

# Project
variable "prefix"           { default = "multizone-demo" }
variable "project"          { default = "f5-gcs-4261-sales-emea-dach" }
variable "region"           { default = "europe-west3" }
variable "zone"             { default = "europe-west3-a" } 

#  [appendix, zone, license]
variable "bigip"            {
  type = "list"
  default = [
    {
      zone     = "europe-west3-c"
      license  = "CMYVL-ZSHOX-TITYW-PXYOH-CADWUXB"
    },
    {
      zone     = "europe-west3-b"
      license  = "ZEDTN-YPNUI-LRACL-LSMMI-YISUBLX"
    }
  ]
}

# BIGIP Setup
variable bigip_host_name      { default = "bigip"}
variable bigip_domain         { default = "example.com"}
variable dns_server           { default = "[ \"9.9.9.9\" ]" }
variable dns_search           { default = "[ \"f5.com\", \"example.com\" ]" }
variable ntp_server           { default = "[ \"0.pool.ntp.org\", \"1.pool.ntp.org\", \"2.pool.ntp.org\" ]" }
variable timezone             { default = "UTC" }


## Please check and update the latest DO URL from https://github.com/F5Networks/f5-declarative-onboarding/tree/master/dist
variable DO_onboard_URL       { default = "https://github.com/F5Networks/f5-declarative-onboarding/raw/master/dist/f5-declarative-onboarding-1.4.1-1.noarch.rpm" }
## Please check and update the latest AS3 URL from https://github.com/F5Networks/f5-appsvcs-extension/releases/latest
variable AS3_URL              { default = "https://github.com/F5Networks/f5-appsvcs-extension/raw/master/dist/lts/f5-appsvcs-3.5.1-5.noarch.rpm" }
variable libs_dir             { default = "/config/cloud/google/node_modules" }
variable onboard_log          { default = "/var/log/startup-script.log" }

# REST API Setting
variable rest_do_uri      { default  = "/mgmt/shared/declarative-onboarding" }
variable rest_as3_uri     { default = "/mgmt/shared/appsvcs/declare" }
variable rest_do_method   { default = "POST" }
variable rest_as3_method  { default = "POST" }
variable rest_port        { default = "8443" }


