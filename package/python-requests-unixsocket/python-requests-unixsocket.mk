################################################################################
#
# python-requests-unixsocket
#
################################################################################

PYTHON_REQUESTS_UNIXSOCKET_VERSION = 0.2.0
PYTHON_REQUESTS_UNIXSOCKET_SOURCE = requests-unixsocket-$(PYTHON_REQUESTS_UNIXSOCKET_VERSION).tar.gz
PYTHON_REQUESTS_UNIXSOCKET_SITE = https://files.pythonhosted.org/packages/4d/ce/78b651fe0adbd4227578fa432d1bde03b4f4945a70c81e252a2b6a2d895f
PYTHON_REQUESTS_UNIXSOCKET_SETUP_TYPE = setuptools
PYTHON_REQUESTS_UNIXSOCKET_LICENSE = Apache-2.0
PYTHON_REQUESTS_UNIXSOCKET_LICENSE_FILES = LICENSE

$(eval $(python-package))

