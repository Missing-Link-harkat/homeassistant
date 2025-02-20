#!/bin/sh
# Create new public and private keypair for ZeroTier identity, enabling predefined whitelist

# Check if the ZeroTier is installed
if command -v zerotier-cli >/dev/null 2>&1; then
    echo "zerotier-cli is installed"
else
    echo "zerotier-cli is not installed"
fi


