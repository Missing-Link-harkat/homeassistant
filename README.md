# Homeassistant

Homeassistant automation system running on OpenWRT.

- OpenWRT 24.10 (ext 4)
- Home Assistant in Docker
- Mosquitto MQTT broker in docker

## Contents:

### api

- Python examples to interact with Home Assistant api
- (work in progress) start of a external logger tool 

### HAOS
- Install script for docker installation
- Install scripts for Home Assistant in docker
- Install script for HACS (Home Assistant Community Store)
- YAML examples for automation and MQTT sensor integration

### MQTT

- Install scripts for spinning up Mosquitto MQTT broker docker container

### OpenWrt

#### Scripts for configuring OpenWrt in various configurations
##### disk_resize
- scripts to resize the disk larger on running system
##### imagebuilder
-
##### network
- set_hostname changes the hostname of system
- setup_wifi configures wifi AP on device
- ssh_sftp_install installs package needed for ssh secure copy
