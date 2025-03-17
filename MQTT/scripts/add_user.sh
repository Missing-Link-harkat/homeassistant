#!/bin/sh

# Add user to MQTT auth

echo "Please enter username and password."

read -p "Username: " USERNAME

read -sp "Password: " PASSWORD
echo

PASSWORD_FILE="/mosquitto/config/mosquitto.passwd"

echo "Adding user '$USERNAME' to MQTT password file..."
docker exec -it mosquitto mosquitto_passwd -b ${PASSWORD_FILE} ${USERNAME} ${PASSWORD}

docker restart mosquitto