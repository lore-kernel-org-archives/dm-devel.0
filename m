From: Benjamin Marzinski <bmarzins@redhat.com>
Subject: [PATCH 2/2] device-mapper: allow tables to share dm_devs
Date: Wed, 13 Aug 2014 13:53:43 -0500
Message-ID: <1407956023-32372-3-git-send-email-bmarzins@redhat.com>
References: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1407956023-32372-1-git-send-email-bmarzins@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: Junichi Nomura <j-nomura@ce.jp.nec.com>
List-Id: dm-devel.ids

When a new table is created, in needs to open all of the devices that it
will use.  For multipathi, this can cause problems because it may need to
reload a table while some devices are unusable. To get around this, device
mapper now stores the dm_devs list for all table devices in the
mapped-device object itself, and the tables' device lists just point to the
main list.

The device list code in dm.c isn't a straight copy/paste form the code in
dm-table.c, but it's very close. One subtle difference is that find_devices
for the mapped-device list will only match devices with the same name and
mode. This is because we don't want to upgrade a device's mode because of
a new inactive table.

Access to the main list requires a mutex, so that tables can be created
and destroyed concurrently.

Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
---
 drivers/md/dm-ioctl.c |   2 +-
 drivers/md/dm-table.c | 101 ++++++++++++++---------------------------
 drivers/md/dm.c       | 123 ++++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm.h       |   5 +-
 4 files changed, 161 insertions(+), 70 deletions(-)

diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index 5152142..0be9381 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1418,7 +1418,7 @@ static void retrieve_deps(struct dm_table *table,
 	deps->count = count;
 	count = 0;
 	list_for_each_entry (dd, dm_table_get_devices(table), list)
-		deps->dev[count++] = huge_encode_dev(dd->dm_dev.bdev->bd_dev);
+		deps->dev[count++] = huge_encode_dev(dd->dm_dev->bdev->bd_dev);
 
 	param->data_size = param->data_start + needed;
 }
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 5f59f1e..9c9cd1d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -210,15 +210,15 @@ int dm_table_create(struct dm_table **result, fmode_t mode,
 	return 0;
 }
 
-static void free_devices(struct list_head *devices)
+static void free_devices(struct mapped_device *md, struct list_head *devices)
 {
 	struct list_head *tmp, *next;
 
 	list_for_each_safe(tmp, next, devices) {
 		struct dm_dev_internal *dd =
 		    list_entry(tmp, struct dm_dev_internal, list);
-		DMWARN("dm_table_destroy: dm_put_device call missing for %s",
-		       dd->dm_dev.name);
+		DMWARN("%s: dm_table_destroy: dm_put_device call missing for %s", dm_device_name(md), dd->dm_dev->name);
+		dm_put_table_device(md, dd->dm_dev);
 		kfree(dd);
 	}
 }
@@ -247,7 +247,7 @@ void dm_table_destroy(struct dm_table *t)
 	vfree(t->highs);
 
 	/* free the device list */
-	free_devices(&t->devices);
+	free_devices(t->md, &t->devices);
 
 	dm_free_md_mempools(t->mempools);
 
@@ -262,53 +262,13 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry (dd, l, list)
-		if (dd->dm_dev.bdev->bd_dev == dev)
+		if (dd->dm_dev->bdev->bd_dev == dev)
 			return dd;
 
 	return NULL;
 }
 
 /*
- * Open a device so we can use it as a map destination.
- */
-static int open_dev(struct dm_dev_internal *d, dev_t dev,
-		    struct mapped_device *md)
-{
-	static char *_claim_ptr = "I belong to device-mapper";
-	struct block_device *bdev;
-
-	int r;
-
-	BUG_ON(d->dm_dev.bdev);
-
-	bdev = blkdev_get_by_dev(dev, d->dm_dev.mode | FMODE_EXCL, _claim_ptr);
-	if (IS_ERR(bdev))
-		return PTR_ERR(bdev);
-
-	r = bd_link_disk_holder(bdev, dm_disk(md));
-	if (r) {
-		blkdev_put(bdev, d->dm_dev.mode | FMODE_EXCL);
-		return r;
-	}
-
-	d->dm_dev.bdev = bdev;
-	return 0;
-}
-
-/*
- * Close a device that we've been using.
- */
-static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
-{
-	if (!d->dm_dev.bdev)
-		return;
-
-	bd_unlink_disk_holder(d->dm_dev.bdev, dm_disk(md));
-	blkdev_put(d->dm_dev.bdev, d->dm_dev.mode | FMODE_EXCL);
-	d->dm_dev.bdev = NULL;
-}
-
-/*
  * If possible, this checks an area of a destination device is invalid.
  */
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
@@ -386,19 +346,17 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
 			struct mapped_device *md)
 {
 	int r;
-	struct dm_dev_internal dd_new, dd_old;
-
-	dd_new = dd_old = *dd;
+	struct dm_dev *old_dev, *new_dev;
 
-	dd_new.dm_dev.mode |= new_mode;
-	dd_new.dm_dev.bdev = NULL;
+	old_dev = dd->dm_dev;
 
-	r = open_dev(&dd_new, dd->dm_dev.bdev->bd_dev, md);
+	r = dm_get_table_device(md, dd->dm_dev->bdev->bd_dev,
+				dd->dm_dev->mode | new_mode, &new_dev);
 	if (r)
 		return r;
 
-	dd->dm_dev.mode |= new_mode;
-	close_dev(&dd_old, md);
+	dd->dm_dev = new_dev;
+	dm_put_table_device(md, old_dev);
 
 	return 0;
 }
@@ -440,27 +398,22 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		if (!dd)
 			return -ENOMEM;
 
-		dd->dm_dev.mode = mode;
-		dd->dm_dev.bdev = NULL;
-
-		if ((r = open_dev(dd, dev, t->md))) {
+		if ((r = dm_get_table_device(t->md, dev, mode, &dd->dm_dev))) {
 			kfree(dd);
 			return r;
 		}
 
-		format_dev_t(dd->dm_dev.name, dev);
-
 		atomic_set(&dd->count, 0);
 		list_add(&dd->list, &t->devices);
 
-	} else if (dd->dm_dev.mode != (mode | dd->dm_dev.mode)) {
+	} else if (dd->dm_dev->mode != (mode | dd->dm_dev->mode)) {
 		r = upgrade_mode(dd, mode, t->md);
 		if (r)
 			return r;
 	}
 	atomic_inc(&dd->count);
 
-	*result = &dd->dm_dev;
+	*result = dd->dm_dev;
 	return 0;
 }
 EXPORT_SYMBOL(dm_get_device);
@@ -505,11 +458,23 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
  */
 void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 {
-	struct dm_dev_internal *dd = container_of(d, struct dm_dev_internal,
-						  dm_dev);
+	int found = 0;
+	struct list_head *l = &ti->table->devices;
+	struct dm_dev_internal *dd;
 
+	list_for_each_entry (dd, l, list) {
+		if (dd->dm_dev == d) {
+			found = 1;
+			break;
+		}
+	}
+	if (!found) {
+		DMWARN("%s: device %s not in table list",
+		       dm_device_name(ti->table->md), d->name);
+		return;
+	}
 	if (atomic_dec_and_test(&dd->count)) {
-		close_dev(dd, ti->table->md);
+		dm_put_table_device(ti->table->md, d);
 		list_del(&dd->list);
 		kfree(dd);
 	}
@@ -906,7 +871,7 @@ static int dm_table_set_type(struct dm_table *t)
 	/* Non-request-stackable devices can't be used for request-based dm */
 	devices = dm_table_get_devices(t);
 	list_for_each_entry(dd, devices, list) {
-		if (!blk_queue_stackable(bdev_get_queue(dd->dm_dev.bdev))) {
+		if (!blk_queue_stackable(bdev_get_queue(dd->dm_dev->bdev))) {
 			DMWARN("table load rejected: including"
 			       " non-request-stackable devices");
 			return -EINVAL;
@@ -1043,7 +1008,7 @@ static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t,
 	struct gendisk *prev_disk = NULL, *template_disk = NULL;
 
 	list_for_each_entry(dd, devices, list) {
-		template_disk = dd->dm_dev.bdev->bd_disk;
+		template_disk = dd->dm_dev->bdev->bd_disk;
 		if (!blk_get_integrity(template_disk))
 			goto no_integrity;
 		if (!match_all && !blk_integrity_is_initialized(template_disk))
@@ -1579,7 +1544,7 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 	int r = 0;
 
 	list_for_each_entry(dd, devices, list) {
-		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
+		struct request_queue *q = bdev_get_queue(dd->dm_dev->bdev);
 		char b[BDEVNAME_SIZE];
 
 		if (likely(q))
@@ -1587,7 +1552,7 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 		else
 			DMWARN_LIMIT("%s: any_congested: nonexistent device %s",
 				     dm_device_name(t->md),
-				     bdevname(dd->dm_dev.bdev, b));
+				     bdevname(dd->dm_dev->bdev, b));
 	}
 
 	list_for_each_entry(cb, &t->target_callbacks, list)
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 437d990..d33b7f1 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -140,6 +140,9 @@ struct mapped_device {
 	 */
 	struct dm_table *map;
 
+	struct list_head table_devices;
+	struct mutex devs_lock;
+
 	unsigned long flags;
 
 	struct request_queue *queue;
@@ -210,6 +213,12 @@ struct dm_md_mempools {
 	struct bio_set *bs;
 };
 
+struct table_device {
+	struct list_head list;
+	atomic_t count;
+	struct dm_dev dm_dev;
+};
+
 #define RESERVED_BIO_BASED_IOS		16
 #define RESERVED_REQUEST_BASED_IOS	256
 #define RESERVED_MAX_IOS		1024
@@ -659,6 +668,117 @@ static void dm_put_live_table_fast(struct mapped_device *md) __releases(RCU)
 }
 
 /*
+ * Open a table device so we can use it as a map destination.
+ */
+static int open_dev(struct table_device *d, dev_t dev,
+		    struct mapped_device *md)
+{
+	static char *_claim_ptr = "I belong to device-mapper";
+	struct block_device *bdev;
+
+	int r;
+
+	BUG_ON(d->dm_dev.bdev);
+
+	bdev = blkdev_get_by_dev(dev, d->dm_dev.mode | FMODE_EXCL, _claim_ptr);
+	if (IS_ERR(bdev))
+		return PTR_ERR(bdev);
+
+	r = bd_link_disk_holder(bdev, dm_disk(md));
+	if (r) {
+		blkdev_put(bdev, d->dm_dev.mode | FMODE_EXCL);
+		return r;
+	}
+
+	d->dm_dev.bdev = bdev;
+	return 0;
+}
+
+/*
+ * Close a table device that we've been using.
+ */
+static void close_dev(struct table_device *d, struct mapped_device *md)
+{
+	if (!d->dm_dev.bdev)
+		return;
+
+	bd_unlink_disk_holder(d->dm_dev.bdev, dm_disk(md));
+	blkdev_put(d->dm_dev.bdev, d->dm_dev.mode | FMODE_EXCL);
+	d->dm_dev.bdev = NULL;
+}
+
+static struct table_device *find_device(struct list_head *l, dev_t dev,
+					fmode_t mode) {
+	struct table_device *dd;
+
+	list_for_each_entry (dd, l, list)
+		if (dd->dm_dev.bdev->bd_dev == dev && dd->dm_dev.mode == mode)
+			return dd;
+
+	return NULL;
+}
+
+int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
+			struct dm_dev **result) {
+	int r;
+	struct table_device *dd;
+
+	mutex_lock(&md->devs_lock);
+	dd = find_device(&md->table_devices, dev, mode);
+	if (!dd) {
+		dd = kmalloc(sizeof(*dd), GFP_KERNEL);
+		if (!dd)
+			return -ENOMEM;
+
+		dd->dm_dev.mode = mode;
+		dd->dm_dev.bdev = NULL;
+
+		if ((r = open_dev(dd, dev, md))) {
+			kfree(dd);
+			return r;
+		}
+
+		format_dev_t(dd->dm_dev.name, dev);
+
+		atomic_set(&dd->count, 0);
+		list_add(&dd->list, &md->table_devices);
+	}
+
+	atomic_inc(&dd->count);
+	mutex_unlock(&md->devs_lock);
+	*result = &dd->dm_dev;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_get_table_device);
+
+void dm_put_table_device(struct mapped_device *md, struct dm_dev *d)
+{
+	struct table_device *dd = container_of(d, struct table_device, dm_dev);
+
+	mutex_lock(&md->devs_lock);
+	if (atomic_dec_and_test(&dd->count)) {
+		close_dev(dd, md);
+		list_del(&dd->list);
+		kfree(dd);
+	}
+	mutex_unlock(&md->devs_lock);
+}
+EXPORT_SYMBOL(dm_put_table_device);
+
+static void free_devices(struct list_head *devices)
+{
+	struct list_head *tmp, *next;
+
+	list_for_each_safe(tmp, next, devices) {
+		struct table_device *dd = list_entry(tmp, struct table_device,
+						     list);
+		DMWARN("dm_destroy: %s still exists with %d references",
+		       dd->dm_dev.name, atomic_read(&dd->count));
+		kfree(dd);
+	}
+}
+
+/*
  * Get the geometry associated with a dm device
  */
 int dm_get_geometry(struct mapped_device *md, struct hd_geometry *geo)
@@ -1938,12 +2058,14 @@ static struct mapped_device *alloc_dev(int minor)
 	md->type = DM_TYPE_NONE;
 	mutex_init(&md->suspend_lock);
 	mutex_init(&md->type_lock);
+	mutex_init(&md->devs_lock);
 	spin_lock_init(&md->deferred_lock);
 	atomic_set(&md->holders, 1);
 	atomic_set(&md->open_count, 0);
 	atomic_set(&md->event_nr, 0);
 	atomic_set(&md->uevent_seq, 0);
 	INIT_LIST_HEAD(&md->uevent_list);
+	INIT_LIST_HEAD(&md->table_devices);
 	spin_lock_init(&md->uevent_lock);
 
 	md->queue = blk_alloc_queue(GFP_KERNEL);
@@ -2029,6 +2151,7 @@ static void free_dev(struct mapped_device *md)
 	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	cleanup_srcu_struct(&md->io_barrier);
+	free_devices(&md->table_devices);
 	free_minor(minor);
 
 	spin_lock(&_minor_lock);
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index ed76126..e6aa368 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -44,7 +44,7 @@
 struct dm_dev_internal {
 	struct list_head list;
 	atomic_t count;
-	struct dm_dev dm_dev;
+	struct dm_dev *dm_dev;
 };
 
 struct dm_table;
@@ -189,6 +189,9 @@ int dm_cancel_deferred_remove(struct mapped_device *md);
 int dm_request_based(struct mapped_device *md);
 sector_t dm_get_size(struct mapped_device *md);
 struct request_queue *dm_get_md_queue(struct mapped_device *md);
+int dm_get_table_device(struct mapped_device *md, dev_t dev, fmode_t mode,
+			struct dm_dev **result);
+void dm_put_table_device(struct mapped_device *md, struct dm_dev *d);
 struct dm_stats *dm_get_stats(struct mapped_device *md);
 
 int dm_kobject_uevent(struct mapped_device *md, enum kobject_action action,
-- 
1.8.3.1
