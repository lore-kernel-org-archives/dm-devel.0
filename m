From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH-v3 1/2] Allow delaying initialization of queue
	after allocation
Date: Tue, 11 Aug 2009 15:02:36 +0530
Message-ID: <200908111502.36570.knikanth@suse.de>
References: <200908081025.58865.knikanth@suse.de>
	<200908101551.08605.knikanth@suse.de>
	<200908101618.18085.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <200908101618.18085.knikanth@suse.de>
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
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, Mike Snitzer <snitzer@redhat.com>, linux-kernel@vger.kernel.org, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Export a way to delay initializing a request_queue after allocating it. This
is needed by device-mapper devices, as they create the queue on device
creation time, but they decide whether it would use the elevator and requests
only after first successful table load. Only request-based dm-devices use the
elevator and requests. Without this either one needs to initialize and free
the mempool and elevator, if it was a bio-based dm-device or leave it
allocated, as it is currently done.

This slightly changes the behaviour of block_init_queue_node() such that
blk_put_queue() would be called, even if blk_init_free_list() fails.

Also export elevator_register_queue() to modules.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index e3299a7..8b05b3b 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -495,6 +495,8 @@ struct request_queue *blk_alloc_queue_node(gfp_t gfp_mask, int node_id)
 	if (!q)
 		return NULL;
 
+	q->node = node_id;
+
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 	q->backing_dev_info.ra_pages =
@@ -569,12 +571,25 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	if (!q)
 		return NULL;
 
-	q->node = node_id;
-	if (blk_init_free_list(q)) {
+	if (blk_init_allocated_queue(q, rfn, lock)) {
+		blk_put_queue(q);
 		kmem_cache_free(blk_requestq_cachep, q);
 		return NULL;
 	}
 
+	return q;
+}
+EXPORT_SYMBOL(blk_init_queue_node);
+
+int blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
+							spinlock_t *lock)
+{
+	int err = 0;
+
+	err = blk_init_free_list(q);
+	if (err)
+		goto out;
+
 	q->request_fn		= rfn;
 	q->prep_rq_fn		= NULL;
 	q->unplug_fn		= generic_unplug_device;
@@ -591,15 +606,23 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
 	/*
 	 * all done
 	 */
-	if (!elevator_init(q, NULL)) {
-		blk_queue_congestion_threshold(q);
-		return q;
-	}
+	err = elevator_init(q, NULL);
+	if (err)
+		goto free_and_out;
 
-	blk_put_queue(q);
-	return NULL;
+	blk_queue_congestion_threshold(q);
+
+	return 0;
+
+free_and_out:
+	/*
+	 * Cleanup mempool allocated by blk_init_free_list
+	 */
+	mempool_destroy(q->rq.rq_pool);
+out:
+	return err;
 }
-EXPORT_SYMBOL(blk_init_queue_node);
+EXPORT_SYMBOL(blk_init_allocated_queue);
 
 int blk_get_queue(struct request_queue *q)
 {
diff --git a/block/elevator.c b/block/elevator.c
index 2d511f9..0827cd3 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -930,6 +930,7 @@ int elv_register_queue(struct request_queue *q)
 	}
 	return error;
 }
+EXPORT_SYMBOL(elv_register_queue);
 
 static void __elv_unregister_queue(struct elevator_queue *e)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 69103e0..4a26fc1 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -901,6 +901,8 @@ extern void blk_abort_queue(struct request_queue *);
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 					spinlock_t *lock, int node_id);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
+extern int blk_init_allocated_queue(struct request_queue *q,
+				request_fn_proc *rfn, spinlock_t *lock);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
