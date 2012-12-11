#!/bin/sh 

tsconf_file=/var/run/tslib.conf

if [ -e $tsconf_file ]
then
	. $tsconf_file
fi
