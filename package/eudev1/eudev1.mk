################################################################################
#
# eudev1
#
################################################################################

EUDEV1_VERSION = 1.10
EUDEV1_SOURCE = eudev-$(EUDEV1_VERSION).tar.gz
EUDEV1_SITE = http://dev.gentoo.org/~blueness/eudev
EUDEV1_LICENSE = GPLv2+ (programs), LGPLv2.1+ (libraries)
EUDEV1_LICENSE_FILES = COPYING
EUDEV1_INSTALL_STAGING = YES

# mq_getattr is in librt
EUDEV1_CONF_ENV += LIBS=-lrt

EUDEV1_CONF_OPTS =		\
	--disable-manpages	\
	--sbindir=/sbin		\
	--libexecdir=/lib	\
	--with-firmware-path=/lib/firmware	\
	--disable-introspection			\
	--enable-libkmod

EUDEV1_DEPENDENCIES = host-gperf host-pkgconf util-linux kmod
EUDEV1_PROVIDES = udev

ifeq ($(BR2_ROOTFS_MERGED_USR),)
EUDEV1_CONF_OPTS += --with-rootlibdir=/lib --enable-split-usr
endif

ifeq ($(BR2_PACKAGE_EUDEV1_RULES_GEN),y)
EUDEV1_CONF_OPTS += --enable-rule-generator
endif

ifeq ($(BR2_PACKAGE_EUDEV1_ENABLE_HWDB),y)
EUDEV1_CONF_OPTS += --enable-hwdb
else
EUDEV1_CONF_OPTS += --disable-hwdb
endif

ifeq ($(BR2_PACKAGE_LIBGLIB2),y)
EUDEV1_CONF_OPTS += --enable-gudev
EUDEV1_DEPENDENCIES += libglib2
else
EUDEV1_CONF_OPTS += --disable-gudev
endif

ifeq ($(BR2_PACKAGE_LIBSELINUX),y)
EUDEV1_CONF_OPTS += --enable-selinux
EUDEV1_DEPENDENCIES += libselinux
else
EUDEV1_CONF_OPTS += --disable-selinux
endif

define EUDEV1_INSTALL_INIT_SYSV
	$(INSTALL) -D -m 0755 package/eudev1/S10udev $(TARGET_DIR)/etc/init.d/S10udev
endef

# Required by default rules for input devices
define EUDEV1_USERS
	- - input -1 * - - - Input device group
endef

$(eval $(autotools-package))
