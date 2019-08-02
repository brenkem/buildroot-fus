################################################################################
#
# ecm
#
################################################################################

ECM_VERSION = v5.26.0
ECM_SITE = $(call github,KDE,extra-cmake-modules,$(ECM_VERSION))
ECM_INSTALL_STAGING = YES
ECM_LICENSE = zlib
ECM_LICENSE_FILES = COPYING.txt

#ECM_CONF_OPTS += \
	-DGLFW_BUILD_EXAMPLES=OFF \
	-DGLFW_BUILD_TESTS=OFF \
	-DGLFW_BUILD_DOCS=OFF \
	-DGLFW_USE_WAYLAND=ON
	#-DOPENGL_INCLUDE_DIR="/home/sergii/proj/i.mx/fsimx6-V3.0/build/buildroot-2016.05-fsimx6-V3.0_org/output/host/usr/arm-buildroot-linux-gnueabihf/sysroot/usr/include/"

#ifeq ($(BR2_PACKAGE_XLIB_LIBXI),y)
#ECM_DEPENDENCIES += xlib_libXi
#endif

#ifeq ($(BR2_PACKAGE_XLIB_LIBXXF86VM),y)
#ECM_DEPENDENCIES += xlib_libXxf86vm
#endif

$(eval $(host-cmake-package))
