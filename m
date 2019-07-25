From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V4 1/2] blk-mq: add callback of .cleanup_rq
Date: Thu, 25 Jul 2019 10:04:59 +0800
Message-ID: <20190725020500.4317-2-ming.lei@redhat.com>
References: <20190725020500.4317-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20190725020500.4317-1-ming.lei@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, "Ewan D . Milne" <emilne@redhat.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, stable@vger.kernel.org
List-Id: dm-devel.ids

SCSI maintains its own driver private data hooked off of each SCSI
request, and the pridate data won't be freed after scsi_queue_rq()
returns BLK_STS_RESOURCE or BLK_STS_DEV_RESOURCE. An upper layer driver
(e.g. dm-rq) may need to retry these SCSI requests, before SCSI has
fully dispatched them, due to a lower level SCSI driver's resource
limitation identified in scsi_queue_rq(). Currently SCSI's per-request
private data is leaked when the upper layer driver (dm-rq) frees and
then retries these requests in response to BLK_STS_RESOURCE or
BLK_STS_DEV_RESOURCE returns from scsi_queue_rq().

This usecase is so specialized that it doesn't warrant training an
existing blk-mq interface (e.g. blk_mq_free_request) to allow SCSI to
account for freeing its driver private data -- doing so would add an
extra branch for handling a special case that all other consumers of
SCSI (and blk-mq) won't ever need to worry about.

So the most pragmatic way forward is to delegate freeing SCSI driver
private data to the upper layer driver (dm-rq).  Do so by adding
new .cleanup_rq callback and calling a new blk_mq_cleanup_rq() method
from dm-rq.  A following commit will implement the .cleanup_rq() hook
in scsi_mq_ops.

Cc: Ewan D. Milne <emilne@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Cc: <stable@vger.kernel.org>
Fixes: 396eaf21ee17 ("blk-mq: improve DM's blk-mq IO merging via blk_insert_cloned_request feedback")
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 drivers/md/dm-rq.c     |  1 +
 include/linux/blk-mq.h | 13 +++++++++++++
 2 files changed, 14 insertions(+)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index c9e44ac1f9a6..21d5c1784d0c 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -408,6 +408,7 @@ static int map_request(struct dm_rq_target_io *tio)
 		ret = dm_dispatch_clone_request(clone, rq);
 		if (ret == BLK_STS_RESOURCE || ret == BLK_STS_DEV_RESOURCE) {
 			blk_rq_unprep_clone(clone);
+			blk_mq_cleanup_rq(clone);
 			tio->ti->type->release_clone_rq(clone, &tio->info);
 			tio->clone = NULL;
 			return DM_MAPIO_REQUEUE;
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 3fa1fa59f9b2..ab25e69a15d1 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -140,6 +140,7 @@ typedef int (poll_fn)(struct blk_mq_hw_ctx *);
 typedef int (map_queues_fn)(struct blk_mq_tag_set *set);
 typedef bool (busy_fn)(struct request_queue *);
 typedef void (complete_fn)(struct request *);
+typedef void (cleanup_rq_fn)(struct request *);
 
 
 struct blk_mq_ops {
@@ -200,6 +201,12 @@ struct blk_mq_ops {
 	/* Called from inside blk_get_request() */
 	void (*initialize_rq_fn)(struct request *rq);
 
+	/*
+	 * Called before freeing one request which isn't completed yet,
+	 * and usually for freeing the driver private data
+	 */
+	cleanup_rq_fn		*cleanup_rq;
+
 	/*
 	 * If set, returns whether or not this queue currently is busy
 	 */
@@ -366,4 +373,10 @@ static inline blk_qc_t request_to_qc_t(struct blk_mq_hw_ctx *hctx,
 			BLK_QC_T_INTERNAL;
 }
 
+static inline void blk_mq_cleanup_rq(struct request *rq)
+{
+	if (rq->q->mq_ops->cleanup_rq)
+		rq->q->mq_ops->cleanup_rq(rq);
+}
+
 #endif
-- 
2.20.1
