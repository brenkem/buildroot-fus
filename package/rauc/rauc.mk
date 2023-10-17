################################################################################
#
# rauc
#
################################################################################

RAUC_VERSION = 1.8
RAUC_SITE = https://github.com/rauc/rauc/releases/download/v$(RAUC_VERSION)
RAUC_SOURCE = rauc-$(RAUC_VERSION).tar.xz
RAUC_LICENSE = LGPL-2.1
RAUC_LICENSE_FILES = COPYING
RAUC_DEPENDENCIES = host-pkgconf openssl libglib2

ifeq ($(BR2_PACKAGE_RAUC_DBUS),y)
RAUC_CONF_OPTS += --enable-service
RAUC_DEPENDENCIES += dbus

# systemd service uses dbus interface
ifeq ($(BR2_PACKAGE_SYSTEMD),y)
# configure uses pkg-config --variable=systemdsystemunitdir systemd
RAUC_DEPENDENCIES += systemd
define RAUC_INSTALL_INIT_SYSTEMD
	mkdir -p $(TARGET_DIR)/usr/lib/systemd/system/rauc.service.d
	printf '[Install]\nWantedBy=multi-user.target\n' \
		>$(TARGET_DIR)/usr/lib/systemd/system/rauc.service.d/buildroot-enable.conf
endef
endif

else
RAUC_CONF_OPTS += --disable-service
endif

ifeq ($(BR2_PACKAGE_RAUC_GPT),y)
RAUC_CONF_OPTS += --enable-gpt
RAUC_DEPENDENCIES += util-linux-libs
else
RAUC_CONF_OPTS += --disable-gpt
endif

ifeq ($(BR2_PACKAGE_RAUC_NETWORK),y)
RAUC_CONF_OPTS += --enable-network
RAUC_DEPENDENCIES += libcurl
else
RAUC_CONF_OPTS += --disable-network
endif

ifeq ($(BR2_PACKAGE_RAUC_JSON),y)
RAUC_CONF_OPTS += --enable-json
RAUC_DEPENDENCIES += json-glib
else
RAUC_CONF_OPTS += --disable-json
endif

ifeq ($(BR2_PACKAGE_RAUC_STREAMING),y)
RAUC_CONF_OPTS += --enable-streaming
RAUC_DEPENDENCIES += libnl
else
RAUC_CONF_OPTS += --disable-streaming
endif

HOST_RAUC_DEPENDENCIES = \
	host-pkgconf \
	host-openssl \
	host-libglib2 \
	host-squashfs \
	$(if $(BR2_PACKAGE_HOST_LIBP11),host-libp11)
HOST_RAUC_CONF_OPTS += \
	--disable-network \
	--disable-json \
	--disable-service \
	--without-dbuspolicydir \
	--with-systemdunitdir=no

$(eval $(autotools-package))
$(eval $(host-autotools-package))
