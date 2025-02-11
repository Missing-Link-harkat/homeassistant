### OpenWrt memo:
#### OpenWRT 24.10 (ext 4 ver.)
#### SSH secure copy:
opkg update\
opkg install openssh-sftp-server
#### DHCP ENABLE:
uci set network.lan.proto="dhcp"\
uci commit network\
service network restart