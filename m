From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH-v3 2/2] Initialize mempool and elevator only for
	request-based dm devices
Date: Tue, 11 Aug 2009 15:02:41 +0530
Message-ID: <200908111502.41930.knikanth@suse.de>
References: <200908081026.01097.knikanth@suse.de>
	<4A812680.7040804@ct.jp.nec.com>
	<200908111435.12020.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200908111435.12020.knikanth@suse.de>
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
To: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Cc: Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Intialize the request_queue and elevator only when the device is marked as
a request-based device. This avoids unnecessary creation of mempool for
requests. Also we wrongly initialize the elevator even for bio-based devices.
As the /sys/block/dm-*/queue/scheduler is exported for device-mapper devices,
it is possible to confuse with scheduler options for bio-based devices where
scheduler is not at all used.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8a311ea..40156b0 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1749,22 +1749,21 @@ static struct mapped_device *alloc_dev(int minor)
 	INIT_LIST_HEAD(&md->uevent_list);
 	spin_lock_init(&md->uevent_lock);
 
-	md->queue = blk_init_queue(dm_request_fn, NULL);
+	md->queue = blk_alloc_queue(GFP_KERNEL);
 	if (!md->queue)
 		goto bad_queue;
 
 	/*
 	 * Request-based dm devices cannot be stacked on top of bio-based dm
-	 * devices.  The type of this dm device has not been decided yet,
-	 * although we initialized the queue using blk_init_queue().
+	 * devices. The type of this dm device has not been decided yet.
 	 * The type is decided at the first table loading time.
 	 * To prevent problematic device stacking, clear the queue flag
 	 * for request stacking support until then.
 	 *
 	 * This queue is new, so no concurrency on the queue_flags.
 	 */
+	md->queue->queue_flags = QUEUE_FLAG_DEFAULT;
 	queue_flag_clear_unlocked(QUEUE_FLAG_STACKABLE, md->queue);
-	md->saved_make_request_fn = md->queue->make_request_fn;
 	md->queue->queuedata = md;
 	md->queue->backing_dev_info.congested_fn = dm_any_congested;
 	md->queue->backing_dev_info.congested_data = md;
@@ -1772,9 +1771,6 @@ static struct mapped_device *alloc_dev(int minor)
 	blk_queue_bounce_limit(md->queue, BLK_BOUNCE_ANY);
 	md->queue->unplug_fn = dm_unplug_all;
 	blk_queue_merge_bvec(md->queue, dm_merge_bvec);
-	blk_queue_softirq_done(md->queue, dm_softirq_done);
-	blk_queue_prep_rq(md->queue, dm_prep_fn);
-	blk_queue_lld_busy(md->queue, dm_lld_busy);
 
 	md->disk = alloc_disk(1);
 	if (!md->disk)
@@ -2203,6 +2199,33 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
+	/* new device is being marked as request-based */
+	if (!md->map && dm_table_request_based(table)) {
+		/*
+		 * Initialize queue for request-based dm.
+		 * Generally DM must not allocate memory during resume as it
+		 * may cause deadlock during no memory situation. But there is
+		 * no I/O happening on this device. So it is ok to allocate
+		 * memory here.
+		 */
+		r = blk_init_allocated_queue(md->queue, dm_request_fn, NULL);
+		if (r)
+			goto out;
+
+		elv_register_queue(md->queue);
+
+		/*
+		 * reinitialize make_request_fn as it was reset to the
+		 * default __make_request by blk_init_allocate_queue
+		 */
+		md->saved_make_request_fn = md->queue->make_request_fn;
+		blk_queue_make_request(md->queue, dm_request);
+
+		blk_queue_softirq_done(md->queue, dm_softirq_done);
+		blk_queue_prep_rq(md->queue, dm_prep_fn);
+		blk_queue_lld_busy(md->queue, dm_lld_busy);
+	}
+
 	__unbind(md);
 	r = __bind(md, table, &limits);
 
