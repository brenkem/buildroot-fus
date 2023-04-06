################################################################################
#
# silex-wlanbt-fs
#
# WLAN kernel module for Silex QCA9377, also needed for Bluetooth.
#
################################################################################

# Version 4.0.11.213V
SILEX_WLANBT_FS_VERSION = cb52696f9eadd8212c3ebccdeeb63f5ea814a954
SILEX_WLANBT_FS_SITE = https://github.com/nxp-imx/qcacld-2.0-imx.git
SILEX_WLANBT_FS_SITE_METHOD = git
SILEX_WLANBT_FS_LICENSE = GPL-2.0 or BSD

# Options (taken from LEA.3.0, config.te-f30) necessary for selecting the
# correct defines in Kbuild.
#
# Attention: These settings will override any assignments for these variables
# done in Kbuild; for example if CONFIG_PER_VDEV_TX_DESC_POOL is set, the
# assignment := 0 in Kbuild in case of SDIO interface is ignored even if the
# condition for it there is true. This is why we do not set it here.
SILEX_WLANBT_FS_MODULE_MAKE_OPTS = KERNEL_SRC=$(LINUX_DIR)
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += WLAN_ROOT=$(@D)
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += MODNAME=wlan
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_QCA_WIFI_ISOC=0
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_QCA_WIFI_2_0=1
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_QCA_CLD_WLAN=m
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += WLAN_OPEN_SOURCE=1
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_CLD_HL_SDIO_CORE=y
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_LINUX_QCMBR=y
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += SAP_AUTH_OFFLOAD=1
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_QCA_LL_TX_FLOW_CT=1
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_WLAN_FEATURE_FILS=y
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_FEATURE_COEX_PTA_CONFIG_ENABLE=y
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_QCA_SUPPORT_TXRX_DRIVER_TCP_DEL_ACK=y
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_WLAN_WAPI_MODE_11AC_DISABLE=y
SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_WLAN_WOW_PULSE=y
# Set in config.te-f30, but according to Kbuild not available in SDIO mode
#SILEX_WLANBT_FS_MODULE_MAKE_OPTS += CONFIG_PER_VDEV_TX_DESC_POOL=1

$(eval $(kernel-module))

# Install startup script to set up the WLAN MAC address
define SILEX_WLANBT_FS_INSTALL_ETC_INITD
	$(INSTALL) -m 0755 -D package/silex-wlanbt-fs/S02silex \
		$(TARGET_DIR)/etc/init.d/S02silex
	ln -sf /run/Silex-MAC $(TARGET_DIR)/lib/firmware/wlan/wlan_mac.bin
endef

SILEX_WLANBT_FS_POST_INSTALL_TARGET_HOOKS += SILEX_WLANBT_FS_INSTALL_ETC_INITD

$(eval $(generic-package))
