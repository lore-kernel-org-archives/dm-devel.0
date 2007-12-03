From: agk@sourceware.org
Subject: device-mapper dmsetup/dmsetup.c lib/libdm-comm ...
Date: 3 Dec 2007 22:48:36 -0000
Message-ID: <20071203224836.32426.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-03 22:48:36

Modified files:
	dmsetup        : dmsetup.c 
	lib            : libdm-common.c libdm-deptree.c 
	lib/ioctl      : libdm-iface.c 

Log message:
	fixes

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmsetup/dmsetup.c.diff?cvsroot=dm&r1=1.99&r2=1.100
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-common.c.diff?cvsroot=dm&r1=1.52&r2=1.53
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/libdm-deptree.c.diff?cvsroot=dm&r1=1.33&r2=1.34
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.48&r2=1.49

--- device-mapper/dmsetup/dmsetup.c	2007/11/30 14:59:57	1.99
+++ device-mapper/dmsetup/dmsetup.c	2007/12/03 22:48:35	1.100
@@ -340,7 +340,7 @@
 	       info->read_only ? " (READ-ONLY)" : "");
 
 	if (dm_task_get_read_ahead(dmt, &read_ahead))
-		printf("Read Ahead:       %" PRIu32 "\n", read_ahead);
+		printf("Read Ahead:        %" PRIu32 "\n", read_ahead);
 
 	if (!info->live_table && !info->inactive_table)
 		printf("Tables present:    None\n");
--- device-mapper/lib/libdm-common.c	2007/12/03 17:56:36	1.52
+++ device-mapper/lib/libdm-common.c	2007/12/03 22:48:35	1.53
@@ -386,13 +386,13 @@
 
 	*read_ahead = 0;
 
-	if (!ioctl(fd, BLKRAGET, read_ahead)) {
+	if (ioctl(fd, BLKRAGET, read_ahead)) {
 		log_sys_error("BLKRAGET", dev_name);
 		r = 0;
 	}  else
 		log_debug("%s: read ahead is %" PRIu32, dev_name, *read_ahead);
 
-	if (!close(fd))
+	if (close(fd))
 		stack;
 
 	return r;
@@ -413,7 +413,7 @@
 		r = 0;
 	}
 
-	if (!close(fd))
+	if (close(fd))
 		stack;
 
 	return r;
--- device-mapper/lib/libdm-deptree.c	2007/11/27 20:57:05	1.33
+++ device-mapper/lib/libdm-deptree.c	2007/12/03 22:48:35	1.34
@@ -901,6 +901,13 @@
 		return 0;
 	}
 
+	/* FIXME Kernel should fill in name on return instead */
+	if (!dm_task_set_name(dmt, name)) {
+		log_error("Failed to set readahead device name for %s", name);
+		dm_task_destroy(dmt);
+		return 0;
+	}
+
 	if (!dm_task_set_major(dmt, major) || !dm_task_set_minor(dmt, minor)) {
 		log_error("Failed to set device number for %s resumption.", name);
 		dm_task_destroy(dmt);
--- device-mapper/lib/ioctl/libdm-iface.c	2007/11/30 14:59:57	1.48
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/12/03 22:48:36	1.49
@@ -1281,7 +1281,9 @@
 			    dmt->major, dmt->minor, dmi->name);
 	}
 
-	if (dmt->dev_name)
+	/* FIXME Until resume ioctl supplies name, use dev_name for readahead */
+	if (dmt->dev_name && (dmt->type != DM_DEVICE_RESUME || dmt->minor < 0 ||
+			      dmt->major < 0))
 		strncpy(dmi->name, dmt->dev_name, sizeof(dmi->name));
 
 	if (dmt->uuid)
@@ -1683,7 +1685,8 @@
 		break;
 
 	case DM_DEVICE_RESUME:
-		set_dev_node_read_ahead(dmi->name, dmt->read_ahead,
+		/* FIXME Kernel needs to fill in dmi->name */
+		set_dev_node_read_ahead(dmt->dev_name, dmt->read_ahead,
 					dmt->read_ahead_flags);
 		break;
 	
