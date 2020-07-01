From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 20/20] block: remove direct_make_request
Date: Wed,  1 Jul 2020 10:59:47 +0200
Message-ID: <20200701085947.3354405-21-hch@lst.de>
References: <20200701085947.3354405-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-bcache-owner@vger.kernel.org>
In-Reply-To: <20200701085947.3354405-1-hch@lst.de>
Sender: linux-bcache-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, linux-m68k@lists.linux-m68k.org, linux-xtensa@linux-xtensa.org, drbd-dev@lists.linbit.com, linuxppc-dev@lists.ozlabs.org, linux-bcache@vger.kernel.org, linux-raid@vger.kernel.org, linux-nvdimm@lists.01.org, linux-nvme@lists.infradead.org, linux-s390@vger.kernel.org
List-Id: dm-devel.ids

Now that submit_bio_noacct has a decent blk-mq fast path there is no
more need for this bypass.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-core.c              | 28 ----------------------------
 drivers/md/dm.c               |  5 +----
 drivers/nvme/host/multipath.c |  2 +-
 include/linux/blkdev.h        |  1 -
 4 files changed, 2 insertions(+), 34 deletions(-)

diff --git a/block/blk-core.c b/block/blk-core.c
index 2ff166f0d24ee3..bf882b8d84450c 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -1211,34 +1211,6 @@ blk_qc_t submit_bio_noacct(struct bio *bio)
 }
 EXPORT_SYMBOL(submit_bio_noacct);
 
-/**
- * direct_make_request - hand a buffer directly to its device driver for I/O
- * @bio:  The bio describing the location in memory and on the device.
- *
- * This function behaves like submit_bio_noacct(), but does not protect
- * against recursion.  Must only be used if the called driver is known
- * to be blk-mq based.
- */
-blk_qc_t direct_make_request(struct bio *bio)
-{
-	struct gendisk *disk = bio->bi_disk;
-
-	if (WARN_ON_ONCE(!disk->queue->mq_ops)) {
-		bio_io_error(bio);
-		return BLK_QC_T_NONE;
-	}
-	if (!submit_bio_checks(bio))
-		return BLK_QC_T_NONE;
-	if (unlikely(bio_queue_enter(bio)))
-		return BLK_QC_T_NONE;
-	if (!blk_crypto_bio_prep(&bio)) {
-		blk_queue_exit(disk->queue);
-		return BLK_QC_T_NONE;
-	}
-	return blk_mq_submit_bio(bio);
-}
-EXPORT_SYMBOL_GPL(direct_make_request);
-
 /**
  * submit_bio - submit a bio to the block device layer for I/O
  * @bio: The &struct bio which describes the I/O
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b32b539dbace56..2cb33896198c4c 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1302,10 +1302,7 @@ static blk_qc_t __map_bio(struct dm_target_io *tio)
 		/* the bio has been remapped so dispatch it */
 		trace_block_bio_remap(clone->bi_disk->queue, clone,
 				      bio_dev(io->orig_bio), sector);
-		if (md->type == DM_TYPE_NVME_BIO_BASED)
-			ret = direct_make_request(clone);
-		else
-			ret = submit_bio_noacct(clone);
+		ret = submit_bio_noacct(clone);
 		break;
 	case DM_MAPIO_KILL:
 		free_tio(tio);
diff --git a/drivers/nvme/host/multipath.c b/drivers/nvme/host/multipath.c
index f07fa47c251d9d..a986ac52c4cc7f 100644
--- a/drivers/nvme/host/multipath.c
+++ b/drivers/nvme/host/multipath.c
@@ -314,7 +314,7 @@ blk_qc_t nvme_ns_head_submit_bio(struct bio *bio)
 		trace_block_bio_remap(bio->bi_disk->queue, bio,
 				      disk_devt(ns->head->disk),
 				      bio->bi_iter.bi_sector);
-		ret = direct_make_request(bio);
+		ret = submit_bio_noacct(bio);
 	} else if (nvme_available_path(head)) {
 		dev_warn_ratelimited(dev, "no usable path - requeuing I/O\n");
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index b73cfa6a5141df..1cc913ffdbe21e 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -853,7 +853,6 @@ static inline void rq_flush_dcache_pages(struct request *rq)
 extern int blk_register_queue(struct gendisk *disk);
 extern void blk_unregister_queue(struct gendisk *disk);
 blk_qc_t submit_bio_noacct(struct bio *bio);
-extern blk_qc_t direct_make_request(struct bio *bio);
 extern void blk_rq_init(struct request_queue *q, struct request *rq);
 extern void blk_put_request(struct request *);
 extern struct request *blk_get_request(struct request_queue *, unsigned int op,
-- 
2.26.2
