#!/bin/bash
cur_dir=`pwd`

echo "Install libsodium"
if [[ ! -f libsodium-1.0.17.tar.gz ]]; then
	wget https://github.com/jedisct1/libsodium/releases/download/1.0.17/libsodium-1.0.17.tar.gz
	tar zxvf libsodium-1.0.17.tar.gz
fi

cd $cur_dir/libsodium-1.0.17/
./configure
make -j4
sudo make -j4 install

echo "Install ZeroMQ"
if [[ ! -f zeromq-4.1.4.tar.gz ]]; then
	wget https://archive.org/download/zeromq_4.1.4/zeromq-4.1.4.tar.gz
	tar zxvf zeromq-4.1.4.tar.gz
fi

cd $cur_dir/zeromq-4.1.4/
./configure
make -j4
sudo make -j4 install

echo "Install pyzmq"
sudo python3 -m pip install pyzmq
