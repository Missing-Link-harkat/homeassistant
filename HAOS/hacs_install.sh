#!/bin/sh

# Installs homeassistant community store
# https://www.hacs.xyz/docs/use/download/download/#to-download-hacs

CONTAINER_NAME=homeassistant

docker exec -it $CONTAINER_NAME bash -c "wget -O - https://get.hacs.xyz | bash -"

reboot