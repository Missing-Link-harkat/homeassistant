#!/bin/sh

# Get radio device name. (eg. 'radio0' on raspberry pi 4.)
get_radio_device() {
    radio_device=$(ubus call network.wireless status | grep -o '"radio[0-9]"' | tr -d '"')
    echo "$radio_device"
}

create_wifi_network() {
    local ssid=$1
    local password=$2
    local network_name=$3

    radio_device=$(get_radio_device)

    if [ -z "$radio_device" ]; then
        echo "No radio device found!"
        exit 1
    fi

    cat <<EOF >> ./test
config wifi-iface '$radio_device'
    option device '$radio_device'     # Radio device to make network
    option network '$network_name'    # network to associate with (lan)
    option mode 'ap'                  # Access point mode
    option ssid '$ssid'               # SSID of Wi-Fi
    option encryption 'psk2'          # encryption
    option key '$password'            # Wi-Fi password
EOF

wifi reload
echo "Wi-Fi network '$ssid' created and added to '$network_name' interface."

}

SSID="OpenWRT"
PASSWORD="testpassword"
NETWORK_NAME="lan"


create_wifi_network "$SSID" "$PASSWORD" "$NETWORK_NAME"