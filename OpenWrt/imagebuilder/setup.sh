#!/bin/bash

# Ensure proper usage
if [ $# -lt 2 ]; then
    echo "Usage: $0 <path_to_openwrt_imagebuilder_tar_or_extracted> <profile>"
    exit 1
fi

TAR_PATH=$1
PROFILE=$2

# Extract imagebuilder

if [ -f $TAR_PATH ]; then
    echo "Extracting OpenWrt ImageBUilder from tar.gz..."
    tar -xvzf "$TAR_PATH" -C ./image
elif [ -d $TAR_PATH ]; then
    echo "Using existing extracted ImageBuilder from directory: $TAR_PATH"
    cp -r "$TAR_PATH" ./image
else
    echo "Invalid path for tar.gz or extracted OpenWrt ImageBuilder!"
    exit 1
fi

# Build image
cd ./image
make image PROFILE="$PROFILE" FILES="../files"

if [ $? -eq 0 ]; then
    echo "Build completed successfully!"
else
    echo "Build failed."
    exit 1
fi