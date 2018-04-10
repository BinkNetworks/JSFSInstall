#!/bin/sh

#move to script directory so all relative paths work
cd "$(dirname "$0")"

cp freeswitch.service /etc/systemd/system/freeswitch.service

cd /usr/src/
if [ $master = "y" ]; then
git clone https://freeswitch.org/stash/scm/fs/freeswitch.git freeswitch
else
git clone https://freeswitch.org/stash/scm/fs/freeswitch.git -bv1.6 freeswitch
fi

cd freeswitch

git config pull.rebase true

./bootstrap.sh -j

sed -i /usr/src/freeswitch/modules.conf -e s:'#xml_int/mod_xml_radius:xml_int/mod_xml_radius:'
sed -i /usr/src/freeswitch/modules.conf -e s:'#applications/mod_rad_auth:applications/mod_rad_auth:'

if [ $master = "y" ]; then
echo ""
else
sed -i /usr/src/freeswitch/src/mod/xml_int/mod_xml_radius/Makefile.am -e s:'RADCLIENT_VERSION=1.1.6:RADCLIENT_VERSION=1.1.7:'
sed -i /usr/src/freeswitch/src/mod/xml_int/mod_xml_radius/Makefile.in -e s:'RADCLIENT_VERSION = 1.1.6:RADCLIENT_VERSION = 1.1.7:'
sed -i /usr/src/freeswitch/src/mod/applications/mod_rad_auth/Makefile.am -e s:'RADCLIENT_VERSION=1.1.6:RADCLIENT_VERSION=1.1.7:'
sed -i /usr/src/freeswitch/src/mod/applications/mod_rad_auth/Makefile.in -e s:'RADCLIENT_VERSION = 1.1.6:RADCLIENT_VERSION = 1.1.7:'
fi

./configure

make
make install

rm -r /usr/local/freeswitch/conf

cd /usr/local/freeswitch
git clone https://github.com/BinkNetworks/JSFSConfig conf
sed -i "s/authserver/$auth/g" /usr/local/freeswitch/conf/vars.xml
sed -i "s/acctserver/$acct/g" /usr/local/freeswitch/conf/vars.xml
sed -i "s/redirectserver/$redirect/g" /usr/local/freeswitch/conf/vars.xml
sed -i "s/radpassword/$pass/g" /usr/local/freeswitch/conf/vars.xml

groupadd freeswitch
adduser --quiet --system --home /usr/local/freeswitch --gecos "FreeSWITCH open source softswitch" --ingroup freeswitch freeswitch --disabled-password
chown -R freeswitch:freeswitch /usr/local/freeswitch/
chmod -R ug=rwX,o= /usr/local/freeswitch/
chmod -R u=rwx,g=rx /usr/local/freeswitch/bin/*

systemctl daemon-reload
systemctl start freeswitch
systemctl enable freeswitch
