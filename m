From: Milan Broz <mbroz@redhat.com>
Subject: [PATCH] Add suspend change flag into dm-ioctl.
Date: Thu, 18 Mar 2010 14:59:00 +0100
Message-ID: <1268920740-11015-1-git-send-email-mbroz@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Milan Broz <mbroz@redhat.com>
List-Id: dm-devel.ids

For some node operation is userspace we need to know
if previous suspend state of device really changed.

Patch add new flag to indicate suspend state change.

Signed-off-by: Milan Broz <mbroz@redhat.com>
---
 drivers/md/dm-ioctl.c    |   25 ++++++++++++++++++-------
 include/linux/dm-ioctl.h |   11 ++++++++---
 2 files changed, 26 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index b670922..5d33492 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -596,7 +596,7 @@ static int __dev_status(struct mapped_device *md, struct dm_ioctl *param)
 	struct dm_table *table;
 
 	param->flags &= ~(DM_SUSPEND_FLAG | DM_READONLY_FLAG |
-			  DM_ACTIVE_PRESENT_FLAG);
+			  DM_SUSPEND_CHANGE_FLAG | DM_ACTIVE_PRESENT_FLAG);
 
 	if (dm_suspended_md(md))
 		param->flags |= DM_SUSPEND_FLAG;
@@ -846,7 +846,7 @@ out:
 
 static int do_suspend(struct dm_ioctl *param)
 {
-	int r = 0;
+	int r = 0, suspended = 0;
 	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct mapped_device *md;
 
@@ -859,11 +859,17 @@ static int do_suspend(struct dm_ioctl *param)
 	if (param->flags & DM_NOFLUSH_FLAG)
 		suspend_flags |= DM_SUSPEND_NOFLUSH_FLAG;
 
-	if (!dm_suspended_md(md))
+	if (!dm_suspended_md(md)) {
 		r = dm_suspend(md, suspend_flags);
+		if (!r)
+			suspended = 1;
+	}
 
-	if (!r)
+	if (!r) {
 		r = __dev_status(md, param);
+		if (suspended)
+			param->flags |= DM_SUSPEND_CHANGE_FLAG;
+	}
 
 	dm_put(md);
 	return r;
@@ -871,7 +877,7 @@ static int do_suspend(struct dm_ioctl *param)
 
 static int do_resume(struct dm_ioctl *param)
 {
-	int r = 0;
+	int r = 0, resumed = 0;
 	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
 	struct hash_cell *hc;
 	struct mapped_device *md;
@@ -919,16 +925,21 @@ static int do_resume(struct dm_ioctl *param)
 
 	if (dm_suspended_md(md)) {
 		r = dm_resume(md);
-		if (!r)
+		if (!r) {
 			dm_ioctl_uevent(md, KOBJ_CHANGE, param->event_nr,
 					&param->flags);
+			resumed = 1;
+		}
 	}
 
 	if (old_map)
 		dm_table_destroy(old_map);
 
-	if (!r)
+	if (!r) {
 		r = __dev_status(md, param);
+		if (resumed)
+			param->flags |= DM_SUSPEND_CHANGE_FLAG;
+	}
 
 	dm_put(md);
 	return r;
diff --git a/include/linux/dm-ioctl.h b/include/linux/dm-ioctl.h
index 2c445e1..ae957a3 100644
--- a/include/linux/dm-ioctl.h
+++ b/include/linux/dm-ioctl.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 - 2003 Sistina Software (UK) Limited.
- * Copyright (C) 2004 - 2009 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004 - 2010 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the LGPL.
  */
@@ -266,9 +266,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	17
+#define DM_VERSION_MINOR	18
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2010-03-05)"
+#define DM_VERSION_EXTRA	"-ioctl (2010-03-10)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -321,4 +321,9 @@ enum {
  */
 #define DM_UEVENT_GENERATED_FLAG	(1 << 13) /* Out */
 
+/*
+ * If set, suspend state of device changed from previous state.
+ */
+#define DM_SUSPEND_CHANGE_FLAG		(1 << 14) /* Out */
+
 #endif				/* _LINUX_DM_IOCTL_H */
-- 
1.7.0
