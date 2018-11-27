#! /bin/bash

echo ""
echo "************************ Please confirm *******************************"
echo " Installing OpenCV from source may take a long time. "
echo " Select n to skip OpenCV installation or y to install it." 
echo " Note that if you installed opencv via pip3 it will be uninstalled"
read -p " Continue installing OpenCV (y/n) ? " CONTINUE
if [[ "$CONTINUE" == "y" || "$CONTINUE" == "Y" ]]; then
	echo ""; 
	echo "Uninstalling pip installation";
	sudo pip3 uninstall opencv-contrib-python
	sudo pip3 uninstall opencv-python  
	echo "";
	echo "Installing OpenCV"; 
	echo "";
	sudo apt update -y
	sudo apt install -y libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
	sudo apt install -y libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
	sudo apt install -y libgstreamer1.0-dev libgstreamer-plugins-base1.0-dev
	sudo apt install -y libxvidcore-dev libx264-dev
	sudo apt install -y libgtk2.0-dev libgtk-3-dev
	sudo apt install -y libatlas-base-dev

    sudo tar --directory=/ -xvzf cv2.tar.bz2
    sudo ldconfig

    echo "OpenCV 3.4.3 is now installed."
else
	echo "";
	echo "Installation skipped.";
	echo "";
fi