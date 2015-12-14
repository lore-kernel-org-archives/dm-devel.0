From: Baolin Wang <baolin.wang@linaro.org>
Subject: [PATCH 1/2] block: Export the __blk_bios_map_sg() to map one bio
Date: Mon, 14 Dec 2015 16:23:39 +0800
Message-ID: <224caa7e50b4a4e6ed6292e3fd70cc0bf290588b.1450080755.git.baolin.wang@linaro.org>
References: <cover.1450080755.git.baolin.wang@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cover.1450080755.git.baolin.wang@linaro.org>
In-Reply-To: <cover.1450080755.git.baolin.wang@linaro.org>
References: <cover.1450080755.git.baolin.wang@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
To: axboe@kernel.dk, agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: neilb@suse.com, dan.j.williams@intel.com, martin.petersen@oracle.com, sagig@mellanox.com, kent.overstreet@gmail.com, keith.busch@intel.com, tj@kernel.org, broonie@kernel.org, arnd@arndb.de, linux-block@vger.kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, baolin.wang@linaro.org
List-Id: dm-devel.ids

In dm-crypt, it need to map one bio to scatterlist for improving the
encryption efficiency. Thus this patch exports the __blk_bios_map_sg()
function to map one bio with scatterlists.

Signed-off-by: Baolin Wang <baolin.wang@linaro.org>
---
 block/blk-merge.c      |    7 ++++---
 include/linux/blkdev.h |    3 +++
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/block/blk-merge.c b/block/blk-merge.c
index de5716d8..09cc7c4 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -331,9 +331,9 @@ new_segment:
 	*bvprv = *bvec;
 }
 
-static int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
-			     struct scatterlist *sglist,
-			     struct scatterlist **sg)
+int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
+		      struct scatterlist *sglist,
+		      struct scatterlist **sg)
 {
 	struct bio_vec bvec, bvprv = { NULL };
 	struct bvec_iter iter;
@@ -372,6 +372,7 @@ single_segment:
 
 	return nsegs;
 }
+EXPORT_SYMBOL(__blk_bios_map_sg);
 
 /*
  * map a request to scatterlist, return number of sg entries setup. Caller
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 3fe27f8..dd8d10f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1004,6 +1004,9 @@ extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 
 extern int blk_rq_map_sg(struct request_queue *, struct request *, struct scatterlist *);
+extern int __blk_bios_map_sg(struct request_queue *q, struct bio *bio,
+			     struct scatterlist *sglist,
+			     struct scatterlist **sg);
 extern void blk_dump_rq_flags(struct request *, char *);
 extern long nr_blockdev_pages(void);
 
-- 
1.7.9.5
