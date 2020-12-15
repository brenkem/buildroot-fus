################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = cee66d0e956a64d03cc866fa8819da5b798c7f1b
IMX_KOBS_SITE = $(call github,codeauroraforum,imx-kobs,$(IMX_KOBS_VERSION))
IMX_KOBS_LICENSE = GPL-2.0+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
