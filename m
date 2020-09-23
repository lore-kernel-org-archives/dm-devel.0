From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2] block: add QUEUE_FLAG_NOWAIT
Date: Wed, 23 Sep 2020 16:06:51 -0400
Message-ID: <20200923200652.11082-2-snitzer@redhat.com>
References: <20200923200652.11082-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
In-Reply-To: <20200923200652.11082-1-snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Add QUEUE_FLAG_NOWAIT to allow a block device to advertise support for
REQ_NOWAIT. Bio-based devices may set QUEUE_FLAG_NOWAIT where
applicable.

Update QUEUE_FLAG_MQ_DEFAULT to include QUEUE_FLAG_NOWAIT.  Also
update submit_bio_checks() to verify it is set for REQ_NOWAIT bios.

Reported-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Suggested-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-core.c       | 4 ++--
 include/linux/blkdev.h | 7 +++++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index ca3f0f00c943..e3adfa135a20 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -817,9 +817,9 @@ static noinline_for_stack bool submit_bio_checks(struct bio *bio)
 
 	/*
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
-	 * if queue is not a request based queue.
+	 * if queue does not support NOWAIT.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
+	if ((bio->bi_opf & REQ_NOWAIT) && !blk_queue_nowait(q))
 		goto not_supported;
 
 	if (should_fail_bio(bio))
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index be5ef6f4ba19..9723b497d435 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -618,10 +618,12 @@ struct request_queue {
 #define QUEUE_FLAG_PCI_P2PDMA	25	/* device supports PCI p2p requests */
 #define QUEUE_FLAG_ZONE_RESETALL 26	/* supports Zone Reset All */
 #define QUEUE_FLAG_RQ_ALLOC_TIME 27	/* record rq->alloc_time_ns */
-#define QUEUE_FLAG_HCTX_ACTIVE 28	/* at least one blk-mq hctx is active */
+#define QUEUE_FLAG_HCTX_ACTIVE	28	/* at least one blk-mq hctx is active */
+#define QUEUE_FLAG_NOWAIT       29	/* device supports NOWAIT */
 
 #define QUEUE_FLAG_MQ_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
-				 (1 << QUEUE_FLAG_SAME_COMP))
+				 (1 << QUEUE_FLAG_SAME_COMP) |		\
+				 (1 << QUEUE_FLAG_NOWAIT))
 
 void blk_queue_flag_set(unsigned int flag, struct request_queue *q);
 void blk_queue_flag_clear(unsigned int flag, struct request_queue *q);
@@ -661,6 +663,7 @@ bool blk_queue_flag_test_and_set(unsigned int flag, struct request_queue *q);
 #define blk_queue_pm_only(q)	atomic_read(&(q)->pm_only)
 #define blk_queue_fua(q)	test_bit(QUEUE_FLAG_FUA, &(q)->queue_flags)
 #define blk_queue_registered(q)	test_bit(QUEUE_FLAG_REGISTERED, &(q)->queue_flags)
+#define blk_queue_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 
 extern void blk_set_pm_only(struct request_queue *q);
 extern void blk_clear_pm_only(struct request_queue *q);
-- 
2.15.0
