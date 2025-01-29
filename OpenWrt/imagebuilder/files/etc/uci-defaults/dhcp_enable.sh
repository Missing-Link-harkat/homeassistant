cat << "EOF" > /etc/uci-defaults/99-custom
uci -q batch << EOI
set network.lan.proto="dhcp"
EOI
EOF
