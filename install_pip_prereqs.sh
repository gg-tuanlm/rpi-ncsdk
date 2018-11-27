#!/bin/bash

read -p "Do you want to install pip's prerequisites? [y,[N]]: " doit
case $doit in
	y|Y)
		sudo -H python3 -m pip install -r requirements.txt --index-url=https://www.piwheels.org/simple
	;;
	*)
		echo "Installation skipped."
	;;
esac
