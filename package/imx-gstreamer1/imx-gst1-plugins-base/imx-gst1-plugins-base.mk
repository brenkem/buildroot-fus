################################################################################
#
# imx-gst1-plugins-base
#
################################################################################

IMX_GST1_PLUGINS_BASE_VERSION = rel_imx_4.9.88_2.0.0_ga
IMX_GST1_PLUGINS_BASE_SOURCE = imx-gst-plugins-base-1.12.2.tar.gz
IMX_GST1_PLUGINS_BASE_SITE = https://github.com/nxp-imx/gst-plugins-base.git
IMX_GST1_PLUGINS_BASE_SITE_METHOD = git
IMX_GST1_PLUGINS_BASE_GIT_SUBMODULES = YES
IMX_GST1_PLUGINS_BASE_INSTALL_STAGING = YES
IMX_GST1_PLUGINS_BASE_LICENSE_FILES = COPYING.LIB
IMX_GST1_PLUGINS_BASE_LICENSE = LGPL-2.0+, LGPL-2.1+

# gio_unix_2_0 is only used for tests
IMX_GST1_PLUGINS_BASE_CONF_OPTS = \
	--disable-examples \
	--disable-valgrind \
	--disable-introspection

# Options which require currently unpackaged libraries
IMX_GST1_PLUGINS_BASE_CONF_OPTS += \
	--disable-cdparanoia \
	--disable-libvisual \
	--disable-iso-codes

# configure is missing but autogen.sh script is available
define IMX_GST1_PLUGINS_BASE_RUN_AUTOGEN
        cd $(@D) && PATH=$(BR_PATH) ./autogen.sh --noconfigure
endef
IMX_GST1_PLUGINS_BASE_POST_PATCH_HOOKS += IMX_GST1_PLUGINS_BASE_RUN_AUTOGEN

IMX_GST1_PLUGINS_BASE_DEPENDENCIES = imx-gstreamer1

# These plugins are listed in the order from ./configure --help
ifeq ($(BR2_PACKAGE_ORC),y)
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += orc
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-orc
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_ADDER),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-adder
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-adder
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_APP),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-app
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-app
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_AUDIOCONVERT),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-audioconvert
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-audioconvert
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_AUDIORATE),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-audiorate
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-audiorate
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_AUDIOTESTSRC),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-audiotestsrc
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-audiotestsrc
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_ENCODING),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-encoding
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-encoding
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_VIDEOCONVERT),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-videoconvert
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-videoconvert
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_GIO),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-gio
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-gio
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_PLAYBACK),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-playback
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-playback
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_AUDIORESAMPLE),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-audioresample
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-audioresample
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_RAWPARSE),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-rawparse
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-rawparse
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_SUBPARSE),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-subparse
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-subparse
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_TCP),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-tcp
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-tcp
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_TYPEFIND),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-typefind
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-typefind
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_VIDEOTESTSRC),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-videotestsrc
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-videotestsrc
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_VIDEORATE),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-videorate
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-videorate
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_VIDEOSCALE),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-videoscale
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-videoscale
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_VOLUME),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-volume
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-volume
endif

ifeq ($(BR2_PACKAGE_ZLIB),y)
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += zlib
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-zlib
endif

ifeq ($(BR2_PACKAGE_XORG7),y)
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += xlib_libX11 xlib_libXext xlib_libXv
IMX_GST1_PLUGINS_BASE_CONF_OPTS += \
	--enable-x \
	--enable-xshm \
	--enable-xvideo
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += \
	--disable-x \
	--disable-xshm \
	--disable-xvideo
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_ALSA),y)
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += alsa-lib
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-alsa
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_TREMOR),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-ivorbis
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += tremor
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-ivorbis
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_OPUS),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-opus
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += opus
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-opus
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_OGG),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-ogg
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += libogg
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-ogg
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_PANGO),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-pango
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += pango
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-pango
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_THEORA),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-theora
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += libtheora
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-theora
endif

ifeq ($(BR2_PACKAGE_IMX_GST1_PLUGINS_BASE_PLUGIN_VORBIS),y)
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --enable-vorbis
IMX_GST1_PLUGINS_BASE_DEPENDENCIES += libvorbis
else
IMX_GST1_PLUGINS_BASE_CONF_OPTS += --disable-vorbis
endif

$(eval $(autotools-package))
