#!/bin/bash

# Backup current network interfaces
sudo mv /etc/network/interfaces /etc/network/interfaces.old

# Prepare new config for networking

cat <<EOF | sudo tee /etc/network/interfaces
auto eth0
iface eth0 inet static
	address 192.168.1.49
	netmask 255.255.255.0
	gateway 192.168.1.1
EOF

# Disable dhcpd
sudo service dhcpcd stop
sudo systemctl disable dhcpcd

# Enable networking service
sudo systemctl enable networking
sudo service networking stop

# Clear ip cache
sudo ifdown eth0
sudo ip address flush dev eth0

# Start networking service with new configuration
sudo ifup eth0
