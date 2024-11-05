#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Make sure necessary packages are installed
opkg update
opkg install parted tune2fs resize2fs

# Resize
parted /dev/mmcblk0p2 --script -- resizepart 2 32GB
mount -o remount,ro /
tune2fs -O^resize_inode /dev/mmcblk0p2
fsck.ext4 -y /dev/mmcblk0p2

# Set disk_resize_finalize to run on reboot to finalize disk resize




reboot