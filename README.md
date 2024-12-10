# missinglink
ICT-alan kehitysprojekti kurssin repo


### OpenWrt muistio:
#### OpenWRT 23.05 versio
#### SSH secure copy:
opkg update\
opkg install openssh-sftp-server
#### DHCP ENABLE:
uci set network.lan.proto="dhcp"\
uci commit network\
service network restart
### Home Assistant muistio:
### Access token
- pakollinen
- [API dokumentaatio](https://developers.home-assistant.io/docs/api/rest/)
