#!/bin/sh

if [ $# -lt 2 ]; then
    echo "Usage: $0 <Zerotier network id> <Whitelisted UUID from zerotier>"
    exit 1
fi

NETWORK_ID=$1
UUID=$2

opkg update
opkg install zerotier

# Configure ZeroTier
uci set zerotier.global.enabled='1'
uci delete zerotier.earth
uci set zerotier.zerotier=network
uci set zerotier.zerotier.id=$NETWORK_ID
uci commit zerotier
service zerotier restart

# Add and configure firewall zone for ZeroTier in order to access device etc. through the network
uci add firewall zone
uci set firewall.@zone[-1].name='zerotier'
uci set firewall.@zone[-1].input='ACCEPT'
uci set firewall.@zone[-1].forward='REJECT'
uci set firewall.@zone[-1].output='ACCEPT'
uci set firewall.@zone[-1].device='zt+'
uci set firewall.@zone[-1].masq='1'
uci set firewall.@zone[-1].mtu_fix='1'

# Set up forwarding between LAN and ZeroTier
uci add firewall forwarding
uci set firewall.@forwarding[-1].src='lan'
uci set firewall.@forwarding[-1].dest='zerotier'

uci add firewall forwarding
uci set firewall.@forwarding[-1].src='zerotier'
uci set firewall.@forwarding[-1].dest='lan'

uci commit firewall
/etc/init.d/zerotier restart
/etc/init.d/firewall restart