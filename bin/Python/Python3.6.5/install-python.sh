# #!/bin/bash

echo ""
read -p "Do you want to install Python 3.6.5? [y,[N]]: " doit_python
case $doit_python in
	y|Y)

	echo ""
	echo "There are 2 options:"
	echo " - Build and install Python from source: (s)"
	echo " - Install prebuilt Python: (p)"
	read -p "Please enter 1 option: [s,[P]]: " CONTINUE
	if [[ "$CONTINUE" == "s" || "$CONTINUE" == "S" ]]; then
		echo "Installing Python 3.6.5 from source"
		wget https://www.python.org/ftp/python/3.6.5/Python-3.6.5.tar.xz
		tar xf Python-3.6.5.tar.xz
		cd Python-3.6.5
		./configure
		make -j4
		sudo make -j4 altinstall
	fi

	if [[ "$CONTINUE" == "p" || "$CONTINUE" == "P" ]]; then
		echo "Installing Python 3.6.5 from prebuilt package"
		tar -xvzf Python-3.6.5.tar.gz
		cd Python-3.6.5
		sudo make -j4 altinstall
	fi

	echo "Python 3.6.5 is now installed"
	;;
	*) echo "Installation skipped."
	;;
esac


