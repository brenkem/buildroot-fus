################################################################################
#
# erpc
#
################################################################################

PYTHON_ERPC_VERSION = 1.7.0
PYTHON_ERPC_SITE = https://github.com/EmbeddedRPC/erpc/archive
PYTHON_ERPC_SOURCE = $(PYTHON_ERPC_VERSION).tar.gz
PYTHON_ERPC_LICENSE = PROPRIETARY
PYTHON_ERPC_LICENSE_FILES = LICENSE
PYTHON_ERPC_SETUP_TYPE = setuptools
HOST_ERPC_DEPENDENCIES = python-serial
PYTHON_ERPC_SUBDIR = erpc_python

$(eval $(python-package))


