From: Keith Busch <keith.busch@intel.com>
Subject: [PATCH] dm: Respect request queue page gaps flag
Date: Sat, 24 Jan 2015 15:10:48 -0700
Message-ID: <1422137448-14747-1-git-send-email-keith.busch@intel.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Jens Axboe <axboe@fb.com>
Cc: Keith Busch <keith.busch@intel.com>
List-Id: dm-devel.ids

This has request based dm inherit the QUEUE_FLAG_SG_GAPS flags from its
underlying block devices' request queues, and does not merge two requests
with sg gaps when required. This fixes problems when submitting cloned
requests to multipathed devices requiring virtually contiguous buffers.

Signed-off-by: Keith Busch <keith.busch@intel.com>
---
 block/blk-merge.c     |   12 ++++++++++++
 drivers/md/dm-table.c |   13 +++++++++++++
 2 files changed, 25 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index 89b97b5..f021a11 100644
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
+					next->bio->bi_io_vec[0].bv_offset);
+}
+
 static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 				struct request *next)
 {
@@ -399,6 +407,10 @@ static int ll_merge_requests_fn(struct request_queue *q, struct request *req,
 	if (req_no_special_merge(req) || req_no_special_merge(next))
 		return 0;
 
+	if ((q->queue_flags & (1 << QUEUE_FLAG_SG_GAPS)) &&
+					req_gap_to_prev(req, next))
+		return 0;
+
 	/*
 	 * Will it become too large?
 	 */
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 14954d8..d7eee6d 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1389,6 +1389,14 @@ static int queue_supports_sg_merge(struct dm_target *ti, struct dm_dev *dev,
 	return q && !test_bit(QUEUE_FLAG_NO_SG_MERGE, &q->queue_flags);
 }
 
+static int queue_contiguous_sg(struct dm_target *ti, struct dm_dev *dev,
+				   sector_t start, sector_t len, void *data)
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
 
+	if (dm_table_all_devices_attribute(t, queue_contiguous_sg))
+		queue_flag_clear_unlocked(QUEUE_FLAG_SG_GAPS, q);
+	else
+		queue_flag_set_unlocked(QUEUE_FLAG_SG_GAPS, q);
+
 	dm_table_set_integrity(t);
 
 	/*
-- 
1.7.10.4
