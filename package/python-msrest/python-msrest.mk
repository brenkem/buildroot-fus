################################################################################
#
# python-msrest
#
################################################################################

PYTHON_MSREST_VERSION = 0.6.19
PYTHON_MSREST_SOURCE = msrest-$(PYTHON_MSREST_VERSION).tar.gz
PYTHON_MSREST_SITE = https://files.pythonhosted.org/packages/6f/ad/fc4dc6c53ec8db010e9acbb1cb6c2626bed9a6646fc5a3383d171affb375
PYTHON_MSREST_SETUP_TYPE = setuptools

$(eval $(python-package))
