From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3] dm: gracefully fail any request beyond the
 end of the device
Date: Mon, 24 Sep 2012 09:28:48 -0400
Message-ID: <20120924132848.GB27531@redhat.com>
References: <20120920192812.GA31495@redhat.com>
	<20120921154703.GB5967@redhat.com> <50602A28.8010402@ce.jp.nec.com>
	<20120924130711.GA27531@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <20120924130711.GA27531@redhat.com>
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
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: stable@vger.kernel.org # v2.6.37+
---
 drivers/md/dm.c |   51 +++++++++++++++++++++++++++++++++++----------------
 1 file changed, 35 insertions(+), 16 deletions(-)

v2: added a DMERR_LIMIT message to give context for the IO errors
v3: folded in Jun'ichi's changes: dm_start_request and continue

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
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
@@ -1588,15 +1591,6 @@ static int map_request(struct dm_target 
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
@@ -1628,6 +1622,26 @@ static int map_request(struct dm_target 
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
@@ -1657,14 +1671,21 @@ static void dm_request_fn(struct request
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
@@ -1684,8 +1705,6 @@ delay_and_out:
 	blk_delay_queue(q, HZ / 10);
 out:
 	dm_table_put(map);
-
-	return;
 }
 
 int dm_underlying_device_busy(struct request_queue *q)
