#!/bin/sh

# Script to speed up SSL certificate creation for MQTT.

if ! command -v openssl &>/dev/null; then
    opkg update
    opkg install openssl-util
fi

mkdir -p certs
cd ./certs

echo "Generating the CA (certificate authority) certificate"

openssl genrsa -des3 -out ca.key 2048
openssl req -new -x509 -days 1826 -key ca.key -out ca.crt

echo "Generating server key pair"

echo "When filling out the form the common name is important and is usually the domain name of the server."

openssl genrsa -out server.key 2048
openssl req -new -out server.csr -key server.key
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360