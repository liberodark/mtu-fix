#!/bin/bash
#
# About: MTU Fix Debian
# Author: liberodark
# License: GNU GPLv3

version="1.0.0"

echo "Welcome on MTU Fix Install Script $version"

#=================================================
# CHECK ROOT
#=================================================

if [[ $(id -u) -ne 0 ]] ; then echo "Please run as root" ; exit 1 ; fi

#=================================================
# RETRIEVE ARGUMENTS FROM THE MANIFEST
#=================================================

app=mtu

#==============================================
# INSTALL NET-TOOLS
#==============================================

apt install -y net-tools
yum install -y net-tools

#==============================================
# INSTALL SERVICE
#==============================================
echo Install $app service

echo "
[Unit]
Description=$app
After=network.target

[Service]
WorkingDirectory=/sbin/
User=root
Group=users
Type=simple
UMask=000
ExecStart=/sbin/ifconfig eth0 mtu 1400
TimeoutSec=30
RestartSec=15s
Restart=always

[Install]
WantedBy=multi-user.target" > /etc/systemd/system/$app.service

#=================================================
# SETUP APP
#=================================================

echo Enable services
systemctl enable $app.service
systemctl start $app.service
