From: agk@sourceware.org
Subject: device-mapper ./INSTALL ./WHATS_NEW ./configur ...
Date: 21 Aug 2007 18:42:00 -0000
Message-ID: <20070821184200.27783.qmail@sourceware.org>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-cvs@sourceware.org, dm-devel@redhat.com
List-Id: dm-devel.ids

CVSROOT:	/cvs/dm
Module name:	device-mapper
Changes by:	agk@sourceware.org	2007-08-21 18:41:59

Modified files:
	.              : INSTALL WHATS_NEW configure configure.in 
	lib            : Makefile.in 
Removed files:
	lib/fs         : libdevmapper.c libdm-targets.h 

Log message:
	Remove obsolete dmfs code from tree and update INSTALL.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/INSTALL.diff?cvsroot=dm&r1=1.20&r2=1.21
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.202&r2=1.203
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.diff?cvsroot=dm&r1=1.42&r2=1.43
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/configure.in.diff?cvsroot=dm&r1=1.44&r2=1.45
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/Makefile.in.diff?cvsroot=dm&r1=1.34&r2=1.35
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/fs/libdevmapper.c.diff?cvsroot=dm&r1=1.15&r2=NONE
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/fs/libdm-targets.h.diff?cvsroot=dm&r1=1.3&r2=NONE

--- device-mapper/INSTALL	2004/03/31 20:09:56	1.20
+++ device-mapper/INSTALL	2007/08/21 18:41:58	1.21
@@ -1,4 +1,4 @@
-Device Mapper installation
+Device Mapper Installation
 ==========================
 
 1) Generate custom makefiles.
@@ -8,8 +8,10 @@
    Example:
    ./configure
 
-   If your 2.4 kernel does NOT yet contain the device-mapper source
-   AND you want to try patching it automatically (described 
+   2.6 kernels now already contain basic device-mapper patches.
+
+   If you are using a 2.4 kernel that does NOT contain the device-mapper
+   mapper source AND you want to try patching it automatically (described 
    in step 2) then you need to tell 'configure' where your kernel 
    source directory is using --with-kernel-dir.  Otherwise, don't
    supply this parameter or you may get compilation failures.
@@ -17,8 +19,6 @@
    Example:  
    ./configure --with-kernel-dir=/usr/src/linux-2.4.26-rc1
 
-   2.6 kernels now already contain basic device-mapper patches
-   BUT they do not support snapshots and pvmove yet.
 
    The same userspace library and tools work with both 2.4 and 2.6 kernels
    because they share the same device-mapper interface (version 4).
@@ -31,7 +31,9 @@
    Other parameters let you change the installation & working directories.
 
 
-2) If your kernel does not already contain device-mapper, patch,
+2) ONLY FOR 2.4 KERNELS:
+
+   If your kernel does not already contain device-mapper, patch,
    configure and build a new kernel with it.
 
    If there is a patch for your kernel included in this package and you
@@ -77,45 +79,24 @@
    The DESTDIR environment variable is supported (e.g. for packaging).
 
 
-4) If you are not using devfs then install scripts/devmap_mknod.sh to run
-   either:
-
-      Each time the kernel boots 
-        e.g. add to /etc/rc*
-
-      Or whenever the device-mapper is loaded (if you built it as a module)
-        e.g. add the following line to /etc/modules.conf and run depmod -a
-	     and use modprobe dm-mod to load the module
-	post-install dm-mod /etc/init.d/devmap_mknod.sh
-	
-   The script creates the /dev/mapper/control device for the ioctl
-   interface using the major and minor numbers that have been allocated
-   dynamically.  It prints a message if it works or else it fails silently 
-   with a non-zero status code (which you probably want to test for).
-
-   To clean up the /dev/mapper directory (e.g. to remove invalid entries
-   left behind after a crash) run:
-
-      dmsetup mknodes
-
-
-5) You can now boot your new kernel and use 'dmsetup' to test the API.
+4) You can now use 'dmsetup' to test the API.
    Read the dmsetup man page for more information.
-   Or proceed to install the new LVM2 tools.
+   Or proceed to install the LVM2 tools.
 
 
-Note if you are upgrading from an old release
-=============================================
+Note if you are upgrading from a very old release
+=================================================
    /dev/mapper was called /dev/device-mapper prior to 0.96.04.
-   Consequently scripts/devmap_mknod.sh has been updated.
+   Consequently scripts/devmap_mknod.sh has been updated,
+   but this script is now obsolete because its functionality has
+   been incorporated into the library.
+
 
-Notes about the alternative filesystem interface
-================================================
-The original 2.4 filesystem interface has not been updated for many
-months, requires an old kernel, and is missing lots of features.
-
-A new filesystem interface was developed which mapped device-mapper
-operations into filesystem operations, but work on this has stopped.
-Look for "dmfs" patches at:
-   http://people.sistina.com/~thornber/patches/
+Notes about the alternative device-mapper filesystem interface
+==============================================================
+The original 2.4 "dmfs" filesystem interface which mapped
+device-mapper operations into filesystem operations has been
+abandoned.  It requires a very old kernel and is missing lots of
+features.  The userspace code (lib/fs in CVS) was finally
+removed from the tree in 1.02.23.
 
--- device-mapper/WHATS_NEW	2007/08/21 17:03:07	1.202
+++ device-mapper/WHATS_NEW	2007/08/21 18:41:58	1.203
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Remove obsolete dmfs code from tree and update INSTALL.
 
 Version 1.02.22 - 21st August 2007
 ==================================
--- device-mapper/configure	2007/08/14 19:11:31	1.42
+++ device-mapper/configure	2007/08/21 18:41:58	1.43
@@ -1316,7 +1316,7 @@
   --with-kernel-dir=DIR   linux kernel source in DIR
   --with-kernel-version=VERSION   linux kernel version
   --with-tmp-dir=DIR      temp dir to make kernel patches [/tmp/kerndiff]
-  --with-interface=IFACE  Choose kernel interface (ioctl or fs) [ioctl]
+  --with-interface=IFACE  Choose kernel interface (ioctl) [ioctl]
   --with-dmeventd-pidfile=PATH    dmeventd pidfile [/var/run/dmeventd.pid]
   --with-dmeventd-path=PATH       dmeventd path [${exec_prefix}/sbin/dmeventd]
 
@@ -6492,10 +6492,10 @@
    interface=ioctl
 fi
 
-if [ "x$interface" != xfs -a "x$interface" != xioctl ];
+if [ "x$interface" != xioctl ];
 then
-  { { echo "$as_me:$LINENO: error: --with-interface=ioctl or --with-interface=fs required" >&5
-echo "$as_me: error: --with-interface=ioctl or --with-interface=fs required" >&2;}
+  { { echo "$as_me:$LINENO: error: --with-interface=ioctl required. fs no longer supported." >&5
+echo "$as_me: error: --with-interface=ioctl required. fs no longer supported." >&2;}
    { (exit 1); exit 1; }; }
 fi
 { echo "$as_me:$LINENO: result: $interface" >&5
--- device-mapper/configure.in	2007/08/14 19:11:31	1.44
+++ device-mapper/configure.in	2007/08/21 18:41:58	1.45
@@ -340,15 +340,15 @@
 fi
 
 ################################################################################
-dnl -- which kernel interface to use (ioctl or fs)
+dnl -- which kernel interface to use (ioctl only)
 AC_MSG_CHECKING(for kernel interface choice)
 AC_ARG_WITH(interface,
-  [  --with-interface=IFACE  Choose kernel interface (ioctl or fs) [[ioctl]] ],
+  [  --with-interface=IFACE  Choose kernel interface (ioctl) [[ioctl]] ],
   [ interface="$withval" ],
   [ interface=ioctl ])
-if [[ "x$interface" != xfs -a "x$interface" != xioctl ]];
+if [[ "x$interface" != xioctl ]];
 then
-  AC_MSG_ERROR(--with-interface=ioctl or --with-interface=fs required)
+  AC_MSG_ERROR(--with-interface=ioctl required. fs no longer supported.)
 fi
 AC_MSG_RESULT($interface)
 
--- device-mapper/lib/Makefile.in	2007/08/21 16:26:06	1.34
+++ device-mapper/lib/Makefile.in	2007/08/21 18:41:58	1.35
@@ -48,7 +48,7 @@
 include ../make.tmpl
 
 .PHONY: install_dynamic install_static install_include \
-	install_fs install_ioctl install_ioctl_static \
+	install_ioctl install_ioctl_static \
 	install_pkgconfig
 
 INSTALL_TYPE = install_dynamic
@@ -74,10 +74,6 @@
 install_static: install_@interface@_static
 	$(LN_S) -f libdevmapper.a.$(LIB_VERSION) $(libdir)/libdevmapper.a
 
-install_fs: fs/libdevmapper.$(LIB_SUFFIX)
-	$(INSTALL) -D $(OWNER) $(GROUP) -m 555 $(STRIP) $< \
-		$(libdir)/libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
-
 install_ioctl: ioctl/libdevmapper.$(LIB_SUFFIX)
 	$(INSTALL) -D $(OWNER) $(GROUP) -m 555 $(STRIP) $< \
 		$(libdir)/libdevmapper.$(LIB_SUFFIX).$(LIB_VERSION)
