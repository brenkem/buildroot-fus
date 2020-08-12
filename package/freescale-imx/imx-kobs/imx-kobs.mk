################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = 5d862669545a850c961b301884ff16f3828e6ce9
IMX_KOBS_SITE = $(call github,codeauroraforum,imx-kobs,$(IMX_KOBS_VERSION))
IMX_KOBS_LICENSE = GPL-2.0+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
