From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 10/12] block: update request stacking methods to
	support discards
Date: Fri, 23 Jul 2010 19:24:01 -0400
Message-ID: <1279927443-1780-11-git-send-email-snitzer@redhat.com>
References: <1279927443-1780-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1279927443-1780-1-git-send-email-snitzer@redhat.com>
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
 1 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 9922a9b..292fc58 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1655,6 +1655,9 @@ EXPORT_SYMBOL(submit_bio);
  */
 int blk_rq_check_limits(struct request_queue *q, struct request *rq)
 {
+	if (blk_discard_rq(rq))
+		return 0;
+
 	if (blk_rq_sectors(rq) > queue_max_sectors(q) ||
 	    blk_rq_bytes(rq) > queue_max_hw_sectors(q) << 9) {
 		printk(KERN_ERR "%s: over max size limit.\n", __func__);
@@ -2499,6 +2502,8 @@ static void __blk_rq_prep_clone(struct request *dst, struct request *src)
 {
 	dst->cpu = src->cpu;
 	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
+	if (blk_discard_rq(src))
+		dst->cmd_flags |= REQ_DISCARD;
 	dst->cmd_type = src->cmd_type;
 	dst->__sector = blk_rq_pos(src);
 	dst->__data_len = blk_rq_bytes(src);
-- 
1.6.6.1
