From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] Allow delaying initialization of queue
	after allocation
Date: Sat, 8 Aug 2009 12:42:04 -0400
Message-ID: <20090808164204.GA7714@redhat.com>
References: <200908081025.58865.knikanth@suse.de>
	<20090808154240.GA7036@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20090808154240.GA7036@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Nikanth Karthikesan <knikanth@suse.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>, dm-devel@redhat.com, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>, Jens Axboe <jens.axboe@oracle.com>
List-Id: dm-devel.ids

On Sat, Aug 08 2009 at 11:42am -0400,
Mike Snitzer <snitzer@redhat.com> wrote:

> On Sat, Aug 08 2009 at 12:55am -0400,
> Nikanth Karthikesan <knikanth@suse.de> wrote:
> 
> > Export a way to delay initializing a request_queue after allocating it. This
> > is needed by device-mapper devices, as they create the queue on device
> > creation time, but they decide whether it would use the elevator and requests
> > only after first successful table load. Only request-based dm-devices use the
> > elevator and requests. Without this either one needs to initialize and free
> > the mempool and elevator, if it was a bio-based dm-device or leave it
> > allocated, as it is currently done.
> > 
> > Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>
> 
> This patch needed to be refreshed to account for the changes from this
> recent commit: a4e7d46407d73f35d217013b363b79a8f8eafcaa
> 
> I've attached a refreshed patch.

Err, I dropped a hunk in the process... here is the refreshed patch
inlined.  Figured I'd save you the busy-work for when you get V2
together.

> Though I still have questions/feedback below.

Hopefully V2 will address my questions/feedback.

Regards,
Mike

---

Export a way to delay initializing a request_queue after allocating it. This
is needed by device-mapper devices, as they create the queue on device
creation time, but they decide whether it would use the elevator and requests
only after first successful table load. Only request-based dm-devices use the
elevator and requests. Without this either one needs to initialize and free
the mempool and elevator, if it was a bio-based dm-device or leave it
allocated, as it is currently done.

Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

---

Index: linux-2.6/block/blk-core.c
===================================================================
--- linux-2.6.orig/block/blk-core.c
+++ linux-2.6/block/blk-core.c
@@ -495,6 +495,8 @@ struct request_queue *blk_alloc_queue_no
 	if (!q)
 		return NULL;
 
+	q->node = node_id;
+
 	q->backing_dev_info.unplug_io_fn = blk_backing_dev_unplug;
 	q->backing_dev_info.unplug_io_data = q;
 	q->backing_dev_info.ra_pages =
@@ -569,12 +571,25 @@ blk_init_queue_node(request_fn_proc *rfn
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
+			     spinlock_t *lock)
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
@@ -591,15 +606,20 @@ blk_init_queue_node(request_fn_proc *rfn
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
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h
+++ linux-2.6/include/linux/blkdev.h
@@ -901,6 +901,8 @@ extern void blk_abort_queue(struct reque
 extern struct request_queue *blk_init_queue_node(request_fn_proc *rfn,
 					spinlock_t *lock, int node_id);
 extern struct request_queue *blk_init_queue(request_fn_proc *, spinlock_t *);
+extern int blk_init_allocated_queue(struct request_queue *q,
+				request_fn_proc *rfn, spinlock_t *lock);
 extern void blk_cleanup_queue(struct request_queue *);
 extern void blk_queue_make_request(struct request_queue *, make_request_fn *);
 extern void blk_queue_bounce_limit(struct request_queue *, u64);
