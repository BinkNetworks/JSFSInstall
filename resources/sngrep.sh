#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

	#package install
	echo 'deb http://packages.irontec.com/debian jessie main' > /etc/apt/sources.list.d/sngrep.list
	wget http://packages.irontec.com/public.key -q -O - | apt-key add -
	apt-get update
	apt-get install -y --force-yes sngrep
