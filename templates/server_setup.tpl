#!/bin/bash

# Set root password
echo "root:${rpassword}" | chpasswd
usermod -s /bin/bash root

# Install docker
apt-get update -y
apt-get install -y docker.io
sleep 2
docker run -d -p 0.0.0.0:81:80 --restart unless-stopped -e F5DEMO_APP=website -e F5DEMO_NODENAME='F5 GCP Deployment' -e F5DEMO_COLOR=ffd734 -e F5DEMO_NODENAME_SSL='F5 GCP SSL Deployment' -e F5DEMO_COLOR_SSL=a0bf37 chen23/f5-demo-app:ssl
docker run -d -p 0.0.0.0:82:80 --restart unless-stopped -e F5DEMO_APP=website -e F5DEMO_NODENAME='F5 GCP Deployment' -e F5DEMO_COLOR=dfb714 -e F5DEMO_NODENAME_SSL='F5 GCP SSL Deployment' -e F5DEMO_COLOR_SSL=809f17 chen23/f5-demo-app:ssl

