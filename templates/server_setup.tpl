#!/bin/bash

# Set root password
echo "root:${rpassword}" | chpasswd
usermod -s /bin/bash root

# Install docker
apt-get update -y
apt-get install -y docker.io

