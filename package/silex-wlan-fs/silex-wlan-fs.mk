################################################################################
#
# silex-wlan-fs
#
# WLAN kernel modules and firmware files for Silex QCA9377.
#
################################################################################

SILEX_WLAN_FS_VERSION = v4.1_01272017
SILEX_WLAN_FS_SITE = $(TOPDIR)/package/silex-wlan-fs
SILEX_WLAN_FS_SOURCE = silex-wlan-fs-$(SILEX_WLAN_FS_VERSION).tar.bz2
SILEX_WLAN_FS_SITE_METHOD = file
SILEX_WLAN_FS_LICENSE = Proprietary

# Linux must be built first
SILEX_WLAN_FS_DEPENDENCIES += linux

# Kernel modules
SILEX_WLAN_FS_KERNEL_MODULES = sxcfg80211.ko compat.ko wlan.ko

# Subcommand to install kernel modules
define SILEX_WLAN_FS_INSTALL_KERNEL_MODULES
	LVP=$(LINUX_VERSION_PROBED); \
	modulesdir=$(TARGET_DIR)/lib/modules/$$LVP; \
	mkdir -p $$modulesdir/silex-wlan; \
	cd $(@D)/modules; \
	$(TAR) c $(sort $(SILEX_WLAN_FS_KERNEL_MODULES)) | \
		$(TAR) x -C $$modulesdir/silex-wlan; \
	$(HOST_DIR)/sbin/depmod -a -b $(TARGET_DIR) $$LVP;
endef

# Also add firmware files
SILEX_WLAN_FS_FIRMWARE_FILES = bdwlan30.bin otp30.bin qwlan30.bin utf30.bin utfbd30.bin
SILEX_WLAN_FS_FIRMWARE_DIRS = qca wlan

# Subcommand to install single firmware files
define SILEX_WLAN_FS_INSTALL_FIRMWARE_FILES
	cd $(@D)/firmware ; \
	$(TAR) c $(sort $(SILEX_WLAN_FS_FIRMWARE_FILES)) | \
		$(TAR) x -C $(TARGET_DIR)/lib/firmware
endef

# Subcommand to install whole firmware directories; remove previous directories
# to avoid copying the new directories inside of the existing directories
define SILEX_WLAN_FS_INSTALL_FIRMWARE_DIRS
	$(foreach d,$(SILEX_WLAN_FS_FIRMWARE_DIRS), \
		rm -rf $(TARGET_DIR)/lib/firmware/$(d); \
		cp -a $(@D)/firmware/$(d) $(TARGET_DIR)/lib/firmware/$(d)$(sep))
endef

# Install WPA tools
define SILEX_WLAN_FS_INSTALL_WPA_SUPPLICANT
	$(INSTALL) -m 0755 -D $(@D)/binaries/wpa_supplicant \
		$(TARGET_DIR)/usr/sbin/wpa_supplicant
	$(INSTALL) -m 0755 -D $(@D)/binaries/wpa_cli \
		$(TARGET_DIR)/usr/sbin/wpa_cli
	$(INSTALL) -m 0755 -D $(@D)/binaries/wpa_passphrase \
		$(TARGET_DIR)/usr/sbin/wpa_passphrase
	$(INSTALL) -m 644 -D package/silex-wlan-fs/wpa_supplicant.conf \
		$(TARGET_DIR)/etc/wpa_supplicant.conf
endef

# Install hostapd tools
define SILEX_WLAN_FS_INSTALL_HOSTAPD
	$(INSTALL) -m 0755 -D $(@D)/binaries/hostapd \
		$(TARGET_DIR)/usr/sbin/hostapd
	$(INSTALL) -m 0755 -D $(@D)/binaries/hostapd_cli \
		$(TARGET_DIR)/usr/bin/hostapd_cli
endef

# Install startup script to set up the WLAN MAC address
define SILEX_WLAN_FS_INSTALL_ETC_INITD
	$(INSTALL) -m 0755 -D package/silex-wlan-fs/S02silex \
		$(TARGET_DIR)/etc/init.d/S02silex
	ln -sf /run/Silex-MAC $(TARGET_DIR)/lib/firmware/wlan/wlan_mac.bin
endef

define SILEX_WLAN_FS_INSTALL_TARGET_CMDS
	$(SILEX_WLAN_FS_INSTALL_KERNEL_MODULES)
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(SILEX_WLAN_FS_INSTALL_FIRMWARE_FILES)
	$(SILEX_WLAN_FS_INSTALL_FIRMWARE_DIRS)
	$(SILEX_WLAN_FS_INSTALL_WPA_SUPPLICANT)
	$(SILEX_WLAN_FS_INSTALL_HOSTAPD)
	$(SILEX_WLAN_FS_INSTALL_ETC_INITD)
endef

ifeq ($(BR2_PACKAGE_SILEX_WLAN_FS),y)
# This package brings an own cfg80211.ko, so add a hook to the Linux build to
# disable the regular one when it is built as part of the Linux package
define SILEX_WLAN_FS_DISABLE_CFG80211
	LVP=$(LINUX_VERSION_PROBED); \
	modulesdir=$(TARGET_DIR)/lib/modules/$$LVP; \
	cfg80211=$$modulesdir/kernel/net/wireless/cfg80211.ko; \
	if [ -e $$cfg80211 ] ; then \
		mv -f $$cfg80211 $$cfg80211.off; \
		$(HOST_DIR)/sbin/depmod -a -b $(TARGET_DIR) $$LVP; \
	fi
endef
LINUX_POST_INSTALL_TARGET_HOOKS += SILEX_WLAN_FS_DISABLE_CFG80211
endif

$(eval $(generic-package))
