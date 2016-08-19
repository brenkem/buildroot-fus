#!/bin/sh
# XServer setup to be run from /etc/profile.d
#
# Set XAUTHOROTY to a directory with write access. /var/run is a ramdisk
# and always writable, even if the rootfs is mounted read-only.

export DISPLAY=:0
export XAUTHORITY=/var/run/.Xauthority
