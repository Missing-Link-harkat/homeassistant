#!/bin/sh

# Changes mode to DHCP client

uci set network.lan.proto="dhcp"
uci commit network
service network restart