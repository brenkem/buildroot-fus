################################################################################
#
# python-fs-updater-lib
#
################################################################################

PYTHON_FS_UPDATER_LIB_VERSION = 0.0.1
PYTHON_FS_UPDATER_LIB_SETUP_TYPE = setuptools
PYTHON_FS_UPDATER_LIB_SOURCE = fs_updater_lib-0.0.1.tar.gz
PYTHON_FS_UPDATER_LIB_SITE = $(TOPDIR)/dl/python-fs-updater-libs
PYTHON_FS_UPDATER_LIB_SITE_METHOD = file
PYTHON_FS_UPDATER_LIB_LICENSE = MIT

$(eval $(python-package))
