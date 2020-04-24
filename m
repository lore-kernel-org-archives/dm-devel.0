From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V8 02/11] block: add helper for copying request
Date: Fri, 24 Apr 2020 18:23:42 +0800
Message-ID: <20200424102351.475641-3-ming.lei@redhat.com>
References: <20200424102351.475641-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20200424102351.475641-1-ming.lei@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Hannes Reinecke <hare@suse.com>, Bart Van Assche <bvanassche@acm.org>, Mike Snitzer <snitzer@redhat.com>, John Garry <john.garry@huawei.com>, Ming Lei <ming.lei@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Thomas Gleixner <tglx@linutronix.de>, Christoph Hellwig <hch@lst.de>
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
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 33 +++++++++++++++++++--------------
 block/blk.h      |  2 ++
 2 files changed, 21 insertions(+), 14 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 91537e526b45..76405551d09e 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1587,6 +1587,24 @@ void blk_rq_unprep_clone(struct request *rq)
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
+	rq->extra_len = rq_src->extra_len;
+	rq->write_hint = rq_src->write_hint;
+}
+
 /**
  * blk_rq_prep_clone - Helper function to setup clone request
  * @rq: the request to be setup
@@ -1629,20 +1647,7 @@ int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
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
-	rq->extra_len = rq_src->extra_len;
-	rq->write_hint = rq_src->write_hint;
+	blk_rq_copy_request(rq, rq_src);
 
 	return 0;
 
diff --git a/block/blk.h b/block/blk.h
index 0a94ec68af32..bbbced0b3c8c 100644
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
