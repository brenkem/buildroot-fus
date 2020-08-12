#!/usr/bin/env bash

main ()
{
    # uboot device tree
    UBOOT_DTB=$2
    # boot device can be currently sd or nand
    BOOT_DEVICE=$3
    # enable hdmi firmware yes or no
    ENABLE_HDMI_FW=$4
    # default skip value to create a uboot without spl
    SKIP=351
    PLATFORM=$5
    RAMFS=$6

    # copy mkimage to output/images directory
    cp  ${HOST_DIR}/bin/mkimage ${BINARIES_DIR}

    if [ ! -e "$UBOOT_DTB" ]; then
        echo "ERROR: couldn't find dtb: $UBOOT_DTB"
        exit 1
    fi

    if [ "$BOOT_DEVICE" == "nand" ]; then
        # TODO: mkimage does create nand images with other offset as sd, mmc...
        # But sd card image does work for nand too.
        # echo "Booting from NAND..."
        # SDPU: write -f fsimx8m(m)-boot-nand(sd).bin -offset 0x5fc00
        # SKIP=383

        # Use SD card image setting...
        SKIP=351
        BOOT_DEVICE=sd
    elif [ "$BOOT_DEVICE" == "sd" ]; then
        # echo "Booting from SD..."
        # SDPU: write -f imx8-boot-nand.bin -offset 0x57c00
        SKIP=351
    else
        BOOT_DEVICE=nand
        echo "Default booting from NAND..."
    fi

    if grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8M=y$" ${BR2_CONFIG}; then
        # check for signed hdmi image
        if [ "$ENABLE_HDMI_FW" == "yes" ]; then
            # SDPU: write -f fsimx8m(m)-boot-nand(sd).bin -offset 0x5c000
            SKIP=368
            ENABLE_HDMI_FW="-signed_hdmi ${BINARIES_DIR}/signed_hdmi_imx8m.bin"
        fi
        cat ${BINARIES_DIR}/u-boot-spl.bin ${BINARIES_DIR}/lpddr4_pmu_train_fw.bin > ${BINARIES_DIR}/u-boot-spl-ddr.bin
        BL31=${BINARIES_DIR}/bl31.bin BL33=${BINARIES_DIR}/u-boot.bin ATF_LOAD_ADDR=0x00910000 \
	    ${HOST_DIR}/bin/mkimage_fit_atf.sh ${UBOOT_DTB} > ${BINARIES_DIR}/u-boot.its

        ${HOST_DIR}/bin/mkimage -E -p 0x3000 -f ${BINARIES_DIR}/u-boot.its ${BINARIES_DIR}/u-boot.itb
        rm -f ${BINARIES_DIR}/u-boot.its

        # TODO: Use param. 3 to create u-boot because of sd card image offsets.
        ${HOST_DIR}/bin/mkimage_imx8 -dev ${BOOT_DEVICE} -fit ${ENABLE_HDMI_FW} -loader ${BINARIES_DIR}/u-boot-spl-ddr.bin 0x7E1000 \
		   -second_loader ${BINARIES_DIR}/u-boot.itb 0x40200000 0x60000 -out ${BINARIES_DIR}/uboot-${PLATFORM}-$3.bin

        dd if=${BINARIES_DIR}/uboot-${PLATFORM}-$3.bin of=${BINARIES_DIR}/u-boot.nb0 bs=1K skip=${SKIP}
    elif grep -Eq "^BR2_PACKAGE_FREESCALE_IMX_PLATFORM_IMX8MM=y$" ${BR2_CONFIG}; then
        # disable hdmi because not available
        ENABLE_HDMI_FW=
        cat ${BINARIES_DIR}/u-boot-spl.bin ${BINARIES_DIR}/lpddr4_pmu_train_fw.bin > ${BINARIES_DIR}/u-boot-spl-ddr.bin
        BL31=${BINARIES_DIR}/bl31.bin BL33=${BINARIES_DIR}/u-boot.bin ATF_LOAD_ADDR=0x00920000 \
	    ${HOST_DIR}/bin/mkimage_fit_atf.sh ${UBOOT_DTB} > ${BINARIES_DIR}/u-boot.its

	${HOST_DIR}/bin/mkimage -E -p 0x3000 -f ${BINARIES_DIR}/u-boot.its ${BINARIES_DIR}/u-boot.itb
        rm -f ${BINARIES_DIR}/u-boot.its

        # TODO: Use param. 3 to create u-boot because of sd card image offsets.
        ${HOST_DIR}/bin/mkimage_imx8 -dev ${BOOT_DEVICE} -fit -loader ${BINARIES_DIR}/u-boot-spl-ddr.bin 0x7E1000 \
		   -second_loader ${BINARIES_DIR}/u-boot.itb 0x40200000 0x60000 -out ${BINARIES_DIR}/uboot-${PLATFORM}-$3.bin

        dd if=${BINARIES_DIR}/uboot-${PLATFORM}-$3.bin of=${BINARIES_DIR}/u-boot.nb0 bs=1K skip=${SKIP}
    else
        ${HOST_DIR}/bin/mkimage_imx8 -commit > ${BINARIES_DIR}/mkimg.commit
        cat ${BINARIES_DIR}/u-boot.bin ${BINARIES_DIR}/mkimg.commit > ${BINARIES_DIR}/u-boot-hash.bin
        cp ${BINARIES_DIR}/bl31.bin ${BINARIES_DIR}/u-boot-atf.bin
        dd if=${BINARIES_DIR}/u-boot-hash.bin of=${BINARIES_DIR}/u-boot-atf.bin bs=1K seek=128

        ${HOST_DIR}/bin/mkimage_imx8 -soc QX -rev B0 -append ${BINARIES_DIR}/ahab-container.img -c -scfw ${BINARIES_DIR}/mx8qx-mek-scfw-tcm.bin \
		   -ap ${BINARIES_DIR}/u-boot-atf.bin a35 0x80000000 -out ${BINARIES_DIR}/${PLATFORM}-boot-${BOOT_DEVICE}.bin
    fi

    if [ "$RAMFS" == "yes" ]; then
        # create ramfs
	${BINARIES_DIR}/mkimage -A arm64 -O linux -T ramdisk -C gzip -d ${BINARIES_DIR}/rootfs.cpio.gz ${BINARIES_DIR}/rootfs.cpio.gz.uboot
    fi


    exit $?
}

main $@
