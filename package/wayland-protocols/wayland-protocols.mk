################################################################################
#
# wayland-protocols
#
################################################################################

ifeq ($(BR2_PACKAGE_IMX_GPU_VIV_OUTPUT_WL),y)
WAYLAND_PROTOCOLS_VERSION = rel_imx_4.14.98_2.3.1_patch
WAYLAND_PROTOCOLS_SITE = https://source.codeaurora.org/external/imx/wayland-protocols-imx
WAYLAND_PROTOCOLS_SITE_METHOD = git
WAYLAND_PROTOCOLS_AUTORECONF = YES
WAYLAND_PROTOCOLS_DEPENDENCIES = host-pkgconf
else
WAYLAND_PROTOCOLS_VERSION = 1.17
WAYLAND_PROTOCOLS_SITE = http://wayland.freedesktop.org/releases
WAYLAND_PROTOCOLS_SOURCE = wayland-protocols-$(WAYLAND_PROTOCOLS_VERSION).tar.xz
endif

WAYLAND_PROTOCOLS_LICENSE = MIT
WAYLAND_PROTOCOLS_LICENSE_FILES = COPYING
WAYLAND_PROTOCOLS_INSTALL_STAGING = YES
WAYLAND_PROTOCOLS_INSTALL_TARGET = NO

$(eval $(autotools-package))
