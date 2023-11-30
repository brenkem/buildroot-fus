#!/bin/bash

# If build out of tree use other output path
if [ -n $O ];then
	OUTPUT=$O/images
else
	OUTPUT=output/images
fi

if grep -Eq "^BR2_aarch64=y$" ${BR2_CONFIG}; then
	ARCH=arm64
else
	ARCH=arm
fi

MKIMAGE=mkimage
$MKIMAGE -V
echo "Arch: $ARCH"

install_src="$1"
echo "Scr TXT: $install_src"
filename=$(basename ${install_src} .txt)
install_bin="${OUTPUT}/${filename}.scr"
echo "Ouput file: $install_bin"
$MKIMAGE -A $ARCH -O u-boot -T script -C none -n "F&S $filename script" -d "$install_src" "$install_bin"

