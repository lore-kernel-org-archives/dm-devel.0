From: meyering@sourceware.org
Subject: device-mapper ./WHATS_NEW lib/.exported_symbol ...
Date: 28 Jul 2007 10:48:37 -0000
Message-ID: <20070728104837.20636.qmail@sourceware.org>
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
Changes by:	meyering@sourceware.org	2007-07-28 10:48:37

Modified files:
	.              : WHATS_NEW 
	lib            : .exported_symbols libdevmapper.h libdm-file.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	Export dm_create_dir (was create_dir) to help fix LVM2 link error
	* lib/libdm-file.c (dm_create_dir): Rename from create_dir.
	* lib/libdevmapper.h (dm_create_dir): Declare.
	* lib/.exported_symbols: Add dm_create_dir.
	* lib/ioctl/libdm-iface.c (_create_control): Update sole use.
	Patch by Jun'ichi Nomura.  Details in
	http://www.redhat.com/archives/lvm-devel/2007-July/msg00040.html

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.195&r2=1.196
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/.exported_symbols.diff?cvsroot=dm&r1=1.30&r2=1.31
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdevmapper.h.diff?cvsroot=dm&r1=1.71&r2=1.72
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-file.c.diff?cvsroot=dm&r1=1.7&r2=1.8
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.44&r2=1.45

--- device-mapper/WHATS_NEW	2007/07/28 10:27:34	1.195
+++ device-mapper/WHATS_NEW	2007/07/28 10:48:36	1.196
@@ -1,5 +1,6 @@
 Version 1.02.22 - 
 ================================
+  Export dm_create_dir (was create_dir) to help fix LVM2 link error
   Don't log mkdir fail-with-EROFS, to make create_dir equiv to the one in LVM2
   Introduce and use log_sys_* macros from LVM2
   dm_fclose: new function
--- device-mapper/lib/.exported_symbols	2007/07/24 14:15:45	1.30
+++ device-mapper/lib/.exported_symbols	2007/07/28 10:48:36	1.31
@@ -1,6 +1,7 @@
 dm_lib_release
 dm_lib_exit
 dm_driver_version
+dm_create_dir
 dm_fclose
 dm_get_library_version
 dm_log
--- device-mapper/lib/libdevmapper.h	2007/07/24 14:15:45	1.71
+++ device-mapper/lib/libdevmapper.h	2007/07/28 10:48:36	1.72
@@ -629,6 +629,12 @@
  **************************/
 
 /*
+ * Create a directory (with parent directories if necessary).
+ * Returns 1 on success, 0 on failure.
+ */
+int dm_create_dir(const char *dir);
+
+/*
  * Close a stream, with nicer error checking than fclose's.
  * Derived from gnulib's close-stream.c.
  *
--- device-mapper/lib/libdm-file.c	2007/07/28 10:27:34	1.7
+++ device-mapper/lib/libdm-file.c	2007/07/28 10:48:36	1.8
@@ -55,7 +55,7 @@
 	return r;
 }
 
-int create_dir(const char *dir)
+int dm_create_dir(const char *dir)
 {
 	struct stat info;
 
--- device-mapper/lib/ioctl/libdm-iface.c	2007/07/28 10:23:02	1.44
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/07/28 10:48:36	1.45
@@ -225,7 +225,7 @@
 		return 0;
 
 	old_umask = umask(0022);
-	ret = create_dir(dm_dir());
+	ret = dm_create_dir(dm_dir());
 	umask(old_umask);
 
 	if (!ret)
