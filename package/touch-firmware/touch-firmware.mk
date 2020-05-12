################################################################################
#
# touch-firmware
#
################################################################################


define TOUCH_FIRMWARE_INSTALL_TARGET_CMDS
	mkdir -p $(TARGET_DIR)/lib/firmware/atmel

	cp -r package/touch-firmware/atmel/ $(TARGET_DIR)/lib/firmware/
endef

$(eval $(generic-package))
