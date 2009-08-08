From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH 1/2] Allow delaying initialization of queue
	after allocation
Date: Sat, 8 Aug 2009 11:42:40 -0400
Message-ID: <20090808154240.GA7036@redhat.com>
References: <200908081025.58865.knikanth@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <200908081025.58865.knikanth@suse.de>
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


--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Sat, Aug 08 2009 at 12:55am -0400,
Nikanth Karthikesan <knikanth@suse.de> wrote:

> Export a way to delay initializing a request_queue after allocating it. This
> is needed by device-mapper devices, as they create the queue on device
> creation time, but they decide whether it would use the elevator and requests
> only after first successful table load. Only request-based dm-devices use the
> elevator and requests. Without this either one needs to initialize and free
> the mempool and elevator, if it was a bio-based dm-device or leave it
> allocated, as it is currently done.
> 
> Signed-off-by: Nikanth Karthikesan <knikanth@suse.de>

This patch needed to be refreshed to account for the changes from this
recent commit: a4e7d46407d73f35d217013b363b79a8f8eafcaa

I've attached a refreshed patch.

Though I still have questions/feedback below.


> diff --git a/block/blk-core.c b/block/blk-core.c
> index 4b45435..5db0772 100644
> --- a/block/blk-core.c
> +++ b/block/blk-core.c
> @@ -569,12 +571,25 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
>  	if (!q)
>  		return NULL;
>  
> -	q->node = node_id;
> -	if (blk_init_free_list(q)) {
> +	if (blk_init_allocated_queue(q, rfn, lock)) {
> +		blk_put_queue(q);
>  		kmem_cache_free(blk_requestq_cachep, q);
>  		return NULL;
>  	}
>  
> +	return q;
> +}
> +EXPORT_SYMBOL(blk_init_queue_node);
> +
> +int blk_init_allocated_queue(struct request_queue *q, request_fn_proc *rfn,
> +							 spinlock_t *lock)
> +{
> +	int err = 0;
> +
> +	err = blk_init_free_list(q);
> +	if (err)
> +		goto out;
> +
>  	/*
>  	 * if caller didn't supply a lock, they get per-queue locking with
>  	 * our embedded lock
> @@ -598,15 +613,20 @@ blk_init_queue_node(request_fn_proc *rfn, spinlock_t *lock, int node_id)
>  	/*
>  	 * all done
>  	 */
> -	if (!elevator_init(q, NULL)) {
> -		blk_queue_congestion_threshold(q);
> -		return q;
> -	}
> +	err = elevator_init(q, NULL);
> +	if (err)
> +		goto free_and_out;
>  
> -	blk_put_queue(q);
> -	return NULL;
> +	blk_queue_congestion_threshold(q);
> +
> +	return 0;
> +
> +free_and_out:
> +	mempool_destroy(q->rq.rq_pool);
> +out:
> +	return err;
>  }
> -EXPORT_SYMBOL(blk_init_queue_node);
> +EXPORT_SYMBOL(blk_init_allocated_queue);
>  
>  int blk_get_queue(struct request_queue *q)
>  {

In the previous code blk_init_queue_node() only called blk_put_queue()
iff elevator_init() failed.

Why is blk_init_queue_node() now always calling blk_put_queue() on an
error from blk_init_allocated_queue()?  It could be that
blk_init_free_list() was what failed and not elevator_init().

I'd imagine it is because some callers of blk_init_allocated_queue(),
e.g. DM, must not have the queue's refcount dropped on failure?  A
comment on _why_ would really help set the caller's expectations.  Maybe
at the top of blk_init_allocated_queue()? E.g.:

"It is up to the caller to manage the allocated queue's lifecycle
relative to blk_init_allocated_queue() failure".  I guess that is
obvious after having reviewed this but...

Also, a comment that blk_init_allocated_queue()'s mempool_destroy() is
to "cleanup the mempool allocated via blk_init_free_list()" would help.

Thanks,
Mike

--DocE+STaALJfprDB
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dm1.patch"

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
@@ -604,15 +606,20 @@ int blk_init_allocated_queue(struct requ
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

--DocE+STaALJfprDB
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--DocE+STaALJfprDB--
