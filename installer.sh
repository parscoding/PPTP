# Created by Majid Abdollahi.
# Last modified : 2017-04-06
# Available on https://parscoding.github.io/pptp

#!/bin/bash -e

echo "Full PPTP Installer for CentOS 6.x"
read "Press any key to Start Installing..."

# Update CentOS and nano editor
echo "Updating CentOS..."
yum update & yum install nano

# change iptables settings for this operation
echo "Change iptables rules for PPTP Configurations..."
# ---------------------------------------------------------
# iptables example configuration script
# Flush all current rules from iptables
iptables -F
# Allow SSH connections on tcp port 22
# This is essential when working on remote servers via SSH to prevent locking yourself out of the system
 iptables -A INPUT -p tcp --dport 22 -j ACCEPT
#for pptpd
#----------------------------------------------------------
iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE
iptables -A INPUT -i eth0 -p tcp --dport 1723 -j ACCEPT
iptables -A INPUT -i eth0 -p gre -j ACCEPT
#----------------------------------------------------------
# Set default policies for INPUT, FORWARD and OUTPUT chains
iptables -P INPUT DROP
iptables -P FORWARD ACCEPT
iptables -P OUTPUT ACCEPT
# Set access for localhost
iptables -A INPUT -i lo -j ACCEPT
# Accept packets belonging to established and related connections
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
# Save settings
service iptables save
# List rules
# Restart iptables Service
service iptables restart
# make iptables service as startup
chkconfig iptables on
# ---------------------------------------------------------

# installing PPTPD
yum install -y pptpd

# 
