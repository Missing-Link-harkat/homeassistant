### OpenWrt muistio:
#### OpenWRT 23.05 (EXT 4 ver.)
#### SSH secure copy:
opkg update\
opkg install openssh-sftp-server
#### DHCP ENABLE:
uci set network.lan.proto="dhcp"\
uci commit network\
service network restart