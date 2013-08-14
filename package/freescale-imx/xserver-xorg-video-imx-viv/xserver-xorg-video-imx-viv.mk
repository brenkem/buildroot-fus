################################################################################
#
# xdriver_xf86-video-vivante -- video driver for framebuffer device
#
################################################################################

XSERVER_XORG_VIDEO_IMX_VIV_VERSION = $(FREESCALE_IMX_VERSION)
XSERVER_XORG_VIDEO_IMX_VIV_SITE = $(FREESCALE_IMX_MIRROR_SITE)
XSERVER_XORG_VIDEO_IMX_VIV_SOURCE = xserver-xorg-video-imx-viv-$(XSERVER_XORG_VIDEO_IMX_VIV_VERSION).tar.gz
XSERVER_XORG_VIDEO_IMX_VIV_LICENSE_FILES = COPYING
XSERVER_XORG_VIDEO_IMX_VIV_DEPENDENCIES = xserver_xorg-server xproto_fontsproto xproto_randrproto xproto_renderproto xproto_videoproto xproto_xproto

XSERVER_XORG_VIDEO_IMX_VIV_SUBDIR = EXA
#XSERVER_XORG_VIDEO_IMX_VIV_SUBDIR = DRI_1.10.4
XSERVER_XORG_VIDEO_IMX_VIV_AUTORECONF = YES
XSERVER_XORG_VIDEO_IMX_VIV_CONF_OPT = --disable-static
#XSERVER_XORG_VIDEO_IMX_VIV_MAKE_OPT = CFLAGS="$(TARGET_CFLAGS) -I../../EXA/src/vivante_gal -g -Wa,-mimplicit-it=thumb" LDFLAGS="$(TARGET_LDFLAGS) -lGAL -lm -ldl -ldrm -lX11"
XSERVER_XORG_VIDEO_IMX_VIV_MAKE_OPT = CFLAGS="$(TARGET_CFLAGS) -DDISABLE_VIVANTE_DRI" LDFLAGS="$(TARGET_LDFLAGS) -lGAL -lm -ldl -lX11"

XSERVER_XORG_VIDEO_IMX_VIV_INSTALL_STAGING = YES

XSERVER_XORG_VIDEO_IMX_VIV_LICENSE = Freescale Semiconductor Software License Agreement

$(eval $(autotools-package))
