From: agk@sourceware.org
Subject: device-mapper ./VERSION ./WHATS_NEW dmsetup/dm ...
Date: 5 Dec 2007 17:05:06 -0000
Message-ID: <20071205170506.14534.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 17:05:05

Modified files:
	.              : VERSION WHATS_NEW 
	dmsetup        : dmsetup.c 
	man            : dmsetup.8 

Log message:
	pre-release

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/VERSION.diff?cvsroot=dm&r1=1.128&r2=1.129
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.212&r2=1.213
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.102&r2=1.103
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/man/dmsetup.8.diff?cvsroot=dm&r1=1.20&r2=1.21

--- device-mapper/VERSION	2007/08/21 17:03:07	1.128
+++ device-mapper/VERSION	2007/12/05 17:05:04	1.129
@@ -1 +1 @@
-1.02.23-cvs (2007-08-21)
+1.02.23-cvs (2007-12-05)
--- device-mapper/WHATS_NEW	2007/12/05 14:11:25	1.212
+++ device-mapper/WHATS_NEW	2007/12/05 17:05:04	1.213
@@ -1,13 +1,12 @@
-Version 1.02.23 - 
-==================================
+Version 1.02.23 - 5th December 2007
+===================================
   Update dm-ioctl.h after removal of compat code.
-  Add --readahead to dmsetup.
-  Add external read_ahead library functions and DM_READ_AHEAD_* definitions.
+  Add readahead support to libdevmapper and dmsetup.
   Fix double free in a libdevmapper-event error path.
   Fix configure --with-dmeventd-path substitution.
-  Allow $DM_DEV_DIR envvar to override default of "/dev".
-  Create e.g., libdevmapper.so.1.02, in build dir alongside the .so file.
-  Avoid static link failure with some SELinux libraries.
+  Allow a DM_DEV_DIR environment variable to override /dev.
+  Create a libdevmapper.so.$LIB_VERSION symlink within the build tree.
+  Avoid static link failure with some SELinux libraries that require libpthread.
   Remove obsolete dmfs code from tree and update INSTALL.
 
 Version 1.02.22 - 21st August 2007
--- device-mapper/dmsetup/dmsetup.c	2007/12/05 14:42:10	1.102
+++ device-mapper/dmsetup/dmsetup.c	2007/12/05 17:05:04	1.103
@@ -2194,8 +2194,8 @@
 
 		/* If dev_dir does not end in a slash, ensure that the
 		   following byte in the device string is "/".  */
-		if (dev_dir[strlen(dev_dir) - 1] != '/'
-		    && device[strlen(dev_dir)] != '/')
+		if (dev_dir[strlen(dev_dir) - 1] != '/' &&
+		    device[strlen(dev_dir)] != '/')
 			goto error;
 
 		strncpy(buf, strrchr(device, '/') + 1, (size_t) PATH_MAX);
@@ -2611,12 +2611,11 @@
 	dev_dir = getenv ("DM_DEV_DIR");
 	if (dev_dir && *dev_dir) {
 		if (!dm_set_dev_dir(dev_dir)) {
-			fprintf(stderr, "Invalid DM_DEV_DIR envvar value.\n");
+			fprintf(stderr, "Invalid DM_DEV_DIR environment variable value.\n");
 			goto out;
 		}
-	} else {
+	} else
 		dev_dir = DEFAULT_DM_DEV_DIR;
-	}
 
 	if (!_process_switches(&argc, &argv, dev_dir)) {
 		fprintf(stderr, "Couldn't process command line.\n");
--- device-mapper/man/dmsetup.8	2007/11/29 14:44:28	1.20
+++ device-mapper/man/dmsetup.8	2007/12/05 17:05:04	1.21
@@ -353,7 +353,7 @@
 .TP
 \fBDM_DEV_DIR\fP
 The device directory name.
-Defaults to "/dev" and must be an absolute name.
+Defaults to "/dev" and must be an absolute path.
 
 .SH AUTHORS
 Original version: Joe Thornber (thornber@sistina.com)
