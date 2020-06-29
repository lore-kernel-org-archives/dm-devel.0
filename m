From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 07/11] block: get rid of blk_trace_request_get_cgid()
Date: Mon, 29 Jun 2020 16:43:10 -0700
Message-ID: <20200629234314.10509-8-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

Now that we have done cleanup we can safely get rid of the
blk_trace_request_get_cgid() and replace it with
blk_trace_bio_get_cgid().

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 kernel/trace/blktrace.c | 26 +++++++++-----------------
 1 file changed, 9 insertions(+), 17 deletions(-)

diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 1d36e6153ab8..bb864a50307f 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -804,15 +804,6 @@ u64 blk_trace_bio_get_cgid(struct request_queue *q, struct bio *bio)
 }
 #endif
 
-static u64
-blk_trace_request_get_cgid(struct request_queue *q, struct request *rq)
-{
-	if (!rq->bio)
-		return 0;
-	/* Use the first bio */
-	return blk_trace_bio_get_cgid(q, rq->bio);
-}
-
 /*
  * blktrace probes
  */
@@ -854,32 +845,32 @@ static void blk_add_trace_rq(struct request *rq, int error,
 static void blk_add_trace_rq_insert(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_INSERT,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 rq->bio ? blk_trace_bio_get_cgid(rq->q, rq->bio) : 0);
 }
 
 static void blk_add_trace_rq_issue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_ISSUE,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 rq->bio ? blk_trace_bio_get_cgid(rq->q, rq->bio) : 0);
 }
 
 static void blk_add_trace_rq_merge(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_BACKMERGE,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 rq->bio ? blk_trace_bio_get_cgid(rq->q, rq->bio) : 0);
 }
 
 static void blk_add_trace_rq_requeue(void *ignore, struct request *rq)
 {
 	blk_add_trace_rq(rq, 0, blk_rq_bytes(rq), BLK_TA_REQUEUE,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 rq->bio ? blk_trace_bio_get_cgid(rq->q, rq->bio) : 0);
 }
 
 static void blk_add_trace_rq_complete(void *ignore, struct request *rq,
 			int error, unsigned int nr_bytes)
 {
 	blk_add_trace_rq(rq, error, nr_bytes, BLK_TA_COMPLETE,
-			 blk_trace_request_get_cgid(rq->q, rq));
+			 rq->bio ? blk_trace_bio_get_cgid(rq->q, rq->bio) : 0);
 }
 
 /**
@@ -1105,7 +1096,8 @@ static void blk_add_trace_rq_remap(void *ignore,
 
 	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
 			rq_data_dir(rq), 0, BLK_TA_REMAP, 0,
-			sizeof(r), &r, blk_trace_request_get_cgid(q, rq));
+			sizeof(r), &r,
+			rq->bio ? blk_trace_bio_get_cgid(q, rq->bio) : 0);
 	rcu_read_unlock();
 }
 
@@ -1134,8 +1126,8 @@ void blk_add_driver_data(struct request_queue *q,
 	}
 
 	__blk_add_trace(bt, blk_rq_trace_sector(rq), blk_rq_bytes(rq), 0, 0,
-				BLK_TA_DRV_DATA, 0, len, data,
-				blk_trace_request_get_cgid(q, rq));
+			BLK_TA_DRV_DATA, 0, len, data,
+			rq->bio ? blk_trace_bio_get_cgid(q, rq->bio) : 0);
 	rcu_read_unlock();
 }
 EXPORT_SYMBOL_GPL(blk_add_driver_data);
-- 
2.26.0
