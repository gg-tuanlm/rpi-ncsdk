echo ""
echo "************************************************************************"
read -p "Do you want to install Caffe? [y,[N]]: " doit_caffe
case $doit_caffe in
    y|Y)
        echo "Installing Caffe..."
        sudo tar -xvzf --directory=/opt/movidius/ ssd-caffe.tar.bz2
        sudo cp Makefile.config /opt/movidius/ssd-caffe/Makefile.config
        
        cd /opt/movidius/ssd-caffe
        make -j`nproc` all py
        echo 'export PYTHONPATH="${PYTHONPATH}:/opt/movidius/caffe/python"' >> /home/${USER}/.bashrc
        echo 'export PYTHONPATH="${PYTHONPATH}:/opt/movidius/caffe/python"' >> /home/${USER}/.profile
        echo "Caffe is now installed."
    ;;
    *)
    echo "Skip install Caffe"
    ;;
esac