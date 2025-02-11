#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"

# Make sure necessary packages are installed
opkg update
opkg install parted tune2fs resize2fs blkid

# Make disk_resize_finalize to run on reboot
sed -i "/exit 0/i \\
$SCRIPT_DIR/disk_resize_finalize.sh" /etc/rc.local

# Resize
parted --script /dev/mmcblk0 resizepart 2 100%

mount -o remount,ro /
tune2fs -O^resize_inode /dev/mmcblk0p2
fsck.ext4 -y /dev/mmcblk0p2

$SCRIPT_DIR/uuid_change.sh

reboot