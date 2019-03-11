How to build and install rootfs for CUBEA7UL/Cube2.0
----------------------------------------------------

Unpack linux sources to a directory:

  tar xvf linux-4.9.88-fsimx6ul-Vx.y.tar.bz2

This creates directory linux-4.9.88-fsimx6ul-Vx.y, where x.y is the
version number of the F&S release.

Then unpack buildroot sources to a separate (!) directory:

  tar xvf buildroot-YYYY.MM-f+s-Vx.y.tar.bz2

This creates the directory buildroot-YYYY.MM-f+s-Vx.y where YYYY.MM is
the buildroot version the F&S release is based on, and x.y is again the
release version.

Buildroot expects the Linux sources in a directory "linux-fsimx6ul" next
to the buildroot directory. So create the following symbolic link:

  ln -s linux-4.9.88-fsimx6ul-Vx.y linux-fsimx6ul

Of course replace x.y in this call with the correct version number
that was created in the first step above.

(Remark: These steps above can be done automatically by using the
script setup-buildroot.sh provided in the top directory of the
release.)

Now switch to the buildroot directory, configure and build everything:

  cd buildroot-YYYY.MM-f+s-Vx.y
  make cube_defconfig
  make

This will build all buildroot packages, including the kernel zImage,
the kernel modules (in the rootfs) and the device trees cubea7ul.dtb
and cube2.0.dtb.

After building, the kernel image, device tree and rootfs images are
available in:

  output/images/

However the kernel and device tree images will also automatically be
stored in directory /boot in the root filesystem. It will also
automatically create the script image install-cube.scr in the top
directory of buildroot. This script matches the current root
filesystem size.

Now copy everything to the place where MFG-Tool can find it. You'll
need:

- uboot.nb0 (the release version or a separately built version)
- output/images/rootfs.ubifs
- install-cube.scr

MFG-Tool should execute the following steps:

 1. Erase the flash ('E')
 2. Load install-cubea7ul.scr to RAM @ 80300000 ('*')
 3. Detect and verify install-cube.scr ('%')
 4. Load rootfs.ubifs to RAM @ 81000000 ('*')
 5. Detect and verify rootfs.ubifs ('%')
 6. Load uboot.nb0 to RAM @ 80100000 ('*')
 7. Detect and verify uboot.nb0 ('%')
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
i.e. do not start a separate build there. Any modificiations should be
done in output/build/linux-custom. But be aware that this directory
will be deleted when you call "make clean" or similar targets. So copy
back your source code modifications from output/build/linux-custom to
../linux-fsimx6ul from time to time.

You can configure the kernel directly from Buildroot with:

  make linux-menuconfig

Then call

  make

again to rebuild the kernel and the root filesystem. If you change
source code in output/build/linux-custom, you can force rebuilding
linux again by calling

  make linux-rebuild

Please note that this does not automatically rebuild the root
filesystem. If you want this, too, simply add "all" as a second target
to the call above or issue an additional "make" after the above
command has finished.

If you want to rebuild the Linux kernel completely from scratch by
using the version in ../linux-fsimx6ul, just remove directory
output/build/linux-custom completely. (Again remember to save any
modifications first!) Then the next build process will copy the whole
source tree again and starts a fresh build.
