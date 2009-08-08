From: Nikanth Karthikesan <knikanth@suse.de>
Subject: [PATCH 1/2] Allow delaying initialization of queue after
	allocation
Date: Sat, 8 Aug 2009 10:25:58 +0530
Message-ID: <200908081025.58865.knikanth@suse.de>
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

Export a way to delay initializing a request_queue after allocating it. This
is needed by device-mapper devices, as they create the queue on device
creation time, but they decide whether it would use the elevator and requests
only after first successful table load. Only request-based dm-devices use the
elevator and requests. Without this either one needs to initialize and free
the mempool and elevator, if it was a bio-based dm-device or leave it
allocated, as it is currently done.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

diff --git a/block/blk-core.c b/block/blk-core.c
index 4b45435..5db0772 100644
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
+							 spinlock_t *lock)
+{
+	int err = 0;
+
+	err = blk_init_free_list(q);
+	if (err)
+		goto out;
+
 	/*
 	 * if caller didn't supply a lock, they get per-queue locking with
 	 * our embedded lock
@@ -598,15 +613,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
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
+	mempool_destroy(q->rq.rq_pool);
+out:
+	return err;
 }
-EXPORT_SYMBOL(blk_init_queue_node);
+EXPORT_SYMBOL(blk_init_allocated_queue);
 
 int blk_get_queue(struct request_queue *q)
 {
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index e7cb5db..9552961 100644
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
