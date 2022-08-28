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

#Get Freeswitch token from signalwire.com
read -p "Enter Auth Token from Signalwire.com:" TOKEN

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
export TOKEN

# removes the cd img from the /etc/apt/sources.list file (not needed after base install)
sed -i '/cdrom:/d' /etc/apt/sources.list

#Update to latest packages
echo "Update installed packages"
apt-get update && apt-get upgrade -y

#Add dependencies
apt-get update && apt-get install -yq gnupg2 wget lsb-release
 
wget --http-user=signalwire --http-password=$TOKEN -O /usr/share/keyrings/signalwire-freeswitch-repo.gpg https://freeswitch.signalwire.com/repo/deb/debian-release/signalwire-freeswitch-repo.gpg
echo "machine freeswitch.signalwire.com login signalwire password $TOKEN" > /etc/apt/auth.conf
echo "deb [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" > /etc/apt/sources.list.d/freeswitch.list
echo "deb-src [signed-by=/usr/share/keyrings/signalwire-freeswitch-repo.gpg] https://freeswitch.signalwire.com/repo/deb/debian-release/ `lsb_release -sc` main" >> /etc/apt/sources.list.d/freeswitch.list

apt-get update
apt-get -y build-dep freeswitch

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
