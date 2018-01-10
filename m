From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 3/3] dm: fix awkward request_queue initialization
Date: Tue,  9 Jan 2018 21:41:04 -0500
Message-ID: <20180110024104.34885-4-snitzer@redhat.com>
References: <20180110024104.34885-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180110024104.34885-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: hch@lst.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Fix DM so that it no longer creates a place-holder request_queue that
doesn't reflect the actual way the request_queue will ulimately be used,
only to have to backfill proper queue and queue_limits initialization.
Instead, DM creates a gendisk that initially doesn't have a
request_queue at all.  This serves to allow DM table loads to own
subordinate devices without first needing to know the aggregated
capabilities that will be needed of the DM device's request_queue.  Once
all DM tables are loaded the request_queue is allocated and DM then
backfills its gendisk's ->queue member and associated sysfs and bdi
initialization via blk_register_queue().

DM is now no longer prone to having its request_queue be improperly
initialized.

Summary of changes:

- alloc_dev() doesn't pre-allocate a place-holder request_queue, and now
  sets md->disk->queue to NULL before calling add_disk().

- dm_setup_md_queue() is updated to allocate and initialize the
  DM's request_queue (_after_ all table loads have occurred and
  request_queue type and features and limits are known).

- dm_setup_md_queue() must call bdi_register_owner() and
  blk_register_queue() because they were not possible at
  add_disk()-time (due to disk->queue being NULL).

Any future "why is disk->queue NULL!?" awkwardness is DM's to own and
shouldn't put more burden on block core (famous last words).  So
potential issues related to disk->queue NULL pointer dereferences should
be for DM maintainer(s) to triage and address.

A very welcome side-effect of these changes is DM no longer needs to:
1) backfill the "mq" sysfs entry (because historically DM didn't
initialize the request_queue to use blk-mq until _after_
register_queue() was called via add_disk()).
2) call elv_register_queue() to get .request_fn request-based DM
device's "queue" exposed in syfs.

These changes also stave off the need to introduce new DM-specific
workarounds in block core, e.g. this proposal:
https://patchwork.kernel.org/patch/10067961/

In the end DM devices should be less unicorn in nature (relative to
initialization and availability of block core infrastructure).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h  |  2 --
 drivers/md/dm-ioctl.c |  7 ++----
 drivers/md/dm-rq.c    | 13 +---------
 drivers/md/dm-table.c |  2 +-
 drivers/md/dm.c       | 66 +++++++++++++++++++++++++++++++--------------------
 5 files changed, 44 insertions(+), 46 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 6a14f945783c..f955123b4765 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -130,8 +130,6 @@ struct mapped_device {
 	struct srcu_struct io_barrier;
 };
 
-void dm_init_md_queue(struct mapped_device *md);
-void dm_init_normal_md_queue(struct mapped_device *md);
 int md_in_flight(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
diff --git a/drivers/md/dm-ioctl.c b/drivers/md/dm-ioctl.c
index e52676fa9832..cf8908a6fcc9 100644
--- a/drivers/md/dm-ioctl.c
+++ b/drivers/md/dm-ioctl.c
@@ -1334,13 +1334,10 @@ static int table_load(struct file *filp, struct dm_ioctl *param, size_t param_si
 	}
 
 	if (dm_get_md_type(md) == DM_TYPE_NONE) {
-		/* Initial table load: acquire type of table. */
-		dm_set_md_type(md, dm_table_get_type(t));
-
-		/* setup md->queue to reflect md's type (may block) */
+		/* setup md->type and md->queue to reflect table's type (may block) */
 		r = dm_setup_md_queue(md, t);
 		if (r) {
-			DMWARN("unable to set up device queue for new table.");
+			DMWARN("unable to setup queue for device.");
 			goto err_unlock_md_type;
 		}
 	} else if (!is_valid_type(dm_get_md_type(md), dm_table_get_type(t))) {
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9d32f25489c2..ab95cc3f2f29 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -56,7 +56,7 @@ static unsigned dm_get_blk_mq_queue_depth(void)
 
 int dm_request_based(struct mapped_device *md)
 {
-	return queue_is_rq_based(md->queue);
+	return md->queue && queue_is_rq_based(md->queue);
 }
 
 static void dm_old_start_queue(struct request_queue *q)
@@ -700,7 +700,6 @@ int dm_old_init_request_queue(struct mapped_device *md, struct dm_table *t)
 	/* disable dm_old_request_fn's merge heuristic by default */
 	md->seq_rq_merge_deadline_usecs = 0;
 
-	dm_init_normal_md_queue(md);
 	blk_queue_softirq_done(md->queue, dm_softirq_done);
 
 	/* Initialize the request-based DM worker thread */
@@ -713,8 +712,6 @@ int dm_old_init_request_queue(struct mapped_device *md, struct dm_table *t)
 		return error;
 	}
 
-	elv_register_queue(md->queue);
-
 	return 0;
 }
 
@@ -810,17 +807,9 @@ int dm_mq_init_request_queue(struct mapped_device *md, struct dm_table *t)
 		err = PTR_ERR(q);
 		goto out_tag_set;
 	}
-	dm_init_md_queue(md);
-
-	/* backfill 'mq' sysfs registration normally done in blk_register_queue */
-	err = blk_mq_register_dev(disk_to_dev(md->disk), q);
-	if (err)
-		goto out_cleanup_queue;
 
 	return 0;
 
-out_cleanup_queue:
-	blk_cleanup_queue(q);
 out_tag_set:
 	blk_mq_free_tag_set(md->tag_set);
 out_kfree_tag_set:
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index aaffd0c0ee9a..4cd9a8f69b55 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1161,7 +1161,7 @@ static int dm_table_build_index(struct dm_table *t)
 
 static bool integrity_profile_exists(struct gendisk *disk)
 {
-	return !!blk_get_integrity(disk);
+	return disk->queue && !!blk_get_integrity(disk);
 }
 
 /*
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7475739fee49..0dff9b131884 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1626,20 +1626,9 @@ static const struct dax_operations dm_dax_ops;
 
 static void dm_wq_work(struct work_struct *work);
 
-void dm_init_md_queue(struct mapped_device *md)
-{
-	/*
-	 * Initialize data that will only be used by a non-blk-mq DM queue
-	 * - must do so here (in alloc_dev callchain) before queue is used
-	 */
-	md->queue->queuedata = md;
-	md->queue->backing_dev_info->congested_data = md;
-}
-
-void dm_init_normal_md_queue(struct mapped_device *md)
+static void dm_init_normal_md_queue(struct mapped_device *md)
 {
 	md->use_blk_mq = false;
-	dm_init_md_queue(md);
 
 	/*
 	 * Initialize aspects of queue that aren't relevant for blk-mq
@@ -1731,13 +1720,7 @@ static struct mapped_device *alloc_dev(int minor)
 	INIT_LIST_HEAD(&md->table_devices);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
-	if (!md->queue)
-		goto bad;
-
-	dm_init_md_queue(md);
-
-	md->disk = alloc_disk_node(1, numa_node_id);
+	md->disk = alloc_disk_node(1, md->numa_node_id);
 	if (!md->disk)
 		goto bad;
 
@@ -1752,7 +1735,7 @@ static struct mapped_device *alloc_dev(int minor)
 	md->disk->major = _major;
 	md->disk->first_minor = minor;
 	md->disk->fops = &dm_blk_dops;
-	md->disk->queue = md->queue;
+	md->disk->queue = NULL;
 	md->disk->private_data = md;
 	sprintf(md->disk->disk_name, "dm-%d", minor);
 
@@ -1962,13 +1945,18 @@ static struct dm_table *__unbind(struct mapped_device *md)
  */
 int dm_create(int minor, struct mapped_device **result)
 {
+	int r;
 	struct mapped_device *md;
 
 	md = alloc_dev(minor);
 	if (!md)
 		return -ENXIO;
 
-	dm_sysfs_init(md);
+	r = dm_sysfs_init(md);
+	if (r) {
+		free_dev(md);
+		return r;
+	}
 
 	*result = md;
 	return 0;
@@ -2021,21 +2009,31 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	int r;
-	enum dm_queue_mode type = dm_get_md_type(md);
+	struct queue_limits limits;
+	enum dm_queue_mode type = dm_table_get_type(t);
+
+	md->queue = blk_alloc_queue_node(GFP_KERNEL, md->numa_node_id);
+	if (!md->queue) {
+		DMERR("Cannot allocate queue for mapped device");
+		return -ENOMEM;
+	}
+	md->queue->queuedata = md;
+	md->queue->backing_dev_info->congested_data = md;
 
 	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
+		dm_init_normal_md_queue(md);
 		r = dm_old_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based mapped device");
-			return r;
+			goto bad;
 		}
 		break;
 	case DM_TYPE_MQ_REQUEST_BASED:
 		r = dm_mq_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based dm-mq mapped device");
-			return r;
+			goto bad;
 		}
 		break;
 	case DM_TYPE_BIO_BASED:
@@ -2057,7 +2055,23 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		break;
 	}
 
+	r = dm_calculate_queue_limits(t, &limits);
+	if (r) {
+		DMERR("Cannot calculate initial queue limits");
+		goto bad;
+	}
+	dm_table_set_restrictions(t, md->queue, &limits);
+
+	md->disk->queue = md->queue;
+	WARN_ON(bdi_register_owner(md->queue->backing_dev_info,
+				   disk_to_dev(md->disk)));
+	blk_register_queue(md->disk);
+
+	dm_set_md_type(md, type);
 	return 0;
+bad:
+	blk_cleanup_queue(md->queue);
+	return r;
 }
 
 struct mapped_device *dm_get_md(dev_t dev)
@@ -2121,7 +2135,6 @@ EXPORT_SYMBOL_GPL(dm_device_name);
 
 static void __dm_destroy(struct mapped_device *md, bool wait)
 {
-	struct request_queue *q = dm_get_md_queue(md);
 	struct dm_table *map;
 	int srcu_idx;
 
@@ -2132,7 +2145,8 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	blk_set_queue_dying(q);
+	if (md->queue)
+		blk_set_queue_dying(md->queue);
 
 	if (dm_request_based(md) && md->kworker_task)
 		kthread_flush_worker(&md->kworker);
-- 
2.15.0
