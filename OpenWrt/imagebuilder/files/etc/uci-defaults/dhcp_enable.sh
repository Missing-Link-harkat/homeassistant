cat << "EOF" > /etc/uci-defaults/99-custom
uci -q batch << EOI
set network.lan.proto="dhcp"
commit network
EOI
service network restart
EOF
