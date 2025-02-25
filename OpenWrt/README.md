### OpenWrt memo:
#### OpenWRT 24.10 (ext 4 ver.)
#### SSH secure copy:
opkg update\
opkg install openssh-sftp-server
#### DHCP ENABLE:
uci set network.lan.proto="dhcp"\
uci commit network\
service network restart
### x86 install memo (initial)
- Get x86 image (etx 4)
- flash to usb stick etc.
- boot from usb and clone
``` 
dd if=/dev/sdb of=/dev/sda
```