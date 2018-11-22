#!/bin/bash
echo "Install OpenCV from source"
read -n1 -p "Do you want to install OpenCV? [y,[N]]: " doit
case $doit in
    y|Y)
    wget https://raw.githubusercontent.com/movidius/ncappzoo/ncsdk2/apps/video_objects_threaded/install-opencv-from_source.sh;
    bash ./install-opencv-from_source.sh;;
    *) echo "Skip install OpenCV";;
esac