#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Finalize disk resize
resize2fs /dev/mmcblk0p2

# Remove this script from running on boot
sed -i "\|$SCRIPT_DIR/resize_finalize.sh|d" /etc/rc.local