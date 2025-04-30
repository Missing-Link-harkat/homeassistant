# MQTT
- spins up a docker container and opens needed ports
- Run mqtt_config.sh
## Configuration overview
- Opens ports 1883 and 8883
- Enables username and password authentication
- Creates SSL certificate for secure connections (ca.crt needed in client)
### Config
- Openssl installed in Docker container to prevent version mismatch between native OpenWrt package and Docker
- Initially spins up container with default settings to make sure the container spins up, then configures the rest.
