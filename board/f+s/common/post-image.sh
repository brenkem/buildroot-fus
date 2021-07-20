#!/usr/bin/env bash

COMMON=board/f+s/common
OUTPUT=output/images

#
# dtb_list extracts the list of DTB files from BR2_LINUX_KERNEL_INTREE_DTS_NAME
# in ${BR_CONFIG}, then prints the corresponding list of file names for the
# genimage configuration file
#
dtb_list()
{
	local DTB_LIST="$(sed -n 's/^BR2_LINUX_KERNEL_INTREE_DTS_NAME="\([A-Z \+ | \. \+ | \/a-z0-9 \-]*\)"$/\1/p' ${BR2_CONFIG})"
	for dt in $DTB_LIST; do
		echo -n "\"`basename $dt`.dtb\", "
	done
}

#
# linux_image extracts the Linux image format from BR2_LINUX_KERNEL_UIMAGE in
# ${BR_CONFIG}, then prints the corresponding file name for the genimage
# configuration file
#
linux_image()
{
	if grep -Eq "^BR2_LINUX_KERNEL_UIMAGE=y$" ${BR2_CONFIG}; then
		echo "\"uImage\""
	elif grep -Eq "^BR2_LINUX_KERNEL_IMAGE=y$" ${BR2_CONFIG}; then
		echo "\"Image\""
	else
		echo "\"zImage\""
	fi
}

genimage_type()
{
	if grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX6UL=y$" ${BR2_CONFIG}; then
		echo "genimage.cfg.template.imx6ul.std"
	else
		echo "genimage.cfg.template"
	fi
}

geninstall_script()
{
	if grep -Eq "^BR2_aarch64=y$" ${BR2_CONFIG}; then
		MKIMAGE_ARCH=arm64
	else
		MKIMAGE_ARCH=arm
	fi
	$HOST_DIR/bin/mkimage -A $MKIMAGE_ARCH -O u-boot -T script -C none \
	    -n "F&S install script" -d ${COMMON}/install.txt $OUTPUT/install.scr
}

main()
{
	local FILES="$(dtb_list) $(linux_image)"
	local UBOOTBIN="uboot.nb0"
	local GENIMAGE_CFG="$(mktemp --suffix genimage.cfg)"
	local GENIMAGE_TMP="${BUILD_DIR}/genimage.tmp"

	sed -e "s/%FILES%/${FILES}/" \
		-e "s/%IMXOFFSET%/${IMXOFFSET}/" \
		-e "s/%UBOOTBIN%/${UBOOTBIN}/" \
		board/f+s/$2/$(genimage_type) > ${GENIMAGE_CFG}

	rm -rf "${GENIMAGE_TMP}"

	genimage \
		--rootpath "${TARGET_DIR}" \
		--tmppath "${GENIMAGE_TMP}" \
		--inputpath "${BINARIES_DIR}" \
		--outputpath "${BINARIES_DIR}" \
		--config "${GENIMAGE_CFG}"

	geninstall_script

	exit $?
}

main $@
