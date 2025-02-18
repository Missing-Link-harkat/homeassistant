#!/bin/sh

# Install script to automate the whole install process (Test)

STATE_FILE="/etc/config/install_state"
SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Checks if step set, if set take it, if not create one with initial value
check_state() {
    if [ ! -f "$STATE_FILE" ]; then
        echo "Making STATE_FILE"
        echo "disk_resize" > "$STATE_FILE"
        # Make this script run on boot
        sed -i "/exit 0/i \\
        $SCRIPT_DIR/install.sh" /etc/rc.local
    fi
}

get_current_step() {
    if [ -f "$STATE_FILE" ]; then
        current_step=$(cat "$STATE_FILE")
        echo $current_step
    else
        echo "Could not read the file $STATE_FILE" >&2
        exit 1
    fi
}

set_install_step() {
    local next_step="$1"
    echo "Setting next step: $next_step"
    echo "$next_step" > "$STATE_FILE"
}

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

run_installation() {
    check_state

    current_step=$(get_current_step)
    echo $current_step
    case "$current_step" in 
        "disk_resize")
            set_install_step "docker_install"
            $SCRIPT_DIR/OpenWrt/disk_resize/disk_resize_setup.sh
            ;;
        "docker_install")
            set_install_step "haos_install"
            $SCRIPT_DIR/HAOS/haos_install.sh
            ;;
        "finish")
            sed -i "\|$SCRIPT_DIR/install.sh|d" /etc/rc.local
            ;;
    esac
}

run_installation