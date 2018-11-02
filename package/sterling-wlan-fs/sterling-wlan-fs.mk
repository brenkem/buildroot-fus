################################################################################
#
# sterling-lwb5-wlan-fs
#
# WLAN kernel modules and firmware files for Sterling LWB5.
#
################################################################################

STERLING_WLAN_FS_SITE = $(TOPDIR)/package/sterling-wlan-fs
STERLING_WLAN_FS_SOURCE = sterling-wlan-fs.tar.bz2
STERLING_WLAN_FS_SITE_METHOD = file
STERLING_WLAN_FS_LICENSE = Proprietary

# Linux must be built first
STERLING_WLAN_FS_DEPENDENCIES += linux

STERLING_WLAN_FS_MAKE_OPTS = \
	$(LINUX_MAKE_FLAGS) \
	KLIB_BUILD=$(LINUX_DIR)

STERLING_WLAN_FS_SUBDIR = laird-backport-5.0.0.22


# Build kernel modules
define STERLING_WLAN_FS_BUILD_CMDS
	$(TARGET_MAKE_ENV) $(MAKE) $(STERLING_WLAN_FS_MAKE_OPTS) \
		-C $(@D)/$(STERLING_WLAN_FS_SUBDIR) defconfig-lwb5-etsi
	$(TARGET_MAKE_ENV) $(MAKE) $(STERLING_WLAN_FS_MAKE_OPTS) \
		-C $(@D)/$(STERLING_WLAN_FS_SUBDIR)
endef

# Kernel modules
define STERLING_WLAN_FS_INSTALL_KERNEL_MODULES
	LVP=$(LINUX_VERSION_PROBED); \
	modulesdir=$(TARGET_DIR)/lib/modules/$$LVP; \
	mkdir -p $$modulesdir/updates/compat; \
	mkdir -p $$modulesdir/updates/net/wireless; \
	mkdir -p $$modulesdir/updates/net/bluetooth; \
	mkdir -p $$modulesdir/updates/drivers/net/wireless/broadcom/brcm80211/brcmutil; \
	mkdir -p $$modulesdir/updates/drivers/net/wireless/broadcom/brcm80211/brcmfmac; \
	cp $(@D)/$(STERLING_WLAN_FS_SUBDIR)/compat/compat.ko $$modulesdir/updates/compat/compat.ko; \
	cp $(@D)/$(STERLING_WLAN_FS_SUBDIR)/net/wireless/cfg80211.ko $$modulesdir/updates/net/wireless/cfg80211.ko; \
	cp $(@D)/$(STERLING_WLAN_FS_SUBDIR)/net/bluetooth/bluetooth.ko $$modulesdir/updates/net/bluetooth/bluetooth.ko; \
	cp $(@D)/$(STERLING_WLAN_FS_SUBDIR)/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko $$modulesdir/updates/drivers/net/wireless/broadcom/brcm80211/brcmutil/brcmutil.ko; \
	cp $(@D)/$(STERLING_WLAN_FS_SUBDIR)/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko $$modulesdir/updates/drivers/net/wireless/broadcom/brcm80211/brcmfmac/brcmfmac.ko; \
	$(HOST_DIR)/sbin/depmod -a -b $(TARGET_DIR) $$LVP;
endef

# Subcommand to install whole firmware directories; remove previous directories
# to avoid copying the new directories inside of the existing directories
define STERLING_WLAN_FS_INSTALL_FIRMWARE_DIRS
	rm -rf $(TARGET_DIR)/lib/firmware/brcm
	cp -a $(@D)/lib/firmware/brcm $(TARGET_DIR)/lib/firmware/brcm
endef

define STERLING_WLAN_FS_INSTALL_TARGET_CMDS
	$(STERLING_WLAN_FS_INSTALL_KERNEL_MODULES)
	mkdir -p $(TARGET_DIR)/lib/firmware
	$(STERLING_WLAN_FS_INSTALL_FIRMWARE_DIRS)
endef

$(eval $(generic-package))
