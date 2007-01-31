From: =?iso-8859-1?Q?Lo=EFc?= Minier <lool+redhat@via.ecp.fr>
Subject: Re: Weird discrepancy between /dev/mapper/* and /dev/dm-*
	devices breaks lilo
Date: Wed, 31 Jan 2007 16:54:29 +0100
Message-ID: <20070131155429.GD27755@bee.dooz.org>
References: <20070131104737.GA29370@bee.dooz.org>
	<20070131150635.GB21980@agk.surrey.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="5/uDoXvLw7AC5HRs"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20070131150635.GB21980@agk.surrey.redhat.com>
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


--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Wed, Jan 31, 2007, Alasdair G Kergon wrote:
> Some distributions chose to configure udev to create /dev/dm-N inodes w=
here
> N is the minor number.  (I have always discouraged that as a recipe for
> confusion: I believe that using configurable names is a better approach=
.)

 I seem to recall even RedHat or Fedora attempted to add these devices,
 but I suppose you know best.  The reasons why these were added in udev
 in Debian and Ubuntu are mentionned in http://bugs.debian.org/392623,
 but in short gnome-mount required this to work; perhaps this should be
 fixed in gnome-mount.  The details are in a comment of #401393 though:
  <http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D401393;msg=3D37>

 (attaching the patch I mentionned in the preceding mail but forgot,
 sorry)

--=20
Lo=EFc Minier <lool@dooz.org>

--5/uDoXvLw7AC5HRs
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="lilo_22.7.3-1.4.diff"

--- lilo-22.7.3/debian/patches/00list
+++ lilo-22.7.3/debian/patches/00list
@@ -31,0 +32 @@
+20_devmapper-use-major-minor
--- lilo-22.7.3/debian/changelog
+++ lilo-22.7.3/debian/changelog
@@ -1,3 +1,11 @@
+lilo (1:22.7.3-1.4) unstable; urgency=low
+
+  * Non-maintainer upload.
+  * New dpatch, 20_devmapper-use-major-minor, to address device-mapper devices
+    via major/minor instead of name for DM_DEVICE_TABLE; closes: #401393.
+
+ -- Loic Minier <lool@dooz.org>  Wed, 31 Jan 2007 15:21:06 +0100
+
 lilo (1:22.7.3-1.3) unstable; urgency=low
 
   * Non-maintainer upload to fix a few more l10n issues.
--- lilo-22.7.3.orig/debian/patches/20_devmapper-use-major-minor.dpatch
+++ lilo-22.7.3/debian/patches/20_devmapper-use-major-minor.dpatch
@@ -0,0 +1,22 @@
+#! /bin/sh /usr/share/dpatch/dpatch-run
+## 20_devmapper-use-major-minor.patch.dpatch by Loic Minier <lool@dooz.org>
+##
+## All lines beginning with `## DP:' are a description of the patch.
+## DP: No description.
+
+@DPATCH@
+diff -urNad lilo-22.7.3~/geometry.c lilo-22.7.3/geometry.c
+--- lilo-22.7.3~/geometry.c	2007-01-31 15:20:37.000000000 +0100
++++ lilo-22.7.3/geometry.c	2007-01-31 15:20:43.000000000 +0100
+@@ -930,8 +930,9 @@
+ 	    slash++;
+ 		else
+ 	    slash = dmdev;
+-	    if (!dm_task_set_name(dmt, slash))
+-		die("device-mapper: dm_task_set_name(\"%s\") failed",dmdev);
++	    if (!dm_task_set_major(dmt, MAJOR(device)) ||
++	        !dm_task_set_minor(dmt, MINOR(device)))
++		die("device-mapper: dm_task_set_major() or dm_task_set_minor() failed");
+ 	    if (!dm_task_run(dmt))
+ 		die("device-mapper: dm_task_run(DM_DEVICE_TABLE) failed");
+ 

--5/uDoXvLw7AC5HRs
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--5/uDoXvLw7AC5HRs--
