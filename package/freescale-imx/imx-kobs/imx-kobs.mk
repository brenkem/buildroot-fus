################################################################################
#
# imx-kobs
#
################################################################################

IMX_KOBS_VERSION = 269fdffcf97238684de9f28977a73677282e061f
IMX_KOBS_SITE = $(call github,codeauroraforum,imx-kobs,$(IMX_KOBS_VERSION))
IMX_KOBS_LICENSE = GPL-2.0+
IMX_KOBS_LICENSE_FILES = COPYING

$(eval $(autotools-package))
