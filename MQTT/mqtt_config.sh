#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Check if docker installed
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed..."
    echo "Please install docker before proceeding."

    return 1
fi


# Needed port forward for port 1883
uci add firewall redirect
uci set firewall.@redirect[-1].name="Forward-MQTT-to-Docker"
uci set firewall.@redirect[-1].src="wan"
uci set firewall.@redirect[-1].src_dport="1883"
uci set firewall.@redirect[-1].dest="lan"
uci set firewall.@redirect[-1].dest_port="1883"
uci set firewall.@redirect[-1].proto="tcp"
uci set firewall.@redirect[-1].target="DNAT"

uci commit firewall
/etc/init.d/firewall reload

mkdir -p ./mosquitto/config/
cp mosquitto.conf ./mosquitto/config/mosquitto.conf
# Launch container
docker-compose -f ./mqttcompose.yml up -d