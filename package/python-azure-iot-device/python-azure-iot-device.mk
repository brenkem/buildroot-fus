################################################################################
#
# python-azure-iot-device
#
################################################################################

PYTHON_AZURE_IOT_DEVICE_VERSION = 2.2.0
PYTHON_AZURE_IOT_DEVICE_SOURCE = azure-iot-device-$(PYTHON_AZURE_IOT_DEVICE_VERSION).tar.gz
PYTHON_AZURE_IOT_DEVICE_SITE = https://files.pythonhosted.org/packages/90/e0/beaa49ab090de249111a61865d3a8fc75df7f949292df2053e12c01f94b6
PYTHON_AZURE_IOT_DEVICE_SETUP_TYPE = setuptools
PYTHON_AZURE_IOT_DEVICE_LICENSE = MIT

$(eval $(python-package))
