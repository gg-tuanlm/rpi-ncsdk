#!/bin/bash

cur_dir=$(pwd)

echo ""
echo "************************ Please confirm *******************************"
echo " Installing NCSDK on Raspberry Pi may take a long time."
echo " You may skip some parts of the installation in which case some examples "
echo " may not work without modifications but the rest of the SDK will still "
echo " be functional. Select n to skip installation part or y to install it."
echo ""
echo "************************************************************************"
echo "Cleaning bloatwares"
sudo apt remove idle* vlc* libreoffice*

echo ""
echo "************************************************************************"
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo ""
echo "************************************************************************"
echo "Prerequisites..."
sudo apt install git vim htop byobu -y
echo "Install RNG-TOOLS to prevent SSL error"
sudo apt install rng-tools -y

echo ""
echo "************************************************************************"
echo "Increasing swap size"
# sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo mv /etc/dphys-swapfile /etc/dphys-swapfile.backup
echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile
sudo dphys-swapfile swapoff
sudo dphys-swapfile setup
sudo dphys-swapfile swapon
echo "Your swap size is now 2048M"

echo ""
echo "************************************************************************"
echo "Downloading ncsdk..."
NCSDK_VER=2.05.00.02
wget https://github.com/movidius/ncsdk/archive/v${NCSDK_VER}.tar.gz --prefix=ncsdk-${NCSDK_VER}
tar xvzf v${NCSDK_VER}.tar.gz
cd ncsdk-${NCSDK_VER}

echo ""
echo "************************************************************************"
echo "Updating both python-pip and python3-pip"
sudo -H -E python -m pip install --upgrade pip
sudo -H -E python3 -m pip install --upgrade pip

echo ""
echo "************************************************************************"
echo "Installing prequisite python packages using pre-built repository"
sudo -H -E python3 -m pip install -r requirements.txt

echo ""
echo "************************************************************************"
echo "Installing NCSDK..."
echo "Disable Caffe installation by default"
sed -i 's/INSTALL_CAFFE=yes/INSTALL_CAFFE=no/g' ./ncsdk.conf
make install

# Install Caffe
cd $cur_dir/bin/Caffe
. $cur_dir/bin/Caffe/install.sh

# Install OpenCV
cd $cur_dir/bin/OpenCV/cv2_3.4.3
. cd $cur_dir/bin/OpenCV/cv2_3.4.3/install.sh

# Install ZeroMQ
cd $cur_dir/
. $cur_dir/install_zmq.sh

echo ""
echo "************************************************************************"
echo "Cleaning up"
cd /home/${USER}
sudo rm -rf /home/${USER}/rpi-ncsdk
sudo rm -rf /home/${USER}/.cache/package
sudo rm -rf /root/.cache/pip
sudo apt autoremove --purge
sudo apt autoclean
sudo apt clean

echo ""
echo "************************************************************************"
echo "Swapoff"
read -p "Do you want to turn off system swap? [y,[N]]: " doit_swap
case $doit_swap in
    y|Y)
        # sudo sed -i 's/CONF_SWAPSIZE=2048/CONF_SWAPSIZE=0/g' /etc/dphys-swapfile
        sudo mv /etc/dphys-swapfile.backup /etc/dphys-swapfile;
        sudo dphys-swapfile setup;
        sudo dphys-swapfile swapoff;
        echo "Swap is now off"
    ;;
    *) echo "Keep current swap setting"
    ;;
esac

echo ""
echo "************************************************************************"
read -p "Do you want to turn off the system now? [y, [N]]: " doit_shutdown
case $doit_shutdown in
    y|Y)
        sudo shutdown now
    ;;
    *) echo "Done."
    ;;
esac
