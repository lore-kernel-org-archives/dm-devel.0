From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v4 4/4] dm: fix awkward and incomplete request_queue initialization
Date: Thu, 11 Jan 2018 15:14:17 -0500
Message-ID: <20180111201417.2042-5-snitzer@redhat.com>
References: <20180111201417.2042-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20180111201417.2042-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk
Cc: Ming Lei <tom.leiming@gmail.com>, hare@suse.de, Bart.VanAssche@wdc.com, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

DM is now no longer prone to having its request_queue be improperly
initialized.

Summary of changes:

- defer DM's blk_register_queue() from add_disk()-time until
  dm_setup_md_queue() by using add_disk_no_queue_reg() in alloc_dev().

- dm_setup_md_queue() is updated to fully initialize DM's request_queue
  (_after_ all table loads have occurred and the request_queue's type,
  features and limits are known).

- various other small improvements that were noticed along the way.

A very welcome side-effect of these changes is DM no longer needs to:
1) backfill the "mq" sysfs entry (because historically DM didn't
initialize the request_queue to use blk-mq until _after_
blk_register_queue() was called via add_disk()).
2) call elv_register_queue() to get .request_fn request-based DM
device's "queue" exposed in syfs.

In addition, blk-mq debugfs support is now made available because
request-based DM's blk-mq request_queue is now properly initialized
before dm_setup_md_queue() calls blk_register_queue().

These changes also stave off the need to introduce new DM-specific
workarounds in block core, e.g. this proposal:
https://patchwork.kernel.org/patch/10067961/

In the end DM devices should be less unicorn in nature (relative to
initialization and availability of block core infrastructure).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Tested-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-core.h |  2 --
 drivers/md/dm-rq.c   | 11 -----------
 drivers/md/dm.c      | 41 ++++++++++++++++++++++-------------------
 3 files changed, 22 insertions(+), 32 deletions(-)

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
diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index 9d32f25489c2..3b319776d80c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
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
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 7475739fee49..c84d4a0c6bf7 100644
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
@@ -1734,10 +1723,10 @@ static struct mapped_device *alloc_dev(int minor)
 	md->queue = blk_alloc_queue_node(GFP_KERNEL, numa_node_id);
 	if (!md->queue)
 		goto bad;
+	md->queue->queuedata = md;
+	md->queue->backing_dev_info->congested_data = md;
 
-	dm_init_md_queue(md);
-
-	md->disk = alloc_disk_node(1, numa_node_id);
+	md->disk = alloc_disk_node(1, md->numa_node_id);
 	if (!md->disk)
 		goto bad;
 
@@ -1761,7 +1750,7 @@ static struct mapped_device *alloc_dev(int minor)
 		goto bad;
 	md->dax_dev = dax_dev;
 
-	add_disk(md->disk);
+	add_disk_no_queue_reg(md->disk);
 	format_dev_t(md->name, MKDEV(_major, minor));
 
 	md->wq = alloc_workqueue("kdmflush", WQ_MEM_RECLAIM, 0);
@@ -1962,13 +1951,18 @@ static struct dm_table *__unbind(struct mapped_device *md)
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
@@ -2021,10 +2015,12 @@ EXPORT_SYMBOL_GPL(dm_get_queue_limits);
 int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 {
 	int r;
+	struct queue_limits limits;
 	enum dm_queue_mode type = dm_get_md_type(md);
 
 	switch (type) {
 	case DM_TYPE_REQUEST_BASED:
+		dm_init_normal_md_queue(md);
 		r = dm_old_init_request_queue(md, t);
 		if (r) {
 			DMERR("Cannot initialize queue for request-based mapped device");
@@ -2057,6 +2053,14 @@ int dm_setup_md_queue(struct mapped_device *md, struct dm_table *t)
 		break;
 	}
 
+	r = dm_calculate_queue_limits(t, &limits);
+	if (r) {
+		DMERR("Cannot calculate initial queue limits");
+		return r;
+	}
+	dm_table_set_restrictions(t, md->queue, &limits);
+	blk_register_queue(md->disk);
+
 	return 0;
 }
 
@@ -2121,7 +2125,6 @@ EXPORT_SYMBOL_GPL(dm_device_name);
 
 static void __dm_destroy(struct mapped_device *md, bool wait)
 {
-	struct request_queue *q = dm_get_md_queue(md);
 	struct dm_table *map;
 	int srcu_idx;
 
@@ -2132,7 +2135,7 @@ static void __dm_destroy(struct mapped_device *md, bool wait)
 	set_bit(DMF_FREEING, &md->flags);
 	spin_unlock(&_minor_lock);
 
-	blk_set_queue_dying(q);
+	blk_set_queue_dying(md->queue);
 
 	if (dm_request_based(md) && md->kworker_task)
 		kthread_flush_worker(&md->kworker);
-- 
2.15.0
