#!/bin/sh

# This script creates a wifi network on OpenWrt device.

# Get radio device name. (eg. 'radio0' on raspberry pi 4.)
get_radio_device() {
    radio_device=$(ubus call network.wireless status | grep -o '"radio[0-9]"' | tr -d '"')
    echo "$radio_device"
}

# Configure radio device settings
configure_radio() {

    if [ $# -lt 2 ]; then
        echo "Usage: $0 <country_code> <channel>"
        exit 1
    fi

    local country_code=$1
    local channel=$2

    radio_device=$(get_radio_device)

    if [ -z "$radio_device" ]; then
        echo "No radio device found!"
        exit 1
    fi

    uci set wireless."$radio_device".country="$country_code"
    uci set wireless."$radio_device".channel="$channel"
    uci set wireless."$radio_device".hwmode='11g'   #802.11g standard
    uci set wireless."$radio_device".htmode='HT20'  # Channel width (20Mhz)
    uci set wireless."$radio_device".band='2g'      # 2.4 Ghz band
    uci set wireless."$radio_device".disabled='0'   # 0 == enabled, 1 = disabled

    uci commit wireless
    wifi reload
}

# Sets up wifi-network with settings
create_wifi_network() {

    if [ $# -lt 3 ]; then
        echo "Usage: $0 <SSID> <password> <network_name>"
        exit 1
    fi

    local ssid=$1
    local password=$2
    local network_name=$3

    radio_device=$(get_radio_device)

    if [ -z "$radio_device" ]; then
        echo "No radio device found!"
        exit 1
    fi

# Remove default interface as that messess up the config
uci delete wireless.default_radio0
uci commit wireless

uci add wireless wifi-iface
uci rename wireless.@wifi-iface[-1]='openwrt_wifi'

uci set wireless.openwrt_wifi.device="$radio_device"    # Radio device to make network
uci set wireless.openwrt_wifi.network="$network_name"   # network to associate with (lan)
uci set wireless.openwrt_wifi.mode='ap'                 # Access point mode
uci set wireless.openwrt_wifi.ssid="$ssid"              # SSID of Wi-Fi
uci set wireless.openwrt_wifi.encryption='psk2'         # encryption
uci set wireless.openwrt_wifi.key="$password"           # Wi-Fi password


uci commit wireless
wifi reload
echo "Wi-Fi network '$ssid' created and added to '$network_name' interface."

}

SSID="OpenWRT"
PASSWORD="testpassword"
NETWORK_NAME="lan"
COUNTRY_CODE="FI"
CHANNEL="1"

configure_radio "$COUNTRY_CODE" "$CHANNEL"
create_wifi_network "$SSID" "$PASSWORD" "$NETWORK_NAME"