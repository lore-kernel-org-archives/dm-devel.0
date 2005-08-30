From: "Lin, Weichuan" <weichuan.lin@intel.com>
Subject: ioctl failed when parted operated on device active by
	dmraid?
Date: Tue, 30 Aug 2005 12:38:53 +0800
Message-ID: <571ACEFD467F7749BC50E0A98C17CDD807BD35D0@pdsmsx403>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <dm-devel-bounces@redhat.com>
Content-class: urn:content-classes:message
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Hi All

I have a machine with chips of silicon image 3114 and ICH7R on the
motherboard [I can choose one of them to connect the hard disk], and two
SATA hard disks, I am going to enable one of this chips at Fedora
installation stage. What I have done is copy the dmraid static link
version to stage2.img of anaconda, and patched the patch below to
anaconda. This patch is gotten from the mail list of anaconda; I just
changed the regular expression match [parameter of re.match()] to meet
the actual output of the dmraid on my machine. After done this, I can
choose the device of /dev/mapper/sil* to slice partition for
installation. But the operation of parted always fails, I have trace
into the program, and find that ped_disk_commit_to_os() failed due to
failure of ioctl with BLKPG request. The error is reported as Invalid
argument, then an exception is thrown in function of
_blkpg_add_partition(). The installation procedure has to hang due to
this failure.=20

On the other hand, if I use parted on an installed system to slice
partition on /dev/mapper/sil* created by dmraid, parted also complains
that he can't notify to the system about the change of the disk
partition. If I connect the hard disks to the ICH7R chips, the dmraid
even can't create /dev/mapper/isw*. With -tay option, dmraid told me
that the GROUP ok, but the device can't be seen under /dev/mapper.

Here is the patch provided by Wormgoor, which enable the support of
dmraid during anaconda installer running, with a little change of
regular
expression match and argument.=20

+# dmraid.py - dmraid probing
+#
+# Mark Wormgoor <mark wormgoor com>
+#
+# Copyright 2004 Mark Wormgoor
+#
+# This software may be freely redistributed under the terms of the GNU
+# general public license.
+#
+# You should have received a copy of the GNU General Public License
+# along with this program; if not, write to the Free Software
+# Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
+
+import iutil
+import os
+import re
+
+from constants import *
+
+output =3D "/tmp/dmraidout"
+
+dmraidDevicePresent =3D 0
+
+def has_dmraid():
+    global dmraidDevicePresent
+
+    if not (os.access("/usr/sbin/dmraid", os.X_OK) or
+            os.access("/sbin/dmraid", os.X_OK)):
+        return
+   =20
+    rc =3D iutil.execWithRedirect("dmraid",
+                                ["dmraid", "-ay"],
+                                stdout =3D output,
+                                stderr =3D output,
+                                searchPath =3D 1)
+    if rc:
+        dmraidDevicePresent =3D 0
+    else:
+	dmraidDevicePresent =3D 1
+
+    return dmraidDevicePresent
+# now check to see if dmraid is available
+has_dmraid()
+       =20
+
+def disklist():
+    global dmraidDevicePresent
+    if dmraidDevicePresent =3D=3D 0:
+        return []
+
+    disks =3D []
+    args =3D ["dmraid", "-vay"]
+    dmraidscanout =3D iutil.execWithCapture(args[0], args, searchPath =3D
1,
+                                      stderr =3D "/dev/tty6")
+    for line in dmraidscanout.split("\n"):
+        try:
+	    found =3D re.match("/dev/(\S+)", line)
+	    disks.append (found.group(1))
+        except:
+            pass
+
+    return disks
+
+def setlist():
+    global dmraidDevicePresent
+    if dmraidDevicePresent =3D=3D 0:
+        return []
+
+    sets =3D []
+    args =3D ["dmraid", "-vay"]
+    dmraidscanout =3D iutil.execWithCapture(args[0], args, searchPath =3D
1,
+                                      stderr =3D "/dev/tty6")
+    for line in dmraidscanout.split("\n"):
+        try:
+	    found =3D re.match("INFO: added /dev/(\S+) to RAID set
\"(\S+)\"", line)
+	    sets.append (found.group(2))
+        except:
+	    pass
+
+    return sets
diff -ruN mnt/usr/lib/anaconda/isys.py new/usr/lib/anaconda/isys.py
--- mnt/usr/lib/anaconda/isys.py	1970-01-01 01:00:00.000000000
+0100
+++ new/usr/lib/anaconda/isys.py	2004-10-10 21:06:58.000000000
+0200
@@ -20,6 +20,7 @@
 import os
 import os.path
 import posix
+import dmraid
 import sys
 import kudzu
=20
@@ -288,6 +289,20 @@
=20
     dict =3D driveDict("disk")
=20
+    # first, figure out the dmraid devices
+    if dmraid.has_dmraid():
+	disks =3D dmraid.disklist()
+	if len(disks) > 0:
+	    for disk in disks:
+		try:
+		    del dict[disk]
+		except:
+		    pass
+	sets =3D dmraid.setlist()
+	if len (sets) > 0:
+	    for set in sets:
+		dict["mapper/" + set] =3D "DMRAID"
+
     # this is kind of ugly, but it's much easier to do this from python
     for (dev, descr) in dict.items():
         # the only raid devs like this are ide, so only worry about
them
@@ -391,14 +406,28 @@
=20
 def makeDevInode(name, fn=3DNone):
     if fn:
-        _isys.mkdevinode(name, fn)
-        return fn
+        if name[:7] =3D=3D "mapper/":
+            try:
+                os.makedirs(os.path.dirname(fn))
+            except:
+                pass
+            os.symlink("/dev/" + name, fn)
+        else:
+            _isys.mkdevinode(name, fn)
+            return fn
     path =3D '/dev/%s' % (name,)
     try:
         os.stat(path)
     except OSError:
         path =3D '/tmp/%s' % (name,)
-        _isys.mkdevinode(name, path)
+        if name[:7] =3D=3D "mapper/":
+            try:
+                os.makedirs(os.path.dirname(path))
+            except:
+                pass
+            os.symlink("/dev/" + name, path)
+        else:
+            _isys.mkdevinode(name, path)
     return path
=20
 def makedev(major, minor):
@@ -674,9 +703,12 @@
         os.unlink("/tmp/cdrom")
=20
 def driveIsRemovable(device):
+    # DMRaid is always non-removable
     # assume ide if starts with 'hd', and we don't have to create
     # device beforehand since it just reads /proc/ide
-    if device[:2] =3D=3D "hd":
+    if device[:7] =3D=3D "mapper/":
+        rc =3D 0
+    elif device[:2] =3D=3D "hd":
         rc =3D (_isys.isIdeRemovable("/dev/"+device) =3D=3D 1)
     else:
         makeDevInode(device, "/tmp/disk")
diff -ruN mnt/usr/lib/anaconda/mknod-stub
new/usr/lib/anaconda/mknod-stub
--- mnt/usr/lib/anaconda/mknod-stub	1970-01-01 01:00:00.000000000
+0100
+++ new/usr/lib/anaconda/mknod-stub	2004-10-10 21:06:58.000000000
+0200
@@ -25,8 +25,9 @@
         # inode
         while (drive.find('/') !=3D -1):
             if (drive.startswith("cciss") or drive.startswith("ida") or
-                drive.startswith("rd") or drive.startswith("ataraid")
-                or drive.startswith("iseries") or
drive.startswith("i2o")):
+                drive.startswith("rd") or drive.startswith("ataraid")
or
+                drive.startswith("mapper") or
drive.startswith("iseries") or=20
+                drive.startswith("i2o")):
                 break
             drive =3D drive[drive.find('/') + 1:]
         isys.makeDevInode(drive, path)
diff -ruN mnt/usr/lib/anaconda/partedUtils.py
new/usr/lib/anaconda/partedUtils.py
--- mnt/usr/lib/anaconda/partedUtils.py	1970-01-01 01:00:00.000000000
+0100
+++ new/usr/lib/anaconda/partedUtils.py	2004-10-10 21:06:58.000000000
+0200
@@ -117,6 +117,9 @@
         or partition.geom.dev.type =3D=3D parted.DEVICE_CPQARRAY):
         return "%sp%d" % (partition.geom.dev.path[5:],
                           partition.num)
+    elif partition.geom.dev.path[5:12] =3D=3D "mapper/":
+        return "%s_p%d" % (partition.geom.dev.path[5:],
+                          partition.num)
     return "%s%d" % (partition.geom.dev.path[5:],
                      partition.num)
=20
diff -ruN mnt/usr/lib/anaconda/raid.py new/usr/lib/anaconda/raid.py
--- mnt/usr/lib/anaconda/raid.py	1970-01-01 01:00:00.000000000
+0100
+++ new/usr/lib/anaconda/raid.py	2004-10-10 21:06:58.000000000
+0200
@@ -38,6 +38,9 @@
     raidDevices =3D {}
=20
     for d in drives:
+	# Assume dmraid is not part of a md raidset
+	if d[:7] =3D=3D "mapper/":
+	    continue
         parts =3D []
 	isys.makeDevInode(d, "/tmp/" + d)
         try:

Best Regards
Weichuan
