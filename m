From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 10/12] block: update request stacking methods
	to support discards
Date: Sat, 24 Jul 2010 12:09:26 -0400
Message-ID: <1279987768-13275-11-git-send-email-snitzer@redhat.com>
References: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279987768-13275-1-git-send-email-snitzer@redhat.com>
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
Cc: Jens Axboe <jaxboe@fusionio.com>, Christoph Hellwig <hch@lst.de>, Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
List-Id: dm-devel.ids

Propagate REQ_DISCARD in cmd_flags when cloning a discard request.
Skip blk_rq_check_limits's existing checks for discard requests because
discard limits will have already been checked in blkdev_issue_discard.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Jens Axboe <jaxboe@fusionio.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
---
 block/blk-core.c |    5 +++++
 1 file changed, 5 insertions(+)

Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -1644,6 +1644,9 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
+	if (rq->cmd_flags & REQ_DISCARD)
+		return 0;
+
 	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
 	    blk_rq_bytes(rq) > queue_max_hw_sectors(q) << 9) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
@@ -2492,6 +2495,8 @@ static void __blk_rq_prep_clone(struct r
 {
 	dst->cpu = src->cpu;
 	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
+	if (src->cmd_flags & REQ_DISCARD)
+		dst->cmd_flags |= REQ_DISCARD;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
