#############################################################
#
# libmcc
#
#############################################################
LIBMCC_VERSION = 1.03
LIBMCC_SOURCE = libmcc-$(LIBMCC_VERSION).tar.bz2
LIBMCC_SITE = $(TOPDIR)/package/mqx/libmcc
LIBMCC_SITE_METHOD = file
LIBMCC_INSTALL_STAGING = YES

define LIBMCC_BUILD_CMDS
	$(MAKE) CC="$(TARGET_CC)" AR="$(TARGET_AR)" -C $(@D) all
endef

define LIBMCC_INSTALL_STAGING_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/libmcc.so $(STAGING_DIR)/usr/lib/libmcc.so
	$(INSTALL) -D -m 0755 $(@D)/build/libmcc.a $(STAGING_DIR)/usr/lib/libmcc.a
	$(INSTALL) -D -m 0644 $(@D)/include/linux/*.h $(STAGING_DIR)/usr/include/linux
	$(INSTALL) -D -m 0644 $(@D)/include/*.h $(STAGING_DIR)/usr/include
endef

define LIBMCC_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/build/libmcc.so $(TARGET_DIR)/usr/lib/libmcc.so
endef

$(eval $(generic-package))
