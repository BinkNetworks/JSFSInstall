#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

#Print Welcome Message
printf "\033c"
echo "FreeSwitch Install Script for use with JeraSoft VCS"
echo ""
echo "This should be run on a fresh minimal install of Debian 8"
echo ""
echo "WARNING!!! This will delete all existing FreeSwitch Config!!!"
echo ""
echo "If you have existing config, please press CTRL-c and make a backup first"
echo ""
echo "Please enter a few details below to configure the system"
echo ""
#Get Auth Server Address
read -p "Enter the IP/FQDN of Jerasoft Auth Server:" auth

#Get Acct Server Address
read -p "Enter the IP/FQDN of JeraSoft Acct Server:" acct

#Get Radius Password
read -p "Enter the password for your Radius Server:" pass

#Get Redirect Server Address
read -p "Enter the IP/FQDN of JeraSoft ReDirect Server:" redirect

echo "Were about to install FreeSwitch, we can either use?"
echo "Master FreeSwitch branch, not recommended for production"
echo "V1.6 which is the current Stable/Production Branch"
echo ""
read -r -p "Install Master Branch? [y/N] " master

#Export Variables
export auth
export acct
export redirect
export pass
export master

# removes the cd img from the /etc/apt/sources.list file (not needed after base install)
sed -i '/cdrom:/d' /etc/apt/sources.list

#Update to latest packages
verbose "Update installed packages"
apt-get update && apt-get upgrade -y --force-yes

#Add dependencies
wget -O - https://files.freeswitch.org/repo/deb/debian/freeswitch_archive_g0.pub | apt-key add -
echo "deb http://files.freeswitch.org/repo/deb/freeswitch-1.6/ jessie main" > /etc/apt/sources.list.d/freeswitch.list
apt-get update
apt-get install -y --force-yes freeswitch-video-deps-most ntp

#Add Execute Permissions to other Scripts
chmod +x resources/*.sh

#IPTables
resources/iptables.sh

#sngrep
resources/sngrep.sh

#Freeswitch
resources/freeswitch.sh

#Fail2ban
resources/fail2ban.sh
