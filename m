From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 1/9] QUEUE_FLAG_NOWAIT to indicate device supports nowait
Date: Wed, 26 Jul 2017 18:57:58 -0500
Message-ID: <20170726235806.12148-2-rgoldwyn@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170726235806.12148-1-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Nowait is a feature of direct AIO, where users can request
to return immediately if the I/O is going to block. This translates
to REQ_NOWAIT in bio.bi_opf flags. While request based devices
don't wait, stacked devices such as md/dm will.

In order to explicitly mark stacked devices as supported, we
set the QUEUE_FLAG_NOWAIT in the queue_flags and return -EAGAIN
whenever the device would block.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 block/blk-core.c       | 3 ++-
 include/linux/blkdev.h | 2 ++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 970b9c9638c5..1c9a981d88e5 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -2025,7 +2025,8 @@ generic_make_request_checks(struct bio *bio)
 	 * if queue is not a request based queue.
 	 */
 
-	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q))
+	if ((bio->bi_opf & REQ_NOWAIT) && !queue_is_rq_based(q) &&
+	    !blk_queue_supports_nowait(q))
 		goto not_supported;
 
 	part = bio->bi_bdev->bd_part;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 25f6a0cb27d3..fae021ebec1b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -633,6 +633,7 @@ struct request_queue {
 #define QUEUE_FLAG_REGISTERED  29	/* queue has been registered to a disk */
 #define QUEUE_FLAG_SCSI_PASSTHROUGH 30	/* queue supports SCSI commands */
 #define QUEUE_FLAG_QUIESCED    31	/* queue has been quiesced */
+#define QUEUE_FLAG_NOWAIT      32	/* stack device driver supports REQ_NOWAIT */
 
 #define QUEUE_FLAG_DEFAULT	((1 << QUEUE_FLAG_IO_STAT) |		\
 				 (1 << QUEUE_FLAG_STACKABLE)	|	\
@@ -732,6 +733,7 @@ static inline void queue_flag_clear(unsigned int flag, struct request_queue *q)
 #define blk_queue_dax(q)	test_bit(QUEUE_FLAG_DAX, &(q)->queue_flags)
 #define blk_queue_scsi_passthrough(q)	\
 	test_bit(QUEUE_FLAG_SCSI_PASSTHROUGH, &(q)->queue_flags)
+#define blk_queue_supports_nowait(q)	test_bit(QUEUE_FLAG_NOWAIT, &(q)->queue_flags)
 
 #define blk_noretry_request(rq) \
 	((rq)->cmd_flags & (REQ_FAILFAST_DEV|REQ_FAILFAST_TRANSPORT| \
-- 
2.12.3
