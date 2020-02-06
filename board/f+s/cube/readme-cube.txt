How to build and install rootfs for CubeA5/Cube2.0
--------------------------------------------------

Both versions are built with one set of sources. Even if the
architecture only mentions fsimx6ul, which refers to the i.MX6UL CPU
of Cube2.0, it will also build the Vybrid version needed for CubeA5.

Unpack linux sources to a directory:

  tar xvf linux-4.9.88-fsimx6ul-Byyyy.mm.tar.bz2

This creates directory linux-4.9.88-fsimx6ul-Byyyy.mm, where yyyy.mm
is the year and month of the F&S release. The B indicates a Buildroot
based release.

Then unpack buildroot sources to a separate (!) directory:

  tar xvf buildroot-YYYY.MM-fsimx6ul-Byyyy.mm.tar.bz2

This creates the directory buildroot-YYYY.MM-fsimx6ul-Byyyy.mm where
YYYY.MM is the buildroot version the F&S release is based on, and
Byyyy.mmm is again the F&S release version as above.

Buildroot expects the Linux sources in a directory "linux-fsimx6ul"
next to the buildroot directory. So create the following symbolic
link:

  ln -s linux-4.9.88-fsimx6ul-Byyyy.mm linux-fsimx6ul

Of course replace yyyy.mm in this call with the correct version
reference that was created in the first step above.

(Remark: These steps above can be done automatically by using the
script setup-buildroot provided in the top directory of the
release.)

Now switch to the buildroot directory, configure and build everything:

  cd buildroot-YYYY.MM-fsimx6ul-Byyyy.mm
  make cube_defconfig
  make

This will build all buildroot packages, including the kernel zImage,
the kernel modules (in the rootfs) and the device trees cubea7ul.dtb,
cube2.0.dtb and cubea5.dtb.

After building, the resulting images and the install script are
available in:

  output/images/

The kernel and device tree images will also automatically be
stored in directory /boot in the root filesystem. The install script
already matches the current root filesystem size.

Now copy everything to the place where MFG-Tool can find it. You'll
need:

- uboot-fsvybrid.nb0 or uboot-fsimx6ul.nb0 (either the release version
  or a separately built version)
- rootfs.ubifs
- install-cube.scr

MFG-Tool should execute the following steps:

 1. Erase the flash ('E')
 2. Load install-cube.scr to RAM @ 80300000 ('*')
 3. Detect and verify install-cube.scr ('%')
 4. Load rootfs.ubifs to RAM @ 81000000 ('*')
 5. Detect and verify rootfs.ubifs ('%')
 6. Load either uboot-fsvybrid.nb0 or uboot-fsimx6ul.nb0 to
    RAM @ 80100000 ('*')
 7. Detect and verify U-Boot ('%')
 8. Store U-Boot to flash ('f')
 9. Start U-Boot ('x')

U-Boot will take over, executes install-cube.scr in RAM @ 80300000
and this in turn stores the rootfs (incl. Kernel) on the board.


Tips
----

Buildroot will copy the linux source code from directory
../linux-fsimx6ul (next to buildroot) to buildroot's subdirectory
output/build/linux-custom. To avoid any problems when doing this, you
should keep the original directory ../linux-fsimx6ul always clean,
i.e. do not start a separate configuration or build there. However
modificiations to the source code can (and should) be done there. They
will be copied again to output/build/linux-custom when the kernel is
rebuilt. Be aware that all modifications in output/build/linux-custom
will be deleted when you call "make clean" or similar targets.

You can configure the kernel directly from Buildroot with:

  make linux-menuconfig

Then call

  make

again to rebuild the kernel and the root filesystem. If you change
source code, you can force rebuilding linux again by calling

  make linux-rebuild

Please note that this does not automatically rebuild the root
filesystem. If you want this, too, simply add "all" as a second target
to the call above or issue an additional "make" after the above
command has finished.

If you want to rebuild the Linux kernel completely from scratch by
using the version in ../linux-fsimx6ul, just remove directory
output/build/linux-custom completely. (Again remember to save any
modifications first!) Then the next build process will copy the whole
source tree again and starts a fresh kernel build.
