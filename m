From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] RFC: Changing dm core (3/5): hash_cell open
	counter
Date: Thu, 16 Mar 2006 19:27:08 -0500
Message-ID: <441A025C.7000208@ce.jp.nec.com>
References: <4419FF61.9050501@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------050107050201000000010306"
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
--------------050107050201000000010306
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit

Move open counter from md to hash_cell.
The counter is checked at hash_cell removal.
Non-zero counter disallows removal.

As a result, md->holders becomes pure reference counter of md.
It guarantees md is not freed until all tables are freed.

By protecting the counter, the race between open and remove
can be avoided.

Thanks,
-- 
Jun'ichi Nomura, NEC Solutions (America), Inc.

--------------050107050201000000010306
Content-Type: text/x-patch;
 name="03-hc-open-count.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="03-hc-open-count.patch"

Move open counter from md to hash_cell.
The counter is checked at hash_cell removal.
Non-zero counter disallows removal.

As a result, md->holders becomes pure reference counter of md.
It guarantees md is not freed until all tables are freed.

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>

 dm-ioctl.c |  133 ++++++++++++++++++++++++++++++++++++++++++++++---------------
 dm-table.c |    2 
 dm.c       |   63 +++++++++++++---------------
 dm.h       |    1 
 4 files changed, 134 insertions(+), 65 deletions(-)

--- linux-2.6.16-rc6-mm1-dm.02-put-table-after-unlock/drivers/md/dm.c	2006-03-16 14:22:16.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.03-hc-open-count/drivers/md/dm.c	2006-03-16 18:23:51.000000000 -0500
@@ -206,27 +206,6 @@ static void __exit dm_exit(void)
 		_exits[i]();
 }
 
-/*
- * Block device functions
- */
-static int dm_blk_open(struct inode *inode, struct file *file)
-{
-	struct mapped_device *md;
-
-	md = inode->i_bdev->bd_disk->private_data;
-	dm_get(md);
-	return 0;
-}
-
-static int dm_blk_close(struct inode *inode, struct file *file)
-{
-	struct mapped_device *md;
-
-	md = inode->i_bdev->bd_disk->private_data;
-	dm_put(md);
-	return 0;
-}
-
 static inline struct dm_io *alloc_io(struct mapped_device *md)
 {
 	return mempool_alloc(md->io_pool, GFP_NOIO);
@@ -835,7 +814,6 @@ static struct mapped_device *alloc_dev(u
 	md->disk->first_minor = minor;
 	md->disk->fops = &dm_blk_dops;
 	md->disk->queue = md->queue;
-	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 	add_disk(md->disk);
 
@@ -861,6 +839,11 @@ static void free_dev(struct mapped_devic
 {
 	unsigned int minor = md->disk->first_minor;
 
+	if (atomic_read(&md->holders) || md->interface_ptr) {
+		DMERR("Trying to free a device which still has user");
+		BUG();
+	}
+
 	if (md->suspended_bdev) {
 		thaw_bdev(md->suspended_bdev, NULL);
 		bdput(md->suspended_bdev);
@@ -978,8 +961,10 @@ struct mapped_device *dm_get_md(dev_t de
 {
 	struct mapped_device *md = dm_find_md(dev);
 
-	if (md)
-		dm_get(md);
+	if (!md || !md->interface_ptr)
+		return NULL;
+
+	dm_get(md);
 
 	return md;
 }
@@ -1001,18 +986,25 @@ void dm_get(struct mapped_device *md)
 
 void dm_put(struct mapped_device *md)
 {
+	if (atomic_dec_and_test(&md->holders))
+		free_dev(md);
+}
+
+/*
+ * Called when md is released from interface container
+ */
+void dm_free(struct mapped_device *md)
+{
 	struct dm_table *map;
 
-	if (atomic_dec_and_test(&md->holders)) {
-		map = dm_get_table(md);
-		if (!dm_suspended(md)) {
-			dm_table_presuspend_targets(map);
-			dm_table_postsuspend_targets(map);
-		}
-		__unbind(md);
-		dm_table_put(map);
-		free_dev(md);
+	map = dm_get_table(md);
+	if (!dm_suspended(md)) {
+		dm_table_presuspend_targets(map);
+		dm_table_postsuspend_targets(map);
 	}
+	dm_table_put(map);
+	__unbind(md);
+	dm_put(md); /* this likely to be the last put */
 }
 
 /*
@@ -1252,6 +1244,11 @@ int dm_suspended(struct mapped_device *m
 	return test_bit(DMF_SUSPENDED, &md->flags);
 }
 
+/*
+ * Block device interface
+ */
+int dm_blk_open(struct inode *inode, struct file *file);
+int dm_blk_close(struct inode *inode, struct file *file);
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
--- linux-2.6.16-rc6-mm1-dm.02-put-table-after-unlock/drivers/md/dm.h	2006-03-16 16:24:31.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.03-hc-open-count/drivers/md/dm.h	2006-03-16 18:19:28.000000000 -0500
@@ -55,6 +55,7 @@ struct mapped_device *dm_get_md(dev_t de
  */
 void dm_get(struct mapped_device *md);
 void dm_put(struct mapped_device *md);
+void dm_free(struct mapped_device *md);
 
 /*
  * A device can still be used while suspended, but I/O is deferred.
--- linux-2.6.16-rc6-mm1-dm.02-put-table-after-unlock/drivers/md/dm-ioctl.c	2006-03-15 10:15:11.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.03-hc-open-count/drivers/md/dm-ioctl.c	2006-03-16 15:38:26.000000000 -0500
@@ -28,6 +28,7 @@ struct hash_cell {
 	struct list_head name_list;
 	struct list_head uuid_list;
 
+	atomic_t count;
 	char *name;
 	char *uuid;
 	struct mapped_device *md;
@@ -54,6 +55,24 @@ static void dm_hash_remove_all(void);
  */
 DECLARE_RWSEM(dm_sem);
 
+/*
+ * Protects links between block device / ioctl and hash_cell
+ */
+static void __get_cell(struct hash_cell *hc)
+{
+	atomic_inc(&hc->count);
+}
+
+static void __put_cell(struct hash_cell *hc)
+{
+	atomic_dec(&hc->count);
+}
+
+static void __put_md(struct mapped_device *md)
+{
+	__put_cell(dm_get_mdptr(md));
+}
+
 static void init_buckets(struct list_head *buckets)
 {
 	unsigned int i;
@@ -153,6 +172,7 @@ static struct hash_cell *alloc_cell(cons
 	INIT_LIST_HEAD(&hc->uuid_list);
 	hc->md = md;
 	hc->new_map = NULL;
+	atomic_set(&hc->count, 0);
 	return hc;
 }
 
@@ -218,6 +238,7 @@ static int dm_hash_insert(const char *na
 	register_with_devfs(cell);
 	dm_get(md);
 	dm_set_mdptr(md, cell);
+	dm_disk(md)->private_data = cell;
 	up_write(&dm_sem);
 
 	return 0;
@@ -228,6 +249,9 @@ static int dm_hash_insert(const char *na
 	return -EBUSY;
 }
 
+/*
+ * Should be called under dm_sem
+ */
 static void __hash_remove(struct hash_cell *hc)
 {
 	struct dm_table *table;
@@ -237,33 +261,55 @@ static void __hash_remove(struct hash_ce
 	list_del(&hc->name_list);
 	unregister_with_devfs(hc);
 	dm_set_mdptr(hc->md, NULL);
+	dm_put(hc->md);
+	dm_disk(hc->md)->private_data = NULL;
 
 	table = dm_get_table(hc->md);
 	if (table) {
 		dm_table_event(table);
 		dm_table_put(table);
 	}
+}
 
+/*
+ * Called outside of dm_sem
+ */
+static void __hash_free(struct hash_cell *hc)
+{
 	if (hc->new_map)
 		dm_table_put(hc->new_map);
-	dm_put(hc->md);
+	dm_free(hc->md);
 	free_cell(hc);
 }
 
 static void dm_hash_remove_all(void)
 {
-	int i;
+	int i, freed;
 	struct hash_cell *hc;
-	struct list_head *tmp, *n;
+	struct list_head *t, *n, r;
 
+rescan:
+	INIT_LIST_HEAD(&r);
 	down_write(&dm_sem);
-	for (i = 0; i < NUM_BUCKETS; i++) {
-		list_for_each_safe (tmp, n, _name_buckets + i) {
-			hc = list_entry(tmp, struct hash_cell, name_list);
-			__hash_remove(hc);
-		}
-	}
+	do {
+		freed = 0;
+		for (i = 0; i < NUM_BUCKETS; i++)
+			list_for_each_safe (t, n, _name_buckets + i) {
+				hc = list_entry(t, struct hash_cell, name_list);
+				if (atomic_read(&hc->count) == 0) {
+					__hash_remove(hc);
+					list_add(&hc->name_list, &r);
+					freed++;
+				}
+			}
+	} while (freed > 0);
 	up_write(&dm_sem);
+
+	if (!list_empty(&r)) {
+		list_for_each_safe (t, n, &r)
+			__hash_free(list_entry(t, struct hash_cell, name_list));
+		goto rescan;
+	}
 }
 
 static int dm_hash_rename(const char *old, const char *new)
@@ -583,14 +629,13 @@ static int dev_create(struct dm_ioctl *p
 
 	r = dm_hash_insert(param->name, *param->uuid ? param->uuid : NULL, md);
 	if (r) {
-		dm_put(md);
+		dm_free(md);
 		return r;
 	}
 
 	param->flags &= ~DM_INACTIVE_PRESENT_FLAG;
 
 	r = __dev_status(md, param);
-	dm_put(md);
 
 	return r;
 }
@@ -600,22 +645,13 @@ static int dev_create(struct dm_ioctl *p
  */
 static struct hash_cell *__find_device_hash_cell(struct dm_ioctl *param)
 {
-	struct mapped_device *md;
-	void *mdptr = NULL;
-
 	if (*param->uuid)
 		return __get_uuid_cell(param->uuid);
 
 	if (*param->name)
 		return __get_name_cell(param->name);
 
-	md = dm_get_md(huge_decode_dev(param->dev));
-	if (md) {
-		mdptr = dm_get_mdptr(md);
-		dm_put(md);
-	}
-
-	return mdptr;
+	return NULL;
 }
 
 static struct mapped_device *find_device(struct dm_ioctl *param)
@@ -627,7 +663,7 @@ static struct mapped_device *find_device
 	hc = __find_device_hash_cell(param);
 	if (hc) {
 		md = hc->md;
-		dm_get(md);
+		__get_cell(hc);
 
 		/*
 		 * Sneakily write in both the name and the uuid
@@ -662,8 +698,14 @@ static int dev_remove(struct dm_ioctl *p
 		return -ENXIO;
 	}
 
+	if (atomic_read(&hc->count)) {
+		up_write(&dm_sem);
+		return -EBUSY;
+	}
+
 	__hash_remove(hc);
 	up_write(&dm_sem);
+	__hash_free(hc);
 	param->data_size = 0;
 	return 0;
 }
@@ -719,7 +761,7 @@ static int do_suspend(struct dm_ioctl *p
 	if (!r)
 		r = __dev_status(md, param);
 
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -741,7 +783,7 @@ static int do_resume(struct dm_ioctl *pa
 	}
 
 	md = hc->md;
-	dm_get(md);
+	atomic_inc(&hc->count);
 
 	new_map = hc->new_map;
 	hc->new_map = NULL;
@@ -759,7 +801,7 @@ static int do_resume(struct dm_ioctl *pa
 
 		r = dm_swap_table(md, new_map);
 		if (r) {
-			dm_put(md);
+			__put_md(md);
 			dm_table_put(new_map);
 			return r;
 		}
@@ -778,7 +820,7 @@ static int do_resume(struct dm_ioctl *pa
 	if (!r)
 		r = __dev_status(md, param);
 
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -808,7 +850,7 @@ static int dev_status(struct dm_ioctl *p
 		return -ENXIO;
 
 	r = __dev_status(md, param);
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -916,7 +958,7 @@ static int dev_wait(struct dm_ioctl *par
 	}
 
  out:
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -1022,7 +1064,7 @@ static int table_load(struct dm_ioctl *p
 out:
 	if (oldmap)
 		dm_table_put(oldmap);
-	dm_put(md);
+	__put_md(md);
 
 	return r;
 }
@@ -1119,7 +1161,7 @@ static int table_deps(struct dm_ioctl *p
 	}
 
  out:
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -1148,7 +1190,7 @@ static int table_status(struct dm_ioctl 
 	}
 
  out:
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -1209,7 +1251,7 @@ static int target_message(struct dm_ioct
 	kfree(argv);
  out:
 	param->data_size = 0;
-	dm_put(md);
+	__put_md(md);
 	return r;
 }
 
@@ -1424,6 +1466,33 @@ static struct miscdevice _dm_misc = {
 };
 
 /*
+ * Block device interface
+ */
+int dm_blk_open(struct inode *inode, struct file *file)
+{
+	struct hash_cell *hc;
+
+	down_read(&dm_sem);
+	hc = inode->i_bdev->bd_disk->private_data;
+	if (hc)
+		__get_cell(hc);
+	up_read(&dm_sem);
+	return hc ? 0 : -ENXIO;
+}
+
+int dm_blk_close(struct inode *inode, struct file *file)
+{
+	struct hash_cell *hc;
+
+	down_read(&dm_sem);
+	hc = inode->i_bdev->bd_disk->private_data;
+	if (hc)
+		__put_cell(hc);
+	up_read(&dm_sem);
+	return 0;
+}
+
+/*
  * Create misc character device and link to DM_DIR/control.
  */
 int __init dm_interface_init(void)
--- linux-2.6.16-rc6-mm1-dm.02-put-table-after-unlock/drivers/md/dm-table.c	2006-03-13 14:58:13.000000000 -0500
+++ linux-2.6.16-rc6-mm1-dm.03-hc-open-count/drivers/md/dm-table.c	2006-03-16 00:37:43.000000000 -0500
@@ -233,6 +233,7 @@ int dm_table_create(struct dm_table **re
 
 	t->mode = mode;
 	t->md = md;
+	dm_get(md);
 	*result = t;
 	return 0;
 }
@@ -276,6 +277,7 @@ static void table_destroy(struct dm_tabl
 		free_devices(&t->devices);
 	}
 
+	dm_put(t->md);
 	kfree(t);
 }
 

--------------050107050201000000010306
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------050107050201000000010306--
