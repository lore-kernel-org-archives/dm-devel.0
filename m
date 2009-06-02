From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH 2/5] dm core: enable request-based dm
Date: Tue, 02 Jun 2009 16:01:00 +0900
Message-ID: <4A24CE2C.1080402@ct.jp.nec.com>
References: <4A24CD74.80708@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <4A24CD74.80708@ct.jp.nec.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair Kergon <agk@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

This patch enables request-based dm.

o Request-based dm and bio-based dm coexist, since there are
  some target drivers which are more fitting to bio-based dm.
  Also, there are other bio-based devices in the kernel
  (e.g. md, loop).
  Since bio-based device can't receive struct request,
  there are some limitations on device stacking between
  bio-based and request-based.

                     type of underlying device
                   bio-based      requeset-based
   ----------------------------------------------
    bio-based         OK                OK
    request-based     NG                OK

  The device type is recognized by the queue flag in the kernel,
  so dm follows that.

o The type of a dm device is decided at the first table binding time.
  Once the type of a dm device is decided, the type can't be changed.

o Mempool allocations are deferred to at the table loading time, since
  mempools for request-based dm are different from those for bio-based
  dm and needed mempool type is fixed by the type of table.

o Currently, request-based dm supports only tables that have a single
  target.  To support multiple targets, we need to support request
  splitting or prevent bio/request from spanning multiple targets.
  The former needs lots of changes in the block layer, and the latter
  needs that all target drivers support merge() function.
  Both will take a time.


Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Alasdair G Kergon <agk@redhat.com>
---
 drivers/md/dm-ioctl.c |   13 ++++
 drivers/md/dm-table.c |  111 ++++++++++++++++++++++++++++++++++
 drivers/md/dm.c       |  162 +++++++++++++++++++++++++++++++++++++++++---------
 drivers/md/dm.h       |   25 +++++++
 4 files changed, 285 insertions(+), 26 deletions(-)

Index: linux-2.6-block/drivers/md/dm-table.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-table.c
+++ linux-2.6-block/drivers/md/dm-table.c
@@ -41,6 +41,7 @@
 struct dm_table {
 	struct mapped_device *md;
 	atomic_t holders;
+	unsigned type;
 
 	/* btree table */
 	unsigned int depth;
@@ -71,6 +72,8 @@ struct dm_table {
 	/* events get handed up using this callback */
 	void (*event_fn)(void *);
 	void *event_context;
+
+	struct dm_md_mempools *mempools;
 };
 
 /*
@@ -264,6 +267,8 @@ void dm_table_destroy(struct dm_table *t
 	if (t->devices.next != &t->devices)
 		free_devices(&t->devices);
 
+	dm_free_md_mempools(t->mempools);
+
 	kfree(t);
 }
 
@@ -794,6 +799,99 @@ int dm_table_add_target(struct dm_table 
 	return r;
 }
 
+int dm_table_set_type(struct dm_table *t)
+{
+	unsigned i;
+	unsigned bio_based = 0, request_based = 0;
+	struct dm_target *tgt;
+	struct dm_dev_internal *dd;
+	struct list_head *devices;
+
+	for (i = 0; i < t->num_targets; i++) {
+		tgt = t->targets + i;
+		if (dm_target_request_based(tgt))
+			request_based = 1;
+		else
+			bio_based = 1;
+
+		if (bio_based && request_based) {
+			DMWARN("Inconsistent table: different target types"
+			       " can't be mixed up");
+			return -EINVAL;
+		}
+	}
+
+	if (bio_based) {
+		/* We must use this table as bio-based */
+		t->type = DM_TYPE_BIO_BASED;
+		return 0;
+	}
+
+	BUG_ON(!request_based); /* No targets in this table */
+
+	/* Non-request-stackable devices can't be used for request-based dm */
+	devices = dm_table_get_devices(t);
+	list_for_each_entry(dd, devices, list) {
+		if (!blk_queue_stackable(bdev_get_queue(dd->dm_dev.bdev))) {
+			DMWARN("table load rejected: including"
+			       " non-request-stackable devices");
+			return -EINVAL;
+		}
+	}
+
+	/*
+	 * Request-based dm supports only tables that have a single target now.
+	 * To support multiple targets, request splitting support is needed,
+	 * and that needs lots of changes in the block-layer.
+	 * (e.g. request completion process for partial completion.)
+	 */
+	if (t->num_targets > 1) {
+		DMWARN("Request-based dm doesn't support multiple targets yet");
+		return -EINVAL;
+	}
+
+	t->type = DM_TYPE_REQUEST_BASED;
+
+	return 0;
+}
+
+unsigned dm_table_get_type(struct dm_table *t)
+{
+	return t->type;
+}
+
+bool dm_table_request_based(struct dm_table *t)
+{
+	return dm_table_get_type(t) == DM_TYPE_REQUEST_BASED;
+}
+
+int dm_table_alloc_md_mempools(struct dm_table *t)
+{
+	unsigned type = dm_table_get_type(t);
+
+	if (unlikely(type == DM_TYPE_NONE)) {
+		DMWARN("no table type is set, can't allocate mempools");
+		return -EINVAL;
+	}
+
+	t->mempools = dm_alloc_md_mempools(type);
+	if (!t->mempools)
+		return -ENOMEM;
+
+	return 0;
+}
+
+void dm_table_free_md_mempools(struct dm_table *t)
+{
+	dm_free_md_mempools(t->mempools);
+	t->mempools = NULL;
+}
+
+struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t)
+{
+	return t->mempools;
+}
+
 static int setup_indexes(struct dm_table *t)
 {
 	int i;
@@ -972,6 +1070,19 @@ void dm_table_set_restrictions(struct dm
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
 	dm_table_set_integrity(t);
+
+	/*
+	 * QUEUE_FLAG_STACKABLE must be set after all queue settings are
+	 * visible to other CPUs because, once the flag is set, incoming bios
+	 * are processed by request-based dm, which refers to the queue
+	 * settings.
+	 * Until the flag set, bios are passed to bio-based dm and queued to
+	 * md->deferred where queue settings are not needed yet.
+	 * Those bios are passed to request-based dm at the resume time.
+	 */
+	smp_mb();
+	if (dm_table_request_based(t))
+		queue_flag_set_unlocked(QUEUE_FLAG_STACKABLE, q);
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)
Index: linux-2.6-block/drivers/md/dm.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.c
+++ linux-2.6-block/drivers/md/dm.c
@@ -185,6 +185,15 @@ struct mapped_device {
 	struct bio barrier_bio;
 };
 
+/*
+ * For mempools pre-allocation at the table loading time.
+ */
+struct dm_md_mempools {
+	mempool_t *io_pool;
+	mempool_t *tio_pool;
+	struct bio_set *bs;
+};
+
 #define MIN_IOS 256
 static struct kmem_cache *_io_cache;
 static struct kmem_cache *_tio_cache;
@@ -1790,10 +1799,22 @@ static struct mapped_device *alloc_dev(i
 	INIT_LIST_HEAD(&md->uevent_list);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_alloc_queue(GFP_KERNEL);
+	md->queue = blk_init_queue(dm_request_fn, NULL);
 	if (!md->queue)
 		goto bad_queue;
 
+	/*
+	 * Request-based dm devices cannot be stacked on top of bio-based dm
+	 * devices.  The type of this dm device has not been decided yet,
+	 * although we initialized the queue using blk_init_queue().
+	 * The type is decided at the first table loading time.
+	 * To prevent problematic device stacking, clear the queue flag
+	 * for request stacking support until then.
+	 *
+	 * This queue is new, so no concurrency on the queue_flags.
+	 */
+	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
+	md->saved_make_request_fn = md->queue->make_request_fn;
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
@@ -1802,18 +1823,9 @@ static struct mapped_device *alloc_dev(i
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-
-	md->io_pool = mempool_create_slab_pool(MIN_IOS, _io_cache);
-	if (!md->io_pool)
-		goto bad_io_pool;
-
-	md->tio_pool = mempool_create_slab_pool(MIN_IOS, _tio_cache);
-	if (!md->tio_pool)
-		goto bad_tio_pool;
-
-	md->bs = bioset_create(16, 0);
-	if (!md->bs)
-		goto bad_no_bioset;
+	blk_queue_softirq_done(md->queue, dm_softirq_done);
+	blk_queue_prep_rq(md->queue, dm_prep_fn);
+	blk_queue_lld_busy(md->queue, dm_lld_busy);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -1855,12 +1867,6 @@ bad_bdev:
 bad_thread:
 	put_disk(md->disk);
 bad_disk:
-	bioset_free(md->bs);
-bad_no_bioset:
-	mempool_destroy(md->tio_pool);
-bad_tio_pool:
-	mempool_destroy(md->io_pool);
-bad_io_pool:
 	blk_cleanup_queue(md->queue);
 bad_queue:
 	free_minor(minor);
@@ -1880,9 +1886,12 @@ static void free_dev(struct mapped_devic
 	unlock_fs(md);
 	bdput(md->bdev);
 	destroy_workqueue(md->wq);
-	mempool_destroy(md->tio_pool);
-	mempool_destroy(md->io_pool);
-	bioset_free(md->bs);
+	if (md->tio_pool)
+		mempool_destroy(md->tio_pool);
+	if (md->io_pool)
+		mempool_destroy(md->io_pool);
+	if (md->bs)
+		bioset_free(md->bs);
 	blk_integrity_unregister(md->disk);
 	del_gendisk(md->disk);
 	free_minor(minor);
@@ -1897,6 +1906,29 @@ static void free_dev(struct mapped_devic
 	kfree(md);
 }
 
+static void __bind_mempools(struct mapped_device *md, struct dm_table *t)
+{
+	struct dm_md_mempools *p;
+
+	if (md->io_pool && md->tio_pool && md->bs)
+		/* the md already has necessary mempools */
+		goto out;
+
+	p = dm_table_get_md_mempools(t);
+	BUG_ON(!p || md->io_pool || md->tio_pool || md->bs);
+
+	md->io_pool = p->io_pool;
+	p->io_pool = NULL;
+	md->tio_pool = p->tio_pool;
+	p->tio_pool = NULL;
+	md->bs = p->bs;
+	p->bs = NULL;
+
+out:
+	/* mempool bind completed, now no need any mempools in the table */
+	dm_table_free_md_mempools(t);
+}
+
 /*
  * Bind a table to the device.
  */
@@ -1947,6 +1979,18 @@ static int __bind(struct mapped_device *
 
 	dm_table_event_callback(t, event_callback, md);
 
+	/*
+	 * The queue hasn't been stopped yet, if the old table type wasn't
+	 * for request-based during suspension.  So stop it to prevent
+	 * I/O mapping before resume.
+	 * This must be done before setting the queue restrictions,
+	 * because request-based dm may be run just after the setting.
+	 */
+	if (dm_table_request_based(t) && !blk_queue_stopped(q))
+		stop_queue(q);
+
+	__bind_mempools(md, t);
+
 	write_lock(&md->map_lock);
 	md->map = t;
 	dm_table_set_restrictions(t, q);
@@ -2160,10 +2204,14 @@ static void dm_wq_work(struct work_struc
 
 		up_write(&md->io_lock);
 
-		if (bio_barrier(c))
-			process_barrier(md, c);
-		else
-			__split_and_process_bio(md, c);
+		if (dm_request_based(md))
+			generic_make_request(c);
+		else {
+			if (bio_barrier(c))
+				process_barrier(md, c);
+			else
+				__split_and_process_bio(md, c);
+		}
 
 		down_write(&md->io_lock);
 	}
@@ -2191,6 +2239,13 @@ int dm_swap_table(struct mapped_device *
 	if (!dm_suspended(md))
 		goto out;
 
+	/* cannot change the device type, once a table is bound */
+	if (md->map &&
+	    (dm_table_get_type(md->map) != dm_table_get_type(table))) {
+		DMWARN("can't change the device type after a table is bound");
+		goto out;
+	}
+
 	__unbind(md);
 	r = __bind(md, table);
 
@@ -2577,6 +2632,61 @@ int dm_noflush_suspending(struct dm_targ
 }
 EXPORT_SYMBOL_GPL(dm_noflush_suspending);
 
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type)
+{
+	struct dm_md_mempools *pools = kmalloc(sizeof(*pools), GFP_KERNEL);
+
+	if (!pools)
+		return NULL;
+
+	pools->io_pool = (type == DM_TYPE_BIO_BASED) ?
+			 mempool_create_slab_pool(MIN_IOS, _io_cache) :
+			 mempool_create_slab_pool(MIN_IOS, _rq_bio_info_cache);
+	if (!pools->io_pool)
+		goto free_pools_and_out;
+
+	pools->tio_pool = (type == DM_TYPE_BIO_BASED) ?
+			  mempool_create_slab_pool(MIN_IOS, _tio_cache) :
+			  mempool_create_slab_pool(MIN_IOS, _rq_tio_cache);
+	if (!pools->tio_pool)
+		goto free_io_pool_and_out;
+
+	pools->bs = (type == DM_TYPE_BIO_BASED) ?
+		    bioset_create(16, 0) : bioset_create(MIN_IOS, 0);
+	if (!pools->bs)
+		goto free_tio_pool_and_out;
+
+	return pools;
+
+free_tio_pool_and_out:
+	mempool_destroy(pools->tio_pool);
+
+free_io_pool_and_out:
+	mempool_destroy(pools->io_pool);
+
+free_pools_and_out:
+	kfree(pools);
+
+	return NULL;
+}
+
+void dm_free_md_mempools(struct dm_md_mempools *pools)
+{
+	if (!pools)
+		return;
+
+	if (pools->io_pool)
+		mempool_destroy(pools->io_pool);
+
+	if (pools->tio_pool)
+		mempool_destroy(pools->tio_pool);
+
+	if (pools->bs)
+		bioset_free(pools->bs);
+
+	kfree(pools);
+}
+
 static struct block_device_operations dm_blk_dops = {
 	.open = dm_blk_open,
 	.release = dm_blk_close,
Index: linux-2.6-block/drivers/md/dm.h
===================================================================
--- linux-2.6-block.orig/drivers/md/dm.h
+++ linux-2.6-block/drivers/md/dm.h
@@ -23,6 +23,13 @@
 #define DM_SUSPEND_NOFLUSH_FLAG		(1 << 1)
 
 /*
+ * Type of table and mapped_device's mempool
+ */
+#define DM_TYPE_NONE		0
+#define DM_TYPE_BIO_BASED	1
+#define DM_TYPE_REQUEST_BASED	2
+
+/*
  * List of devices that a metadevice uses and should open/close.
  */
 struct dm_dev_internal {
@@ -32,6 +39,7 @@ struct dm_dev_internal {
 };
 
 struct dm_table;
+struct dm_md_mempools;
 
 /*-----------------------------------------------------------------
  * Internal table functions.
@@ -48,12 +56,23 @@ void dm_table_postsuspend_targets(struct
 int dm_table_resume_targets(struct dm_table *t);
 int dm_table_any_congested(struct dm_table *t, int bdi_bits);
 int dm_table_any_busy_target(struct dm_table *t);
+int dm_table_set_type(struct dm_table *t);
+unsigned dm_table_get_type(struct dm_table *t);
+bool dm_table_request_based(struct dm_table *t);
+int dm_table_alloc_md_mempools(struct dm_table *t);
+void dm_table_free_md_mempools(struct dm_table *t);
+struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
 
 /*
  * To check the return value from dm_table_find_target().
  */
 #define dm_target_is_valid(t) ((t)->table)
 
+/*
+ * To check whether the target type is request-based or not (bio-based).
+ */
+#define dm_target_request_based(t) ((t)->type->map_rq != NULL)
+
 /*-----------------------------------------------------------------
  * A registry of target types.
  *---------------------------------------------------------------*/
@@ -98,4 +117,10 @@ void dm_kobject_uevent(struct mapped_dev
 int dm_kcopyd_init(void);
 void dm_kcopyd_exit(void);
 
+/*
+ * Mempool operations
+ */
+struct dm_md_mempools *dm_alloc_md_mempools(unsigned type);
+void dm_free_md_mempools(struct dm_md_mempools *pools);
+
 #endif
Index: linux-2.6-block/drivers/md/dm-ioctl.c
===================================================================
--- linux-2.6-block.orig/drivers/md/dm-ioctl.c
+++ linux-2.6-block/drivers/md/dm-ioctl.c
@@ -1044,6 +1044,12 @@ static int populate_table(struct dm_tabl
 		next = spec->next;
 	}
 
+	r = dm_table_set_type(table);
+	if (r) {
+		DMWARN("unable to set table type");
+		return r;
+	}
+
 	return dm_table_complete(table);
 }
 
@@ -1089,6 +1095,13 @@ static int table_load(struct dm_ioctl *p
 		goto out;
 	}
 
+	r = dm_table_alloc_md_mempools(t);
+	if (r) {
+		DMWARN("unable to allocate mempools for this table");
+		dm_table_destroy(t);
+		goto out;
+	}
+
 	down_write(&_hash_lock);
 	hc = dm_get_mdptr(md);
 	if (!hc || hc->md != md) {
