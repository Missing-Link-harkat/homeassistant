#!/bin/sh

# Script to speed up SSL certificate creation for MQTT (inside docker container).


if ! command -v openssl &>/dev/null; then
    echo "openssl not found; can't continue"
    exit 1
fi

cd config/certs

echo "openssl genrsa -des3 -out ca.key 2048"
openssl genrsa -des3 -out ca.key 2048

echo "openssl req -new -x509 -days 1826 -key ca.key -out ca.crt"
openssl req -new -x509 -days 1826 -key ca.key -out ca.crt

echo "openssl genrsa -out server.key 2048"
openssl genrsa -out server.key 2048

echo "openssl req -new -out server.csr -key server.key"
openssl req -new -out server.csr -key server.key

echo "openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360"
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360
