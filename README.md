# missinglink
ICT-alan kehitysprojekti kurssin repo


### OpenWrt muistio:
#### SSH secure copy:
opkg update\
opkg install openssh-sftp-server
#### DHCP ENABLE:
uci set network.lan.proto="dhcp"\
uci commit network\
service network restart
### HomeAssistant api
### Access token
- pakollinen
