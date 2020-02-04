#!/bin/bash
# Build install/update/recover scripts for CUBEA5
#

BOARD=board/f+s/fsvybrid
platform=cubea5
OUTPUT=output/images
script=install-$platform
rootfs=${OUTPUT}/rootfs.ubifs

MKIMAGE=mkimage
RM="/bin/rm -f"

if [ ! -f "$rootfs" ]
    then
    echo "$rootfs not found"
    exit
fi

recoverdec=$(stat -c "%s" "$rootfs")
recoversize=$(printf "%x" $recoverdec)

echo "Building install script, recoversize=0x$recoversize (=$recoverdec Bytes)"
sed -e "s/#recoversize#/$recoversize/" ${BOARD}/$script.txt \
    > ${OUTPUT}/$script.tmp
${MKIMAGE} -A arm -O u-boot -T script -C none -n "$platform install script" \
    -d ${OUTPUT}/$script.tmp ${OUTPUT}/$script.scr
${RM} ${OUTPUT}/$script.tmp
