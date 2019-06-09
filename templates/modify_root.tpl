#!/bin/bash

# BIG-IPS ONBOARD SCRIPT

echo "Will change Password" > /tmp/pass.txt

echo "root:${rpassword}" | chpasswd
usermod -s /bin/bash root

cp /etc/passwd /tmp/pass2.txt

