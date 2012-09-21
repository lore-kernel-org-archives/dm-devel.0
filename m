From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm: gracefully fail any request beyond the
 end of the device
Date: Fri, 21 Sep 2012 11:47:03 -0400
Message-ID: <20120921154703.GB5967@redhat.com>
References: <20120920192812.GA31495@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120920192812.GA31495@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, Mike Christie <michaelc@cs.wisc.edu>
List-Id: dm-devel.ids

The access beyond the end of device BUG_ON that was introduced to
dm_request_fn via commit 29e4013de7ad950280e4b2208 ("dm: implement
REQ_FLUSH/FUA support for request-based dm") is an overly drastic
response.  Use dm_kill_unmapped_request() to fail the clone and original
request with -EIO.

map_request() will assign the valid target returned by
dm_table_find_target to tio->ti.  But in the case where the target
isn't valid tio->ti is never assigned (because map_request isn't
called); so add a check for tio->ti != NULL to dm_done().

Reported-by: Mike Christie <michaelc@cs.wisc.edu>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org # v2.6.37+
---
 drivers/md/dm.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

v2: added a DMERR_LIMIT message to give context for the IO errors

Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c
+++ linux/drivers/md/dm.c
@@ -865,7 +865,10 @@ static void dm_done(struct request *clon
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
@@ -1651,19 +1654,31 @@ static void dm_request_fn(struct request
 		if (!rq)
 			goto delay_and_out;
 
+		clone = rq->special;
+
 		/* always use block 0 to find the target for flushes for now */
 		pos = 0;
 		if (!(rq->cmd_flags & REQ_FLUSH))
 			pos = blk_rq_pos(rq);
 
 		ti = dm_table_find_target(map, pos);
-		BUG_ON(!dm_target_is_valid(ti));
+		if (!dm_target_is_valid(ti)) {
+			/*
+			 * Must perform setup, that dm_done() requires,
+			 * before calling dm_kill_unmapped_request
+			 */
+			DMERR_LIMIT("request attempted access beyond the end of device");
+			blk_start_request(rq);
+			atomic_inc(&md->pending[rq_data_dir(clone)]);
+			dm_get(md);
+			dm_kill_unmapped_request(clone, -EIO);
+			goto out;
+		}
 
 		if (ti->type->busy && ti->type->busy(ti))
 			goto delay_and_out;
 
 		blk_start_request(rq);
-		clone = rq->special;
 		atomic_inc(&md->pending[rq_data_dir(clone)]);
 
 		spin_unlock(q->queue_lock);
@@ -1684,8 +1699,6 @@ delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
 	dm_table_put(map);
-
-	return;
 }
 
 int dm_underlying_device_busy(struct request_queue *q)
