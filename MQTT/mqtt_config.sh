#!/bin/sh

# Spins up and configures MQTT

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Check if docker installed
if ! command -v docker &>/dev/null; then
    echo "Docker is not installed..."
    echo "Please install docker before proceeding."

    return 1
fi

# Port forward 1883
uci add firewall redirect
uci set firewall.@redirect[-1].name="Forward-MQTT-to-Docker-1883"
uci set firewall.@redirect[-1].src="wan"
uci set firewall.@redirect[-1].src_dport="1883"
uci set firewall.@redirect[-1].dest="lan"
uci set firewall.@redirect[-1].dest_port="1883"
uci set firewall.@redirect[-1].proto="tcp"
uci set firewall.@redirect[-1].target="DNAT"

# Port forward 8883
uci add firewall redirect
uci set firewall.@redirect[-1].name="Forward-MQTT-to-Docker-8883"
uci set firewall.@redirect[-1].src="wan"
uci set firewall.@redirect[-1].src_dport="8883"
uci set firewall.@redirect[-1].dest="lan"
uci set firewall.@redirect[-1].dest_port="8883"
uci set firewall.@redirect[-1].proto="tcp"
uci set firewall.@redirect[-1].target="DNAT"

uci commit firewall
/etc/init.d/firewall reload

# Build and launch container with minimal config
mkdir -p mosquitto/config/certs
cp mosquitto.conf ./mosquitto/config/mosquitto.conf
docker build --network host -t mosquitto_with_openssl .
docker-compose -f ./mqttcompose.yml up -d


#### Configure the container


# Configure username and password authentication

CONFIG_FILE="./mosquitto/config/mosquitto.conf"

# Setup credential authentication
sed -i '/^allow_anonymous true/s/^/#/' "$CONFIG_FILE"   # Comment out 'allow_anonymous true'
sed -i '/^#allow_anonymous false/s/^#//' "$CONFIG_FILE"  # Uncomment 'allow_anonymous false'
sed -i '/^#password_file \/mosquitto\/config\/mosquitto.passwd/s/^#//' "$CONFIG_FILE"  # Uncomment 'password_file'


# Setup initial test user
echo "Setting up initial user to MQTT, please enter user password:"
CONTAINER_NAME="mosquitto"
PASSWORD_FILE="/mosquitto/config/mosquitto.passwd"
INITIAL_USER="admin"

docker exec -it ${CONTAINER_NAME} sh -c "mosquitto_passwd -c ${PASSWORD_FILE} ${INITIAL_USER}"

# Make SSL/TLS cert

# Create certificates
cp scripts/create_cert.sh ./mosquitto/create_cert.sh
docker exec -it ${CONTAINER_NAME} sh ./create_cert.sh


# File paths for needed cert files
sed -i '/^#cafile /s/^#//' "$CONFIG_FILE"  # Uncomment '#cafile /mosquitto/config/certs/ca.crt'
sed -i '/^#certfile /s/^#//' "$CONFIG_FILE"  # Uncomment '#certfile /mosquitto/config/certs/server.crt'
sed -i '/^#keyfile /s/^#//' "$CONFIG_FILE"  # Uncomment '#keyfile /mosquitto/config/certs/server.key'


# Enable ACL

cp acl.conf ./mosquitto/config/acl.conf
sed -i '/^#acl_file /s/^#//' "$CONFIG_FILE"  # Uncomment '#acl_file /mosquitto/config/acl.conf'

# Restart container to apply changes
docker restart mosquitto