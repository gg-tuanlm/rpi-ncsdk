#!/bin/bash

echo ""
echo "Remove bloatware"
echo "(Wolfram Engine, Libre Office, Minecraft Pi, sonic-pi dillo gpicview penguinspuzzle oracle-java8-jdk openjdk-7-jre oracle-java7-jdk openjdk-8-jre)"
sudo apt-get remove --purge -y \
	wolfram-engine libreoffice* scratch* \
	minecraft-pi sonic-pi dillo gpicview \
    idle* vlc* libreoffice* \
	oracle-java8-jdk openjdk-7-jre oracle-java7-jdk openjdk-8-jre

## Remove old packages
#sudo apt-get --purge -y remove tk-dev
#sudo apt-get --purge -y remove libncurses5-dev libncursesw5-dev libreadline6-dev
#sudo apt-get --purge -y remove libdb5.3-dev libgdbm-dev libsqlite3-dev libssl-dev
#sudo apt-get --purge -y remove libbz2-dev libexpat1-dev liblzma-dev zlib1g-dev

# Autoremove
sudo apt-get autoremove -y

# Clean
sudo apt-get autoclean -y

# Update
sudo apt-get update
