From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH for-4.2 04/14] block: factor out blkdev_issue_discard_async
Date: Thu, 14 May 2015 17:05:02 -0400
Message-ID: <1431637512-64245-5-git-send-email-snitzer@redhat.com>
References: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1431637512-64245-1-git-send-email-snitzer@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
To: dm-devel@redhat.com
Cc: Jens Axboe <axboe@kernel.dk>, Joe Thornber <ejt@redhat.com>, linux-kernel@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

From: Joe Thornber <ejt@redhat.com>

Useful for callers who wish to manage the async completion of discard(s)
without explicitly blocking waiting for completion.

blkdev_issue_discard() is updated to call blkdev_issue_discard_async()
and DM thinp will make use of blkdev_issue_discard_async() in the
upcoming "dm thin: range discard support" commit.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-lib.c           | 57 +++++++++++++++++++++++++++++++++++++----------
 include/linux/blk_types.h |  1 +
 include/linux/blkdev.h    |  3 +++
 3 files changed, 49 insertions(+), 12 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 7688ee3..2815973 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -26,26 +26,36 @@ static void bio_batch_end_io(struct bio *bio, int err)
 	bio_put(bio);
 }
 
+static void bio_batch_set_completion(struct bio *bio, void *data)
+{
+	struct bio_batch *bb = data;
+
+	bio->bi_end_io = bio_batch_end_io;
+	bio->bi_private = data;
+	atomic_inc(&bb->done);
+}
+
 /**
- * blkdev_issue_discard - queue a discard
+ * blkdev_issue_discard_async - queue a discard with async completion
  * @bdev:	blockdev to issue discard for
  * @sector:	start sector
  * @nr_sects:	number of sectors to discard
  * @gfp_mask:	memory allocation flags (for bio_alloc)
  * @flags:	BLKDEV_IFL_* flags to control behaviour
+ * @set_completion: callback to set completion mechanism for discard bios
+ * @data:       callback data passed to @set_completion
  *
  * Description:
  *    Issue a discard request for the sectors in question.
  */
-int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
-		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+int blkdev_issue_discard_async(struct block_device *bdev, sector_t sector,
+			       sector_t nr_sects, gfp_t gfp_mask, unsigned long flags,
+			       bio_discard_completion_t set_completion, void *data)
 {
-	DECLARE_COMPLETION_ONSTACK(wait);
 	struct request_queue *q = bdev_get_queue(bdev);
 	int type = REQ_WRITE | REQ_DISCARD;
 	unsigned int max_discard_sectors, granularity;
 	int alignment;
-	struct bio_batch bb;
 	struct bio *bio;
 	int ret = 0;
 	struct blk_plug plug;
@@ -77,10 +87,6 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		type |= REQ_SECURE;
 	}
 
-	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
-	bb.wait = &wait;
-
 	blk_start_plug(&plug);
 	while (nr_sects) {
 		unsigned int req_sects;
@@ -108,16 +114,15 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 			req_sects = end_sect - sector;
 		}
 
+		set_completion(bio, data);
+
 		bio->bi_iter.bi_sector = sector;
-		bio->bi_end_io = bio_batch_end_io;
 		bio->bi_bdev = bdev;
-		bio->bi_private = &bb;
 
 		bio->bi_iter.bi_size = req_sects << 9;
 		nr_sects -= req_sects;
 		sector = end_sect;
 
-		atomic_inc(&bb.done);
 		submit_bio(type, bio);
 
 		/*
@@ -129,6 +134,34 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		cond_resched();
 	}
 	blk_finish_plug(&plug);
+	return ret;
+}
+EXPORT_SYMBOL(blkdev_issue_discard_async);
+
+/**
+ * blkdev_issue_discard - queue a discard
+ * @bdev:	blockdev to issue discard for
+ * @sector:	start sector
+ * @nr_sects:	number of sectors to discard
+ * @gfp_mask:	memory allocation flags (for bio_alloc)
+ * @flags:	BLKDEV_IFL_* flags to control behaviour
+ *
+ * Description:
+ *    Issue a discard request for the sectors in question.
+ */
+int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
+			 sector_t nr_sects, gfp_t gfp_mask, unsigned long flags)
+{
+	int ret;
+	DECLARE_COMPLETION_ONSTACK(wait);
+	struct bio_batch bb;
+
+	atomic_set(&bb.done, 1);
+	bb.flags = 1 << BIO_UPTODATE;
+	bb.wait = &wait;
+
+	ret = blkdev_issue_discard_async(bdev, sector, nr_sects, gfp_mask, flags,
+					 bio_batch_set_completion, &bb);
 
 	/* Wait for bios in-flight */
 	if (!atomic_dec_and_test(&bb.done))
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 745588b..a0c00e8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -16,6 +16,7 @@ struct io_context;
 struct cgroup_subsys_state;
 typedef void (bio_end_io_t) (struct bio *, int);
 typedef void (bio_destructor_t) (struct bio *);
+typedef void (bio_discard_completion_t) (struct bio *, void *);
 
 /*
  * was unsigned short, but we might as well be ready for > 64kB I/O pages
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index cd14e2d..16beac3 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1128,6 +1128,9 @@ static inline struct request *blk_map_queue_find_tag(struct blk_queue_tag *bqt,
 extern int blkdev_issue_flush(struct block_device *, gfp_t, sector_t *);
 extern int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, unsigned long flags);
+extern int blkdev_issue_discard_async(struct block_device *bdev, sector_t sector,
+	        sector_t nr_sects, gfp_t gfp_mask, unsigned long flags,
+		bio_discard_completion_t set_completion, void *data);
 extern int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		sector_t nr_sects, gfp_t gfp_mask, struct page *page);
 extern int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
-- 
2.3.2 (Apple Git-55)
