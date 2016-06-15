################################################################################
#
# imx-gst1-plugin
#
################################################################################

IMX_GST1_PLUGIN_VERSION = 4.0.9
IMX_GST1_PLUGIN_SITE = $(FREESCALE_IMX_SITE)
IMX_GST1_PLUGIN_SOURCE = imx-gst1.0-plugin-$(IMX_GST1_PLUGIN_VERSION).tar.gz

# Most is LGPLv2+, but some sources are copied from upstream and are
# LGPLv2.1+, which essentially makes it LGPLv2.1+
IMX_GST1_PLUGIN_LICENSE = LGPLv2+, LGPLv2.1+, PROPRIETARY (asf.h)
IMX_GST1_PLUGIN_LICENSE_FILES = COPYING-LGPL-2.1 COPYING-LGPL-2

IMX_GST1_PLUGIN_INSTALL_STAGING = YES
IMX_GST1_PLUGIN_AUTORECONF = YES

IMX_GST1_PLUGIN_DEPENDENCIES += host-pkgconf gstreamer1 gst1-plugins-base \
	imx-vpuwrap imx-lib imx-vpu imx-parser imx-codec

IMX_GST1_PLUGIN_CONF_ENV = \
	PLATFORM=$(BR2_PACKAGE_IMX_GST1_PLUGIN_PLATFORM) \
	CROSS_ROOT="$(STAGING_DIR)"

# needs access to imx-specific kernel headers
IMX_GST1_PLUGIN_DEPENDENCIES += linux
IMX_GST1_PLUGIN_CONF_ENV += CPPFLAGS="$(TARGET_CPPFLAGS) -idirafter $(LINUX_DIR)/include/uapi -I$(@D)/libs"

ifeq ($(BR2_PACKAGE_XLIB_LIBX11),y)
IMX_GST1_PLUGIN_DEPENDENCIES += xlib_libX11
IMX_GST1_PLUGIN_CONF_OPTS += --enable-x11
else
IMX_GST1_PLUGIN_CONF_OPTS += --disable-x11
endif
IMX_GST1_PLUGIN_CONF_OPTS += --disable-mp3enc

# Autoreconf requires an m4 directory to exist
define IMX_GST1_PLUGIN_PATCH_M4
	mkdir -p $(@D)/m4
endef

# We need the newest videodev2.h, which in turn needs compiler.h
define IMX_GST1_PLUGIN_VIDEODEV2
	mkdir -p $(@D)/libs/linux
	cp $(LINUX_DIR)/include/uapi/linux/videodev2.h $(@D)/libs/linux
	cp $(LINUX_DIR)/include/linux/compiler.h $(@D)/libs/linux
endef

IMX_GST1_PLUGIN_POST_PATCH_HOOKS += IMX_GST1_PLUGIN_PATCH_M4 IMX_GST1_PLUGIN_VIDEODEV2

IMX_GST1_PLUGIN_CONF_ENV += PKG_CONFIG_SYSROOT_DIR="$(STAGING_DIR)"

$(eval $(autotools-package))
