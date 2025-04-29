#!/bin/sh

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
ROOT_DEV=/dev/mmcblk0
ROOT_PART=/dev/mmcblk0p2

# Make sure necessary packages are installed
opkg update
opkg install parted tune2fs resize2fs blkid

# Make disk_resize_finalize to run on reboot
sed -i "/exit 0/i \\
$SCRIPT_DIR/disk_resize_finalize.sh" /etc/rc.local

# Resize
parted --script $ROOT_DEV resizepart 2 100%

mount -o remount,ro /
tune2fs -O^resize_inode $ROOT_PART
fsck.ext4 -y $ROOT_PART

$SCRIPT_DIR/uuid_change.sh

reboot