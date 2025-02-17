#!/bin/bash

# Ensure proper usage
if [ $# -lt 2 ]; then
    echo "Usage: $0 <path_to_openwrt_imagebuilder_tar_or_extracted> <profile>"
    exit 1
fi

TAR_PATH=$1
PROFILE=$2
EXTRACTED_DIR=""
# Extract imagebuilder
if [ -f $TAR_PATH ]; then
    echo "Extracting OpenWrt ImageBUilder from tar.zst..."
    tar -I zstd -xvf "$TAR_PATH" -C ./image
    EXTRACTED_DIR=$(tar -I zstd -tf "$TAR_PATH" | head -n 1 | cut -f1 -d"/")
elif [ -d $TAR_PATH ]; then
    echo "Using existing extracted ImageBuilder from directory: $TAR_PATH"
    cp -r "$TAR_PATH" ./image
    EXTRACTED_DIR=$(basename "$TAR_PATH")
else
    echo "Invalid path for tar.gz or extracted OpenWrt ImageBuilder!"
    exit 1
fi

# Symlink setup scripts
./symlink.sh


# Build image
#EXTRACTED_DIR=$(tar -I zstd -tf "$TAR_PATH" | head -n 1 | cut -f1 -d"/")
cd ./image/$EXTRACTED_DIR/
make image PROFILE="$PROFILE" FILES="../../files"

if [ $? -eq 0 ]; then
    echo "Build completed successfully!"
else
    echo "Build failed."
    exit 1
fi