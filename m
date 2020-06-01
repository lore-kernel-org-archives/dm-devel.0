From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 1/3] block: add flag 'nowait_requests' into queue limits
Date: Mon, 01 Jun 2020 15:37:09 +0300
Message-ID: <159101502963.180989.6228080995222059011.stgit@buzz>
References: <159101473169.180989.12175693728191972447.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <159101473169.180989.12175693728191972447.stgit@buzz>
Sender: linux-block-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Add flag for marking bio-based queues which support REQ_NOWAIT.
Set for all request based (mq) devices.

Stacking device should set it after blk_set_stacking_limits() if method
make_request() itself doesn't delay requests or handles REQ_NOWAIT.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 block/blk-core.c       |    4 ++--
 block/blk-mq.c         |    3 +++
 block/blk-settings.c   |    3 +++
 include/linux/blkdev.h |    1 +
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index c4b015004796..9139a316e6d4 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -892,9 +892,9 @@ generic_make_request_checks(struct bio *bio)
 
 	/*
 	 * For a REQ_NOWAIT based request, return -EOPNOTSUPP
-	 * if queue is not a request based queue.
+	 * if queue does not support this flag.
 	 */
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_mq(q))
+	if ((bio->bi_opf & REQ_NOWAIT) && !q->limits.nowait_requests)
 		goto not_supported;
 
 	if (should_fail_bio(bio))
diff --git a/block/blk-mq.c b/block/blk-mq.c
index a7785df2c944..0c3daa0cda87 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2952,6 +2952,9 @@ struct request_queue *blk_mq_init_allocated_queue(struct blk_mq_tag_set *set,
 	 */
 	q->poll_nsec = BLK_MQ_POLL_CLASSIC;
 
+	/* Request based queue always supports REQ_NOWAIT */
+	q->limits.nowait_requests = 1;
+
 	blk_mq_init_cpu_queues(q, set->nr_hw_queues);
 	blk_mq_add_queue_tag_set(set, q);
 	blk_mq_map_swqueue(q);
diff --git a/block/blk-settings.c b/block/blk-settings.c
index 14397b4c4b53..8f96c7324497 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -59,6 +59,7 @@ void blk_set_default_limits(struct queue_limits *lim)
 	lim->io_opt = 0;
 	lim->misaligned = 0;
 	lim->zoned = BLK_ZONED_NONE;
+	lim->nowait_requests = 0;
 }
 EXPORT_SYMBOL(blk_set_default_limits);
 
@@ -486,6 +487,8 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	t->nowait_requests &= b->nowait_requests;
+
 	t->misaligned |= b->misaligned;
 
 	alignment = queue_limit_alignment_offset(b, start);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 32868fbedc9e..5f612dda34c2 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -346,6 +346,7 @@ struct queue_limits {
 	unsigned char		misaligned;
 	unsigned char		discard_misaligned;
 	unsigned char		raid_partial_stripes_expensive;
+	unsigned char		nowait_requests;
 	enum blk_zoned_model	zoned;
 };
 
