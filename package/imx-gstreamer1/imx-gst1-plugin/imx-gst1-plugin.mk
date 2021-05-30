################################################################################
#
# imx-gst1-plugin
#
################################################################################

IMX_GST1_PLUGIN_VERSION = rel_imx_5.4.70_2.3.2
IMX_GST1_PLUGIN_SOURCE = imx-gst1.0-plugin-4.5.6.tar.gz
IMX_GST1_PLUGIN_SITE = https://source.codeaurora.org/external/imx/imx-gst1.0-plugin
IMX_GST1_PLUGIN_SITE_METHOD = git

# Most is LGPLv2+, but some sources are copied from upstream and are
# LGPLv2.1+, which essentially makes it LGPLv2.1+
IMX_GST1_PLUGIN_LICENSE = LGPLv2+, LGPLv2.1+, PROPRIETARY (asf.h)
IMX_GST1_PLUGIN_LICENSE_FILES = COPYING-LGPL-2.1 COPYING-LGPL-2

IMX_GST1_PLUGIN_INSTALL_STAGING = YES
IMX_GST1_PLUGIN_AUTORECONF = YES

IMX_GST1_PLUGIN_DEPENDENCIES += host-pkgconf imx-lib imx-parser imx-codec \
	imx-gstreamer1 imx-gst1-plugins-base imx-gst1-plugins-bad libdrm
ifeq ($(BR2_PACKAGE_FREESCALE_IMX_HAS_VPU),y)
IMX_GST1_PLUGIN_DEPENDENCIES += imx-vpu imx-vpuwrap
endif

IMX_GST1_PLUGIN_CONF_ENV = \
	PLATFORM=$(BR2_PACKAGE_IMX_GST1_PLUGIN_PLATFORM) \
	CROSS_ROOT="$(STAGING_DIR)"

# needs access to imx-specific kernel headers
IMX_GST1_PLUGIN_DEPENDENCIES += linux
IMX_GST1_PLUGIN_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -idirafter $(LINUX_DIR)/include/uapi -I$(@D)/libs"

IMX_GST1_PLUGIN_CONF_OPTS = --disable-mp3enc
ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
IMX_GST1_PLUGIN_DEPENDENCIES += xlib_libX11
IMX_GST1_PLUGIN_CONF_OPTS += --enable-x11
else
IMX_GST1_PLUGIN_CONF_OPTS += --disable-x11
endif

# Autoreconf requires an m4 directory to exist
define IMX_GST1_PLUGIN_PATCH_M4
	mkdir -p $(@D)/m4
endef

# We need the newest videodev2.h, which in turn needs compiler.h
define IMX_GST1_PLUGIN_VIDEODEV2
	mkdir -p $(@D)/libs/linux
	cp $(LINUX_DIR)/include/uapi/linux/videodev2.h $(@D)/libs/linux
	cp $(LINUX_DIR)/include/linux/compiler.h $(@D)/libs/linux
	cp $(LINUX_DIR)/include/linux/compiler_types.h $(@D)/libs/linux
endef

IMX_GST1_PLUGIN_POST_PATCH_HOOKS += IMX_GST1_PLUGIN_PATCH_M4 IMX_GST1_PLUGIN_VIDEODEV2

IMX_GST1_PLUGIN_CONF_ENV += PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)"

$(eval $(autotools-package))
