From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 1/2] block: move blk_queue_bypass_{start,end} to include/linux/blkdev.h
Date: Thu, 25 Oct 2012 18:41:05 +0900
Message-ID: <50890931.3050906@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, device-mapper development <dm-devel@redhat.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

[PATCH] block: move blk_queue_bypass_{start,end} to include/linux/blkdev.h

dm wants to use those functions to control the bypass status of
half-initialized device.

This patch is a preparation for:
  [PATCH] dm: stay in blk_queue_bypass until queue becomes initialized

Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Vivek Goyal <vgoyal@redhat.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Alasdair G Kergon <agk@redhat.com>

---
 block/blk.h            |    2 --
 include/linux/blkdev.h |    2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/block/blk.h b/block/blk.h
index ca51543..48bac5b 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -26,8 +26,6 @@ void blk_rq_bio_prep(struct request_queue *q, struct request *rq,
 			struct bio *bio);
 int blk_rq_append_bio(struct request_queue *q, struct request *rq,
 		      struct bio *bio);
-void blk_queue_bypass_start(struct request_queue *q);
-void blk_queue_bypass_end(struct request_queue *q);
 void blk_dequeue_request(struct request *rq);
 void __blk_queue_free_tags(struct request_queue *q);
 bool __blk_end_bidi_request(struct request *rq, int error,
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 1756001..86ba153 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -949,6 +949,8 @@ bool __must_check blk_get_queue(struct request_queue *);
 struct request_queue *blk_alloc_queue(gfp_t);
 struct request_queue *blk_alloc_queue_node(gfp_t, int);
 extern void blk_put_queue(struct request_queue *);
+void blk_queue_bypass_start(struct request_queue *q);
+void blk_queue_bypass_end(struct request_queue *q);
 
 /*
  * blk_plug permits building a queue of related requests by holding the I/O
