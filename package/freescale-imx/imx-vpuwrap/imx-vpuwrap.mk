################################################################################
#
# imx-vpuwrap
#
################################################################################

IMX_VPUWRAP_VERSION = rel_imx_5.4.70_2.3.2
IMX_VPUWRAP_SOURCE = $(IMX_VPUWRAP_VERSION).tar.gz
IMX_VPUWRAP_SITE = https://github.com/NXP/imx-vpuwrap/archive

IMX_VPUWRAP_INSTALL_STAGING = YES

# configure is missing but autogen.sh script is available
define IMX_VPUWRAP_RUN_AUTOGEN
        cd $(@D) && PATH=$(BR_PATH) NOCONFIGURE=yes ./autogen.sh
endef
IMX_VPUWRAP_PRE_CONFIGURE_HOOKS += IMX_VPUWRAP_RUN_AUTOGEN

IMX_VPUWRAP_MAKE_ENV = \
	$(TARGET_MAKE_ENV) \
	$(TARGET_CONFIGURE_OPTS) \
	CROSS_COMPILE="$(TARGET_CROSS)" \
	PKG_CONFIG_SYSROOT_DIR=$(STAGING_DIR)

ifeq ($(BR2_PACKAGE_IMX_VPU),y)
IMX_VPUWRAP_DEPENDENCIES += imx-vpu
endif

ifeq ($(BR2_PACKAGE_IMX_VPU_HANTRO),y)
IMX_VPUWRAP_DEPENDENCIES += imx-vpu-hantro
endif

IMX_VPUWRAP_LICENSE = NXP Semiconductor Software License Agreement
IMX_VPUWRAP_LICENSE_FILES = COPYING
IMX_VPUWRAP_REDISTRIBUTE = NO

define IMX_VPU_VPUWRAP_BUILD_CMDS
	$(IMX_VPUWRAP_MAKE_ENV) $(MAKE1) -C $(@D)
endef

$(eval $(autotools-package))
