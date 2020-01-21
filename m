From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v3 2/7] block: Pass op_flags into blk_queue_get_max_sectors()
Date: Tue, 21 Jan 2020 13:18:50 +0300
Message-ID: <157960193056.97730.5556479428398013001.stgit@localhost.localdomain>
References: <157960153921.97730.9973412459876396302.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <157960153921.97730.9973412459876396302.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, darrick.wong@oracle.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

This preparation patch changes argument type, and now
the function takes full op_flags instead of just op code.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
---
 block/blk-core.c       |    4 ++--
 include/linux/blkdev.h |    8 +++++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 50a5de025d5e..ac2634bcda1f 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1250,10 +1250,10 @@ EXPORT_SYMBOL(submit_bio);
 static int blk_cloned_rq_check_limits(struct request_queue *q,
 				      struct request *rq)
 {
-	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, req_op(rq))) {
+	if (blk_rq_sectors(rq) > blk_queue_get_max_sectors(q, rq->cmd_flags)) {
 		printk(KERN_ERR "%s: over max size limit. (%u > %u)\n",
 			__func__, blk_rq_sectors(rq),
-			blk_queue_get_max_sectors(q, req_op(rq)));
+			blk_queue_get_max_sectors(q, rq->cmd_flags));
 		return -EIO;
 	}
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 0f1127d0b043..23a5850f35f6 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -989,8 +989,10 @@ static inline struct bio_vec req_bvec(struct request *rq)
 }
 
 static inline unsigned int blk_queue_get_max_sectors(struct request_queue *q,
-						     int op)
+						     unsigned int op_flags)
 {
+	int op = op_flags & REQ_OP_MASK;
+
 	if (unlikely(op == REQ_OP_DISCARD || op == REQ_OP_SECURE_ERASE))
 		return min(q->limits.max_discard_sectors,
 			   UINT_MAX >> SECTOR_SHIFT);
@@ -1029,10 +1031,10 @@ static inline unsigned int blk_rq_get_max_sectors(struct request *rq,
 	if (!q->limits.chunk_sectors ||
 	    req_op(rq) == REQ_OP_DISCARD ||
 	    req_op(rq) == REQ_OP_SECURE_ERASE)
-		return blk_queue_get_max_sectors(q, req_op(rq));
+		return blk_queue_get_max_sectors(q, rq->cmd_flags);
 
 	return min(blk_max_size_offset(q, offset),
-			blk_queue_get_max_sectors(q, req_op(rq)));
+			blk_queue_get_max_sectors(q, rq->cmd_flags));
 }
 
 static inline unsigned int blk_rq_count_bios(struct request *rq)
