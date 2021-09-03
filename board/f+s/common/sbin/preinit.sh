#!/bin/busybox sh

/sbin/dynamic_overlay


# Boot the real thing.
exec /sbin/init
