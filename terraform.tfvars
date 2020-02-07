## Deployment Prefix (No capital letter in name!):
prefix = "multizone-demo"


####################### BIG-IP ################################

# BIG-IP deployments:

bigips = [
    {
      zone    = "a"
      license = "CVNFT-NVLMM-WIPUP-YXYNN-WIKUABN"
    },
    {
      zone     = "b"
      license  = "UTHCK-ISHUG-PAPEG-TDIIK-NUNBVDK"
#    },
#    {
#      zone     = "c"
#      license  = "TQHDR-RHCNC-LGOYM-CDWCO-KPNQMCW"
    }

  ]

# BiIG-IP Administrator user:
uname     = "ralf"
upassword = "Demo-123"
# BIG-IP root password:
rpassword = "Demo-123"

bigip_host_name = "bigip"
bigip_domain    = "f5demo.com"

## Resources for AS3 and DO
## Please validate if the links are working before start:
DO_onboard_URL = "https://github.com/F5Networks/f5-declarative-onboarding/releases/download/v1.8.0/f5-declarative-onboarding-1.8.0-2.noarch.rpm"
AS3_URL        = "https://github.com/F5Networks/f5-appsvcs-extension/releases/download/v3.13.1/f5-appsvcs-3.13.1-1.noarch.rpm"

#################### Provider Setup #############################

## Google Cloud Provider
# Create on Google Cloud Platform Console at IAM & admin -> Service accounts for your Service Account a new Key and store it as json:
gcp_credentials = "~/.gcp/f5-gcs-4261-sales-emea-dach.json"
region          = "europe-west3"
zone            = "europe-west3-a"

