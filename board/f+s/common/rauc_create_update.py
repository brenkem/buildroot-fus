import subprocess as sp
import os, parted, shutil, pathlib
import sys

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

kernel_image_name=str(sys.argv[1])[1:-1]
print("Info: kernel image", kernel_image_name)
dt_image_name=str(sys.argv[2])
print("Info: device tree name", dt_image_name)

# mmc rauc output

input_dir   = os.path.join(os.environ["RAUC_TEMPLATE_MMC"], "*")

dest_dir = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update")
pathlib.Path(dest_dir).mkdir(parents=True, exist_ok=True)

work_dir = input_dir[0:-1]
template_dir = input_dir[0:-1] + "../"
print("Info: Create rauc manifest compatible", work_dir)
# create manifest.raucm from manifest template
handle = sp.Popen(f"cp -f {template_dir}/manifest.template {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy from manifest.template is not successful: \n {error_msg}"))

# define compatible string
compatible = str(sys.argv[3])
print("Info: Create rauc manifest compatible", compatible)
handle = sp.Popen(f"sed -i \"s/<compatible>/\"{compatible}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <compatible> string is not successful: \n {error_msg}"))

# define compatible string
update_version = str(sys.argv[4])
print("Info: Create rauc manifest update_version", update_version)
handle = sp.Popen(f"sed -i \"s/<version>/\"{update_version}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <version> string is not successful: \n {error_msg}"))

# define in image.boot filename -> boot.vat image
manifest_vfat_name = "boot.vfat"
print("Info: Create rauc manifest bootimage", manifest_vfat_name)
handle = sp.Popen(f"sed -i \"s/<bootimage>/\"{manifest_vfat_name}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <bootimage> string is not successful: \n {error_msg}"))

handle = sp.Popen(f"cp -r {input_dir} {dest_dir}", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy from {input_dir} to {dest_dir} are not successfull: \n {error_msg}"))
# remove quote from kernel name
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], kernel_image_name), os.path.join(dest_dir, kernel_image_name + ".img"))
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

# nand rauc output

input_dir   = os.path.join(os.environ["RAUC_TEMPLATE_NAND"], "*")
dest_dir = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update")

dest_dir = os.path.join(os.environ["DEPLOY_DIR_IMAGE"], "rauc_update")
pathlib.Path(dest_dir).mkdir(parents=True, exist_ok=True)

work_dir = input_dir[0:-1]
template_dir = input_dir[0:-1] + "../"
print("Info: Create rauc manifest compatible", template_dir)
# create manifest.raucm from manifest template
handle = sp.Popen(f"cp -f {template_dir}/manifest.template {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy of template manifest.template is not successful: \n {error_msg}"))

# create install-check from template
handle = sp.Popen(f"cp -f {template_dir}/install-check {work_dir}/install-check", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy of template install-check is not successful: \n {error_msg}"))


# replace placeholder in manifest.raucm with required values

# define in image.boot filename -> kernel
manifest_kernel_name = kernel_image_name + ".img"
print("Info: Create rauc manifest bootimage", manifest_kernel_name)
handle = sp.Popen(f"sed -i \"s/<bootimage>/\"{manifest_kernel_name}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <bootimage> string is not successful: \n {error_msg}"))

# add block [boot.fdt]
# [image.fdt]
# filename=<dtb>
# hooks=post-install;

# Open a file with access mode 'a'
with open(f"{work_dir}/manifest.raucm", "a") as file_object:
    file_object.write("\n[image.fdt]\n")
    file_object.write("filename=<dtb>\n")
    file_object.write("hooks=post-install;\n")


# define in image.fdt filename -> dtb
manifest_dtb_name = dt_image_name + ".dtb.img"
print("Info: Create rauc manifest dtb", manifest_dtb_name)
handle = sp.Popen(f"sed -i \"s/<dtb>/\"{manifest_dtb_name}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <dtb> string is not successful: \n {error_msg}"))

# define compatible string
compatible = str(sys.argv[3])
print("Info: Create rauc manifest compatible", compatible)
handle = sp.Popen(f"sed -i \"s/<compatible>/\"{compatible}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <compatible> string is not successful: \n {error_msg}"))

# define compatible string
update_version = str(sys.argv[4])
print("Info: Create rauc manifest update_version", update_version)
handle = sp.Popen(f"sed -i \"s/<version>/\"{update_version}\"/g\" {work_dir}/manifest.raucm", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <version> string is not successful: \n {error_msg}"))

# Create install-check.sh for nand only because of
# kernel and device tree 

# define in <kernel>
manifest_kernel_name = kernel_image_name + ".img"
print("Info: Create rauc install check script kernel", manifest_kernel_name)
handle = sp.Popen(f"sed -i \"s/<kernel>/\"{manifest_kernel_name}\"/g\" {work_dir}/install-check", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <bootimage> string is not successful: \n {error_msg}"))

# define in image.fdt filename -> dtb
manifest_dtb_name = dt_image_name + ".dtb.img"
print("Info: Create rauc manifest dtb", manifest_dtb_name)
handle = sp.Popen(f"sed -i \"s/<dtb>/\"{manifest_dtb_name}\"/g\" {work_dir}/install-check", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"Replacing of <dtb> string is not successful: \n {error_msg}"))



handle = sp.Popen(f"cp -r {input_dir} {dest_dir}", shell=True, stderr=sp.PIPE)
handle.wait()
if handle.returncode != 0:
    error_msg = handle.stderr.read().decode("ASCII").rstrip()
    raise(Exception(f"The copy from {input_dir} to {dest_dir} are not successfull: \n {error_msg}"))

print("Info: device tree name", dt_image_name)
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], kernel_image_name), os.path.join(dest_dir, kernel_image_name + ".img"))
shutil.copyfile(os.path.join(os.environ["RAUC_PATH_TO_OUTPUT"], dt_image_name + ".dtb"), os.path.join(dest_dir, dt_image_name + ".dtb.img"))
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

