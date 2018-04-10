#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#send a message
verbose "Installing Fail2ban"

#add the dependencies
apt-get install -y --force-yes fail2ban

#move the filters
cp freeswitch-ip.conf /etc/fail2ban/filter.d/freeswitch-ip.conf
cp jail.local /etc/fail2ban/jail.local

#restart fail2ban
/usr/sbin/service fail2ban restart
