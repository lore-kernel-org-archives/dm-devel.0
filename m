From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 2/2] Initialize mempool and elevator only for
	request-based dm devices
Date: Sat, 8 Aug 2009 10:26:00 +0530
Message-ID: <200908081026.01097.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org
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
index 8a311ea..b01dfbe 100644
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
@@ -2203,7 +2199,25 @@ int dm_swap_table(struct mapped_device *md, struct dm_table *table)
 		goto out;
 	}
 
-	__unbind(md);
+	if (md->map)
+		__unbind(md);
+	else {
+	/* new device is being marked as either request-based or bio-based */
+		if (dm_table_request_based(table)) {
+			/* Initialize queue for request-based dm */
+			r = blk_init_allocated_queue(md->queue, dm_request_fn,
+								 NULL);
+			if (r)
+				goto out;
+			md->saved_make_request_fn = md->queue->make_request_fn;
+			blk_queue_make_request(md->queue, dm_request);
+			blk_queue_softirq_done(md->queue, dm_softirq_done);
+			blk_queue_prep_rq(md->queue, dm_prep_fn);
+			blk_queue_lld_busy(md->queue, dm_lld_busy);
+
+		}
+	}
+
 	r = __bind(md, table, &limits);
 
 out:
