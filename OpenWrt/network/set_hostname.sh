#!/bin/sh

# Sets hostname to device, hostname given as a parameter.

if [ -z "$1" ]; then
    echo "Usage: $0 <hostname>"
    exit 1
fi

NEW_HOSTNAME=$1

uci set system.@system[0].hostname=$NEW_HOSTNAME
uci commit system

/etc/init.d/network restart

echo "Hostname has been changed to $NEW_HOSTNAME"

reboot