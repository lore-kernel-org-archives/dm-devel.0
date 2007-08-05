From: agk@sourceware.org
Subject: device-mapper/dmeventd libdevmapper-event.c
Date: 5 Aug 2007 00:13:04 -0000
Message-ID: <20070805001304.27341.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-08-05 00:13:02

Modified files:
	dmeventd       : libdevmapper-event.c 

Log message:
	Use NULL not 0.
	Remove worthless comment.

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/dmeventd/libdevmapper-event.c.diff?cvsroot=dm&r1=1.23&r2=1.24

--- device-mapper/dmeventd/libdevmapper-event.c	2007/08/02 22:31:59	1.23
+++ device-mapper/dmeventd/libdevmapper-event.c	2007/08/05 00:13:02	1.24
@@ -670,13 +670,7 @@
 }
 
 /*
- * dm_event_get_registered_device
- * @dso_name
- * @device_path
- * @mask
- * @next
- *
- * Returns: 0 if handler found, error (-ENOMEM, -ENOENT) otherwise
+ * Returns 0 if handler found; error (-ENOMEM, -ENOENT) otherwise.
  */
 int dm_event_get_registered_device(struct dm_event_handler *dmevh, int next)
 {
@@ -706,7 +700,7 @@
 	}
 
 	dm_task_destroy(dmt);
-	dmt = 0;
+	dmt = NULL;
 
 	if (msg.data) {
 		dm_free(msg.data);
