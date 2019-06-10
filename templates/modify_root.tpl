#!/bin/bash

# BIG-IPS ONBOARD SCRIPT

echo "root:${rpassword}" | chpasswd
usermod -s /bin/bash root

