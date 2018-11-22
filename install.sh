#!/bin/bash
echo "Clean bloatwares"
sudo apt remove idle* vlc*

echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo "Increase swap size"
sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo systemctl restart dphys-swapfile.service

echo "Downloading ncsdk..."
NCSDK_VER=v2.05.00.02
wget https://github.com/movidius/ncsdk/archive/${NCSDK_VER}.tar.gz
tar xvzf ${NCSDK_VER}.tar.gz
cd ncsdk-${NCSDK_VER}

# # disable install caffe by default
# sed -i 's/INSTALL_CAFFE=yes/INSTALL_CAFFE=no/g' ./ncsdk.conf

echo "Update both python-pip and python3-pip"
sudo -H -E python -m pip install --upgrade pip
sudo -H -E python3 -m pip install --upgrade pip

echo "Install prequisite python packages using pre-built repository"
sudo -H -E python3 -m pip install -r requirements.txt

echo "Installing NCSDK..."
make install

echo "Install OpenCV from source"
read -n1 -p "Do you want to install OpenCV? [y,[N]]: " doit_cv
case $doit_cv in
    y|Y)
    # wget https://raw.githubusercontent.com/movidius/ncappzoo/ncsdk2/apps/video_objects_threaded/install-opencv-from_source.sh;
    bash ./install-opencv-from_source.sh;
    echo "OpenCV installed.";;
    *) echo "Skip install OpenCV";;
esac

echo "Clean up"
sudo rm -rf /home/pi/.cache/package
sudo rm -rf /root/.cache/pip
sudo apt autoremove
sudo apt autoclean
sudo apt clean

# set swap off to decrease backup size
echo "Swapoff"
sudo sed -i 's/CONF_SWAPSIZE=2048/CONF_SWAPSIZE=0/g' /etc/dphys-swapfile
sudo dphys-swapfile swapoff

# shutdown for now
echo "Shutting down in next 30s..."
echo "Press Ctrl+C to stop"
sleep(30)
sudo shutdown now