import subprocess as sp
import os, parted, shutil, pathlib

###
# This script expects following variables:
# RAUC_BINARY ="/path/to/rauc/binary"
# RAUC_CERT = "/path/to/rauc/cert"
# RAUC_KEY = "/path/to/rauc/key"
# RAUC_IMG = "/path/to/out/image/wic"
# RAUC_TEMPLATE = "/path/to/rauc/template"
#

identify_partition_by_position = dict()
###################################
# Here youc can adapt the partition layout; ONLY EMMC
identify_partition_by_position[1] = "uboot.img"
identify_partition_by_position[5] = "boot.vfat"
identify_partition_by_position[7] = "rootfs.squashfs"

##################################

if "RAUC_BINARY" not in os.environ.keys():
    print("Variable RAUC_BINARY is not defined")
    exit(1)

elif "RAUC_CERT" not in os.environ.keys():
    print("Variable RAUC_CERT not defined")
    exit(1)

elif "RAUC_KEY" not in os.environ.keys():
    print("Variable RAUC_KEY not defined")
    exit(1)

elif "RAUC_TEMPLATE_NAND" not in os.environ.keys():
    print("Variable RAUC_TEMPLATE_NAND not defined")
    exit(1)

elif "RAUC_TEMPLATE_MMC" not in os.environ.keys():
    print("Variable RAUC_TEMPLATE_MMC not defined")
    exit(1)

elif "RAUC_PATH_TO_OUTPUT" not in os.environ.keys():
    print("Variable RAUC_PATH_TO_OUTPUT is not defined")
    exit(1)

path_to_rauc = os.environ["RAUC_BINARY"]
path_to_cert = os.environ["RAUC_CERT"]
path_to_key = os.environ["RAUC_KEY"]

# nand rauc output

input_dir   = os.path.join(os.environ["RAUC_TEMPLATE_MMC"], "*")

dest_dir = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update")
pathlib.Path(dest_dir).mkdir(parents=True, exist_ok=True)

handle = sp.Popen(f"cp -r {input_dir} {dest_dir}", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy from {input_dir} to {dest_dir} are not successfull: \n {error_msg}"))

shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], "Image"), os.path.join(dest_dir, "Image.img"))
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], "boot.vfat"), os.path.join(dest_dir, "boot.vfat"))
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], "rootfs.squashfs"), os.path.join(dest_dir, "rootfs.squashfs"))

input_dir = dest_dir
output_file = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update_emmc.artifact")

try:
    os.remove(output_file)
except:
    pass

handle = sp.Popen(f"{path_to_rauc} bundle --key {path_to_key} --cert {path_to_cert} {input_dir} {output_file}", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("UTF-8").rstrip()
    argument = f"{path_to_rauc} bundle --key {path_to_key} --cert {path_to_cert} {input_dir} {output_file}"
    raise(Exception(f"Error in creating RAUC update package: {error_msg} \n argument: {argument}"))

shutil.rmtree(input_dir)

# mmc rauc output

input_dir   = os.path.join(os.environ["RAUC_TEMPLATE_NAND"], "*")
dest_dir = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update")

dest_dir = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update")
pathlib.Path(dest_dir).mkdir(parents=True, exist_ok=True)

handle = sp.Popen(f"cp -r {input_dir} {dest_dir}", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy from {input_dir} to {dest_dir} are not successfull: \n {error_msg}"))


shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], "Image"), os.path.join(dest_dir, "Image.img"))
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], "picocoremx8mm.dtb"), os.path.join(dest_dir, "picocoremx8mm.dtb.img"))
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], "rootfs.squashfs"), os.path.join(dest_dir, "rootfs.squashfs"))

input_dir = dest_dir
output_file = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update_nand.artifact")

try:
    os.remove(output_file)
except:
    pass

handle = sp.Popen(f"{path_to_rauc} bundle --key {path_to_key} --cert {path_to_cert} {input_dir} {output_file}", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("UTF-8").rstrip()
    argument = f"{path_to_rauc} bundle --key {path_to_key} --cert {path_to_cert} {input_dir} {output_file}"
    raise(Exception(f"Error in creating RAUC update package: {error_msg} \n argument: {argument}"))

shutil.rmtree(input_dir)

