#!/bin/sh

# Install script to automate the whole install process.

STATE_FILE="/etc/config/install"

call_script() {
    script_path=$1
    if [ -f "$script_path" ]; then
        echo "Running script: $script_path"
        /bin/ash "$script_path"
    else
        echo "Error: script not found: $script_path"
        exit 1
    fi
}