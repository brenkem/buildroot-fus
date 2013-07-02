#############################################################
#
# mqxboot
#
#############################################################
MQXBOOT_VERSION = 1.0
MQXBOOT_SOURCE = mqxboot-$(MQXBOOT_VERSION).tar.bz2
MQXBOOT_SITE = $(TOPDIR)/package/mqx/mqxboot
MQXBOOT_SITE_METHOD = file
MQXBOOT_DEPENDENCIES = libmcc

define MQXBOOT_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" -C $(@D) all
endef

define MQXBOOT_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/mqxboot $(TARGET_DIR)/usr/bin/mqxboot
endef

$(eval $(generic-package))
