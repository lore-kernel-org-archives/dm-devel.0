From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v3 8/8] dm: allocate requests from target
 when stacking on blk-mq devices
Date: Wed, 17 Dec 2014 17:35:49 -0500
Message-ID: <20141217223548.GA15390@redhat.com>
References: <1418788804-1982-1-git-send-email-snitzer@redhat.com>
	<1418788804-1982-9-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1418788804-1982-9-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Keith Busch <keith.busch@intel.com>
Cc: axboe@kernel.dk, hch@infradead.org, j-nomura@ce.jp.nec.com, bvanassche@acm.org
List-Id: dm-devel.ids

On Tue, Dec 16 2014 at 11:00pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> From: Keith Busch <keith.busch@intel.com>
> 
> For blk-mq request-based DM the responsibility of allocating a cloned
> request is transfered from DM core to the target type so that the cloned
> request is allocated from the appropriate request_queue's pool and
> initialized for the target block device.  The original request's
> 'special' now points to the dm_rq_target_io because the clone is
> allocated later in the block layer rather than in DM core.
> 
> Care was taken to preserve compatibility with old-style block request
> completion that requires request-based DM _not_ acquire the clone
> request's queue lock in the completion path.  As such, there are now 2
> different request-based dm_target interfaces:
> 1) the original .map_rq() interface will continue to be used for
>    non-blk-mq devices -- the preallocated clone request is passed in
>    from DM core.
> 2) a new .clone_and_map_rq() and .release_clone_rq() will be used for
>    blk-mq devices -- blk_get_request() and blk_put_request() are used
>    respectively from these hooks.
> 
> dm_table_set_type() was updated to detect if the request-based target is
> being stacked on blk-mq devices, if so DM_TYPE_MQ_REQUEST_BASED is set.
> DM core disallows switching the DM table's type after it is set.  This
> means that there is no mixing of non-blk-mq and blk-mq devices within
> the same request-based DM table.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>

I did some testing using the DM "error" target and found some error path
fixes were needed, so I folded the following changes into this last
patch and pushed the rebased result to the linux-dm.git
'dm-for-3.20-blk-mq' branch:

diff --git a/drivers/md/dm-mpath.c b/drivers/md/dm-mpath.c
index df408bc..1fa6f14 100644
--- a/drivers/md/dm-mpath.c
+++ b/drivers/md/dm-mpath.c
@@ -424,6 +424,7 @@ static int __multipath_map(struct dm_target *ti, struct request *clone,
 		*__clone = blk_get_request(bdev_get_queue(bdev),
 					   rq_data_dir(rq), GFP_KERNEL);
 		if (IS_ERR(*__clone))
+			/* ENOMEM, requeue */
 			goto out_unlock;
 		(*__clone)->cmd_flags |= REQ_FAILFAST_TRANSPORT;
 	}
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 612e1c1..19914f6 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1044,7 +1044,7 @@ static void free_rq_clone(struct request *clone)
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
 	blk_rq_unprep_clone(clone);
-	if (clone->q->mq_ops)
+	if (clone->q && clone->q->mq_ops)
 		tio->ti->type->release_clone_rq(clone);
 	else
 		free_clone_request(tio->md, clone);
@@ -1855,15 +1855,15 @@ static int dm_prep_fn(struct request_queue *q, struct request *rq)
 
 /*
  * Returns:
- * 0   : the request has been processed (not requeued)
- * 1   : the request has been requeued
- * < 0 : the original request needs to be requeued
+ * 0                : the request has been processed (not requeued)
+ * 1                : the request has been requeued
+ * DM_MAPIO_REQUEUE : the original request needs to be requeued
  */
 static int map_request(struct dm_target *ti, struct request *rq,
 		       struct mapped_device *md)
 {
 	struct request *clone = NULL;
-	int r, r2, requeued = 0;
+	int r, requeued = 0;
 	struct dm_rq_target_io *tio = rq->special;
 
 	if (tio->clone) {
@@ -1871,12 +1871,17 @@ static int map_request(struct dm_target *ti, struct request *rq,
 		r = ti->type->map_rq(ti, clone, &tio->info);
 	} else {
 		r = ti->type->clone_and_map_rq(ti, rq, &tio->info, &clone);
+		if (r < 0) {
+			/* The target wants to complete the I/O */
+			dm_kill_unmapped_request(rq, r);
+			return r;
+		}
 		if (IS_ERR(clone))
-			return PTR_ERR(clone);
-		r2 = setup_clone(clone, rq, tio, GFP_KERNEL);
-		if (r2) {
+			return DM_MAPIO_REQUEUE;
+		if (setup_clone(clone, rq, tio, GFP_KERNEL)) {
+			/* -ENOMEM */
 			ti->type->release_clone_rq(clone);
-			return r2;
+			return DM_MAPIO_REQUEUE;
 		}
 	}
 
@@ -1915,7 +1920,7 @@ static void map_tio_request(struct kthread_work *work)
 	struct request *rq = tio->orig;
 	struct mapped_device *md = tio->md;
 
-	if (map_request(tio->ti, rq, md) < 0)
+	if (map_request(tio->ti, rq, md) == DM_MAPIO_REQUEUE)
 		dm_requeue_unmapped_original_request(md, rq);
 }
 
