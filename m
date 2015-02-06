From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] block: do not merge two requests with sg gaps
 if unsupported
Date: Fri, 6 Feb 2015 17:00:53 -0500
Message-ID: <20150206220053.GA12141@redhat.com>
References: <1422137448-14747-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1422137448-14747-1-git-send-email-keith.busch@intel.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Keith Busch <keith.busch@intel.com>, Jens Axboe <axboe@fb.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Sat, Jan 24 2015 at  5:10P -0500,
Keith Busch <keith.busch@intel.com> wrote:

> This has request based dm inherit the QUEUE_FLAG_SG_GAPS flags from its
> underlying block devices' request queues, and does not merge two requests
> with sg gaps when required. This fixes problems when submitting cloned
> requests to multipathed devices requiring virtually contiguous buffers.
> 
> Signed-off-by: Keith Busch <keith.busch@intel.com>

Hi Keith,

I reviewed your patch and cleaned it up a little.  Just some whitespace
nits and used test_bit().  I also renamed dm-table.c's
queue_contiguous_sg() to queue_supports_sg_gaps() to follow the pattern
established by the existing queue_supports_sg_merge().

Jens, provided you and Keith agree with my changes, and given that the
initial request-based DM support for blk-mq will land during the 3.20
merge: can you please pick this fix up for 3.20?  If you'd prefer to
just take the block change I'm fine with picking up the DM portion.

Let me know, thanks!
Mike


From: Keith Busch <keith.busch@intel.com>
Date: Sat, 24 Jan 2015 15:10:48 -0700
Subject: [PATCH] block: do not merge two requests with sg gaps if unsupported

Also, a DM device must inherit the QUEUE_FLAG_SG_GAPS flags from its
underlying block devices' request queues.

This fixes problems when submitting cloned requests to multipathed
devices requiring virtually contiguous buffers.

Signed-off-by: Keith Busch <keith.busch@intel.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-merge.c     | 12 ++++++++++++
 drivers/md/dm-table.c | 13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 89b97b5..1ae46e5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -385,6 +385,14 @@ static bool req_no_special_merge(struct request *req)
 	return !q->mq_ops && req->special;
 }
 
+static int req_gap_to_prev(struct request *req, struct request *next)
+{
+	struct bio *prev = req->biotail;
+
+	return bvec_gap_to_prev(&prev->bi_io_vec[prev->bi_vcnt - 1],
+				next->bio->bi_io_vec[0].bv_offset);
+}
+
 static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 				struct request *next)
 {
@@ -399,6 +407,10 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	if (req_no_special_merge(req) || req_no_special_merge(next))
 		return 0;
 
+	if (test_bit(QUEUE_FLAG_SG_GAPS, q->queue_flags) &&
+	    req_gap_to_prev(req, next))
+		return 0;
+
 	/*
 	 * Will it become too large?
 	 */
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 14954d8..6554d91 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1389,6 +1389,14 @@ static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
 	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 }
 
+static int queue_supports_sg_gaps(struct dm_target *ti, struct dm_dev *dev,
+				  sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !test_bit(QUEUE_FLAG_SG_GAPS, &q->queue_flags);
+}
+
 static bool dm_table_all_devices_attribute(struct dm_table *t,
 					   iterate_devices_callout_fn func)
 {
@@ -1509,6 +1517,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_NO_SG_MERGE, q);
 
+	if (dm_table_all_devices_attribute(t, queue_supports_sg_gaps))
+		queue_flag_clear_unlocked(QUEUE_FLAG_SG_GAPS, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_SG_GAPS, q);
+
 	dm_table_set_integrity(t);
 
 	/*
-- 
1.9.3 (Apple Git-50)
