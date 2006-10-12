From: agk@sourceware.org
Subject: device-mapper/lib/ioctl libdm-iface.c libdm-ta ...
Date: 12 Oct 2006 17:29:05 -0000
Message-ID: <20061012172905.4982.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2006-10-12 17:29:05

Modified files:
	lib/ioctl      : libdm-iface.c libdm-targets.h 

Log message:
	noflush code fixes: missing debug log; non-standard variable name

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.38&r2=1.39
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-targets.h.diff?cvsroot=dm&r1=1.19&r2=1.20

--- device-mapper/lib/ioctl/libdm-iface.c	2006/10/12 15:42:24	1.38
+++ device-mapper/lib/ioctl/libdm-iface.c	2006/10/12 17:29:05	1.39
@@ -1028,7 +1028,7 @@
 
 int dm_task_no_flush(struct dm_task *dmt)
 {
-	dmt->noflush = 1;
+	dmt->no_flush = 1;
 
 	return 1;
 }
@@ -1277,7 +1277,7 @@
 
 	if (dmt->type == DM_DEVICE_SUSPEND)
 		dmi->flags |= DM_SUSPEND_FLAG;
-	if (dmt->noflush)
+	if (dmt->no_flush)
 		dmi->flags |= DM_NOFLUSH_FLAG;
 	if (dmt->read_only)
 		dmi->flags |= DM_READONLY_FLAG;
@@ -1552,7 +1552,7 @@
 		dmi->flags |= DM_SKIP_BDGET_FLAG;
 
 	log_debug("dm %s %s %s%s%s %s%.0d%s%.0d%s"
-		  "%s%c%s %.0llu %s [%u]",
+		  "%s%c%c%s %.0llu %s [%u]",
 		  _cmd_data_v4[dmt->type].name,
 		  dmi->name, dmi->uuid, dmt->newname ? " " : "",
 		  dmt->newname ? dmt->newname : "",
@@ -1563,6 +1563,7 @@
 		  dmt->major > 0 && dmt->minor == 0 ? "0" : "",
 		  dmt->major > 0 ? ") " : "",
 		  dmt->no_open_count ? 'N' : 'O',
+		  dmt->no_flush ? 'N' : 'F',
 		  dmt->skip_lockfs ? "S " : "",
 		  dmt->sector, dmt->message ? dmt->message : "",
 		  dmi->data_size);
--- device-mapper/lib/ioctl/libdm-targets.h	2006/10/12 15:42:24	1.19
+++ device-mapper/lib/ioctl/libdm-targets.h	2006/10/12 17:29:05	1.20
@@ -52,7 +52,7 @@
 	char *message;
 	char *geometry;
 	uint64_t sector;
-	int noflush;
+	int no_flush;
 	int no_open_count;
 	int skip_lockfs;
 	int suppress_identical_reload;
