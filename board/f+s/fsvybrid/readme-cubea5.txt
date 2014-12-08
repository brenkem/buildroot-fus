How to build and install rootfs for CUBEA5, AGATEWAY, HGATEWAY
---------------------------------------------------------------

Unpack linux sources to a directory:

  tar xvf linux-3.0.15-fsvybrid-Vx.y.tar.bz2

This creates directory linux-3.0.15-fsvybrid-Vx.y, where x.y is the
version number of the F&S release.

Then unpack buildroot sources to a separate (!) directory:

  tar xvf buildroot-YYYY.MM-f+s-Vx.y.tar.bz2

This creates the directory buildroot-YYYY.MM-f+s-Vx.y where YYYY.MM is
the buildroot version the F&S release is based on, and x.y is again the
release version.

Buildroot expects the Linux sources in a directory "linux-fsvybrid" next
to the buildroot directory. So create the following symbolic link:

  ln -s linux-3.0.15-fsvybrid-Vx.y linux-fsvybrid

Of course replace x.y in this call with the correct version number
that was created in the first step above.

Now switch to the buildroot directory, configure and build everything:

  cd buildroot-YYYY.MM-f+s-Vx.y
  make cubea5_defconfig
  make

This will build all buildroot packages. It will also build the kernel
and the kernel modules in the separate directory, using configuration
cubea5_defconfig. 

ATTENTION!

When building the kernel from the Buildroot directory for the first
time (or after a "make clean"), this will really use cubea5_defconfig,
not the current .config! This will overwrite any previous .config file
already there! So be sure to save any important modifications of
.config first, for example by calling "make savedefconfig" in the
linux-fsvybrid directory!

After building, the kernel image is available in:

  output/images/uImage

However the kernel image will also automatically be stored in
directory /boot in the root filesystem.

After all is done, you have to call

  board/f+s/fsvybrid/mkinstall-cubea5.bash

to create the install.scr file matching the current root filesystem
size. Now copy everything to the place where MFG-Tool can find it.
You'll need:

- uboot.nb0 (the release version or a separately built version)
- output/images/rootfs.ubifs
- install-cubea5.scr

MFG-Tool should execute the following steps:

 1. Erase the flash ('E')
 2. Load uboot.nb0 to RAM ('*')
 3. Detect and verify uboot.nb0 ('%')
 4. Store U-Boot to flash ('f')
 5. Load install.scr to RAM @ 80300000 ('*')
 6. Detect and verify install.scr ('%')
 7. Load rootfs.ubifs to RAM @ 81000000 ('*')
 8. Detect and verify rootfs.ubifs ('%')
 9. Load U-Boot from flash ('l')
10. Start U-Boot ('x')

U-Boot will take over, executes install.scr in RAM @ 80300000 and this
in turn stores the rootfs (incl. Kernel) on the board.


Tips
----

You can configure the kernel directly from Buildroot with:

  make linux-menuconfig

Then call

  make

again to rebuild the kernel and the root filesystem. If you change the
configuration .config in the kernel directory directly, call

  make linux-rebuild

in Buildroot to rebuild the kernel and root filesystem. If you change
arch/arm/configs/cubea5_defconfig in Linux, call

  make linux-reconfigure

in Buildroot to activate the new configuration file in this build.
