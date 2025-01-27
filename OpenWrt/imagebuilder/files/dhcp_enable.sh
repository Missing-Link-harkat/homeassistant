#!/bin/sh

# Set lan interface act as DHCP client

uci set network.lan.proto="dhcp"
uci commit network
service network restart