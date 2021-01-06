#!/bin/sh

#install packages
apt-get install -y git

#get the install script
cd /usr/src && git clone https://github.com/BinkNetworks/JSFSInstall
