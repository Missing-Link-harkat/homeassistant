#!/bin/sh
# Create new public and private keypair for ZeroTier identity, enabling predefined whitelist

if command -v zerotier-cli >/dev/null 2>&1; then
    echo "<command-name> is installed"
else
    echo "<command-name> is not installed"
fi
