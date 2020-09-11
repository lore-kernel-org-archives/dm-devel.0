From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] block: fix blk_rq_get_max_sectors() to flow more carefully
Date: Fri, 11 Sep 2020 17:53:36 -0400
Message-ID: <20200911215338.44805-2-snitzer@redhat.com>
References: <20200911215338.44805-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200911215338.44805-1-snitzer@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: Vijayendra Suman <vijayendra.suman@oracle.com>, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

blk_queue_get_max_sectors() has been trained for REQ_OP_WRITE_SAME and
REQ_OP_WRITE_ZEROES yet blk_rq_get_max_sectors() didn't call it for
those operations.

Also, there is no need to avoid blk_max_size_offset() if
'chunk_sectors' isn't set because it falls back to 'max_sectors'.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 include/linux/blkdev.h | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bb5636cc17b9..453a3d735d66 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1070,17 +1070,24 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 						  sector_t offset)
 {
 	struct request_queue *q = rq->q;
+	int op;
+	unsigned int max_sectors;
 
 	if (blk_rq_is_passthrough(rq))
 		return q->limits.max_hw_sectors;
 
-	if (!q->limits.chunk_sectors ||
-	    req_op(rq) == REQ_OP_DISCARD ||
-	    req_op(rq) == REQ_OP_SECURE_ERASE)
-		return blk_queue_get_max_sectors(q, req_op(rq));
+	op = req_op(rq);
+	max_sectors = blk_queue_get_max_sectors(q, op);
 
-	return min(blk_max_size_offset(q, offset),
-			blk_queue_get_max_sectors(q, req_op(rq)));
+	switch (op) {
+	case REQ_OP_DISCARD:
+	case REQ_OP_SECURE_ERASE:
+	case REQ_OP_WRITE_SAME:
+	case REQ_OP_WRITE_ZEROES:
+		return max_sectors;
+	}
+
+	return min(blk_max_size_offset(q, offset), max_sectors);
 }
 
 static inline unsigned int blk_rq_count_bios(struct request *rq)
-- 
2.15.0
