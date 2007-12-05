From: agk@sourceware.org
Subject: device-mapper/lib/ioctl libdm-iface.c
Date: 5 Dec 2007 16:24:41 -0000
Message-ID: <20071205162441.26547.qmail@sourceware.org>
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
Changes by:	agk@sourceware.org	2007-12-05 16:24:41

Modified files:
	lib/ioctl      : libdm-iface.c 

Log message:
	work out device name to use for read ahead request

Patches:
http://sourceware.org/cgi-bin/cvsweb.cgi/device-mapper/lib/ioctl/libdm-iface.c.diff?cvsroot=dm&r1=1.49&r2=1.50

--- device-mapper/lib/ioctl/libdm-iface.c	2007/12/03 22:48:36	1.49
+++ device-mapper/lib/ioctl/libdm-iface.c	2007/12/05 16:24:41	1.50
@@ -922,7 +922,29 @@
 
 uint32_t dm_task_get_read_ahead(const struct dm_task *dmt, uint32_t *read_ahead)
 {              
-	return get_dev_node_read_ahead(dmt->dev_name, read_ahead);
+	const char *dev_name;
+
+	*read_ahead = 0;
+
+#ifdef DM_COMPAT
+	/* Not supporting this */
+        if (_dm_version == 1)
+                return 1;
+#endif  
+
+        if (!dmt->dmi.v4 || !(dmt->dmi.v4->flags & DM_EXISTS_FLAG))
+		return 0;
+
+	if (*dmt->dmi.v4->name)
+		dev_name = dmt->dmi.v4->name;
+	else if (dmt->dev_name)
+		dev_name = dmt->dev_name;
+	else {
+		log_error("Get read ahead request failed: device name unrecorded.");
+		return 0;
+	}
+
+	return get_dev_node_read_ahead(dev_name, read_ahead);
 }
 
 const char *dm_task_get_name(const struct dm_task *dmt)
