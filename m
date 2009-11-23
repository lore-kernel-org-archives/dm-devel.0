From: bmarzins@sourceware.org
Subject: multipath-tools/libmultipath discovery.c
Date: 23 Nov 2009 21:08:34 -0000
Message-ID: <20091123210834.23464.qmail@sourceware.org>
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
Module name:	multipath-tools
Branch: 	RHEL5_FC6
Changes by:	bmarzins@sourceware.org	2009-11-23 21:08:34

Modified files:
	libmultipath   : discovery.c 

Log message:
	Fix for 527754. multipathd no longer waits for sysfs to create
	/sys/block/<devname>/device/state

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/multipath-tools/libmultipath/discovery.c.diff?cvsroot=dm&only_with_tag=RHEL5_FC6&r1=1.32.2.8&r2=1.32.2.9

--- multipath-tools/libmultipath/discovery.c	2009/06/08 21:38:02	1.32.2.8
+++ multipath-tools/libmultipath/discovery.c	2009/11/23 21:08:34	1.32.2.9
@@ -197,7 +197,7 @@
 }
 #endif
 
-#define declare_sysfs_get_str(fname, fmt) \
+#define declare_sysfs_get_str(fname, fmt, dowait) \
 extern int \
 sysfs_get_##fname (char * sysfs_path, char * dev, char * buff, int len) \
 { \
@@ -207,7 +207,7 @@
 	if (safe_sprintf(attr_path, fmt, sysfs_path, dev)) \
 		return 1; \
 \
-	if (wait_for_file(attr_path)) \
+	if (dowait && wait_for_file(attr_path)) \
 		return 1; \
 \
 	if (!(attr = sysfs_open_attribute(attr_path))) \
@@ -228,14 +228,14 @@
 	return 1; \
 }
 
-declare_sysfs_get_str(devtype, "%s/block/%s/device/devtype");
-declare_sysfs_get_str(cutype, "%s/block/%s/device/cutype");
-declare_sysfs_get_str(vendor, "%s/block/%s/device/vendor");
-declare_sysfs_get_str(model, "%s/block/%s/device/model");
-declare_sysfs_get_str(rev, "%s/block/%s/device/rev");
-declare_sysfs_get_str(dev, "%s/block/%s/dev");
-declare_sysfs_get_str(bustype, "%s/block/%s/device/bus");
-declare_sysfs_get_str(state, "%s/block/%s/device/state");
+declare_sysfs_get_str(devtype, "%s/block/%s/device/devtype", 1);
+declare_sysfs_get_str(cutype, "%s/block/%s/device/cutype", 1);
+declare_sysfs_get_str(vendor, "%s/block/%s/device/vendor", 1);
+declare_sysfs_get_str(model, "%s/block/%s/device/model", 1);
+declare_sysfs_get_str(rev, "%s/block/%s/device/rev", 1);
+declare_sysfs_get_str(dev, "%s/block/%s/dev", 1);
+declare_sysfs_get_str(bustype, "%s/block/%s/device/bus", 1);
+declare_sysfs_get_str(state, "%s/block/%s/device/state", 0);
 
 int
 sysfs_get_size (char * sysfs_path, char * dev, unsigned long long * size)
