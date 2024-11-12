# Enable DHCP to get ip address from router

uci set network.lan.proto="dhcp"
uci commit network
service network restart