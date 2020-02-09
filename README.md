# terraform_bigip_gcp_multizone
BIG-IP multizone deployment over terraform with single nic and byol.



## Install Terraform

Run the following commands to download and install Terraform.

On Linux:

```
wget https://releases.hashicorp.com/terraform/0.12.20/terraform_0.12.20_linux_amd64.zip
unzip terraform_0.12.20_linux_amd64.zip
mv terraform ~/bin/
```
I prefer to move terraform in the user bin folder, like shown above. Feel free to install it in any bin folder listed in $PATH.

On Mac:

```
brew install terraform
```


## Set up your Google Cloud Platform working environment

Once we have our project, we can install and configure the Google Cloud SDK. The SDK provides the tools used to interact with the Google Cloud Platform REST API, they allow us to create and manage GCP resources from a command-line interface. Run the following commands to install and initialize it:

On Linux:

```
echo "deb https://packages.cloud.google.com/apt cloud-sdk main" | sudo tee -a /etc/apt/sources.list.d/google-cloud-sdk.list
curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo apt-get update && sudo apt-get install google-cloud-sdk
gcloud init
```

On Mac:

```
curl https://sdk.cloud.google.com | bash
exec -l $SHELL
gcloud init
```


Google Cloud offers an advanced permissions management system with Cloud Identity and Access Management (Cloud IAM). Terraform needs to be authorized to communicate with the Google Cloud API to create and manage resources in our GCP project. We achieve this by enabling the corresponding APIs and creating a service account with appropriate roles.

First, enable the Google Cloud APIs we will be using:

```
gcloud services enable compute.googleapis.com
gcloud services enable servicenetworking.googleapis.com
gcloud services enable cloudresourcemanager.googleapis.com
```
Then create a service account:

```
gcloud iam service-accounts create <service_account_name>
```
Here service_account_name is the name of our service account, it cannot contain spaces or fancy characters, you can name account-yourname for example.

Now we can grant the necessary roles for our service account to create a GKE cluster and the associated resources:

```
gcloud projects add-iam-policy-binding <project_name> --member serviceAccount:<service_account_name>@<project_name>.iam.gserviceaccount.com --role roles/compute.admin
```

Finally, we can create and download a key file that Terraform will use to authenticate as the service account against the Google Cloud Platform API:

```
gcloud iam service-accounts keys create terraform-gcp-keyfile.json --iam-account=<service_account_name>@<project_name>.iam.gserviceaccount.com
```
