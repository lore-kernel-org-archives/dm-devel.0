From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V11 02/12] block: add helper for copying request
Date: Wed, 13 May 2020 11:47:53 +0800
Message-ID: <20200513034803.1844579-3-ming.lei@redhat.com>
References: <20200513034803.1844579-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200513034803.1844579-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

Add one new helper of blk_rq_copy_request() to copy request, and the helper
will be used in this patch for re-submitting request, so make it as a block
layer internal helper.

Cc: John Garry <john.garry@huawei.com>
Cc: Bart Van Assche <bvanassche@acm.org>
Cc: Hannes Reinecke <hare@suse.com>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Snitzer <snitzer@redhat.com>
Cc: dm-devel@redhat.com
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 31 ++++++++++++++++++-------------
 block/blk.h      |  2 ++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 08ee92baa451..ffb1579fd4da 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1620,6 +1620,23 @@ void blk_rq_unprep_clone(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
 
+void blk_rq_copy_request(struct request *rq, struct request *rq_src)
+{
+	/* Copy attributes of the original request to the clone request. */
+	rq->__sector = blk_rq_pos(rq_src);
+	rq->__data_len = blk_rq_bytes(rq_src);
+	if (rq_src->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
+		rq->special_vec = rq_src->special_vec;
+	}
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
+#endif
+	rq->nr_phys_segments = rq_src->nr_phys_segments;
+	rq->ioprio = rq_src->ioprio;
+	rq->write_hint = rq_src->write_hint;
+}
+
 /**
  * blk_rq_prep_clone - Helper function to setup clone request
  * @rq: the request to be setup
@@ -1662,19 +1679,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
 			rq->bio = rq->biotail = bio;
 	}
 
-	/* Copy attributes of the original request to the clone request. */
-	rq->__sector = blk_rq_pos(rq_src);
-	rq->__data_len = blk_rq_bytes(rq_src);
-	if (rq_src->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		rq->rq_flags |= RQF_SPECIAL_PAYLOAD;
-		rq->special_vec = rq_src->special_vec;
-	}
-#ifdef CONFIG_BLK_DEV_INTEGRITY
-	rq->nr_integrity_segments = rq_src->nr_integrity_segments;
-#endif
-	rq->nr_phys_segments = rq_src->nr_phys_segments;
-	rq->ioprio = rq_src->ioprio;
-	rq->write_hint = rq_src->write_hint;
+	blk_rq_copy_request(rq, rq_src);
 
 	return 0;
 
diff --git a/block/blk.h b/block/blk.h
index e5cd350ca379..faf616cb0463 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -120,6 +120,8 @@ static inline void blk_rq_bio_prep(struct request *rq, struct bio *bio,
 		rq->rq_disk = bio->bi_disk;
 }
 
+void blk_rq_copy_request(struct request *rq, struct request *rq_src);
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
-- 
2.25.2
