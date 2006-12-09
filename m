From: Bernard Pidoux <pidoux@ccr.jussieu.fr>
Subject: dm_mirror and dm_mod
Date: Sat, 09 Dec 2006 23:44:18 +0100
Message-ID: <457B3C42.4010002@ccr.jussieu.fr>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jonathan E Brassow <jbrassow@redhat.com>, Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi,

In kernel 2.6.19 and 2.6.18.5 I am facing a problem with modules
dm_mirror and dm_mod not found.

These two modules are part of

Multiple devices driver support (RAID and LVM)
    Device mapper support
        Mirror target (EXPERIMENTAL)

which I validated.

Compile process built dm-mirror.ko and dm-mod.ko

make install complained that dm_mirror and dm_mod where not found.
Thus I guessed that the modules where incorrectly named.

I only patched Makefile for dm_mirror module name to verify my hypothesis=
.

--- linux/drivers/md/Makefile.old     2006-12-03 15:38:24.000000000 +0100
+++ linux/drivers/md/Makefile 2006-12-03 15:39:21.000000000 +0100
@@ -6,7 +6,7 @@
                   dm-ioctl.o dm-io.o kcopyd.o
 dm-multipath-objs :=3D dm-hw-handler.o dm-path-selector.o dm-mpath.o
 dm-snapshot-objs :=3D dm-snap.o dm-exception-store.o
-dm-mirror-objs :=3D dm-log.o dm-raid1.o
+dm_mirror-objs :=3D dm-log.o dm-raid1.o
 md-mod-objs     :=3D md.o bitmap.o
 raid456-objs   :=3D raid5.o raid6algos.o raid6recov.o raid6tables.o \
                   raid6int1.o raid6int2.o raid6int4.o \
@@ -34,7 +34,7 @@
 obj-$(CONFIG_DM_MULTIPATH)     +=3D dm-multipath.o dm-round-robin.o
 obj-$(CONFIG_DM_MULTIPATH_EMC) +=3D dm-emc.o
 obj-$(CONFIG_DM_SNAPSHOT)      +=3D dm-snapshot.o
-obj-$(CONFIG_DM_MIRROR)                +=3D dm-mirror.o
+obj-$(CONFIG_DM_MIRROR)                +=3D dm_mirror.o
 obj-$(CONFIG_DM_ZERO)          +=3D dm-zero.o

 quiet_cmd_unroll =3D UNROLL  $@
-

Then make modules

.....
  CC [M]  drivers/md/bitmap.o
  LD [M]  drivers/md/md-mod.o
  LD [M]  drivers/md/dm-mod.o
  LD [M]  drivers/md/dm_mirror.o
  Building modules, stage 2.
  MODPOST 546 modules
WARNING: Can't handle masks in drivers/ide/pci/atiixp:FFFF05
  CC      drivers/md/dm-mod.mod.o
  LD [M]  drivers/md/dm-mod.ko
  CC      drivers/md/dm_mirror.mod.o
  LD [M]  drivers/md/dm_mirror.ko
  CC      drivers/md/linear.mod.o
  LD [M]  drivers/md/linear.ko
  CC      drivers/md/md-mod.mod.o
  LD [M]  drivers/md/md-mod.ko
.....

make install_modules

  INSTALL drivers/md/dm-mod.ko
  INSTALL drivers/md/dm_mirror.ko
  INSTALL drivers/md/linear.ko
  INSTALL drivers/md/md-mod.ko

make install

sh /usr/src/linux-2.6.19/arch/i386/boot/install.sh 2.6.19
arch/i386/boot/bzImage System.map "/boot"
FATAL: Module dm_mirror not found.
FATAL: Module dm_mirror not found.
FATAL: Module dm_mod not found.
FATAL: Module dm_mod not found.

However, I checked that modules where in
/lib/modules/2.6.1.9.kernel/drivers/md/

ll /lib/modules/2.6.19/kernel/drivers/md/
total 169
-rw-r--r-- 1 root root 21879 d=E9c  8 15:12 dm_mirror.ko
-rw-r--r-- 1 root root 58701 d=E9c  8 15:12 dm-mod.ko
-rw-r--r-- 1 root root  6727 d=E9c  8 15:12 linear.ko
-rw-r--r-- 1 root root 80744 d=E9c  8 15:12 md-mod.ko

Thus, Makefile script is probably looking into the wrong directory to
find modules dm_mirror and dm_mod

Due to a lack of knowledge, I was not able to determine the actual
directory where make was looking nor to find out in which script part I
could change this.

Any idea ?


Bernard Pidoux
