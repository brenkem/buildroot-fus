#!/bin/sh
# F&S X-Server touch configuration

tsconf_file=/var/run/tslib.conf

# If there is the configuration file, source it (see /etc/init.d/S40xorg).
# This makes ts_calibrate and ts_test work right away without the need to set
# anything manually
if [ -f $tsconf_file ]
then
	. $tsconf_file
fi
