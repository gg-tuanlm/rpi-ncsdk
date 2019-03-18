#!/bin/bash

# Do backup job
sudo cp /etc/dhcpcd.conf /etc/dhcpcd.conf.old

cat <<EOF | sudo tee /etc/dhcpcd.conf
# static ip for this pi
interface eth0
static ip_address=192.168.1.49/24
static routers=192.168.1.1
static domain_name_servers=192.168.1.1 8.8.8.8 8.8.4.4
EOF

# Reset dhcpd
sudo systemctl stop dhcpcd.service
sudo ip address flush dev eth0
sudo systemctl restart dhcpcd.service
