#!/bin/bash

echo "Firmware configuration Tool"
config_file=/media/${USER}/boot/config.txt
etc_modules=/media/${USER}/rootfs/etc/modules

echo ""
read -p "Disable Wireless LAN? ([Y], n): " doit_disable_wl
read -p "Disable Bluetooth? ([Y], n): " doit_disable_bt
read -p "Disable Audio? ([Y], n): " doit_disable_audio
read -p "GPU memory in megabytes (defaults to 64): " gpu_mem
read -p "Enable camera with v4l2 driver bcm2835-v4l2 ([Y], n): " doit_camera

cat <<EOF >> $config_file

# author: Tuan Le
# project: aicampj
# reference: https://www.raspberrypi.org/documentation/configuration/config-txt/

EOF

if [[ "$doit_disable_wl" == "" || "$doit_disable_wl" == "y" || "$doit_disable_wl" == "Y" ]]; then
cat <<EOF >> $config_file

# Disable Wireless LAN
dtoverlay=pi3-disable-wifi
EOF
fi

if [[ "$doit_disable_bt" == "" || "$doit_disable_bt" == "y" || "$doit_disable_bt" == "Y" ]]; then
cat <<EOF >> $config_file

# Disable Bluetooth
dtoverlay=pi3-disable-bt
EOF
fi

if [[ "$doit_disable_audio" == "" || "$doit_disable_audio" == "y" || "$doit_disable_audio" == "Y" ]]; then
cat <<EOF >> $config_file

# Disable Audio
dtparam=audio=off
EOF
fi

if [[ "$doit_camera" == "" || "$doit_camera" == "y" || "$doit_camera" == "Y" ]]; then
cat <<EOF >> $etc_modules

# Camera with v4l2 driver
bcm2835-v4l2
EOF
fi

if [[ "$gpu_mem" == "" ]]; then
cat <<EOF >> $config_file

# GPU memory in megabytes
gpu_mem=64
EOF
else
cat <<EOF >> $config_file

# GPU memory in megabytes
gpu_mem=$gpu_mem
EOF
fi

echo "Done!"
