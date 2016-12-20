#!/bin/bash
# Build install/update/recover scripts for CubeA7UL/Cube2.0
#

BOARD=board/f+s/fsimx6
platform=cube
script=install-$platform

MKIMAGE=mkimage
RM="/bin/rm -f"

rootfs=output/images/rootfs.ubifs
if [ ! -f "$rootfs" ]
    then
    echo "$rootfs not found"
    exit
fi

recoverdec=$(stat -c "%s" "$rootfs")
recoversize=$(printf "%x" $recoverdec)

echo "Building install script, recoversize=0x$recoversize (=$recoverdec Bytes)"
sed -e "s/#recoversize#/$recoversize/" ${BOARD}/$script.txt \
    > ${BOARD}/$script.tmp
${MKIMAGE} -A arm -O u-boot -T script -C none -n "$platform install script" \
    -d ${BOARD}/$script.tmp $script.scr
${RM} ${BOARD}/$script.tmp
