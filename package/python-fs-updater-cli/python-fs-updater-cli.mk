################################################################################
#
# python-fs-updater-cli
#
################################################################################

PYTHON_FS_UPDATER_CLI_VERSION = 0.0.1
PYTHON_FS_UPDATER_CLI_SETUP_TYPE = setuptools
PYTHON_FS_UPDATER_CLI_SOURCE = fs_updater_cli-0.0.1.tar.gz
PYTHON_FS_UPDATER_CLI_SITE = $(TOPDIR)/dl/python-fs-updater-cli
PYTHON_FS_UPDATER_CLI_SITE_METHOD = file
PYTHON_FS_UPDATER_CLI_LICENSE = MIT

$(eval $(python-package))
