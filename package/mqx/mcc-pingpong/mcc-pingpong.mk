#############################################################
#
# mcc-pingpong
#
#############################################################
MCC_PINGPONG_VERSION = 1.0
MCC_PINGPONG_SOURCE = mcc-pingpong-$(MCC_PINGPONG_VERSION).tar.bz2
MCC_PINGPONG_SITE = $(TOPDIR)/package/mqx/mcc-pingpong
MCC_PINGPONG_SITE_METHOD = file
MCC_PINGPONG_DEPENDENCIES = libmcc

define MCC_PINGPONG_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

define MCC_PINGPONG_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/mcc-pingpong $(TARGET_DIR)/usr/bin/mcc-pingpong
endef

$(eval $(generic-package))
