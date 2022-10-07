################################################################################
#
# mxm-wifiex-fs
#
# WLAN kernel module for NXP (ex-Marvell) WLAN chips, e.g. SD8997,
# especially Azurewave AW CM276NF for F&S boards and modules.
#
################################################################################

MXM_WIFIEX_FS_VERSION = lf-5.15.32-2.0.0
MXM_WIFIEX_FS_SITE = http://source.codeaurora.org/external/imx/mwifiex/snapshot
MXM_WIFIEX_FS_SOURCE = $(MXM_WIFIEX_FS_VERSION).tar.gz
#MXM_WIFIEX_FS_SITE_METHOD = wget
MXM_WIFIEX_FS_LICENSE = GPL-2.0 or BSD
MXM_WIFIEX_FS_DEPENDENCIES = linux-firmware
MXM_WIFIEX_FS_SUBDIR = mxm_wifiex/wlan_src
MXM_WIFIEX_FS_MODULE_SUBDIRS = mxm_wifiex/wlan_src

# Only SD8997 is currently supported by our wifi_mod_para.conf and
# calibration data is only available for AW CM276NF WLAN module. If
# other devices are enabled, the conf file needs to be modified,
# additional calibration data must be provided and additional firmware
# files must be installed.
MXM_WIFIEX_FS_MODULE_MAKE_OPTS = KERNELDIR=$(LINUX_DIR)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8887=n CONFIG_SD8897=n \
	CONFIG_USB8897=n CONFIG_PCIE8897=n CONFIG_SD8977=n CONFIG_USB8978=n \
	CONFIG_USB8997=n CONFIG_SD9097=n CONFIG_SD9177=n CONFIG_USB8801=n \
	CONFIG_USB9097=n CONFIG_PCIE9097=n CONFIG_USB9098=n CONFIG_SDNW62X=n \
	CONFIG_PCIENW62X=n CONFIG_USBNW62X=n

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_SD8801),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8801=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8801=n
endif

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_SD8978),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8978=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8978=n
endif

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_SD8987),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8987=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8987=n
endif

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_SD8997),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8997=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD8997=n
endif

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_PCIE8997),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_PCIE8997=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_PCIE8997=n
endif

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_SD9098),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD9098=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_SD9098=n
endif

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_PCIE9098),y)
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_PCIE9098=y
else
MXM_WIFIEX_FS_MODULE_MAKE_OPTS += CONFIG_PCIE9098=n
endif

$(eval $(kernel-module))

MXM_WIFIEX_FS_MAKE_OPTS = 

ifeq ($(BR2_PACKAGE_MXM_WIFIEX_FS_MLANUTL),y)
define MXM_WIFIEX_FS_BUILD_CMDS
	$(MAKE) CC=$(TARGET_CC) -C $(@D)/$(MXM_WIFIEX_FS_SUBDIR) mapp/mlanutl
endef

define MXM_WIFIEX_FS_INSTALL_TARGET_CMDS
	$(INSTALL) -D -m 0755 $(@D)/$(MXM_WIFIEX_FS_SUBDIR)/mlanutl \
		$(TARGET_DIR)/usr/sbin
endef
endif

# Install configuration file and calibration data
define MXM_WIFIEX_FS_INSTALL_LIB_FIRMWARE
	ln -sf mrvl $(TARGET_DIR)/lib/firmware/nxp
	$(INSTALL) -m 0644 -D package/mxm-wifiex-fs/wifi_mod_para.conf \
		$(TARGET_DIR)/lib/firmware/nxp/
	$(INSTALL) -m 0644 -D \
		package/mxm-wifiex-fs/WlanCalData_AW_CM276NF.conf \
		$(TARGET_DIR)/lib/firmware/nxp/
endef

MXM_WIFIEX_FS_POST_INSTALL_TARGET_HOOKS += MXM_WIFIEX_FS_INSTALL_LIB_FIRMWARE

$(eval $(generic-package))
