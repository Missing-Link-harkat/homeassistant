#!/bin/sh

# Required package for ssh secure copy to device

opkg update
opkg install openssh-sftp-server
