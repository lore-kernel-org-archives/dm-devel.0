From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH v3 1/2] block: Introduce blk_bio_map_sg() to map one bio
Date: Thu, 17 Dec 2015 15:32:48 +0800
Message-ID: <f8104b9a6ceae6c869ae4e74b6f8f82a693d1404.1450336551.git.baolin.wang@linaro.org>
References: <cover.1450336551.git.baolin.wang@linaro.org>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <cover.1450336551.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1450336551.git.baolin.wang@linaro.org>
References: <cover.1450336551.git.baolin.wang@linaro.org>
Sender: linux-raid-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

In dm-crypt, it need to map one bio to scatterlist for improving the
encryption efficiency. Thus this patch introduces the blk_bio_map_sg()
function to map one bio with scatterlists.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 block/blk-merge.c      |   45 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/blkdev.h |    3 +++
 2 files changed, 48 insertions(+)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index de5716d8..281b9e5 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -374,6 +374,51 @@ single_segment:
 }
 
 /*
+ * map a bio to scatterlist, return number of sg entries setup.
+ */
+int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+		   struct scatterlist *sglist,
+		   struct scatterlist **sg)
+{
+	struct bio_vec bvec, bvprv = { NULL };
+	struct bvec_iter iter;
+	int nsegs, cluster;
+
+	nsegs = 0;
+	cluster = blk_queue_cluster(q);
+
+	if (bio->bi_rw & REQ_DISCARD) {
+		/*
+		 * This is a hack - drivers should be neither modifying the
+		 * biovec, nor relying on bi_vcnt - but because of
+		 * blk_add_request_payload(), a discard bio may or may not have
+		 * a payload we need to set up here (thank you Christoph) and
+		 * bi_vcnt is really the only way of telling if we need to.
+		 */
+
+		if (bio->bi_vcnt)
+			goto single_segment;
+
+		return 0;
+	}
+
+	if (bio->bi_rw & REQ_WRITE_SAME) {
+single_segment:
+		*sg = sglist;
+		bvec = bio_iovec(bio);
+		sg_set_page(*sg, bvec.bv_page, bvec.bv_len, bvec.bv_offset);
+		return 1;
+	}
+
+	bio_for_each_segment(bvec, bio, iter)
+		__blk_segment_map_sg(q, &bvec, sglist, &bvprv, sg,
+				     &nsegs, &cluster);
+
+	return nsegs;
+}
+EXPORT_SYMBOL(blk_bio_map_sg);
+
+/*
  * map a request to scatterlist, return number of sg entries setup. Caller
  * must make sure sg can hold rq->nr_phys_segments entries
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3fe27f8..3ca90ac 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1004,6 +1004,9 @@ extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int blk_bio_map_sg(struct request_queue *q, struct bio *bio,
+			  struct scatterlist *sglist,
+			  struct scatterlist **sg);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.9.5

