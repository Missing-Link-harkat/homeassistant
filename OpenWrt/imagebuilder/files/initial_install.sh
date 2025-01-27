#!/bin/sh


# Enable DHCP client
./dhcp_enable.sh


# Clone the repo
git clone git@github.com:Missing-Link-harkat/homeassistant.git /root/

# Enlarge the partition
./disk_resize/disk_resize_setup.sh
