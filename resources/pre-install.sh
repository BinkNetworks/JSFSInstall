#!/bin/sh

#upgrade the packages
apt-get update && apt-get upgrade -y --force-yes

#install packages
apt-get install -y --force-yes git

#get the install script
cd /usr/src && git clone https://github.com/BinkNetworks/JSFSInstall

#change the working directory
cd /usr/src/JSFSInstall
