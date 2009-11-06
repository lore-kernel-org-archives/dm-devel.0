From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH] dm ioctl: retrieve status from inactive table
Date: Fri, 6 Nov 2009 02:15:17 +0000
Message-ID: <20091106021517.GR13375@agk-dp.fab.redhat.com>
References: <1256072571-5193-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1256072571-5193-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

Latest version.  The userspace support is now in dmsetup in CVS.

Please could some people who are familiar with the ioctls and dmsetup 
try these out?

The --inactive flag is meant to work with all dmsetup cmds that return
any table information, and all table information should be affected
(including number of targets).

(Patch is also here: 
http://www.kernel.org/pub/linux/kernel/people/agk/patches/2.6/editing/dm-ioctl-retrieve-status-from-inactive-table.patch
and should apply on top of current linux-next.)

Alasdair



Add the flag DM_QUERY_INACTIVE_TABLE_FLAG to the ioctls to return
infomation about the loaded-but-not-yet-active table instead of the live
table.  Prior to this patch it was impossible to obtain this information
until the device had been 'resumed'.

Userspace dmsetup and libdevmapper support the flag as of version 1.02.40.
e.g. dmsetup info --inactive vg1-lv1

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-ioctl.c    |   70 ++++++++++++++++++++++++++++++++++++++---------
 include/linux/dm-ioctl.h |   13 ++++++--
 2 files changed, 67 insertions(+), 16 deletions(-)

Index: linux-2.6.32-rc6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.32-rc6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6.32-rc6/drivers/md/dm-ioctl.c
@@ -512,8 +512,6 @@ static int list_versions(struct dm_ioctl
 	return 0;
 }
 
-
-
 static int check_name(const char *name)
 {
 	if (strchr(name, '/')) {
@@ -525,6 +523,40 @@ static int check_name(const char *name)
 }
 
 /*
+ * On successful return, the caller must not attempt to acquire
+ * _hash_lock without first calling dm_table_put, because dm_table_destroy
+ * waits for this dm_table_put and could be called under this lock.
+ */
+static struct dm_table *dm_get_inactive_table(struct mapped_device *md)
+{
+	struct hash_cell *hc;
+	struct dm_table *table = NULL;
+
+	down_read(&_hash_lock);
+	hc = dm_get_mdptr(md);
+	if (!hc || hc->md != md) {
+		DMWARN("device has been removed from the dev hash table.");
+		goto out;
+	}
+
+	table = hc->new_map;
+	if (table)
+		dm_table_get(table);
+
+out:
+	up_read(&_hash_lock);
+
+	return table;
+}
+
+static struct dm_table *dm_get_live_or_inactive_table(struct mapped_device *md,
+						      struct dm_ioctl *param)
+{
+	return (param->flags & DM_QUERY_INACTIVE_TABLE_FLAG) ?
+		dm_get_inactive_table(md) : dm_get_live_table(md);
+}
+
+/*
  * Fills in a dm_ioctl structure, ready for sending back to
  * userland.
  */
@@ -548,18 +580,30 @@ static int __dev_status(struct mapped_de
 	 */
 	param->open_count = dm_open_count(md);
 
-	if (get_disk_ro(disk))
-		param->flags |= DM_READONLY_FLAG;
-
 	param->event_nr = dm_get_event_nr(md);
+	param->target_count = 0;
 
 	table = dm_get_live_table(md);
 	if (table) {
-		param->flags |= DM_ACTIVE_PRESENT_FLAG;
-		param->target_count = dm_table_get_num_targets(table);
+		if (!(param->flags & DM_QUERY_INACTIVE_TABLE_FLAG)) {
+			if (get_disk_ro(disk))
+				param->flags |= DM_READONLY_FLAG;
+			param->target_count = dm_table_get_num_targets(table);
+		}
 		dm_table_put(table);
-	} else
-		param->target_count = 0;
+
+		param->flags |= DM_ACTIVE_PRESENT_FLAG;
+	}
+
+	if (param->flags & DM_QUERY_INACTIVE_TABLE_FLAG) {
+		table = dm_get_inactive_table(md);
+		if (table) {
+			if (!(dm_table_get_mode(table) & FMODE_WRITE))
+				param->flags |= DM_READONLY_FLAG;
+			param->target_count = dm_table_get_num_targets(table);
+			dm_table_put(table);
+		}
+	}
 
 	return 0;
 }
@@ -982,7 +1026,7 @@ static int dev_wait(struct dm_ioctl *par
 	if (r)
 		goto out;
 
-	table = dm_get_live_table(md);
+	table = dm_get_live_or_inactive_table(md, param);
 	if (table) {
 		retrieve_status(table, param, param_size);
 		dm_table_put(table);
@@ -1215,7 +1259,7 @@ static int table_deps(struct dm_ioctl *p
 	if (r)
 		goto out;
 
-	table = dm_get_live_table(md);
+	table = dm_get_live_or_inactive_table(md, param);
 	if (table) {
 		retrieve_deps(table, param, param_size);
 		dm_table_put(table);
@@ -1244,13 +1288,13 @@ static int table_status(struct dm_ioctl 
 	if (r)
 		goto out;
 
-	table = dm_get_live_table(md);
+	table = dm_get_live_or_inactive_table(md, param);
 	if (table) {
 		retrieve_status(table, param, param_size);
 		dm_table_put(table);
 	}
 
- out:
+out:
 	dm_put(md);
 	return r;
 }
Index: linux-2.6.32-rc6/include/linux/dm-ioctl.h
===================================================================
--- linux-2.6.32-rc6.orig/include/linux/dm-ioctl.h
+++ linux-2.6.32-rc6/include/linux/dm-ioctl.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (C) 2001 - 2003 Sistina Software (UK) Limited.
- * Copyright (C) 2004 - 2005 Red Hat, Inc. All rights reserved.
+ * Copyright (C) 2004 - 2009 Red Hat, Inc. All rights reserved.
  *
  * This file is released under the LGPL.
  */
@@ -266,9 +266,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	15
+#define DM_VERSION_MINOR	16
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2009-04-01)"
+#define DM_VERSION_EXTRA	"-ioctl (2009-11-05)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -309,4 +309,11 @@ enum {
  */
 #define DM_NOFLUSH_FLAG		(1 << 11) /* In */
 
+/*
+ * If set, any table information returned will relate to the inactive
+ * table instead of the live one.  Always check DM_INACTIVE_PRESENT_FLAG
+ * is set before using the data returned.
+ */
+#define DM_QUERY_INACTIVE_TABLE_FLAG	(1 << 12) /* In */
+
 #endif				/* _LINUX_DM_IOCTL_H */
