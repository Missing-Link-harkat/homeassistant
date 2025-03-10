#!/bin/sh

# Script to speed up SSL certificate creation for MQTT.

if ! command -v openssl &>/dev/null; then
    opkg update
    opkg install openssl-util


openssl genrsa -des3 -out root.key 2048
openssl req -new -x509 -key root.key -out root.csr
openssl x509 -req -days 365 -sha1 -extensions v3_ca -signkey root.key -in root.csr -out root.crt
