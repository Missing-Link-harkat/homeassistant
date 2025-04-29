#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ROOT_PART=/dev/mmcblk0p2

# Finalize disk resize
resize2fs $ROOT_PART

# Remove this script from running on boot
sed -i "\|$SCRIPT_DIR/disk_resize_finalize.sh|d" /etc/rc.local