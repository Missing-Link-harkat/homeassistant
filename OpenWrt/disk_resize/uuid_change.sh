#!/bin/sh

# Updates partition UUID to make system bootable
echo "Updating partition UUID"

ROOT_PARTUUID_BASE=$(blkid -s PARTUUID -o value /dev/mmcblk0p2 | cut -d '-' -f 1)

ROOT_PARTUUID_FULL=$(blkid -s PARTUUID -o value /dev/mmcblk0p2)

# Update values
echo "$ROOT_PARTUUID_BASE" > /boot/partuuid.txt

sed -i "s|root=PARTUUID=[^ ]*|root=PARTUUID=$ROOT_PARTUUID_FULL|" /boot/cmdline.txt

echo "Updated /boot/partuuid.txt with PARTUUID base: $ROOT_PARTUUID_BASE"
echo "Updated /boot/cmdline.txt with root=PARTUUID: $ROOT_PARTUUID_FULL"

