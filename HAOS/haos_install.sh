#!/bin/sh

opkg update
opkg install docker dockerd docker-compose

docker compose up -d