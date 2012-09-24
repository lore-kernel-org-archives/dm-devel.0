From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: Re: [PATCH v2] dm: gracefully fail any request beyond
 the end of the device
Date: Mon, 24 Sep 2012 18:38:48 +0900
Message-ID: <50602A28.8010402@ce.jp.nec.com>
References: <20120920192812.GA31495@redhat.com>
	<20120921154703.GB5967@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030901070305000405060509"
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20120921154703.GB5967@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com, Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------030901070305000405060509
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

On 09/22/12 00:47, Mike Snitzer wrote:
> @@ -1651,19 +1654,31 @@ static void dm_request_fn(struct request
>  		if (!rq)
>  			goto delay_and_out;
>  
> +		clone = rq->special;
> +
>  		/* always use block 0 to find the target for flushes for now */
>  		pos = 0;
>  		if (!(rq->cmd_flags & REQ_FLUSH))
>  			pos = blk_rq_pos(rq);
>  
>  		ti = dm_table_find_target(map, pos);
> -		BUG_ON(!dm_target_is_valid(ti));
> +		if (!dm_target_is_valid(ti)) {
> +			/*
> +			 * Must perform setup, that dm_done() requires,
> +			 * before calling dm_kill_unmapped_request
> +			 */
> +			DMERR_LIMIT("request attempted access beyond the end of device");
> +			blk_start_request(rq);
> +			atomic_inc(&md->pending[rq_data_dir(clone)]);
> +			dm_get(md);
> +			dm_kill_unmapped_request(clone, -EIO);
> +			goto out;

This "goto out" should be "continue" so that request_fn
process next requests in the queue.

Also I think introducing a function dm_start_request()
will make this part of code a little bit easier for reading.
An edited patch is attached.

-- 
Jun'ichi Nomura, NEC Corporation


--------------030901070305000405060509
Content-Type: text/x-patch;
 name="a.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="a.patch"

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index e24143c..3977f8d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -865,7 +865,10 @@ static void dm_done(struct request *clone, int error, bool mapped)
 {
 	int r = error;
 	struct dm_rq_target_io *tio = clone->end_io_data;
-	dm_request_endio_fn rq_end_io = tio->ti->type->rq_end_io;
+	dm_request_endio_fn rq_end_io = NULL;
+
+	if (tio->ti)
+		rq_end_io = tio->ti->type->rq_end_io;
 
 	if (mapped && rq_end_io)
 		r = rq_end_io(tio->ti, clone, error, &tio->info);
@@ -1566,15 +1569,6 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	int r, requeued = 0;
 	struct dm_rq_target_io *tio = clone->end_io_data;
 
-	/*
-	 * Hold the md reference here for the in-flight I/O.
-	 * We can't rely on the reference count by device opener,
-	 * because the device may be closed during the request completion
-	 * when all bios are completed.
-	 * See the comment in rq_completed() too.
-	 */
-	dm_get(md);
-
 	tio->ti = ti;
 	r = ti->type->map_rq(ti, clone, &tio->info);
 	switch (r) {
@@ -1606,6 +1600,26 @@ static int map_request(struct dm_target *ti, struct request *clone,
 	return requeued;
 }
 
+static struct request *dm_start_request(struct mapped_device *md, struct request *orig)
+{
+	struct request *clone;
+
+	blk_start_request(orig);
+	clone = orig->special;
+	atomic_inc(&md->pending[rq_data_dir(clone)]);
+
+	/*
+	 * Hold the md reference here for the in-flight I/O.
+	 * We can't rely on the reference count by device opener,
+	 * because the device may be closed during the request completion
+	 * when all bios are completed.
+	 * See the comment in rq_completed() too.
+	 */
+	dm_get(md);
+
+	return clone;
+}
+
 /*
  * q->request_fn for request-based dm.
  * Called with the queue lock held.
@@ -1635,14 +1649,21 @@ static void dm_request_fn(struct request_queue *q)
 			pos = blk_rq_pos(rq);
 
 		ti = dm_table_find_target(map, pos);
-		BUG_ON(!dm_target_is_valid(ti));
+		if (!dm_target_is_valid(ti)) {
+			/*
+			 * Must perform setup, that dm_done() requires,
+			 * before calling dm_kill_unmapped_request
+			 */
+			DMERR_LIMIT("request attempted access beyond the end of device");
+			clone = dm_start_request(md, rq);
+			dm_kill_unmapped_request(clone, -EIO);
+			continue;
+		}
 
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
-		blk_start_request(rq);
-		clone = rq->special;
-		atomic_inc(&md->pending[rq_data_dir(clone)]);
+		clone = dm_start_request(md, rq);
 
 		spin_unlock(q->queue_lock);
 		if (map_request(ti, clone, md))
@@ -1662,8 +1683,6 @@ delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
 	dm_table_put(map);
-
-	return;
 }
 
 int dm_underlying_device_busy(struct request_queue *q)

--------------030901070305000405060509
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------030901070305000405060509--
