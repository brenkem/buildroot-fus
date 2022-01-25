################################################################################
#
# fs-freertos-sample
#
# Default fs-freertos image which will be included to sdcard image
#
################################################################################

FS_FREERTOS_SAMPLE_VERSION = 1.0
FS_FREERTOS_SAMPLE_SITE = $(TOPDIR)/package/fs-freertos-sample
FS_FREERTOS_SAMPLE_SOURCE = fs-freertos-sample-$(FS_FREERTOS_SAMPLE_VERSION).tar.bz2
FS_FREERTOS_SAMPLE_SITE_METHOD = file
FS_FREERTOS_SAMPLE_LICENSE = Proprietary
FS_FREERTOS_SAMPLE_INSTALL_IMAGES = YES

define FS_FREERTOS_SAMPLE_INSTALL_IMAGES_CMDS
	$(INSTALL) -d $(BINARIES_DIR)/fs-freertos-samples/
	cp -dpf $(@D)/* $(BINARIES_DIR)/fs-freertos-samples/
endef

$(eval $(generic-package))
