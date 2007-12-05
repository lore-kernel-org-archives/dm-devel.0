From: agk@sourceware.org
Subject: device-mapper ./WHATS_NEW kernel/ioctl/dm-ioct ...
Date: 5 Dec 2007 14:11:27 -0000
Message-ID: <20071205141127.15057.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 14:11:26

Modified files:
	.              : WHATS_NEW 
	kernel/ioctl   : dm-ioctl.h 
	lib            : libdm-common.c 

Log message:
	fix ioctls to use long not int
	update dm-ioctl.h after compat tidy-up

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/WHATS_NEW.diff?cvsroot=dm&r1=1.211&r2=1.212
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/kernel/ioctl/dm-ioctl.h.diff?cvsroot=dm&r1=1.44&r2=1.45
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.53&r2=1.54

--- device-mapper/WHATS_NEW	2007/11/27 20:57:04	1.211
+++ device-mapper/WHATS_NEW	2007/12/05 14:11:25	1.212
@@ -1,5 +1,6 @@
 Version 1.02.23 - 
 ==================================
+  Update dm-ioctl.h after removal of compat code.
   Add --readahead to dmsetup.
   Add external read_ahead library functions and DM_READ_AHEAD_* definitions.
   Fix double free in a libdevmapper-event error path.
--- device-mapper/kernel/ioctl/dm-ioctl.h	2006/10/12 15:42:24	1.44
+++ device-mapper/kernel/ioctl/dm-ioctl.h	2007/12/05 14:11:26	1.45
@@ -8,9 +8,7 @@
 #ifndef _LINUX_DM_IOCTL_V4_H
 #define _LINUX_DM_IOCTL_V4_H
 
-#ifdef linux
-#  include <linux/types.h>
-#endif
+#include <linux/types.h>
 
 #define DM_DIR "mapper"		/* Slashes not supported */
 #define DM_MAX_TYPE_NAME 16
@@ -133,6 +131,7 @@
 	char name[DM_NAME_LEN];	/* device name */
 	char uuid[DM_UUID_LEN];	/* unique identifier for
 				 * the block device */
+	char data[7];		/* padding or data */
 };
 
 /*
@@ -233,36 +232,6 @@
 	DM_DEV_SET_GEOMETRY_CMD
 };
 
-/*
- * The dm_ioctl struct passed into the ioctl is just the header
- * on a larger chunk of memory.  On x86-64 and other
- * architectures the dm-ioctl struct will be padded to an 8 byte
- * boundary so the size will be different, which would change the
- * ioctl code - yes I really messed up.  This hack forces these
- * architectures to have the correct ioctl code.
- */
-#ifdef CONFIG_COMPAT
-typedef char ioctl_struct[308];
-#define DM_VERSION_32       _IOWR(DM_IOCTL, DM_VERSION_CMD, ioctl_struct)
-#define DM_REMOVE_ALL_32    _IOWR(DM_IOCTL, DM_REMOVE_ALL_CMD, ioctl_struct)
-#define DM_LIST_DEVICES_32  _IOWR(DM_IOCTL, DM_LIST_DEVICES_CMD, ioctl_struct)
-
-#define DM_DEV_CREATE_32    _IOWR(DM_IOCTL, DM_DEV_CREATE_CMD, ioctl_struct)
-#define DM_DEV_REMOVE_32    _IOWR(DM_IOCTL, DM_DEV_REMOVE_CMD, ioctl_struct)
-#define DM_DEV_RENAME_32    _IOWR(DM_IOCTL, DM_DEV_RENAME_CMD, ioctl_struct)
-#define DM_DEV_SUSPEND_32   _IOWR(DM_IOCTL, DM_DEV_SUSPEND_CMD, ioctl_struct)
-#define DM_DEV_STATUS_32    _IOWR(DM_IOCTL, DM_DEV_STATUS_CMD, ioctl_struct)
-#define DM_DEV_WAIT_32      _IOWR(DM_IOCTL, DM_DEV_WAIT_CMD, ioctl_struct)
-
-#define DM_TABLE_LOAD_32    _IOWR(DM_IOCTL, DM_TABLE_LOAD_CMD, ioctl_struct)
-#define DM_TABLE_CLEAR_32   _IOWR(DM_IOCTL, DM_TABLE_CLEAR_CMD, ioctl_struct)
-#define DM_TABLE_DEPS_32    _IOWR(DM_IOCTL, DM_TABLE_DEPS_CMD, ioctl_struct)
-#define DM_TABLE_STATUS_32  _IOWR(DM_IOCTL, DM_TABLE_STATUS_CMD, ioctl_struct)
-#define DM_LIST_VERSIONS_32 _IOWR(DM_IOCTL, DM_LIST_VERSIONS_CMD, ioctl_struct)
-#define DM_TARGET_MSG_32    _IOWR(DM_IOCTL, DM_TARGET_MSG_CMD, ioctl_struct)
-#define DM_DEV_SET_GEOMETRY_32	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, ioctl_struct)
-#endif
-
 #define DM_IOCTL 0xfd
 
 #define DM_VERSION       _IOWR(DM_IOCTL, DM_VERSION_CMD, struct dm_ioctl)
@@ -287,9 +256,9 @@
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	11
+#define DM_VERSION_MINOR	13
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2006-10-12)"
+#define DM_VERSION_EXTRA	"-ioctl (2007-10-18)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
--- device-mapper/lib/libdm-common.c	2007/12/03 22:48:35	1.53
+++ device-mapper/lib/libdm-common.c	2007/12/05 14:11:26	1.54
@@ -380,17 +380,19 @@
 {
 	int r = 1;
 	int fd;
+	long read_ahead_long;
 
 	if ((fd = _open_dev_node(dev_name)) < 0)
 		return_0;
 
-	*read_ahead = 0;
-
-	if (ioctl(fd, BLKRAGET, read_ahead)) {
+	if (ioctl(fd, BLKRAGET, &read_ahead_long)) {
 		log_sys_error("BLKRAGET", dev_name);
+		*read_ahead = 0;
 		r = 0;
-	}  else
+	}  else {
+		*read_ahead = (uint32_t) read_ahead_long;
 		log_debug("%s: read ahead is %" PRIu32, dev_name, *read_ahead);
+	}
 
 	if (close(fd))
 		stack;
@@ -402,13 +404,14 @@
 {
 	int r = 1;
 	int fd;
+	long read_ahead_long = (long) read_ahead;
 
 	if ((fd = _open_dev_node(dev_name)) < 0)
 		return_0;
 
 	log_debug("%s: Setting read ahead to %" PRIu32, dev_name, read_ahead);
 
-	if (ioctl(fd, BLKRASET, read_ahead)) {
+	if (ioctl(fd, BLKRASET, read_ahead_long)) {
 		log_sys_error("BLKRASET", dev_name);
 		r = 0;
 	}
