From: Mike Snitzer <snitzer@redhat.com>
Subject: [for-4.16 PATCH v2 4/5] dm mpath: use NVMe error handling to know when an error is retryable
Date: Tue, 26 Dec 2017 22:22:56 -0500
Message-ID: <20171227032257.8182-5-snitzer@redhat.com>
References: <20171227032257.8182-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171227032257.8182-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: axboe@kernel.dk, hch@lst.de, keith.busch@intel.com
Cc: emilne@redhat.com, james.smart@broadcom.com, hare@suse.de, Bart.VanAssche@wdc.com, linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, dm-devel@redhat.com
List-Id: dm-devel.ids

Like NVMe's native multipath support, DM multipath's NVMe bio-based
support now allows NVMe core's error handling to requeue an NVMe blk-mq
request's bios onto DM multipath's queued_bios list for resubmission
once fail_path() occurs.  multipath_failover_rq() serves as a
replacement for the traditional multipath_end_io_bio().

DM multipath's bio submission to NVMe must be done in terms that allow
the reuse of NVMe core's error handling.  The following care is taken to
realize this reuse:

- NVMe core won't attempt to retry an IO if it has
  REQ_FAILFAST_TRANSPORT set; so only set it in __map_bio().

- Setup underlying request_queue's 'failover_rq_fn' callback, to use
  multipath_failover_rq, so that NVMe blk-mq requests use it
  if/when NVMe core determines a request must be retried.
  (a new target_type 'cleanup_device' hook is established to properly
   reset each underlying requests_queue's 'failover_rq_fn' on final
   teardown of the multipath device)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-mpath.c         | 71 +++++++++++++++++++++++++++++++++++++++++--
 drivers/md/dm-table.c         |  2 ++
 include/linux/device-mapper.h |  3 ++
 3 files changed, 73 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index 3198093006e4..875df8ad6efe 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -584,6 +584,8 @@ static struct pgpath *__map_bio(struct multipath *m, struct bio *bio)
 		return ERR_PTR(-EAGAIN);
 	}
 
+	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
+
 	return pgpath;
 }
 
@@ -641,7 +643,6 @@ static int __multipath_map_bio(struct multipath *m, struct bio *bio,
 
 	bio->bi_status = 0;
 	bio_set_dev(bio, pgpath->path.dev->bdev);
-	bio->bi_opf |= REQ_FAILFAST_TRANSPORT;
 
 	if (pgpath->pg->ps.type->start_io)
 		pgpath->pg->ps.type->start_io(&pgpath->pg->ps,
@@ -855,6 +856,8 @@ static int setup_scsi_dh(struct block_device *bdev, struct multipath *m, char **
 	return 0;
 }
 
+static void multipath_failover_rq(struct request *rq);
+
 static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps,
 				 struct dm_target *ti)
 {
@@ -879,7 +882,10 @@ static struct pgpath *parse_path(struct dm_arg_set *as, struct path_selector *ps
 		goto bad;
 	}
 
-	if (m->queue_mode != DM_TYPE_NVME_BIO_BASED) {
+	if (m->queue_mode == DM_TYPE_NVME_BIO_BASED) {
+		struct request_queue *q = bdev_get_queue(p->path.dev->bdev);
+		q->failover_rq_fn = multipath_failover_rq;
+	} else {
 		INIT_DELAYED_WORK(&p->activate_path, activate_path_work);
 		if (setup_scsi_dh(p->path.dev->bdev, m, &ti->error)) {
 			dm_put_device(ti, p->path.dev);
@@ -1610,6 +1616,14 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	unsigned long flags;
 	int r = DM_ENDIO_DONE;
 
+	/*
+	 * NVMe bio-based only needs to update path selector (on
+	 * success or errors that NVMe deemed non-retryable)
+	 * - retryable errors are handled by multipath_failover_rq
+	 */
+	if (m->queue_mode == DM_TYPE_NVME_BIO_BASED)
+		goto done;
+
 	if (!*error || !retry_error(*error))
 		goto done;
 
@@ -1645,6 +1659,43 @@ static int multipath_end_io_bio(struct dm_target *ti, struct bio *clone,
 	return r;
 }
 
+/*
+ * multipath_failover_rq serves as a replacement for multipath_end_io_bio
+ * for all bios in a request with a retryable error.
+ */
+static void multipath_failover_rq(struct request *rq)
+{
+	struct dm_target *ti = dm_bio_get_target(rq->bio);
+	struct multipath *m = ti->private;
+	struct dm_mpath_io *mpio = get_mpio_from_bio(rq->bio);
+	struct pgpath *pgpath = mpio->pgpath;
+	unsigned long flags;
+
+	if (pgpath) {
+		struct path_selector *ps = &pgpath->pg->ps;
+
+		if (ps->type->end_io)
+			ps->type->end_io(ps, &pgpath->path, blk_rq_bytes(rq));
+
+		fail_path(pgpath);
+	}
+
+	if (atomic_read(&m->nr_valid_paths) == 0 &&
+	    !test_bit(MPATHF_QUEUE_IF_NO_PATH, &m->flags) &&
+	    !must_push_back_bio(m)) {
+		dm_report_EIO(m);
+		blk_mq_end_request(rq, BLK_STS_IOERR);
+		return;
+	}
+
+	spin_lock_irqsave(&m->lock, flags);
+	blk_steal_bios(&m->queued_bios, rq);
+	spin_unlock_irqrestore(&m->lock, flags);
+	queue_work(kmultipathd, &m->process_queued_bios);
+
+	blk_mq_end_request(rq, 0);
+}
+
 /*
  * Suspend can't complete until all the I/O is processed so if
  * the last path fails we must error any remaining I/O.
@@ -2029,12 +2080,25 @@ static int multipath_busy(struct dm_target *ti)
 	return busy;
 }
 
+static void multipath_cleanup_device(struct dm_target *ti, struct dm_dev *dev)
+{
+	struct multipath *m = ti->private;
+	struct request_queue *q;
+
+	if (m->queue_mode != DM_TYPE_NVME_BIO_BASED)
+		return;
+
+	q = bdev_get_queue(dev->bdev);
+	if (q)
+		q->failover_rq_fn = NULL;
+}
+
 /*-----------------------------------------------------------------
  * Module setup
  *---------------------------------------------------------------*/
 static struct target_type multipath_target = {
 	.name = "multipath",
-	.version = {1, 12, 0},
+	.version = {1, 13, 0},
 	.features = DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
 	.module = THIS_MODULE,
 	.ctr = multipath_ctr,
@@ -2052,6 +2116,7 @@ static struct target_type multipath_target = {
 	.prepare_ioctl = multipath_prepare_ioctl,
 	.iterate_devices = multipath_iterate_devices,
 	.busy = multipath_busy,
+	.cleanup_device = multipath_cleanup_device,
 };
 
 static int __init dm_multipath_init(void)
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index ad4ac294dd57..86d7530384c3 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -517,6 +517,8 @@ void dm_put_device(struct dm_target *ti, struct dm_dev *d)
 		return;
 	}
 	if (refcount_dec_and_test(&dd->count)) {
+		if (ti->type->cleanup_device)
+			ti->type->cleanup_device(ti, d);
 		dm_put_table_device(ti->table->md, d);
 		list_del(&dd->list);
 		kfree(dd);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index e46ad2ada674..758feae899f9 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -92,6 +92,8 @@ typedef int (*dm_message_fn) (struct dm_target *ti, unsigned argc, char **argv);
 typedef int (*dm_prepare_ioctl_fn) (struct dm_target *ti,
 			    struct block_device **bdev, fmode_t *mode);
 
+typedef void (*dm_cleanup_device_fn) (struct dm_target *ti, struct dm_dev *dev);
+
 /*
  * These iteration functions are typically used to check (and combine)
  * properties of underlying devices.
@@ -181,6 +183,7 @@ struct target_type {
 	dm_message_fn message;
 	dm_prepare_ioctl_fn prepare_ioctl;
 	dm_busy_fn busy;
+	dm_cleanup_device_fn cleanup_device;
 	dm_iterate_devices_fn iterate_devices;
 	dm_io_hints_fn io_hints;
 	dm_dax_direct_access_fn direct_access;
-- 
2.15.0
