#!/bin/bash

# Creates symlinks from files in files/etc/init.d to files/etc/rc.d

INIT_DIR="./files/etc/init.d"
RC_DIR="./files/etc/rc.d"

# Make sure directories exist
if [ ! -d "$INIT_DIR" ]; then
  echo "Init directory not found at $INIT_DIR"
  exit 1
fi
mkdir -p "$RC_DIR"

echo "Creating symlinks"
for INIT_SCRIPT in "$INIT_DIR"/*; do

  if [ -f "$INIT_SCRIPT" ]; then
    SCRIPT_NAME=$(basename "$INIT_SCRIPT")
    ln -sfv "$INIT_SCRIPT" "$RC_DIR/S99$SCRIPT_NAME"
  fi
done