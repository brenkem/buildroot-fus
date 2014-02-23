#!/bin/bash
# Build install/update/recover scripts for CUBEA5
#

BOARD=board/f+s/fsvybrid
platform=cubea5
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
sed -e "s/#recoversize#/$recoversize/" ${BOARD}/install-$platform.txt \
    > ${BOARD}/install-$platform.tmp
${MKIMAGE} -A arm -O u-boot -T script -C none -n "$platform install script" \
    -d ${BOARD}/install-$platform.tmp install-$platform.scr
${RM} ${BOARD}/install-$platform.tmp
