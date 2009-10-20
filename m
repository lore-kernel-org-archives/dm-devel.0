From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm ioctl: retrieve status from inactive table
Date: Tue, 20 Oct 2009 17:02:51 -0400
Message-ID: <1256072571-5193-1-git-send-email-snitzer@redhat.com>
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
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Adds input flag (DM_STATUS_INACTIVE_FLAG) for use in the ioctl STATUS
command.  Introduces dm_get_inactive_table() to get a reference on the
inactive table so that it is protected during use in table_status().
Allows us to safely display the status/table of a DM device's inactive
table.

This is useful for seeing when a DM device is in the middle a complex
transition, e.g. snapshot-merge's exception handover:

Before snapshot-merge:
----------------------
# dmsetup status test-testlv
0 67108864 snapshot-origin
# dmsetup status test-testlv_snap
0 67108864 snapshot 1328904/14680064 5184

# dmsetup status --inactive test-testlv
0 0
# dmsetup status --inactive test-testlv_snap
0 0


Snapshot-merge target created, about to handover exceptions:
------------------------------------------------------------
# dmsetup status test-testlv
0 67108864 snapshot-origin
# dmsetup status test-testlv_snap
0 67108864 snapshot 1328904/14680064 5184

# dmsetup status --inactive test-testlv
0 67108864 snapshot-merge 16/14680064 16

NOTE: the snapshot-merge store is empty (handover hasn't happened yet)


After exception handover, before merge has started:
---------------------------------------------------
# dmsetup status test-testlv
0 67108864 snapshot-origin

# dmsetup status --inactive test-testlv
0 67108864 snapshot-merge 1328904/14680064 5184


Snapshot-merge table is now active and is merging:
--------------------------------------------------
# dmsetup status test-testlv
0 67108864 snapshot-merge 1114360/14680064 4344

# dmsetup table --inactive test-testlv
0 0


Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-ioctl.c    |   33 ++++++++++++++++++++++++++++++++-
 include/linux/dm-ioctl.h |   10 ++++++++--
 2 files changed, 40 insertions(+), 3 deletions(-)

Index: linux-2.6/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-ioctl.c
+++ linux-2.6/drivers/md/dm-ioctl.c
@@ -650,6 +650,23 @@ static struct mapped_device *find_device
 	return md;
 }
 
+static struct dm_table *dm_get_inactive_table(struct dm_ioctl *param)
+{
+	struct hash_cell *hc;
+	struct dm_table *table = NULL;
+
+	down_read(&_hash_lock);
+	hc = __find_device_hash_cell(param);
+	if (hc) {
+		table = hc->new_map;
+		if (table)
+			dm_table_get(table);
+	}
+        up_read(&_hash_lock);
+
+	return table;
+}
+
 static int dev_remove(struct dm_ioctl *param, size_t param_size)
 {
 	struct hash_cell *hc;
@@ -1226,6 +1243,20 @@ static int table_deps(struct dm_ioctl *p
 	return r;
 }
 
+static struct dm_table* __dm_get_table(struct mapped_device *md,
+				       struct dm_ioctl *param)
+{
+	struct dm_table *table = NULL;
+
+	if (param->flags & DM_STATUS_INACTIVE_FLAG) {
+		if (param->flags & DM_INACTIVE_PRESENT_FLAG)
+			table = dm_get_inactive_table(param);
+	} else
+		table = dm_get_table(md);
+
+	return table;
+}
+
 /*
  * Return the status of a device as a text string for each
  * target.
@@ -1244,7 +1275,7 @@ static int table_status(struct dm_ioctl 
 	if (r)
 		goto out;
 
-	table = dm_get_table(md);
+	table = __dm_get_table(md, param);
 	if (table) {
 		retrieve_status(table, param, param_size);
 		dm_table_put(table);
Index: linux-2.6/include/linux/dm-ioctl.h
===================================================================
--- linux-2.6.orig/include/linux/dm-ioctl.h
+++ linux-2.6/include/linux/dm-ioctl.h
@@ -266,9 +266,9 @@ enum {
 #define DM_DEV_SET_GEOMETRY	_IOWR(DM_IOCTL, DM_DEV_SET_GEOMETRY_CMD, struct dm_ioctl)
 
 #define DM_VERSION_MAJOR	4
-#define DM_VERSION_MINOR	15
+#define DM_VERSION_MINOR	16
 #define DM_VERSION_PATCHLEVEL	0
-#define DM_VERSION_EXTRA	"-ioctl (2009-04-01)"
+#define DM_VERSION_EXTRA	"-ioctl (2009-10-20)"
 
 /* Status bits */
 #define DM_READONLY_FLAG	(1 << 0) /* In/Out */
@@ -282,6 +282,12 @@ enum {
 #define DM_STATUS_TABLE_FLAG	(1 << 4) /* In */
 
 /*
+ * Flag passed into ioctl STATUS command to get table information
+ * or current status from the inactive table.
+ */
+#define DM_STATUS_INACTIVE_FLAG	(1 << 7) /* In */
+
+/*
  * Flags that indicate whether a table is present in either of
  * the two table slots that a device has.
  */
