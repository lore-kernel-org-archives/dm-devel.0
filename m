From: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Subject: [PATCH block#for-2.6.31] block: add request clone
	interface (v2)
Date: Thu, 11 Jun 2009 12:10:42 +0900
Message-ID: <4A3075B2.9040208@ct.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <jens.axboe@oracle.com>
Cc: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>, k-ueda@ct.jp.nec.com, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: dm-devel.ids

Hi Jens,

This patch adds the following 2 interfaces for request-stacking drivers:

  - blk_rq_prep_clone(struct request *clone, struct request *orig,
		      struct bio_set *bs, gfp_t gfp_mask,
		      int (*bio_ctr)(struct bio *, struct bio*, void *),
		      void *data)
      * Clones bios in the original request to the clone request
        (bio_ctr is called for each cloned bios.)
      * Copies attributes of the original request to the clone request.
        The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not
        copied.

  - blk_rq_unprep_clone(struct request *clone)
      * Frees cloned bios from the clone request.

Request stacking drivers (e.g. request-based dm) need to make a clone
request for a submitted request and dispatch it to other devices.

To allocate request for the clone, request stacking drivers may not
be able to use blk_get_request() because the allocation may be done
in an irq-disabled context.
So blk_rq_prep_clone() takes a request allocated by the caller
as an argument.

For each clone bio in the clone request, request stacking drivers
should be able to set up their own completion handler.
So blk_rq_prep_clone() takes a callback function which is called
for each clone bio, and a pointer for private data which is passed
to the callback.

NOTE:
blk_rq_prep_clone() doesn't copy any actual data of the original
request.  Pages are shared between original bios and cloned bios.
So caller must not complete the original request before the clone
request.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>
---
 block/blk-core.c       |  100 +++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    5 ++
 2 files changed, 105 insertions(+)

Index: linux-2.6-block/block/blk-core.c
===================================================================
--- linux-2.6-block.orig/block/blk-core.c
+++ linux-2.6-block/block/blk-core.c
@@ -2295,6 +2295,106 @@ int blk_lld_busy(struct request_queue *q
 }
 EXPORT_SYMBOL_GPL(blk_lld_busy);
 
+/**
+ * blk_rq_unprep_clone - Helper function to free all bios in a cloned request
+ * @rq: the clone request to be cleaned up
+ *
+ * Description:
+ *     Free all bios in @rq for a cloned request.
+ */
+void blk_rq_unprep_clone(struct request *rq)
+{
+	struct bio *bio;
+
+	while ((bio = rq->bio) != NULL) {
+		rq->bio = bio->bi_next;
+
+		bio_put(bio);
+	}
+}
+EXPORT_SYMBOL_GPL(blk_rq_unprep_clone);
+
+/*
+ * Copy attributes of the original request to the clone request.
+ * The actual data parts (e.g. ->cmd, ->buffer, ->sense) are not copied.
+ */
+static void __blk_rq_prep_clone(struct request *dst, struct request *src)
+{
+	dst->cpu = src->cpu;
+	dst->cmd_flags = (rq_data_dir(src) | REQ_NOMERGE);
+	dst->cmd_type = src->cmd_type;
+	dst->__sector = blk_rq_pos(src);
+	dst->__data_len = blk_rq_bytes(src);
+	dst->nr_phys_segments = src->nr_phys_segments;
+	dst->ioprio = src->ioprio;
+	dst->extra_len = src->extra_len;
+}
+
+/**
+ * blk_rq_prep_clone - Helper function to setup clone request
+ * @rq: the request to be setup
+ * @rq_src: original request to be cloned
+ * @bs: bio_set that bios for clone are allocated from
+ * @gfp_mask: memory allocation mask for bio
+ * @bio_ctr: setup function to be called for each clone bio.
+ *           Returns %0 for success, non %0 for failure.
+ * @data: private data to be passed to @bio_ctr
+ *
+ * Description:
+ *     Clones bios in @rq_src to @rq, and copies attributes of @rq_src to @rq.
+ *     The actual data parts of @rq_src (e.g. ->cmd, ->buffer, ->sense)
+ *     are not copied, and copying such parts is the caller's responsibility.
+ *     Also, pages which the original bios are pointing to are not copied
+ *     and the cloned bios just point same pages.
+ *     So cloned bios must be completed before original bios, which means
+ *     the caller must complete @rq before @rq_src.
+ */
+int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
+		      struct bio_set *bs, gfp_t gfp_mask,
+		      int (*bio_ctr)(struct bio *, struct bio *, void *),
+		      void *data)
+{
+	struct bio *bio, *bio_src;
+
+	if (!bs)
+		bs = fs_bio_set;
+
+	blk_rq_init(NULL, rq);
+
+	__rq_for_each_bio(bio_src, rq_src) {
+		bio = bio_alloc_bioset(gfp_mask, bio_src->bi_max_vecs, bs);
+		if (!bio)
+			goto free_and_out;
+
+		__bio_clone(bio, bio_src);
+
+		if (bio_integrity(bio_src) &&
+		    bio_integrity_clone(bio, bio_src, gfp_mask))
+			goto free_and_out;
+
+		if (bio_ctr && bio_ctr(bio, bio_src, data))
+			goto free_and_out;
+
+		if (rq->bio) {
+			rq->biotail->bi_next = bio;
+			rq->biotail = bio;
+		} else
+			rq->bio = rq->biotail = bio;
+	}
+
+	__blk_rq_prep_clone(rq, rq_src);
+
+	return 0;
+
+free_and_out:
+	if (bio)
+		bio_free(bio, bs);
+	blk_rq_unprep_clone(rq);
+
+	return -ENOMEM;
+}
+EXPORT_SYMBOL_GPL(blk_rq_prep_clone);
+
 int kblockd_schedule_work(struct request_queue *q, struct work_struct *work)
 {
 	return queue_work(kblockd_workqueue, work);
Index: linux-2.6-block/include/linux/blkdev.h
===================================================================
--- linux-2.6-block.orig/include/linux/blkdev.h
+++ linux-2.6-block/include/linux/blkdev.h
@@ -765,6 +765,11 @@ extern void blk_insert_request(struct re
 extern void blk_requeue_request(struct request_queue *, struct request *);
 extern int blk_rq_check_limits(struct request_queue *q, struct request *rq);
 extern int blk_lld_busy(struct request_queue *q);
+extern int blk_rq_prep_clone(struct request *rq, struct request *rq_src,
+			     struct bio_set *bs, gfp_t gfp_mask,
+			     int (*bio_ctr)(struct bio *, struct bio *, void *),
+			     void *data);
+extern void blk_rq_unprep_clone(struct request *rq);
 extern int blk_insert_cloned_request(struct request_queue *q,
 				     struct request *rq);
 extern void blk_plug_device(struct request_queue *);
