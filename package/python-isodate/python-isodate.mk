################################################################################
#
# python-isodate
#
################################################################################

PYTHON_ISODATE_VERSION = 0.6.0
PYTHON_ISODATE_SOURCE = isodate-$(PYTHON_ISODATE_VERSION).tar.gz
PYTHON_ISODATE_SITE = https://files.pythonhosted.org/packages/b1/80/fb8c13a4cd38eb5021dc3741a9e588e4d1de88d895c1910c6fc8a08b7a70
PYTHON_ISODATE_SETUP_TYPE = setuptools

$(eval $(python-package))
