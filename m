From: Xose Vazquez Perez <xose.vazquez@gmail.com>
Subject: [PATCH] multipath-tools: remove old multipath/{01_udev,
	02_multipath} scripts
Date: Sat,  5 Nov 2016 00:48:12 +0100
Message-ID: <20161104234812.6414-1-xose.vazquez@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
Cc: device-mapper development <dm-devel@redhat.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>
List-Id: dm-devel.ids

Irrelevant nowadays.

Cc: Christophe Varoqui <christophe.varoqui@opensvc.com>
Cc: device-mapper development <dm-devel@redhat.com>
Signed-off-by: Xose Vazquez Perez <xose.vazquez@gmail.com>
---
 multipath/01_udev      | 50 --------------------------------------------------
 multipath/02_multipath | 32 --------------------------------
 2 files changed, 82 deletions(-)
 delete mode 100755 multipath/01_udev
 delete mode 100755 multipath/02_multipath

diff --git a/multipath/01_udev b/multipath/01_udev
deleted file mode 100755
index c4e4c53..0000000
--- a/multipath/01_udev
+++ /dev/null
@@ -1,50 +0,0 @@
-#!/bin/sh
-#
-cp /sbin/udev $INITRDDIR/sbin/hotplug
-cp /sbin/udevstart $INITRDDIR/sbin/
-cp /bin/mountpoint $INITRDDIR/bin/
-cp /bin/readlink $INITRDDIR/bin/
-
-PROGS="/sbin/udev /sbin/udevstart /bin/mountpoint /bin/readlink"
-LIBS=`ldd $PROGS | grep -v linux-gate.so | sort -u | \
-awk '{print $3}'`
-for i in $LIBS
-do
-	mkdir -p `dirname $INITRDDIR/$i`
-	cp $i $INITRDDIR/$i
-done
-
-#
-# config files
-#
-if [ -d /etc/dev.d ]
-then
-	cp -a /etc/dev.d $INITRDDIR/etc/
-fi
-
-if [ -d /etc/udev ]
-then
-	cp -a /etc/udev $INITRDDIR/etc/
-fi
-
-#
-# run udev from initrd
-#
-cat <<EOF >| $INITRDDIR/scripts/10_udev.sh
-
-cd /
-mount -nt proc proc proc
-mount -nt sysfs sysfs sys
-mount -nt tmpfs tmpfs dev || mount -nt ramfs ramfs dev
-mount -nt tmpfs tmpfs tmp || mount -nt ramfs ramfs tmp
-
-#modprobe dm-mod
-#modprobe dm-multipath
-/sbin/udevstart
-
-umount -n tmp
-umount -n sys
-umount -n proc
-
-sleep 2
-EOF
diff --git a/multipath/02_multipath b/multipath/02_multipath
deleted file mode 100755
index 523f0ef..0000000
--- a/multipath/02_multipath
+++ /dev/null
@@ -1,32 +0,0 @@
-#!/bin/sh
-#
-# store the multipath tool in the initrd
-# hotplug & udev will take care of calling it when appropriate
-# this tool is statically linked against klibc : no additional libs
-#
-cp /sbin/multipath $INITRDDIR/sbin
-cp /sbin/kpartx $INITRDDIR/sbin
-
-#
-# feed the dependencies too
-# scsi_id is dynamicaly linked, so store the libs too
-#
-cp /lib/udev/scsi_id $INITRDDIR/lib/udev/
-cp /bin/mountpoint $INITRDDIR/bin
-
-PROGS="/lib/udev/scsi_id /bin/mountpoint"
-LIBS=`ldd $PROGS | grep -v linux-gate.so | sort -u | \
-awk '{print $3}'`
-for i in $LIBS
-do
-	mkdir -p `dirname $INITRDDIR/$i`
-	cp $i $INITRDDIR/$i
-done
-
-#
-# config file ?
-#
-if [ -f /etc/multipath.conf ]
-then
-	cp /etc/multipath.conf $INITRDDIR/etc/
-fi
-- 
2.10.2
