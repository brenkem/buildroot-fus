################################################################################
#
# imx-gstreamer1
#
################################################################################

IMX_GSTREAMER1_VERSION = rel_imx_4.14.98_2.3.1_patch
IMX_GSTREAMER1_SOURCE = imx-gstreamer-1.14.4.tar.gz
IMX_GSTREAMER1_SITE = https://source.codeaurora.org/external/imx/gstreamer
IMX_GSTREAMER1_SITE_METHOD = git
IMX_GSTREAMER1_GIT_SUBMODULES = YES

#IMX_GSTREAMER1_VERSION = 1.14.4
#IMX_GSTREAMER1_SOURCE = gstreamer-$(IMX_GSTREAMER1_VERSION).tar.xz
#IMX_GSTREAMER1_SITE = https://gstreamer.freedesktop.org/src/gstreamer
IMX_GSTREAMER1_INSTALL_STAGING = YES
IMX_GSTREAMER1_LICENSE_FILES = COPYING
IMX_GSTREAMER1_LICENSE = LGPL-2.0+, LGPL-2.1+

#IMX_GSTREAMER1_AUTORECONF = YES
#IMX_GSTREAMER1_GETTEXTIZE = YES

IMX_GSTREAMER1_CONF_OPTS = \
	--disable-examples \
	--disable-tests \
	--disable-failing-tests \
	--disable-valgrind \
	--disable-benchmarks \
	--disable-introspection \
	$(if $(BR2_PACKAGE_IMX_GSTREAMER1_CHECK),,--disable-check) \
	$(if $(BR2_PACKAGE_IMX_GSTREAMER1_TRACE),,--disable-trace) \
	$(if $(BR2_PACKAGE_IMX_GSTREAMER1_PARSE),,--disable-parse) \
	$(if $(BR2_PACKAGE_IMX_GSTREAMER1_GST_DEBUG),,--disable-gst-debug) \
	$(if $(BR2_PACKAGE_IMX_GSTREAMER1_PLUGIN_REGISTRY),,--disable-registry) \
	$(if $(BR2_PACKAGE_IMX_GSTREAMER1_INSTALL_TOOLS),,--disable-tools)

# configure is missing but autogen.sh script is available
define IMX_GSTREAMER1_RUN_AUTOGEN
        cd $(@D) && PATH=$(BR_PATH) ./autogen.sh --noconfigure
endef
IMX_GSTREAMER1_POST_PATCH_HOOKS += IMX_GSTREAMER1_RUN_AUTOGEN
#IMX_GSTREAMER1_PRE_CONFIGURE_HOOKS += IMX_GSTREAMER1_RUN_AUTOGEN

IMX_GSTREAMER1_DEPENDENCIES = \
	host-bison \
	host-flex \
	host-pkgconf \
	libglib2 \
	$(if $(BR2_PACKAGE_LIBUNWIND),libunwind)

$(eval $(autotools-package))
