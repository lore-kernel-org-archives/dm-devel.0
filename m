From: Ming Lei <ming.lei@redhat.com>
Subject: [PATCH V10 02/11] block: add helper for copying request
Date: Tue,  5 May 2020 10:09:21 +0800
Message-ID: <20200505020930.1146281-3-ming.lei@redhat.com>
References: <20200505020930.1146281-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200505020930.1146281-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>, John Garry <john.garry@huawei.com>, Bart Van Assche <bvanassche@acm.org>, Hannes Reinecke <hare@suse.com>, Christoph Hellwig <hch@lst.de>, Thomas Gleixner <tglx@linutronix.de>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, Hannes Reinecke <hare@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

Add one new helper of blk_rq_copy_request() to copy request, and the help=
er
will be used in this patch for re-submitting request, so make it as a blo=
ck
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
Tested-by: John Garry <john.garry@huawei.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
---
 block/blk-core.c | 31 ++++++++++++++++++-------------
 block/blk.h      |  2 ++
 2 files changed, 20 insertions(+), 13 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 1fe73051fec3..ec50d7e6be21 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1581,6 +1581,23 @@ void blk_rq_unprep_clone(struct request *rq)
 }
 EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
=20
+void blk_rq_copy_request(struct request *rq, struct request *rq_src)
+{
+	/* Copy attributes of the original request to the clone request. */
+	rq->__sector =3D blk_rq_pos(rq_src);
+	rq->__data_len =3D blk_rq_bytes(rq_src);
+	if (rq_src->rq_flags & RQF_SPECIAL_PAYLOAD) {
+		rq->rq_flags |=3D RQF_SPECIAL_PAYLOAD;
+		rq->special_vec =3D rq_src->special_vec;
+	}
+#ifdef CONFIG_BLK_DEV_INTEGRITY
+	rq->nr_integrity_segments =3D rq_src->nr_integrity_segments;
+#endif
+	rq->nr_phys_segments =3D rq_src->nr_phys_segments;
+	rq->ioprio =3D rq_src->ioprio;
+	rq->write_hint =3D rq_src->write_hint;
+}
+
 /**
  * blk_rq_prep_clone - Helper function to setup clone request
  * @rq: the request to be setup
@@ -1623,19 +1640,7 @@ int blk_rq_prep_clone(struct request *rq, struct r=
equest *rq_src,
 			rq->bio =3D rq->biotail =3D bio;
 	}
=20
-	/* Copy attributes of the original request to the clone request. */
-	rq->__sector =3D blk_rq_pos(rq_src);
-	rq->__data_len =3D blk_rq_bytes(rq_src);
-	if (rq_src->rq_flags & RQF_SPECIAL_PAYLOAD) {
-		rq->rq_flags |=3D RQF_SPECIAL_PAYLOAD;
-		rq->special_vec =3D rq_src->special_vec;
-	}
-#ifdef CONFIG_BLK_DEV_INTEGRITY
-	rq->nr_integrity_segments =3D rq_src->nr_integrity_segments;
-#endif
-	rq->nr_phys_segments =3D rq_src->nr_phys_segments;
-	rq->ioprio =3D rq_src->ioprio;
-	rq->write_hint =3D rq_src->write_hint;
+	blk_rq_copy_request(rq, rq_src);
=20
 	return 0;
=20
diff --git a/block/blk.h b/block/blk.h
index 73bd3b1c6938..73dd86dc8f47 100644
--- a/block/blk.h
+++ b/block/blk.h
@@ -120,6 +120,8 @@ static inline void blk_rq_bio_prep(struct request *rq=
, struct bio *bio,
 		rq->rq_disk =3D bio->bi_disk;
 }
=20
+void blk_rq_copy_request(struct request *rq, struct request *rq_src);
+
 #ifdef CONFIG_BLK_DEV_INTEGRITY
 void blk_flush_integrity(void);
 bool __bio_integrity_endio(struct bio *);
--=20
2.25.2
