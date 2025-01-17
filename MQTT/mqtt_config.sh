#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

#Check if docker installed
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed..."

    ./HAOS/docker_install.sh
fi

# TODO:
# Needed firewall + etc. config to make the broker available.


# Launch container
docker-compose -f ./MQTT/mqttcompose.yml up -d