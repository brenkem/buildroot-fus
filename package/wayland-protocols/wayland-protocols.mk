################################################################################
#
# wayland-protocols
#
################################################################################

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_OUTPUT_WL),y)
WAYLAND_PROTOCOLS_VERSION = rel_imx_5.4.70_2.3.2
WAYLAND_PROTOCOLS_SITE = https://github.com/nxp-imx/wayland-protocols-imx.git
WAYLAND_PROTOCOLS_SITE_METHOD = git
WAYLAND_PROTOCOLS_AUTORECONF = YES
WAYLAND_PROTOCOLS_DEPENDENCIES = host-pkgconf
else
WAYLAND_PROTOCOLS_VERSION = 1.18
WAYLAND_PROTOCOLS_SITE = http://wayland.freedesktop.org/releases
WAYLAND_PROTOCOLS_SOURCE = wayland-protocols-$(WAYLAND_PROTOCOLS_VERSION).tar.xz
endif

WAYLAND_PROTOCOLS_LICENSE = MIT
WAYLAND_PROTOCOLS_LICENSE_FILES = COPYING
WAYLAND_PROTOCOLS_INSTALL_STAGING = YES
WAYLAND_PROTOCOLS_INSTALL_TARGET = NO

$(eval $(autotools-package))
