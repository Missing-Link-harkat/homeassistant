#!/bin/bash

INIT_SCRIPT="/files/etc/init.d/network_setup"

if [ -f "$INIT_SCRIPT" ]; then
  # Create the symlink in /etc/rc.d/
  ln -s "$INIT_SCRIPT" /files/etc/rc.d/S99network-setup
  echo "Symlink created for your-script at /files/etc/rc.d/S99network-setup"
else
  echo "Init script not found at $INIT_SCRIPT"
  exit 1
fi