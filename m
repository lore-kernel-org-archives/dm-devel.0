From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] RFC: Changing dm core: (5/5): Move new_map from
 hash_cell to mapped_device
Date: Thu, 16 Mar 2006 19:29:42 -0500
Message-ID: <441A02F6.70603@ce.jp.nec.com>
References: <4419FF61.9050501@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000705020808020809070602"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4419FF61.9050501@ce.jp.nec.com>
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

This is a multi-part message in MIME format.
--------------000705020808020809070602
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Move new_map from hash_cell to mapped_device.

This simplifies dm-ioctl.c a bit.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------000705020808020809070602
Content-Type: text/x-patch;
 name="05-move-new-map-to-md.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="05-move-new-map-to-md.patch"

Move new_map from hash_cell to mapped_device.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

 dm-ioctl.c |   72 +++++++++++--------------------------------------------------
 dm.c       |   58 +++++++++++++++++++++++++++++++++++++++++++++++--
 dm.h       |   10 +++++++-
 3 files changed, 78 insertions(+), 62 deletions(-)

--- linux-2.6.16-rc6-mm1-dm.04-remove-dm-get-md/drivers/md/dm.c	2006-03-16 18:15:58.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.05-move-new-map-to-md/drivers/md/dm.c	2006-03-16 18:16:10.000000000 -0500
@@ -84,6 +84,10 @@ struct mapped_device {
 	 * The current mapping.
 	 */
 	struct dm_table *map;
+	/*
+	 * Loaded, inactive mapping.
+	 */
+	struct dm_table *new_map;
 
 	/*
 	 * io objects are allocated from here.
@@ -877,6 +881,18 @@ static void __set_size(struct mapped_dev
 	mutex_unlock(&md->suspended_bdev->bd_inode->i_mutex);
 }
 
+static struct dm_table *__extract_new_map(struct mapped_device *md)
+{
+	struct dm_table *t;
+
+	write_lock(&md->map_lock);
+	t = md->new_map;
+	md->new_map = NULL;
+	write_unlock(&md->map_lock);
+
+	return t;
+}
+
 static int __bind(struct mapped_device *md, struct dm_table *t)
 {
 	request_queue_t *q = md->queue;
@@ -887,7 +903,6 @@ static int __bind(struct mapped_device *
 	if (size == 0)
 		return 0;
 
-	dm_table_get(t);
 	dm_table_event_callback(t, event_callback, md);
 
 	write_lock(&md->map_lock);
@@ -966,6 +981,7 @@ void dm_free(struct mapped_device *md)
 {
 	struct dm_table *map;
 
+	dm_table_put(md->new_map);
 	map = dm_get_table(md);
 	if (!dm_suspended(md)) {
 		dm_table_presuspend_targets(map);
@@ -994,9 +1010,10 @@ static void __flush_deferred_io(struct m
 /*
  * Swap in a new table (destroying old one).
  */
-int dm_swap_table(struct mapped_device *md, struct dm_table *table)
+int dm_swap_table(struct mapped_device *md)
 {
 	int r = -EINVAL;
+	sturct dm_table *table;
 
 	down(&md->suspend_lock);
 
@@ -1004,6 +1021,13 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
+	/* no-op if no table is loaded */
+	table = __extract_new_map(md);
+	if (!table) {
+		r = 0;
+		goto out;
+	}
+
 	__unbind(md);
 	r = __bind(md, table);
 
@@ -1012,6 +1036,26 @@ out:
 	return r;
 }
 
+ /*
+  * Load a new table (or clear a loaded table if t == NULL).
+  * Should be called outside of dm_sem.
+  */
+int dm_load_table(struct mapped_device *md, struct dm_table *t)
+{
+	struct dm_table *old_map = NULL;
+
+	write_lock(&md->map_lock);
+	if (md->new_map)
+		old_map = md->new_map;
+	md->new_map = t;
+	write_unlock(&md->map_lock);
+
+	if (old_map)
+		dm_table_put(old_map);
+
+	return 1;
+}
+
 /*
  * Functions to lock and unlock any filesystem running on the
  * device.
@@ -1213,6 +1257,16 @@ int dm_suspended(struct mapped_device *m
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+int dm_inactive_present(struct mapped_device *md)
+{
+	return md->new_map != NULL;
+}
+
+int dm_get_mode(struct mapped_device *md)
+{
+	return md->map ? dm_table_get_mode(md->map) : 0;
+}
+
 /*
  * Block device interface
  */
--- linux-2.6.16-rc6-mm1-dm.04-remove-dm-get-md/drivers/md/dm.h	2006-03-16 18:19:35.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.05-move-new-map-to-md/drivers/md/dm.h	2006-03-16 15:48:13.000000000 -0500
@@ -65,7 +65,13 @@ int dm_resume(struct mapped_device *md);
 /*
  * The device must be suspended before calling this method.
  */
-int dm_swap_table(struct mapped_device *md, struct dm_table *t);
+int dm_swap_table(struct mapped_device *md);
+
+/*
+ * No lock is needed
+ */
+int dm_load_table(struct mapped_device *md, struct dm_table *t);
+
 
 /*
  * Drop a reference on the table when you've finished with the
@@ -84,6 +90,8 @@ int dm_wait_event(struct mapped_device *
  */
 struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct mapped_device *md);
+int dm_inactive_present(struct mapped_device *md);
+int dm_get_mode(struct mapped_device *md);
 
 /*-----------------------------------------------------------------
  * Functions for manipulating a table.  Tables are also reference
--- linux-2.6.16-rc6-mm1-dm.04-remove-dm-get-md/drivers/md/dm-ioctl.c	2006-03-16 15:38:26.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.05-move-new-map-to-md/drivers/md/dm-ioctl.c	2006-03-16 15:53:19.000000000 -0500
@@ -32,7 +32,6 @@ struct hash_cell {
 	char *name;
 	char *uuid;
 	struct mapped_device *md;
-	struct dm_table *new_map;
 };
 
 struct vers_iter {
@@ -171,7 +170,6 @@ static struct hash_cell *alloc_cell(cons
 	INIT_LIST_HEAD(&hc->name_list);
 	INIT_LIST_HEAD(&hc->uuid_list);
 	hc->md = md;
-	hc->new_map = NULL;
 	atomic_set(&hc->count, 0);
 	return hc;
 }
@@ -276,8 +274,6 @@ static void __hash_remove(struct hash_ce
  */
 static void __hash_free(struct hash_cell *hc)
 {
-	if (hc->new_map)
-		dm_table_put(hc->new_map);
 	dm_free(hc->md);
 	free_cell(hc);
 }
@@ -675,7 +671,7 @@ static struct mapped_device *find_device
 		else
 			param->uuid[0] = '\0';
 
-		if (hc->new_map)
+		if (dm_inactive_present(md))
 			param->flags |= DM_INACTIVE_PRESENT_FLAG;
 		else
 			param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
@@ -769,44 +765,29 @@ static int do_resume(struct dm_ioctl *pa
 {
 	int r = 0;
 	int do_lockfs = 1;
-	struct hash_cell *hc;
 	struct mapped_device *md;
-	struct dm_table *new_map;
-
-	down_write(&dm_sem);
 
-	hc = __find_device_hash_cell(param);
-	if (!hc) {
+	md = find_device(param);
+	if (!md) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&dm_sem);
 		return -ENXIO;
 	}
 
-	md = hc->md;
-	atomic_inc(&hc->count);
-
-	new_map = hc->new_map;
-	hc->new_map = NULL;
-	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-
-	up_write(&dm_sem);
-
 	/* Do we need to load a new map ? */
-	if (new_map) {
+	if (dm_inactive_present(md)) {
 		/* Suspend if it isn't already suspended */
 		if (param->flags & DM_SKIP_LOCKFS_FLAG)
 			do_lockfs = 0;
 		if (!dm_suspended(md))
 			dm_suspend(md, do_lockfs);
 
-		r = dm_swap_table(md, new_map);
+		r = dm_swap_table(md);
 		if (r) {
 			__put_md(md);
-			dm_table_put(new_map);
 			return r;
 		}
 
-		if (dm_table_get_mode(new_map) & FMODE_WRITE)
+		if (dm_get_mode(md) & FMODE_WRITE)
 			set_disk_ro(dm_disk(md), 0);
 		else
 			set_disk_ro(dm_disk(md), 1);
@@ -817,6 +798,7 @@ static int do_resume(struct dm_ioctl *pa
 	if (dm_suspended(md))
 		r = dm_resume(md);
 
+	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 	if (!r)
 		r = __dev_status(md, param);
 
@@ -1025,8 +1007,7 @@ static int populate_table(struct dm_tabl
 static int table_load(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
-	struct hash_cell *hc;
-	struct dm_table *t, *oldmap = NULL;
+	struct dm_table *t;
 	struct mapped_device *md;
 
 	md = find_device(param);
@@ -1043,27 +1024,12 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
-	down_write(&dm_sem);
-	hc = dm_get_mdptr(md);
-	if (!hc || hc->md != md) {
-		DMWARN("device has been removed from the dev hash table.");
-		oldmap = t;
-		up_write(&dm_sem);
-		r = -ENXIO;
-		goto out;
-	}
-
-	if (hc->new_map)
-		oldmap = hc->new_map;
-	hc->new_map = t;
-	up_write(&dm_sem);
+	dm_load_table(md, t);
 
 	param->flags |= DM_INACTIVE_PRESENT_FLAG;
 	r = __dev_status(md, param);
 
 out:
-	if (oldmap)
-		dm_table_put(oldmap);
 	__put_md(md);
 
 	return r;
@@ -1072,30 +1038,18 @@ out:
 static int table_clear(struct dm_ioctl *param, size_t param_size)
 {
 	int r;
-	struct hash_cell *hc;
-	struct dm_table *oldmap = NULL;
-
-	down_write(&dm_sem);
+	struct mapped_device *md;
 
-	hc = __find_device_hash_cell(param);
-	if (!hc) {
+	md = find_device(param);
+	if (!md) {
 		DMWARN("device doesn't appear to be in the dev hash table.");
-		up_write(&dm_sem);
 		return -ENXIO;
 	}
 
-	if (hc->new_map) {
-		oldmap = hc->new_map;
-		hc->new_map = NULL;
-	}
+	dm_load_table(md, NULL);
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
-
 	r = __dev_status(hc->md, param);
-	up_write(&dm_sem);
-
-	if (oldmap)
-		dm_table_put(oldmap);
 
 	return r;
 }

--------------000705020808020809070602
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------000705020808020809070602--
