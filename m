From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH][RFC] dm-ioctl: protect new_map
Date: Thu, 15 Oct 2009 16:30:35 -0400
Message-ID: <20091015203034.GA23245@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

Alasdair,

This is an RFC patch that adds locking around each hash_cell's new_map.

It allows us to safely display the status/info of a DM device's INACTIVE
table.  I haven't tied this in to userspace yet (see 'TODO' below) but
my intention is to add an --inactive flag, e.g.:
dmsetup status --inactive
dmsetup info --inactive

This is useful for seeing when a DM device is in the middle a complex
transition, e.g. snapshot-merge's exception handover:

Before snapshot-merge:
----------------------
# dmsetup status test-testlv
0 67108864 snapshot-origin

Snapshot-merge target created, about to handover exceptions:
------------------------------------------------------------
# dmsetup status test-testlv
0 67108864 snapshot-merge 16/14680064 16

NOTE: the snapshot-merge store is empty (handover hasn't happened yet)

After exception handover, before merge has started:
---------------------------------------------------
# dmsetup status test-testlv
0 67108864 snapshot-merge 1328904/14680064 5184

Snapshot-merge table is now active and is merging:
--------------------------------------------------
# dmsetup status test-testlv
0 67108864 snapshot-merge 1005392/14680064 3920


diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 8208b3a..17fc78d 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -34,6 +34,7 @@ struct hash_cell {
 	char *uuid;
 	struct mapped_device *md;
 	struct dm_table *new_map;
+	rwlock_t new_map_lock;
 };
 
 struct vers_iter {
@@ -157,6 +158,7 @@ static struct hash_cell *alloc_cell(const char *name, const char *uuid,
 	INIT_LIST_HEAD(&hc->uuid_list);
 	hc->md = md;
 	hc->new_map = NULL;
+	rwlock_init(&hc->new_map_lock);
 	return hc;
 }
 
@@ -620,6 +622,26 @@ out:
 	return mdptr;
 }
 
+static struct dm_table *dm_get_inactive_table(struct dm_ioctl *param)
+{
+	struct hash_cell *hc;
+	struct dm_table *table = NULL;
+	unsigned long flags;
+
+	down_read(&_hash_lock);
+	hc = __find_device_hash_cell(param);
+	if (hc) {
+		read_lock_irqsave(&hc->new_map_lock, flags);
+		table = hc->new_map;
+		if (table)
+			dm_table_get(table);
+		read_unlock_irqrestore(&hc->new_map_lock, flags);
+	}
+	up_read(&_hash_lock);
+
+	return table;
+}
+
 static struct mapped_device *find_device(struct dm_ioctl *param)
 {
 	struct hash_cell *hc;
@@ -798,6 +820,7 @@ static int do_resume(struct dm_ioctl *param)
 {
 	int r = 0;
 	unsigned suspend_flags = DM_SUSPEND_LOCKFS_FLAG;
+	unsigned long flags;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 	struct dm_table *new_map;
@@ -813,8 +836,10 @@ static int do_resume(struct dm_ioctl *param)
 
 	md = hc->md;
 
+	write_lock_irqsave(&hc->new_map_lock, flags);
 	new_map = hc->new_map;
 	hc->new_map = NULL;
+	write_unlock_irqrestore(&hc->new_map_lock, flags);
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
 	up_write(&_hash_lock);
@@ -1075,6 +1100,7 @@ static int table_prealloc_integrity(struct dm_table *t,
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
+	unsigned long flags;
 	struct hash_cell *hc;
 	struct dm_table *t;
 	struct mapped_device *md;
@@ -1118,9 +1144,11 @@ static int table_load(struct dm_ioctl *param, size_t param_size)
 		goto out;
 	}
 
+	write_lock_irqsave(&hc->new_map_lock, flags);
 	if (hc->new_map)
 		dm_table_destroy(hc->new_map);
 	hc->new_map = t;
+	write_unlock_irqrestore(&hc->new_map_lock, flags);
 	up_write(&_hash_lock);
 
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
@@ -1135,6 +1163,7 @@ out:
 static int table_clear(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
+	unsigned long flags;
 	struct hash_cell *hc;
 	struct mapped_device *md;
 
@@ -1147,10 +1176,11 @@ static int table_clear(struct dm_ioctl *param, size_t param_size)
 		return -ENXIO;
 	}
 
-	if (hc->new_map) {
+	write_lock_irqsave(&hc->new_map_lock, flags);
+	if (hc->new_map)
 		dm_table_destroy(hc->new_map);
-		hc->new_map = NULL;
-	}
+	hc->new_map = NULL;
+	write_unlock_irqrestore(&hc->new_map_lock, flags);
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
@@ -1226,6 +1256,21 @@ static int table_deps(struct dm_ioctl *param, size_t param_size)
 	return r;
 }
 
+static struct dm_table* __dm_get_table(struct mapped_device *md,
+				       struct dm_ioctl *param)
+{
+	struct dm_table *table;
+	/* TODO: make this conditional on user param --inactive,
+	   e.g.: DM_STATUS_INACTIVE_FLAG
+	 */
+	if (param->flags & DM_INACTIVE_PRESENT_FLAG) {
+		table = dm_get_inactive_table(param);
+	} else {
+		table = dm_get_table(md);
+	}
+	return table;
+}
+
 /*
  * Return the status of a device as a text string for each
  * target.
@@ -1244,7 +1289,7 @@ static int table_status(struct dm_ioctl *param, size_t param_size)
 	if (r)
 		goto out;
 
-	table = dm_get_table(md);
+	table = __dm_get_table(md, param);
 	if (table) {
 		retrieve_status(table, param, param_size);
 		dm_table_put(table);
