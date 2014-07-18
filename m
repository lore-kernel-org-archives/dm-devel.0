From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm-multipath: Accept failed paths for multipath maps
Date: Thu, 17 Jul 2014 20:23:19 -0400
Message-ID: <20140718002319.GA20071@redhat.com>
References: <1387353155-7271-1-git-send-email-hare@suse.de>
	<20131218140858.GC17730@redhat.com> <52B1B046.3040301@suse.de>
	<1387380498.7608.6.camel@ict-vth-stewarts01.ict.englab.netapp.com>
	<20140718000411.GB337@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20140718000411.GB337@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Stewart, Sean" <Sean.Stewart@netapp.com>
Cc: device-mapper development <dm-devel@redhat.com>, Bryn Reeves <breeves@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

On Thu, Jul 17 2014 at  8:04pm -0400,
Mike Snitzer <snitzer@redhat.com> wrote:
 
> Revisiting this can of worms...
> 
> As part of full due-diligence on the approach that SUSE and NetApp have
> seemingly enjoyed "for years" I reviewed Hannes' v3 patch, fixed one
> issue and did some cleanup.  I then converted over to using a slightly
> different approach where-in the DM core becomes a more willing
> co-conspirator in this hack by introducing the ability to have
> place-holder devices (dm_dev without an opened bdev) referenced in a DM
> table.  The work is here:
> http://git.kernel.org/cgit/linux/kernel/git/snitzer/linux.git/log/?h=throwaway-dm-mpath-placeholder-devs

Here is the rolled up patch (the individual commits in the above branch
are rather noisy given the sequencing):

 drivers/md/dm-mpath.c | 51 +++++++++++++++++++++++++++++++++----------------
 drivers/md/dm-table.c | 53 ++++++++++++++++++++++++++++++++++++++-------------
 drivers/md/dm.c       |  5 ++---
 drivers/md/dm.h       | 12 ++++++++++++
 4 files changed, 89 insertions(+), 32 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 833d7e7..6c3ddd2 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -162,7 +162,7 @@ static void free_pgpaths(struct list_head *pgpaths, struct dm_target *ti)
 
 	list_for_each_entry_safe(pgpath, tmp, pgpaths, list) {
 		list_del(&pgpath->list);
-		if (m->hw_handler_name)
+		if (m->hw_handler_name && pgpath->path.dev->bdev)
 			scsi_dh_detach(bdev_get_queue(pgpath->path.dev->bdev));
 		dm_put_device(ti, pgpath->path.dev);
 		free_pgpath(pgpath);
@@ -306,6 +306,11 @@ static int __choose_path_in_pg(struct multipath *m, struct priority_group *pg,
 
 	m->current_pgpath = path_to_pgpath(path);
 
+	if (!m->current_pgpath->path.dev->bdev) {
+		m->current_pgpath = NULL;
+		return -ENODEV;
+	}
+
 	if (m->current_pg != pg)
 		__switch_pg(m, m->current_pgpath);
 
@@ -509,6 +514,9 @@ static int parse_path_selector(struct dm_arg_set *as, struct priority_group *pg,
 	return 0;
 }
 
+static void __fail_path(struct pgpath *pgpath, struct multipath *m,
+			struct path_selector *ps);
+
 static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps,
 			       struct dm_target *ti)
 {
@@ -528,17 +536,19 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 	if (!p)
 		return ERR_PTR(-ENOMEM);
 
-	r = dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
-			  &p->path.dev);
+	r = __dm_get_device(ti, dm_shift_arg(as), dm_table_get_mode(ti->table),
+			    &p->path.dev, true);
 	if (r) {
 		ti->error = "error getting device";
 		goto bad;
 	}
 
-	if (m->retain_attached_hw_handler || m->hw_handler_name)
+	if (p->path.dev->bdev)
 		q = bdev_get_queue(p->path.dev->bdev);
+	else
+		p->is_active = 0;
 
-	if (m->retain_attached_hw_handler) {
+	if (q && m->retain_attached_hw_handler) {
 		attached_handler_name = scsi_dh_attached_handler_name(q, GFP_KERNEL);
 		if (attached_handler_name) {
 			/*
@@ -557,7 +567,7 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		}
 	}
 
-	if (m->hw_handler_name) {
+	if (q && m->hw_handler_name) {
 		/*
 		 * Increments scsi_dh reference, even when using an
 		 * already-attached handler.
@@ -596,6 +606,9 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
+	if (!p->is_active)
+		__fail_path(p, m, ps);
+
 	return p;
 
  bad:
@@ -912,6 +925,15 @@ static void multipath_dtr(struct dm_target *ti)
 	free_multipath(m);
 }
 
+static void __fail_path(struct pgpath *pgpath, struct multipath *m,
+			struct path_selector *ps)
+{
+	ps->type->fail_path(ps, &pgpath->path);
+	pgpath->fail_count++;
+
+	m->nr_valid_paths--;
+}
+
 /*
  * Take a path out of use.
  */
@@ -927,17 +949,14 @@ static int fail_path(struct pgpath *pgpath)
 
 	DMWARN("Failing path %s.", pgpath->path.dev->name);
 
-	pgpath->pg->ps.type->fail_path(&pgpath->pg->ps, &pgpath->path);
 	pgpath->is_active = 0;
-	pgpath->fail_count++;
-
-	m->nr_valid_paths--;
+	__fail_path(pgpath, m, &pgpath->pg->ps);
 
 	if (pgpath == m->current_pgpath)
 		m->current_pgpath = NULL;
 
 	dm_path_uevent(DM_UEVENT_PATH_FAILED, m->ti,
-		      pgpath->path.dev->name, m->nr_valid_paths);
+		       pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
 
@@ -983,7 +1002,7 @@ static int reinstate_path(struct pgpath *pgpath)
 	}
 
 	dm_path_uevent(DM_UEVENT_PATH_REINSTATED, m->ti,
-		      pgpath->path.dev->name, m->nr_valid_paths);
+		       pgpath->path.dev->name, m->nr_valid_paths);
 
 	schedule_work(&m->trigger_event);
 
@@ -1195,7 +1214,7 @@ static void activate_path(struct work_struct *work)
 	struct pgpath *pgpath =
 		container_of(work, struct pgpath, activate_path.work);
 
-	if (pgpath->is_active)
+	if (pgpath->is_active && pgpath->path.dev->bdev)
 		scsi_dh_activate(bdev_get_queue(pgpath->path.dev->bdev),
 				 pg_init_done, pgpath);
 	else
@@ -1528,7 +1547,7 @@ static int multipath_ioctl(struct dm_target *ti, unsigned int cmd,
 
 	pgpath = m->current_pgpath;
 
-	if (pgpath) {
+	if (pgpath && pgpath->path.dev->bdev) {
 		bdev = pgpath->path.dev->bdev;
 		mode = pgpath->path.dev->mode;
 	}
@@ -1586,9 +1605,9 @@ out:
 
 static int __pgpath_busy(struct pgpath *pgpath)
 {
-	struct request_queue *q = bdev_get_queue(pgpath->path.dev->bdev);
+	struct request_queue *q = dm_dev_get_queue(pgpath->path.dev);
 
-	return dm_underlying_device_busy(q);
+	return q && dm_underlying_device_busy(q);
 }
 
 /*
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 3c72bf1..1ef1601 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -262,7 +262,7 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 	struct dm_dev_internal *dd;
 
 	list_for_each_entry (dd, l, list)
-		if (dd->dm_dev.bdev->bd_dev == dev)
+		if (dd->dm_dev.bdev && dd->dm_dev.bdev->bd_dev == dev)
 			return dd;
 
 	return NULL;
@@ -317,12 +317,16 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
-	sector_t dev_size =
-		i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
+	sector_t dev_size;
 	unsigned short logical_block_size_sectors =
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
+	if (!bdev)
+		return 0;
+
+	dev_size = i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
+
 	/*
 	 * Some devices exist without request functions,
 	 * such as loop devices not yet bound to backing files.
@@ -393,6 +397,9 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
 	dd_new.dm_dev.mode |= new_mode;
 	dd_new.dm_dev.bdev = NULL;
 
+	if (!dd->dm_dev.bdev)
+		return 0;
+
 	r = open_dev(&dd_new, dd->dm_dev.bdev->bd_dev, md);
 	if (r)
 		return r;
@@ -407,8 +414,8 @@ static int upgrade_mode(struct dm_dev_internal *dd, fmode_t new_mode,
  * Add a device to the list, or just increment the usage count if
  * it's already present.
  */
-int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
-		  struct dm_dev **result)
+int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		    struct dm_dev **result, bool open_may_fail)
 {
 	int r;
 	dev_t uninitialized_var(dev);
@@ -443,7 +450,8 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 		dd->dm_dev.mode = mode;
 		dd->dm_dev.bdev = NULL;
 
-		if ((r = open_dev(dd, dev, t->md))) {
+		r = open_dev(dd, dev, t->md);
+		if (r && !open_may_fail) {
 			kfree(dd);
 			return r;
 		}
@@ -463,6 +471,13 @@ int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
 	*result = &dd->dm_dev;
 	return 0;
 }
+EXPORT_SYMBOL_GPL(__dm_get_device);
+
+int dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		  struct dm_dev **result)
+{
+	return __dm_get_device(ti, path, mode, result, false);
+}
 EXPORT_SYMBOL(dm_get_device);
 
 static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
@@ -470,9 +485,13 @@ static int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
 {
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
+	struct request_queue *q;
 	char b[BDEVNAME_SIZE];
 
+	if (!bdev)
+		return 0;
+
+	q = bdev_get_queue(bdev);
 	if (unlikely(!q)) {
 		DMWARN("%s: Cannot set limits for nonexistent device %s",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
@@ -906,6 +925,8 @@ static int dm_table_set_type(struct dm_table *t)
 	/* Non-request-stackable devices can't be used for request-based dm */
 	devices = dm_table_get_devices(t);
 	list_for_each_entry(dd, devices, list) {
+		if (!dd->dm_dev.bdev)
+			continue;
 		if (!blk_queue_stackable(bdev_get_queue(dd->dm_dev.bdev))) {
 			DMWARN("table load rejected: including"
 			       " non-request-stackable devices");
@@ -1043,6 +1064,8 @@ static struct gendisk * dm_table_get_integrity_disk(struct dm_table *t,
 	struct gendisk *prev_disk = NULL, *template_disk = NULL;
 
 	list_for_each_entry(dd, devices, list) {
+		if (!dd->dm_dev.bdev)
+			continue;
 		template_disk = dd->dm_dev.bdev->bd_disk;
 		if (!blk_get_integrity(template_disk))
 			goto no_integrity;
@@ -1321,7 +1344,7 @@ static int device_flush_capable(struct dm_target *ti, struct dm_dev *dev,
 				sector_t start, sector_t len, void *data)
 {
 	unsigned flush = (*(unsigned *)data);
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct request_queue *q = dm_dev_get_queue(dev);
 
 	return q && (q->flush_flags & flush);
 }
@@ -1373,7 +1396,7 @@ static bool dm_table_discard_zeroes_data(struct dm_table *t)
 static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
 			    sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct request_queue *q = dm_dev_get_queue(dev);
 
 	return q && blk_queue_nonrot(q);
 }
@@ -1381,7 +1404,7 @@ static int device_is_nonrot(struct dm_target *ti, struct dm_dev *dev,
 static int device_is_not_random(struct dm_target *ti, struct dm_dev *dev,
 			     sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct request_queue *q = dm_dev_get_queue(dev);
 
 	return q && !blk_queue_add_random(q);
 }
@@ -1406,7 +1429,7 @@ static bool dm_table_all_devices_attribute(struct dm_table *t,
 static int device_not_write_same_capable(struct dm_target *ti, struct dm_dev *dev,
 					 sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct request_queue *q = dm_dev_get_queue(dev);
 
 	return q && !q->limits.max_write_same_sectors;
 }
@@ -1433,7 +1456,7 @@ static bool dm_table_supports_write_same(struct dm_table *t)
 static int device_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q = bdev_get_queue(dev->bdev);
+	struct request_queue *q = dm_dev_get_queue(dev);
 
 	return q && blk_queue_discard(q);
 }
@@ -1616,9 +1639,13 @@ int dm_table_any_congested(struct dm_table *t, int bdi_bits)
 	int r = 0;
 
 	list_for_each_entry(dd, devices, list) {
-		struct request_queue *q = bdev_get_queue(dd->dm_dev.bdev);
+		struct request_queue *q;
 		char b[BDEVNAME_SIZE];
 
+		if (!dd->dm_dev.bdev)
+			continue;
+
+		q = bdev_get_queue(dd->dm_dev.bdev);
 		if (likely(q))
 			r |= bdi_congested(&q->backing_dev_info, bdi_bits);
 		else
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 32b958d..60989fa 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2148,10 +2148,9 @@ static int dm_device_merge_is_compulsory(struct dm_target *ti,
 					 struct dm_dev *dev, sector_t start,
 					 sector_t len, void *data)
 {
-	struct block_device *bdev = dev->bdev;
-	struct request_queue *q = bdev_get_queue(bdev);
+	struct request_queue *q = dm_dev_get_queue(dev);
 
-	return dm_queue_merge_is_compulsory(q);
+	return q && dm_queue_merge_is_compulsory(q);
 }
 
 /*
diff --git a/drivers/md/dm.h b/drivers/md/dm.h
index e81d215..aa30a05 100644
--- a/drivers/md/dm.h
+++ b/drivers/md/dm.h
@@ -85,6 +85,18 @@ struct target_type *dm_get_immutable_target_type(struct mapped_device *md);
 
 int dm_setup_md_queue(struct mapped_device *md);
 
+static inline struct request_queue *dm_dev_get_queue(struct dm_dev *dev)
+{
+	return dev->bdev ? bdev_get_queue(dev->bdev) : NULL;
+}
+
+/*
+ * Variant of dm_get_device that allows place-holder devices to be referenced,
+ * but you _really_ shouldn't need to use this!
+ */
+int __dm_get_device(struct dm_target *ti, const char *path, fmode_t mode,
+		    struct dm_dev **result, bool open_may_fail);
+
 /*
  * To check the return value from dm_table_find_target().
  */
