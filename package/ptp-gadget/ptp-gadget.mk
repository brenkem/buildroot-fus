################################################################################
#
# ptp-gadget
#
################################################################################

PTP_GADGET_VERSION = v1.2
PTP_GADGET_SOURCE = ptp-gadget-$(PTP_GADGET_VERSION).tar.gz
PTP_GADGET_SITE = http://git.denx.de/ptp-gadget.git
PTP_GADGET_SITE_METHOD = git
PTP_GADGET_LICENSE = LGPLv2.1+
PTP_GADGET_LICENSE_FILES = LICENSE

# The git archive does not have the autoconf/automake stuff generated.
PTP_GADGET_AUTORECONF = YES
PTP_GADGET_DEPENDENCIES = libglib2
PTP_GADGET_INSTALL_TARGET = YES
PTP_GADGET_INSTALL_STAGING = YES
PTP_GADGET_EXPORT_DIR = $(call qstrip,$(BR2_PACKAGE_PTP_GADGET_DIR))

define PTP_GADGET_INSTALL_INIT_SYSV
	sed -e "s|@PTP_GADGET_DIR@|$(PTP_GADGET_EXPORT_DIR)|g" \
		package/ptp-gadget/S65ptp-gadget > $(@D)/S65ptp-gadget
	$(INSTALL) -m 0755 -D $(@D)/S65ptp-gadget \
		$(TARGET_DIR)/etc/init.d/S65ptp-gadget
endef

$(eval $(autotools-package))
