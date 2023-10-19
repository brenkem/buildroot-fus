#!/bin/bash

INSTALL_TXT_PATH=$1

if [ -z "$var" ];then
	INSTALL_TXT_PATH=board/f+s/common
fi

install_src="$INSTALL_TXT_PATH/install.txt"
OUTPUT=output/images
install_bin="$OUTPUT/install.scr"
MKIMAGE=mkimage

if grep -Eq "^BR2_aarch64=y$" ${BR2_CONFIG}; then
	ARCH=arm64
else
	ARCH=arm
fi

$MKIMAGE -V
echo $ARCH
$MKIMAGE -A $ARCH -O u-boot -T script -C none -n "F&S install script" -d "$install_src" "$install_bin"

install_src="$INSTALL_TXT_PATH/update_all.txt"
install_bin="$OUTPUT/update_all.scr"
$MKIMAGE -A $ARCH -O u-boot -T script -C none -n "F&S install script" -d "$install_src" "$install_bin"
