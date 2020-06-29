From: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
Subject: [PATCH 06/11] block: remove extra param for trace_block_getrq()
Date: Mon, 29 Jun 2020 16:43:09 -0700
Message-ID: <20200629234314.10509-7-chaitanya.kulkarni@wdc.com>
References: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200629234314.10509-1-chaitanya.kulkarni@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org, dm-devel@redhat.com
Cc: jack@suse.czi, rdunlap@infradead.org, sagi@grimberg.me, mingo@redhat.com, rostedt@goodmis.org, snitzer@redhat.com, agk@redhat.com, axboe@kernel.dk, paolo.valente@linaro.org, ming.lei@redhat.com, bvanassche@acm.org, fangguoju@gmail.com, colyli@suse.de, hch@lst.de, Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
List-Id: dm-devel.ids

Remove the extra parameter for trace_block_getrq() since we can derive
I/O direction from bio->bi_opf.

Signed-off-by: Chaitanya Kulkarni <chaitanya.kulkarni@wdc.com>
---
 block/blk-mq.c               |  2 +-
 include/trace/events/block.h | 14 ++++++--------
 kernel/trace/blktrace.c      | 13 ++++++-------
 3 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index dbb98b2bc868..d66bb299d4ae 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2111,7 +2111,7 @@ blk_qc_t blk_mq_make_request(struct request_queue *q, struct bio *bio)
 		goto queue_exit;
 	}
 
-	trace_block_getrq(bio, bio->bi_opf);
+	trace_block_getrq(bio);
 
 	rq_qos_track(q, rq, bio);
 
diff --git a/include/trace/events/block.h b/include/trace/events/block.h
index d7289576f1fd..3d8923062fc4 100644
--- a/include/trace/events/block.h
+++ b/include/trace/events/block.h
@@ -347,9 +347,9 @@ DEFINE_EVENT(block_bio, block_bio_queue,
 
 DECLARE_EVENT_CLASS(block_get_rq,
 
-	TP_PROTO(struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(bio, rw),
+	TP_ARGS(bio),
 
 	TP_STRUCT__entry(
 		__field( dev_t,		dev			)
@@ -377,22 +377,20 @@ DECLARE_EVENT_CLASS(block_get_rq,
 /**
  * block_getrq - get a free request entry in queue for block IO operations
  * @bio: pending block IO operation (can be %NULL)
- * @rw: low bit indicates a read (%0) or a write (%1)
  *
  * A request struct for queue has been allocated to handle the
  * block IO operation @bio.
  */
 DEFINE_EVENT(block_get_rq, block_getrq,
 
-	TP_PROTO(struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(bio, rw)
+	TP_ARGS(bio)
 );
 
 /**
  * block_sleeprq - waiting to get a free request entry in queue for block IO operation
  * @bio: pending block IO operation (can be %NULL)
- * @rw: low bit indicates a read (%0) or a write (%1)
  *
  * In the case where a request struct cannot be provided for queue
  * the process needs to wait for an request struct to become
@@ -401,9 +399,9 @@ DEFINE_EVENT(block_get_rq, block_getrq,
  */
 DEFINE_EVENT(block_get_rq, block_sleeprq,
 
-	TP_PROTO(struct bio *bio, int rw),
+	TP_PROTO(struct bio *bio),
 
-	TP_ARGS(bio, rw)
+	TP_ARGS(bio)
 );
 
 /**
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index 7b72781a591d..1d36e6153ab8 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -949,8 +949,7 @@ static void blk_add_trace_bio_queue(void *ignore, struct bio *bio)
 	blk_add_trace_bio(bio, BLK_TA_QUEUE, 0);
 }
 
-static void blk_add_trace_getrq(void *ignore,
-				struct bio *bio, int rw)
+static void blk_add_trace_getrq(void *ignore, struct bio *bio)
 {
 	if (bio)
 		blk_add_trace_bio(bio, BLK_TA_GETRQ, 0);
@@ -960,14 +959,14 @@ static void blk_add_trace_getrq(void *ignore,
 		rcu_read_lock();
 		bt = rcu_dereference(bio_q(bio)->blk_trace);
 		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_GETRQ, 0, 0,
-					NULL, 0);
+			__blk_add_trace(bt, 0, 0, bio->bi_opf, 0,
+					BLK_TA_GETRQ, 0, 0, NULL, 0);
 		rcu_read_unlock();
 	}
 }
 
 
-static void blk_add_trace_sleeprq(void *ignore, struct bio *bio, int rw)
+static void blk_add_trace_sleeprq(void *ignore, struct bio *bio)
 {
 	if (bio)
 		blk_add_trace_bio(bio, BLK_TA_SLEEPRQ, 0);
@@ -977,8 +976,8 @@ static void blk_add_trace_sleeprq(void *ignore, struct bio *bio, int rw)
 		rcu_read_lock();
 		bt = rcu_dereference(bio_q(bio)->blk_trace);
 		if (bt)
-			__blk_add_trace(bt, 0, 0, rw, 0, BLK_TA_SLEEPRQ,
-					0, 0, NULL, 0);
+			__blk_add_trace(bt, 0, 0, bio->bi_opf, 0,
+					BLK_TA_SLEEPRQ, 0, 0, NULL, 0);
 		rcu_read_unlock();
 	}
 }
-- 
2.26.0
