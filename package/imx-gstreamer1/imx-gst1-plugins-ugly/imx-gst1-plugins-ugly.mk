################################################################################
#
# imx-gst1-plugins-ugly
#
################################################################################

IMX_GST1_PLUGINS_UGLY_VERSION = 1.16.2
IMX_GST1_PLUGINS_UGLY_SOURCE = gst-plugins-ugly-$(IMX_GST1_PLUGINS_UGLY_VERSION).tar.xz
IMX_GST1_PLUGINS_UGLY_SITE = https://gstreamer.freedesktop.org/src/gst-plugins-ugly
IMX_GST1_PLUGINS_UGLY_LICENSE_FILES = COPYING
# GPL licensed plugins will append to IMX_GST1_PLUGINS_UGLY_LICENSE if enabled.
IMX_GST1_PLUGINS_UGLY_LICENSE = LGPL-2.1+

IMX_GST1_PLUGINS_UGLY_CONF_OPTS = --disable-examples --disable-valgrind

IMX_GST1_PLUGINS_UGLY_CONF_OPTS += \
	--disable-a52dec \
	--disable-amrnb \
	--disable-amrwb \
	--disable-cdio \
	--disable-sidplay \
	--disable-twolame

IMX_GST1_PLUGINS_UGLY_DEPENDENCIES = imx-gstreamer1 imx-gst1-plugins-base

ifeq ($(BR2_PACKAGE_ORC),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-orc
IMX_GST1_PLUGINS_UGLY_DEPENDENCIES += orc
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_ASFDEMUX),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-asfdemux
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-asfdemux
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_DVDLPCMDEC),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-dvdlpcmdec
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-dvdlpcmdec
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_DVDSUB),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-dvdsub
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-dvdsub
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_XINGMUX),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-xingmux
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-xingmux
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_REALMEDIA),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-realmedia
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-realmedia
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_DVDREAD),y)
# configure does not use pkg-config to detect libdvdread
ifeq ($(BR2_PACKAGE_LIBDVDCSS)$(BR2_STATIC_LIBS),yy)
IMX_GST1_PLUGINS_UGLY_CONF_ENV += LIBS="-ldvdcss"
endif
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-dvdread
IMX_GST1_PLUGINS_UGLY_DEPENDENCIES += libdvdread
IMX_GST1_PLUGINS_UGLY_HAS_GPL_LICENSE = y
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-dvdread
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_LAME),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-lame
IMX_GST1_PLUGINS_UGLY_DEPENDENCIES += lame
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-lame
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_MPG123),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-mpg123
IMX_GST1_PLUGINS_UGLY_DEPENDENCIES += mpg123
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-mpg123
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_MPEG2DEC),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-mpeg2dec
IMX_GST1_PLUGINS_UGLY_DEPENDENCIES += libmpeg2
IMX_GST1_PLUGINS_UGLY_HAS_GPL_LICENSE = y
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-mpeg2dec
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_UGLY_PLUGIN_X264),y)
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --enable-x264
IMX_GST1_PLUGINS_UGLY_DEPENDENCIES += x264
IMX_GST1_PLUGINS_UGLY_HAS_GPL_LICENSE = y
else
IMX_GST1_PLUGINS_UGLY_CONF_OPTS += --disable-x264
endif

# Add GPL license if GPL plugins enabled.
ifeq ($(IMX_GST1_PLUGINS_UGLY_HAS_GPL_LICENSE),y)
IMX_GST1_PLUGINS_UGLY_LICENSE += GPL-2.0
endif

# Use the following command to extract license info for plugins.
# # find . -name 'plugin-*.xml' | xargs grep license

$(eval $(autotools-package))
