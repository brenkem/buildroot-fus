################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = c50b0a001d506a8c39c206b26ec24e71fcf2afb6
IMX_KOBS_SITE = $(call github,codeauroraforum,imx-kobs,$(IMX_KOBS_VERSION))
IMX_KOBS_LICENSE = GPL-2.0+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
