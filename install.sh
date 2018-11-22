#!/bin/bashecho ""

echo "************************ Please confirm *******************************"
echo " Installing NCSDK on Raspberry Pi may take a long time."
echo " You may skip some parts of the installation in which case some examples "
echo " may not work without modifications but the rest of the SDK will still "
echo " be functional. Select n to skip installation part or y to install it."
echo ""
echo "************************************************************************"
echo "Clean bloatwares"
sudo apt remove idle* vlc*

echo ""
echo "************************************************************************"
echo "Updating system..."
sudo apt update && sudo apt upgrade -y

echo ""
echo "************************************************************************"
echo "Increase swap size"
# sudo sed -i 's/CONF_SWAPSIZE=100/CONF_SWAPSIZE=2048/g' /etc/dphys-swapfile
sudo mv /etc/dphys-swapfile /etc/dphys-swapfile.backup
echo "CONF_SWAPSIZE=2048" > /etc/dphys-swapfile
sudo systemctl restart dphys-swapfile.service

echo ""
echo "************************************************************************"
echo "Downloading ncsdk..."
NCSDK_VER=2.05.00.02
wget https://github.com/movidius/ncsdk/archive/v${NCSDK_VER}.tar.gz --prefix=ncsdk-${NCSDK_VER}
tar xvzf v${NCSDK_VER}.tar.gz
cd ncsdk-${NCSDK_VER}

# # disable install caffe by default
# sed -i 's/INSTALL_CAFFE=yes/INSTALL_CAFFE=no/g' ./ncsdk.conf

echo ""
echo "************************************************************************"
echo "Update both python-pip and python3-pip"
sudo -H -E python -m pip install --upgrade pip
sudo -H -E python3 -m pip install --upgrade pip

echo ""
echo "************************************************************************"
echo "Install prequisite python packages using pre-built repository"
sudo -H -E python3 -m pip install -r requirements.txt

echo ""
echo "************************************************************************"
echo "Installing NCSDK..."
make install

echo ""
echo "************************************************************************"
echo "Install OpenCV from source"
read -n1 -p "Do you want to install OpenCV? [y,[N]]: " doit_cv
case $doit_cv in
    y|Y)
        # wget https://raw.githubusercontent.com/movidius/ncappzoo/ncsdk2/apps/video_objects_threaded/install-opencv-from_source.sh;
        bash ./install-opencv-from_source.sh;
        echo "OpenCV installed.";;
    *) echo "Skip install OpenCV";;
esac

echo ""
echo "************************************************************************"
echo "Clean up..."
sudo rm -rf /home/pi/.cache/package
sudo rm -rf /root/.cache/pip
sudo apt autoremove
sudo apt autoclean
sudo apt clean

# set swap off to decrease backup size
echo ""
echo "************************************************************************"
echo "Swapoff"
read -n1 -p "Do you want to turn off system swap? [y,[N]]: " doit_swap
case $doit_swap in
    y|Y)
        # sudo sed -i 's/CONF_SWAPSIZE=2048/CONF_SWAPSIZE=0/g' /etc/dphys-swapfile
        sudo mv /etc/dphys-swapfile.backup /etc/dphys-swapfile;
        sudo dphys-swapfile swapoff;;
    *) echo "Keep current swap setting";;
esac

echo ""
echo "************************************************************************"
read -n1 -p "Do you want to turn off the system now? [y, [N]]: " doit_shutdown
case $doit_shutdown in
    y|Y)
        sudo shutdown now;;
    *) echo "Done.";;
esac