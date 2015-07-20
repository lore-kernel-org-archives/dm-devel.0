From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH] block: add a bi_error field to struct bio
Date: Mon, 20 Jul 2015 15:29:37 +0200
Message-ID: <1437398977-8492-2-git-send-email-hch@lst.de>
References: <1437398977-8492-1-git-send-email-hch@lst.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1437398977-8492-1-git-send-email-hch@lst.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Neil Brown <neilb@suse.de>, Liu Bo <bo.li.liu@oracle.com>, linux-raid@vger.kernel.org, dm-devel@redhat.com, linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Currently we have two different ways to signal an I/O error on a BIO:

 (1) by clearing the BIO_UPTODATE flag
 (2) by returning a Linux errno value to the bi_end_io callback

The first one has the drawback of only communicating a single possible
error (-EIO), and the second one has the drawback of not beeing persistent
when bios are queued up, and are not passed along from child to parent
bio in the ever more popular chaining scenario.  Having both mechanisms
available has the additional drawback of utterly confusing driver authors
and introducing bugs where various I/O submitters only deal with one of
them, and the others have to add boilerplate code to deal with both kinds
of error returns.

So add a new bi_error field to store an errno value directly in struct
bio and remove the existing mechanisms to clean all this up.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 Documentation/block/biodoc.txt      |  2 +-
 arch/m68k/emu/nfblock.c             |  2 +-
 arch/powerpc/sysdev/axonram.c       |  2 +-
 arch/xtensa/platforms/iss/simdisk.c | 12 ++-----
 block/bio-integrity.c               | 11 +++----
 block/bio.c                         | 43 +++++++++++--------------
 block/blk-core.c                    | 15 ++++-----
 block/blk-lib.c                     | 30 ++++++++----------
 block/blk-map.c                     |  2 +-
 block/blk-mq.c                      |  6 ++--
 block/bounce.c                      | 27 ++++++++--------
 drivers/block/aoe/aoecmd.c          | 10 +++---
 drivers/block/aoe/aoedev.c          |  2 +-
 drivers/block/brd.c                 | 13 +++++---
 drivers/block/drbd/drbd_actlog.c    |  4 +--
 drivers/block/drbd/drbd_bitmap.c    | 19 +++---------
 drivers/block/drbd/drbd_int.h       | 11 ++++---
 drivers/block/drbd/drbd_req.c       | 10 +++---
 drivers/block/drbd/drbd_worker.c    | 44 +++++++-------------------
 drivers/block/floppy.c              |  7 +++--
 drivers/block/null_blk.c            |  2 +-
 drivers/block/pktcdvd.c             | 32 +++++++++----------
 drivers/block/ps3vram.c             |  3 +-
 drivers/block/rsxx/dev.c            |  9 ++++--
 drivers/block/umem.c                |  4 +--
 drivers/block/xen-blkback/blkback.c |  4 +--
 drivers/block/xen-blkfront.c        |  9 ++----
 drivers/block/zram/zram_drv.c       |  5 ++-
 drivers/md/bcache/btree.c           | 10 +++---
 drivers/md/bcache/closure.h         |  2 +-
 drivers/md/bcache/io.c              |  8 ++---
 drivers/md/bcache/journal.c         |  8 ++---
 drivers/md/bcache/movinggc.c        |  8 ++---
 drivers/md/bcache/request.c         | 27 ++++++++--------
 drivers/md/bcache/super.c           | 14 ++++-----
 drivers/md/bcache/writeback.c       | 10 +++---
 drivers/md/dm-bio-prison.c          |  6 ++--
 drivers/md/dm-bufio.c               | 26 ++++++++++------
 drivers/md/dm-cache-target.c        | 24 +++++++-------
 drivers/md/dm-crypt.c               | 14 ++++-----
 drivers/md/dm-flakey.c              |  2 +-
 drivers/md/dm-io.c                  |  6 ++--
 drivers/md/dm-log-writes.c          | 11 +++----
 drivers/md/dm-raid1.c               | 24 +++++++-------
 drivers/md/dm-snap.c                |  6 ++--
 drivers/md/dm-stripe.c              |  2 +-
 drivers/md/dm-thin.c                | 41 +++++++++++++-----------
 drivers/md/dm-verity.c              |  9 +++---
 drivers/md/dm-zero.c                |  2 +-
 drivers/md/dm.c                     | 15 +++++----
 drivers/md/faulty.c                 |  4 +--
 drivers/md/linear.c                 |  2 +-
 drivers/md/md.c                     | 18 +++++------
 drivers/md/multipath.c              | 12 +++----
 drivers/md/raid0.c                  |  2 +-
 drivers/md/raid1.c                  | 53 ++++++++++++++++---------------
 drivers/md/raid10.c                 | 55 +++++++++++++++-----------------
 drivers/md/raid5.c                  | 52 +++++++++++++++----------------
 drivers/nvdimm/blk.c                |  5 +--
 drivers/nvdimm/btt.c                |  5 +--
 drivers/nvdimm/pmem.c               |  2 +-
 drivers/s390/block/dcssblk.c        |  2 +-
 drivers/s390/block/xpram.c          |  3 +-
 drivers/target/target_core_iblock.c | 21 +++++--------
 drivers/target/target_core_pscsi.c  |  6 ++--
 fs/btrfs/check-integrity.c          | 10 +++---
 fs/btrfs/compression.c              | 24 ++++++++------
 fs/btrfs/disk-io.c                  | 35 +++++++++++----------
 fs/btrfs/extent_io.c                | 30 +++++++-----------
 fs/btrfs/inode.c                    | 50 ++++++++++++++++--------------
 fs/btrfs/raid56.c                   | 62 +++++++++++++++++--------------------
 fs/btrfs/scrub.c                    | 22 ++++++-------
 fs/btrfs/volumes.c                  | 23 +++++++-------
 fs/buffer.c                         |  4 +--
 fs/direct-io.c                      | 13 ++++----
 fs/ext4/page-io.c                   | 15 ++++-----
 fs/ext4/readpage.c                  |  6 ++--
 fs/f2fs/data.c                      | 10 +++---
 fs/gfs2/lops.c                      | 10 +++---
 fs/gfs2/ops_fstype.c                |  6 ++--
 fs/jfs/jfs_logmgr.c                 |  8 ++---
 fs/jfs/jfs_metapage.c               |  8 ++---
 fs/logfs/dev_bdev.c                 | 12 +++----
 fs/mpage.c                          |  4 +--
 fs/nfs/blocklayout/blocklayout.c    | 14 ++++-----
 fs/nilfs2/segbuf.c                  |  5 ++-
 fs/ocfs2/cluster/heartbeat.c        |  9 +++---
 fs/xfs/xfs_aops.c                   |  5 ++-
 fs/xfs/xfs_buf.c                    |  7 ++---
 include/linux/bio.h                 | 13 +++++---
 include/linux/blk_types.h           |  4 +--
 include/linux/swap.h                |  4 +--
 kernel/power/swap.c                 | 12 +++----
 kernel/trace/blktrace.c             | 10 ++----
 mm/page_io.c                        | 12 +++----
 95 files changed, 622 insertions(+), 682 deletions(-)

diff --git a/Documentation/block/biodoc.txt b/Documentation/block/biodoc.txt
index fd12c0d..5be8a7f 100644
--- a/Documentation/block/biodoc.txt
+++ b/Documentation/block/biodoc.txt
@@ -1109,7 +1109,7 @@ it will loop and handle as many sectors (on a bio-segment granularity)
 as specified.
 
 Now bh->b_end_io is replaced by bio->bi_end_io, but most of the time the
-right thing to use is bio_endio(bio, uptodate) instead.
+right thing to use is bio_endio(bio) instead.
 
 If the driver is dropping the io_request_lock from its request_fn strategy,
 then it just needs to replace that with q->queue_lock instead.
diff --git a/arch/m68k/emu/nfblock.c b/arch/m68k/emu/nfblock.c
index 2d75ae2..f2a00c5 100644
--- a/arch/m68k/emu/nfblock.c
+++ b/arch/m68k/emu/nfblock.c
@@ -76,7 +76,7 @@ static void nfhd_make_request(struct request_queue *queue, struct bio *bio)
 				bvec_to_phys(&bvec));
 		sec += len;
 	}
-	bio_endio(bio, 0);
+	bio_endio(bio);
 }
 
 static int nfhd_getgeo(struct block_device *bdev, struct hd_geometry *geo)
diff --git a/arch/powerpc/sysdev/axonram.c b/arch/powerpc/sysdev/axonram.c
index ee90db1..f86250c 100644
--- a/arch/powerpc/sysdev/axonram.c
+++ b/arch/powerpc/sysdev/axonram.c
@@ -132,7 +132,7 @@ axon_ram_make_request(struct request_queue *queue, struct bio *bio)
 		phys_mem += vec.bv_len;
 		transfered += vec.bv_len;
 	}
-	bio_endio(bio, 0);
+	bio_endio(bio);
 }
 
 /**
diff --git a/arch/xtensa/platforms/iss/simdisk.c b/arch/xtensa/platforms/iss/simdisk.c
index 48eebac..fa84ca9 100644
--- a/arch/xtensa/platforms/iss/simdisk.c
+++ b/arch/xtensa/platforms/iss/simdisk.c
@@ -101,8 +101,9 @@ static void simdisk_transfer(struct simdisk *dev, unsigned long sector,
 	spin_unlock(&dev->lock);
 }
 
-static int simdisk_xfer_bio(struct simdisk *dev, struct bio *bio)
+static void simdisk_make_request(struct request_queue *q, struct bio *bio)
 {
+	struct simdisk *dev = q->queuedata;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	sector_t sector = bio->bi_iter.bi_sector;
@@ -116,17 +117,10 @@ static int simdisk_xfer_bio(struct simdisk *dev, struct bio *bio)
 		sector += len;
 		__bio_kunmap_atomic(buffer);
 	}
-	return 0;
-}
 
-static void simdisk_make_request(struct request_queue *q, struct bio *bio)
-{
-	struct simdisk *dev = q->queuedata;
-	int status = simdisk_xfer_bio(dev, bio);
-	bio_endio(bio, status);
+	bio_endio(bio);
 }
 
-
 static int simdisk_open(struct block_device *bdev, fmode_t mode)
 {
 	struct simdisk *dev = bdev->bd_disk->private_data;
diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index 719b715..4aecca7 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -355,13 +355,12 @@ static void bio_integrity_verify_fn(struct work_struct *work)
 		container_of(work, struct bio_integrity_payload, bip_work);
 	struct bio *bio = bip->bip_bio;
 	struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
-	int error;
 
-	error = bio_integrity_process(bio, bi->verify_fn);
+	bio->bi_error = bio_integrity_process(bio, bi->verify_fn);
 
 	/* Restore original bio completion handler */
 	bio->bi_end_io = bip->bip_end_io;
-	bio_endio(bio, error);
+	bio_endio(bio);
 }
 
 /**
@@ -376,7 +375,7 @@ static void bio_integrity_verify_fn(struct work_struct *work)
  * in process context.	This function postpones completion
  * accordingly.
  */
-void bio_integrity_endio(struct bio *bio, int error)
+void bio_integrity_endio(struct bio *bio)
 {
 	struct bio_integrity_payload *bip = bio_integrity(bio);
 
@@ -386,9 +385,9 @@ void bio_integrity_endio(struct bio *bio, int error)
 	 * integrity metadata.  Restore original bio end_io handler
 	 * and run it.
 	 */
-	if (error) {
+	if (bio->bi_error) {
 		bio->bi_end_io = bip->bip_end_io;
-		bio_endio(bio, error);
+		bio_endio(bio);
 
 		return;
 	}
diff --git a/block/bio.c b/block/bio.c
index 2a00d34..a23f489 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -269,7 +269,6 @@ static void bio_free(struct bio *bio)
 void bio_init(struct bio *bio)
 {
 	memset(bio, 0, sizeof(*bio));
-	bio->bi_flags = 1 << BIO_UPTODATE;
 	atomic_set(&bio->__bi_remaining, 1);
 	atomic_set(&bio->__bi_cnt, 1);
 }
@@ -292,14 +291,17 @@ void bio_reset(struct bio *bio)
 	__bio_free(bio);
 
 	memset(bio, 0, BIO_RESET_BYTES);
-	bio->bi_flags = flags | (1 << BIO_UPTODATE);
+	bio->bi_flags = flags;
 	atomic_set(&bio->__bi_remaining, 1);
 }
 EXPORT_SYMBOL(bio_reset);
 
-static void bio_chain_endio(struct bio *bio, int error)
+static void bio_chain_endio(struct bio *bio)
 {
-	bio_endio(bio->bi_private, error);
+	struct bio *parent = bio->bi_private;
+
+	parent->bi_error = bio->bi_error;
+	bio_endio(parent);
 	bio_put(bio);
 }
 
@@ -896,11 +898,11 @@ struct submit_bio_ret {
 	int error;
 };
 
-static void submit_bio_wait_endio(struct bio *bio, int error)
+static void submit_bio_wait_endio(struct bio *bio)
 {
 	struct submit_bio_ret *ret = bio->bi_private;
 
-	ret->error = error;
+	ret->error = bio->bi_error;
 	complete(&ret->event);
 }
 
@@ -1445,7 +1447,7 @@ void bio_unmap_user(struct bio *bio)
 }
 EXPORT_SYMBOL(bio_unmap_user);
 
-static void bio_map_kern_endio(struct bio *bio, int err)
+static void bio_map_kern_endio(struct bio *bio)
 {
 	bio_put(bio);
 }
@@ -1501,13 +1503,13 @@ struct bio *bio_map_kern(struct request_queue *q, void *data, unsigned int len,
 }
 EXPORT_SYMBOL(bio_map_kern);
 
-static void bio_copy_kern_endio(struct bio *bio, int err)
+static void bio_copy_kern_endio(struct bio *bio)
 {
 	bio_free_pages(bio);
 	bio_put(bio);
 }
 
-static void bio_copy_kern_endio_read(struct bio *bio, int err)
+static void bio_copy_kern_endio_read(struct bio *bio)
 {
 	char *p = bio->bi_private;
 	struct bio_vec *bvec;
@@ -1518,7 +1520,7 @@ static void bio_copy_kern_endio_read(struct bio *bio, int err)
 		p += bvec->bv_len;
 	}
 
-	bio_copy_kern_endio(bio, err);
+	bio_copy_kern_endio(bio);
 }
 
 /**
@@ -1778,25 +1780,15 @@ static inline bool bio_remaining_done(struct bio *bio)
 /**
  * bio_endio - end I/O on a bio
  * @bio:	bio
- * @error:	error, if any
  *
  * Description:
- *   bio_endio() will end I/O on the whole bio. bio_endio() is the
- *   preferred way to end I/O on a bio, it takes care of clearing
- *   BIO_UPTODATE on error. @error is 0 on success, and and one of the
- *   established -Exxxx (-EIO, for instance) error values in case
- *   something went wrong. No one should call bi_end_io() directly on a
- *   bio unless they own it and thus know that it has an end_io
- *   function.
+ *   bio_endio() will end I/O on the whole bio. bio_endio() is the preferred
+ *   way to end I/O on a bio. No one should call bi_end_io() directly on a
+ *   bio unless they own it and thus know that it has an end_io function.
  **/
-void bio_endio(struct bio *bio, int error)
+void bio_endio(struct bio *bio)
 {
 	while (bio) {
-		if (error)
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
-		else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-			error = -EIO;
-
 		if (unlikely(!bio_remaining_done(bio)))
 			break;
 
@@ -1810,11 +1802,12 @@ void bio_endio(struct bio *bio, int error)
 		 */
 		if (bio->bi_end_io == bio_chain_endio) {
 			struct bio *parent = bio->bi_private;
+			parent->bi_error = bio->bi_error;
 			bio_put(bio);
 			bio = parent;
 		} else {
 			if (bio->bi_end_io)
-				bio->bi_end_io(bio, error);
+				bio->bi_end_io(bio);
 			bio = NULL;
 		}
 	}
diff --git a/block/blk-core.c b/block/blk-core.c
index 627ed0c..7ef15b9 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -143,9 +143,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 			  unsigned int nbytes, int error)
 {
 	if (error)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
-	else if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = -EIO;
+		bio->bi_error = error;
 
 	if (unlikely(rq->cmd_flags & REQ_QUIET))
 		set_bit(BIO_QUIET, &bio->bi_flags);
@@ -154,7 +152,7 @@ static void req_bio_endio(struct request *rq, struct bio *bio,
 
 	/* don't actually finish bio if it's part of flush sequence */
 	if (bio->bi_iter.bi_size == 0 && !(rq->cmd_flags & REQ_FLUSH_SEQ))
-		bio_endio(bio, error);
+		bio_endio(bio);
 }
 
 void blk_dump_rq_flags(struct request *rq, char *msg)
@@ -1620,7 +1618,8 @@ static void blk_queue_bio(struct request_queue *q, struct bio *bio)
 	blk_queue_bounce(q, &bio);
 
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
-		bio_endio(bio, -EIO);
+		bio->bi_error = -EIO;
+		bio_endio(bio);
 		return;
 	}
 
@@ -1673,7 +1672,8 @@ get_rq:
 	 */
 	req = get_request(q, rw_flags, bio, GFP_NOIO);
 	if (IS_ERR(req)) {
-		bio_endio(bio, PTR_ERR(req));	/* @q is dead */
+		bio->bi_error = PTR_ERR(req);
+		bio_endio(bio);
 		goto out_unlock;
 	}
 
@@ -1896,7 +1896,8 @@ generic_make_request_checks(struct bio *bio)
 	return true;
 
 end_io:
-	bio_endio(bio, err);
+	bio->bi_error = err;
+	bio_endio(bio);
 	return false;
 }
 
diff --git a/block/blk-lib.c b/block/blk-lib.c
index 7688ee3..6dee174 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -11,16 +11,16 @@
 
 struct bio_batch {
 	atomic_t		done;
-	unsigned long		flags;
+	int			error;
 	struct completion	*wait;
 };
 
-static void bio_batch_end_io(struct bio *bio, int err)
+static void bio_batch_end_io(struct bio *bio)
 {
 	struct bio_batch *bb = bio->bi_private;
 
-	if (err && (err != -EOPNOTSUPP))
-		clear_bit(BIO_UPTODATE, &bb->flags);
+	if (bio->bi_error && bio->bi_error != -EOPNOTSUPP)
+		bb->error = bio->bi_error;
 	if (atomic_dec_and_test(&bb->done))
 		complete(bb->wait);
 	bio_put(bio);
@@ -78,7 +78,7 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	}
 
 	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
+	bb.error = 0;
 	bb.wait = &wait;
 
 	blk_start_plug(&plug);
@@ -134,9 +134,8 @@ int blkdev_issue_discard(struct block_device *bdev, sector_t sector,
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		ret = -EIO;
-
+	if (bb.error)
+		return bb.error;
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_discard);
@@ -172,7 +171,7 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 		return -EOPNOTSUPP;
 
 	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
+	bb.error = 0;
 	bb.wait = &wait;
 
 	while (nr_sects) {
@@ -208,9 +207,8 @@ int blkdev_issue_write_same(struct block_device *bdev, sector_t sector,
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		ret = -ENOTSUPP;
-
+	if (bb.error)
+		return bb.error;
 	return ret;
 }
 EXPORT_SYMBOL(blkdev_issue_write_same);
@@ -236,7 +234,7 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	DECLARE_COMPLETION_ONSTACK(wait);
 
 	atomic_set(&bb.done, 1);
-	bb.flags = 1 << BIO_UPTODATE;
+	bb.error = 0;
 	bb.wait = &wait;
 
 	ret = 0;
@@ -270,10 +268,8 @@ static int __blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	if (!atomic_dec_and_test(&bb.done))
 		wait_for_completion_io(&wait);
 
-	if (!test_bit(BIO_UPTODATE, &bb.flags))
-		/* One of bios in the batch was completed with error.*/
-		ret = -EIO;
-
+	if (bb.error)
+		return bb.error;
 	return ret;
 }
 
diff --git a/block/blk-map.c b/block/blk-map.c
index da310a1..5fe1c30 100644
--- a/block/blk-map.c
+++ b/block/blk-map.c
@@ -103,7 +103,7 @@ int blk_rq_map_user_iov(struct request_queue *q, struct request *rq,
 		 * normal IO completion path
 		 */
 		bio_get(bio);
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		__blk_rq_unmap_user(bio);
 		return -EINVAL;
 	}
diff --git a/block/blk-mq.c b/block/blk-mq.c
index 7d842db..9455902 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -1199,7 +1199,7 @@ static struct request *blk_mq_map_request(struct request_queue *q,
 	struct blk_mq_alloc_data alloc_data;
 
 	if (unlikely(blk_mq_queue_enter(q, GFP_KERNEL))) {
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 		return NULL;
 	}
 
@@ -1283,7 +1283,7 @@ static void blk_mq_make_request(struct request_queue *q, struct bio *bio)
 	blk_queue_bounce(q, &bio);
 
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 		return;
 	}
 
@@ -1368,7 +1368,7 @@ static void blk_sq_make_request(struct request_queue *q, struct bio *bio)
 	blk_queue_bounce(q, &bio);
 
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 		return;
 	}
 
diff --git a/block/bounce.c b/block/bounce.c
index b173112..f4db245 100644
--- a/block/bounce.c
+++ b/block/bounce.c
@@ -123,7 +123,7 @@ static void copy_to_high_bio_irq(struct bio *to, struct bio *from)
 	}
 }
 
-static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
+static void bounce_end_io(struct bio *bio, mempool_t *pool)
 {
 	struct bio *bio_orig = bio->bi_private;
 	struct bio_vec *bvec, *org_vec;
@@ -141,39 +141,40 @@ static void bounce_end_io(struct bio *bio, mempool_t *pool, int err)
 		mempool_free(bvec->bv_page, pool);
 	}
 
-	bio_endio(bio_orig, err);
+	bio_orig->bi_error = bio->bi_error;
+	bio_endio(bio_orig);
 	bio_put(bio);
 }
 
-static void bounce_end_io_write(struct bio *bio, int err)
+static void bounce_end_io_write(struct bio *bio)
 {
-	bounce_end_io(bio, page_pool, err);
+	bounce_end_io(bio, page_pool);
 }
 
-static void bounce_end_io_write_isa(struct bio *bio, int err)
+static void bounce_end_io_write_isa(struct bio *bio)
 {
 
-	bounce_end_io(bio, isa_page_pool, err);
+	bounce_end_io(bio, isa_page_pool);
 }
 
-static void __bounce_end_io_read(struct bio *bio, mempool_t *pool, int err)
+static void __bounce_end_io_read(struct bio *bio, mempool_t *pool)
 {
 	struct bio *bio_orig = bio->bi_private;
 
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (!bio->bi_error)
 		copy_to_high_bio_irq(bio_orig, bio);
 
-	bounce_end_io(bio, pool, err);
+	bounce_end_io(bio, pool);
 }
 
-static void bounce_end_io_read(struct bio *bio, int err)
+static void bounce_end_io_read(struct bio *bio)
 {
-	__bounce_end_io_read(bio, page_pool, err);
+	__bounce_end_io_read(bio, page_pool);
 }
 
-static void bounce_end_io_read_isa(struct bio *bio, int err)
+static void bounce_end_io_read_isa(struct bio *bio)
 {
-	__bounce_end_io_read(bio, isa_page_pool, err);
+	__bounce_end_io_read(bio, isa_page_pool);
 }
 
 #ifdef CONFIG_NEED_BOUNCE_POOL
diff --git a/drivers/block/aoe/aoecmd.c b/drivers/block/aoe/aoecmd.c
index 422b7d8..ad80c85 100644
--- a/drivers/block/aoe/aoecmd.c
+++ b/drivers/block/aoe/aoecmd.c
@@ -1110,7 +1110,7 @@ aoe_end_request(struct aoedev *d, struct request *rq, int fastfail)
 		d->ip.rq = NULL;
 	do {
 		bio = rq->bio;
-		bok = !fastfail && test_bit(BIO_UPTODATE, &bio->bi_flags);
+		bok = !fastfail && !bio->bi_error;
 	} while (__blk_end_request(rq, bok ? 0 : -EIO, bio->bi_iter.bi_size));
 
 	/* cf. http://lkml.org/lkml/2006/10/31/28 */
@@ -1172,7 +1172,7 @@ ktiocomplete(struct frame *f)
 			ahout->cmdstat, ahin->cmdstat,
 			d->aoemajor, d->aoeminor);
 noskb:		if (buf)
-			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+			buf->bio->bi_error = -EIO;
 		goto out;
 	}
 
@@ -1185,7 +1185,7 @@ noskb:		if (buf)
 				"aoe: runt data size in read from",
 				(long) d->aoemajor, d->aoeminor,
 			       skb->len, n);
-			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+			buf->bio->bi_error = -EIO;
 			break;
 		}
 		if (n > f->iter.bi_size) {
@@ -1193,7 +1193,7 @@ noskb:		if (buf)
 				"aoe: too-large data size in read from",
 				(long) d->aoemajor, d->aoeminor,
 				n, f->iter.bi_size);
-			clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+			buf->bio->bi_error = -EIO;
 			break;
 		}
 		bvcpy(skb, f->buf->bio, f->iter, n);
@@ -1695,7 +1695,7 @@ aoe_failbuf(struct aoedev *d, struct buf *buf)
 	if (buf == NULL)
 		return;
 	buf->iter.bi_size = 0;
-	clear_bit(BIO_UPTODATE, &buf->bio->bi_flags);
+	buf->bio->bi_error = -EIO;
 	if (buf->nframesout == 0)
 		aoe_end_buf(d, buf);
 }
diff --git a/drivers/block/aoe/aoedev.c b/drivers/block/aoe/aoedev.c
index e774c50..ffd1947 100644
--- a/drivers/block/aoe/aoedev.c
+++ b/drivers/block/aoe/aoedev.c
@@ -170,7 +170,7 @@ aoe_failip(struct aoedev *d)
 	if (rq == NULL)
 		return;
 	while ((bio = d->ip.nxbio)) {
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		bio->bi_error = -EIO;
 		d->ip.nxbio = bio->bi_next;
 		n = (unsigned long) rq->special;
 		rq->special = (void *) --n;
diff --git a/drivers/block/brd.c b/drivers/block/brd.c
index e573e470b..f9ab745 100644
--- a/drivers/block/brd.c
+++ b/drivers/block/brd.c
@@ -331,14 +331,12 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 	struct bio_vec bvec;
 	sector_t sector;
 	struct bvec_iter iter;
-	int err = -EIO;
 
 	sector = bio->bi_iter.bi_sector;
 	if (bio_end_sector(bio) > get_capacity(bdev->bd_disk))
-		goto out;
+		goto io_error;
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
-		err = 0;
 		discard_from_brd(brd, sector, bio->bi_iter.bi_size);
 		goto out;
 	}
@@ -349,15 +347,20 @@ static void brd_make_request(struct request_queue *q, struct bio *bio)
 
 	bio_for_each_segment(bvec, bio, iter) {
 		unsigned int len = bvec.bv_len;
+		int err;
+
 		err = brd_do_bvec(brd, bvec.bv_page, len,
 					bvec.bv_offset, rw, sector);
 		if (err)
-			break;
+			goto io_error;
 		sector += len >> SECTOR_SHIFT;
 	}
 
 out:
-	bio_endio(bio, err);
+	bio_endio(bio);
+	return;
+io_error:
+	bio_io_error(bio);
 }
 
 static int brd_rw_page(struct block_device *bdev, sector_t sector,
diff --git a/drivers/block/drbd/drbd_actlog.c b/drivers/block/drbd/drbd_actlog.c
index 1318e32..b3868e7 100644
--- a/drivers/block/drbd/drbd_actlog.c
+++ b/drivers/block/drbd/drbd_actlog.c
@@ -175,11 +175,11 @@ static int _drbd_md_sync_page_io(struct drbd_device *device,
 	atomic_inc(&device->md_io.in_use); /* drbd_md_put_buffer() is in the completion handler */
 	device->md_io.submit_jif = jiffies;
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD))
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 	else
 		submit_bio(rw, bio);
 	wait_until_done_or_force_detached(device, bdev, &device->md_io.done);
-	if (bio_flagged(bio, BIO_UPTODATE))
+	if (!bio->bi_error)
 		err = device->md_io.error;
 
  out:
diff --git a/drivers/block/drbd/drbd_bitmap.c b/drivers/block/drbd/drbd_bitmap.c
index 434c77d..e5e0f19 100644
--- a/drivers/block/drbd/drbd_bitmap.c
+++ b/drivers/block/drbd/drbd_bitmap.c
@@ -941,36 +941,27 @@ static void drbd_bm_aio_ctx_destroy(struct kref *kref)
 }
 
 /* bv_page may be a copy, or may be the original */
-static void drbd_bm_endio(struct bio *bio, int error)
+static void drbd_bm_endio(struct bio *bio)
 {
 	struct drbd_bm_aio_ctx *ctx = bio->bi_private;
 	struct drbd_device *device = ctx->device;
 	struct drbd_bitmap *b = device->bitmap;
 	unsigned int idx = bm_page_to_idx(bio->bi_io_vec[0].bv_page);
-	int uptodate = bio_flagged(bio, BIO_UPTODATE);
-
-
-	/* strange behavior of some lower level drivers...
-	 * fail the request by clearing the uptodate flag,
-	 * but do not return any error?!
-	 * do we want to WARN() on this? */
-	if (!error && !uptodate)
-		error = -EIO;
 
 	if ((ctx->flags & BM_AIO_COPY_PAGES) == 0 &&
 	    !bm_test_page_unchanged(b->bm_pages[idx]))
 		drbd_warn(device, "bitmap page idx %u changed during IO!\n", idx);
 
-	if (error) {
+	if (bio->bi_error) {
 		/* ctx error will hold the completed-last non-zero error code,
 		 * in case error codes differ. */
-		ctx->error = error;
+		ctx->error = bio->bi_error;
 		bm_set_page_io_err(b->bm_pages[idx]);
 		/* Not identical to on disk version of it.
 		 * Is BM_PAGE_IO_ERROR enough? */
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_err(device, "IO ERROR %d on bitmap page idx %u\n",
-					error, idx);
+					bio->bi_error, idx);
 	} else {
 		bm_clear_page_io_err(b->bm_pages[idx]);
 		dynamic_drbd_dbg(device, "bitmap page idx %u completed\n", idx);
@@ -1031,7 +1022,7 @@ static void bm_page_io_async(struct drbd_bm_aio_ctx *ctx, int page_nr) __must_ho
 
 	if (drbd_insert_fault(device, (rw & WRITE) ? DRBD_FAULT_MD_WR : DRBD_FAULT_MD_RD)) {
 		bio->bi_rw |= rw;
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 	} else {
 		submit_bio(rw, bio);
 		/* this should not count as user activity and cause the
diff --git a/drivers/block/drbd/drbd_int.h b/drivers/block/drbd/drbd_int.h
index efd19c2..a08c4a9 100644
--- a/drivers/block/drbd/drbd_int.h
+++ b/drivers/block/drbd/drbd_int.h
@@ -1481,9 +1481,9 @@ extern int drbd_khelper(struct drbd_device *device, char *cmd);
 
 /* drbd_worker.c */
 /* bi_end_io handlers */
-extern void drbd_md_endio(struct bio *bio, int error);
-extern void drbd_peer_request_endio(struct bio *bio, int error);
-extern void drbd_request_endio(struct bio *bio, int error);
+extern void drbd_md_endio(struct bio *bio);
+extern void drbd_peer_request_endio(struct bio *bio);
+extern void drbd_request_endio(struct bio *bio);
 extern int drbd_worker(struct drbd_thread *thi);
 enum drbd_ret_code drbd_resync_after_valid(struct drbd_device *device, int o_minor);
 void drbd_resync_after_changed(struct drbd_device *device);
@@ -1604,12 +1604,13 @@ static inline void drbd_generic_make_request(struct drbd_device *device,
 	__release(local);
 	if (!bio->bi_bdev) {
 		drbd_err(device, "drbd_generic_make_request: bio->bi_bdev == NULL\n");
-		bio_endio(bio, -ENODEV);
+		bio->bi_error = -ENODEV;
+		bio_endio(bio);
 		return;
 	}
 
 	if (drbd_insert_fault(device, fault_type))
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 	else
 		generic_make_request(bio);
 }
diff --git a/drivers/block/drbd/drbd_req.c b/drivers/block/drbd/drbd_req.c
index 3907202..9cb4116 100644
--- a/drivers/block/drbd/drbd_req.c
+++ b/drivers/block/drbd/drbd_req.c
@@ -201,7 +201,8 @@ void start_new_tl_epoch(struct drbd_connection *connection)
 void complete_master_bio(struct drbd_device *device,
 		struct bio_and_error *m)
 {
-	bio_endio(m->bio, m->error);
+	m->bio->bi_error = m->error;
+	bio_endio(m->bio);
 	dec_ap_bio(device);
 }
 
@@ -1153,12 +1154,12 @@ drbd_submit_req_private_bio(struct drbd_request *req)
 				      rw == WRITE ? DRBD_FAULT_DT_WR
 				    : rw == READ  ? DRBD_FAULT_DT_RD
 				    :               DRBD_FAULT_DT_RA))
-			bio_endio(bio, -EIO);
+			bio_io_error(bio);
 		else
 			generic_make_request(bio);
 		put_ldev(device);
 	} else
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 }
 
 static void drbd_queue_write(struct drbd_device *device, struct drbd_request *req)
@@ -1191,7 +1192,8 @@ drbd_request_prepare(struct drbd_device *device, struct bio *bio, unsigned long
 		/* only pass the error to the upper layers.
 		 * if user cannot handle io errors, that's not our business. */
 		drbd_err(device, "could not kmalloc() req\n");
-		bio_endio(bio, -ENOMEM);
+		bio->bi_error = -ENOMEM;
+		bio_endio(bio);
 		return ERR_PTR(-ENOMEM);
 	}
 	req->start_jif = start_jif;
diff --git a/drivers/block/drbd/drbd_worker.c b/drivers/block/drbd/drbd_worker.c
index d0fae55..5578c14 100644
--- a/drivers/block/drbd/drbd_worker.c
+++ b/drivers/block/drbd/drbd_worker.c
@@ -65,12 +65,12 @@ rwlock_t global_state_lock;
 /* used for synchronous meta data and bitmap IO
  * submitted by drbd_md_sync_page_io()
  */
-void drbd_md_endio(struct bio *bio, int error)
+void drbd_md_endio(struct bio *bio)
 {
 	struct drbd_device *device;
 
 	device = bio->bi_private;
-	device->md_io.error = error;
+	device->md_io.error = bio->bi_error;
 
 	/* We grabbed an extra reference in _drbd_md_sync_page_io() to be able
 	 * to timeout on the lower level device, and eventually detach from it.
@@ -170,31 +170,20 @@ void drbd_endio_write_sec_final(struct drbd_peer_request *peer_req) __releases(l
 /* writes on behalf of the partner, or resync writes,
  * "submitted" by the receiver.
  */
-void drbd_peer_request_endio(struct bio *bio, int error)
+void drbd_peer_request_endio(struct bio *bio)
 {
 	struct drbd_peer_request *peer_req = bio->bi_private;
 	struct drbd_device *device = peer_req->peer_device->device;
-	int uptodate = bio_flagged(bio, BIO_UPTODATE);
 	int is_write = bio_data_dir(bio) == WRITE;
 	int is_discard = !!(bio->bi_rw & REQ_DISCARD);
 
-	if (error && __ratelimit(&drbd_ratelimit_state))
+	if (bio->bi_error && __ratelimit(&drbd_ratelimit_state))
 		drbd_warn(device, "%s: error=%d s=%llus\n",
 				is_write ? (is_discard ? "discard" : "write")
-					: "read", error,
+					: "read", bio->bi_error,
 				(unsigned long long)peer_req->i.sector);
-	if (!error && !uptodate) {
-		if (__ratelimit(&drbd_ratelimit_state))
-			drbd_warn(device, "%s: setting error to -EIO s=%llus\n",
-					is_write ? "write" : "read",
-					(unsigned long long)peer_req->i.sector);
-		/* strange behavior of some lower level drivers...
-		 * fail the request by clearing the uptodate flag,
-		 * but do not return any error?! */
-		error = -EIO;
-	}
 
-	if (error)
+	if (bio->bi_error)
 		set_bit(__EE_WAS_ERROR, &peer_req->flags);
 
 	bio_put(bio); /* no need for the bio anymore */
@@ -208,24 +197,13 @@ void drbd_peer_request_endio(struct bio *bio, int error)
 
 /* read, readA or write requests on R_PRIMARY coming from drbd_make_request
  */
-void drbd_request_endio(struct bio *bio, int error)
+void drbd_request_endio(struct bio *bio)
 {
 	unsigned long flags;
 	struct drbd_request *req = bio->bi_private;
 	struct drbd_device *device = req->device;
 	struct bio_and_error m;
 	enum drbd_req_event what;
-	int uptodate = bio_flagged(bio, BIO_UPTODATE);
-
-	if (!error && !uptodate) {
-		drbd_warn(device, "p %s: setting error to -EIO\n",
-			 bio_data_dir(bio) == WRITE ? "write" : "read");
-		/* strange behavior of some lower level drivers...
-		 * fail the request by clearing the uptodate flag,
-		 * but do not return any error?! */
-		error = -EIO;
-	}
-
 
 	/* If this request was aborted locally before,
 	 * but now was completed "successfully",
@@ -259,14 +237,14 @@ void drbd_request_endio(struct bio *bio, int error)
 		if (__ratelimit(&drbd_ratelimit_state))
 			drbd_emerg(device, "delayed completion of aborted local request; disk-timeout may be too aggressive\n");
 
-		if (!error)
+		if (!bio->bi_error)
 			panic("possible random memory corruption caused by delayed completion of aborted local request\n");
 	}
 
 	/* to avoid recursion in __req_mod */
-	if (unlikely(error)) {
+	if (unlikely(bio->bi_error)) {
 		if (bio->bi_rw & REQ_DISCARD)
-			what = (error == -EOPNOTSUPP)
+			what = (bio->bi_error == -EOPNOTSUPP)
 				? DISCARD_COMPLETED_NOTSUPP
 				: DISCARD_COMPLETED_WITH_ERROR;
 		else
@@ -279,7 +257,7 @@ void drbd_request_endio(struct bio *bio, int error)
 		what = COMPLETED_OK;
 
 	bio_put(req->private_bio);
-	req->private_bio = ERR_PTR(error);
+	req->private_bio = ERR_PTR(bio->bi_error);
 
 	/* not req_mod(), we need irqsave here! */
 	spin_lock_irqsave(&device->resource->req_lock, flags);
diff --git a/drivers/block/floppy.c b/drivers/block/floppy.c
index a08cda9..331363e 100644
--- a/drivers/block/floppy.c
+++ b/drivers/block/floppy.c
@@ -3771,13 +3771,14 @@ struct rb0_cbdata {
 	struct completion complete;
 };
 
-static void floppy_rb0_cb(struct bio *bio, int err)
+static void floppy_rb0_cb(struct bio *bio)
 {
 	struct rb0_cbdata *cbdata = (struct rb0_cbdata *)bio->bi_private;
 	int drive = cbdata->drive;
 
-	if (err) {
-		pr_info("floppy: error %d while reading block 0\n", err);
+	if (bio->bi_error) {
+		pr_info("floppy: error %d while reading block 0\n",
+			bio->bi_error);
 		set_bit(FD_OPEN_SHOULD_FAIL_BIT, &UDRS->flags);
 	}
 	complete(&cbdata->complete);
diff --git a/drivers/block/null_blk.c b/drivers/block/null_blk.c
index 69de41a..016a59a 100644
--- a/drivers/block/null_blk.c
+++ b/drivers/block/null_blk.c
@@ -222,7 +222,7 @@ static void end_cmd(struct nullb_cmd *cmd)
 		blk_end_request_all(cmd->rq, 0);
 		break;
 	case NULL_Q_BIO:
-		bio_endio(cmd->bio, 0);
+		bio_endio(cmd->bio);
 		break;
 	}
 
diff --git a/drivers/block/pktcdvd.c b/drivers/block/pktcdvd.c
index 4c20c22..a7a259e 100644
--- a/drivers/block/pktcdvd.c
+++ b/drivers/block/pktcdvd.c
@@ -977,7 +977,7 @@ static void pkt_make_local_copy(struct packet_data *pkt, struct bio_vec *bvec)
 	}
 }
 
-static void pkt_end_io_read(struct bio *bio, int err)
+static void pkt_end_io_read(struct bio *bio)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
@@ -985,9 +985,9 @@ static void pkt_end_io_read(struct bio *bio, int err)
 
 	pkt_dbg(2, pd, "bio=%p sec0=%llx sec=%llx err=%d\n",
 		bio, (unsigned long long)pkt->sector,
-		(unsigned long long)bio->bi_iter.bi_sector, err);
+		(unsigned long long)bio->bi_iter.bi_sector, bio->bi_error);
 
-	if (err)
+	if (bio->bi_error)
 		atomic_inc(&pkt->io_errors);
 	if (atomic_dec_and_test(&pkt->io_wait)) {
 		atomic_inc(&pkt->run_sm);
@@ -996,13 +996,13 @@ static void pkt_end_io_read(struct bio *bio, int err)
 	pkt_bio_finished(pd);
 }
 
-static void pkt_end_io_packet_write(struct bio *bio, int err)
+static void pkt_end_io_packet_write(struct bio *bio)
 {
 	struct packet_data *pkt = bio->bi_private;
 	struct pktcdvd_device *pd = pkt->pd;
 	BUG_ON(!pd);
 
-	pkt_dbg(2, pd, "id=%d, err=%d\n", pkt->id, err);
+	pkt_dbg(2, pd, "id=%d, err=%d\n", pkt->id, bio->bi_error);
 
 	pd->stats.pkt_ended++;
 
@@ -1340,22 +1340,22 @@ static void pkt_start_write(struct pktcdvd_device *pd, struct packet_data *pkt)
 	pkt_queue_bio(pd, pkt->w_bio);
 }
 
-static void pkt_finish_packet(struct packet_data *pkt, int uptodate)
+static void pkt_finish_packet(struct packet_data *pkt, int error)
 {
 	struct bio *bio;
 
-	if (!uptodate)
+	if (error)
 		pkt->cache_valid = 0;
 
 	/* Finish all bios corresponding to this packet */
-	while ((bio = bio_list_pop(&pkt->orig_bios)))
-		bio_endio(bio, uptodate ? 0 : -EIO);
+	while ((bio = bio_list_pop(&pkt->orig_bios))) {
+		bio->bi_error = error;
+		bio_endio(bio);
+	}
 }
 
 static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data *pkt)
 {
-	int uptodate;
-
 	pkt_dbg(2, pd, "pkt %d\n", pkt->id);
 
 	for (;;) {
@@ -1384,7 +1384,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 			if (atomic_read(&pkt->io_wait) > 0)
 				return;
 
-			if (test_bit(BIO_UPTODATE, &pkt->w_bio->bi_flags)) {
+			if (!pkt->w_bio->bi_error) {
 				pkt_set_state(pkt, PACKET_FINISHED_STATE);
 			} else {
 				pkt_set_state(pkt, PACKET_RECOVERY_STATE);
@@ -1401,8 +1401,7 @@ static void pkt_run_state_machine(struct pktcdvd_device *pd, struct packet_data
 			break;
 
 		case PACKET_FINISHED_STATE:
-			uptodate = test_bit(BIO_UPTODATE, &pkt->w_bio->bi_flags);
-			pkt_finish_packet(pkt, uptodate);
+			pkt_finish_packet(pkt, pkt->w_bio->bi_error);
 			return;
 
 		default:
@@ -2332,13 +2331,14 @@ static void pkt_close(struct gendisk *disk, fmode_t mode)
 }
 
 
-static void pkt_end_io_read_cloned(struct bio *bio, int err)
+static void pkt_end_io_read_cloned(struct bio *bio)
 {
 	struct packet_stacked_data *psd = bio->bi_private;
 	struct pktcdvd_device *pd = psd->pd;
 
+	psd->bio->bi_error = bio->bi_error;
 	bio_put(bio);
-	bio_endio(psd->bio, err);
+	bio_endio(psd->bio);
 	mempool_free(psd, psd_pool);
 	pkt_bio_finished(pd);
 }
diff --git a/drivers/block/ps3vram.c b/drivers/block/ps3vram.c
index b1612eb..49b4706 100644
--- a/drivers/block/ps3vram.c
+++ b/drivers/block/ps3vram.c
@@ -593,7 +593,8 @@ out:
 	next = bio_list_peek(&priv->list);
 	spin_unlock_irq(&priv->lock);
 
-	bio_endio(bio, error);
+	bio->bi_error = error;
+	bio_endio(bio);
 	return next;
 }
 
diff --git a/drivers/block/rsxx/dev.c b/drivers/block/rsxx/dev.c
index ac8c62c..63b9d2f 100644
--- a/drivers/block/rsxx/dev.c
+++ b/drivers/block/rsxx/dev.c
@@ -137,7 +137,10 @@ static void bio_dma_done_cb(struct rsxx_cardinfo *card,
 		if (!card->eeh_state && card->gendisk)
 			disk_stats_complete(card, meta->bio, meta->start_time);
 
-		bio_endio(meta->bio, atomic_read(&meta->error) ? -EIO : 0);
+		if (atomic_read(&meta->error))
+			bio_io_error(meta->bio);
+		else
+			bio_endio(meta->bio);
 		kmem_cache_free(bio_meta_pool, meta);
 	}
 }
@@ -199,7 +202,9 @@ static void rsxx_make_request(struct request_queue *q, struct bio *bio)
 queue_err:
 	kmem_cache_free(bio_meta_pool, bio_meta);
 req_err:
-	bio_endio(bio, st);
+	if (st)
+		bio->bi_error = st;
+	bio_endio(bio);
 }
 
 /*----------------- Device Setup -------------------*/
diff --git a/drivers/block/umem.c b/drivers/block/umem.c
index 4cf81b5..3b3afd2 100644
--- a/drivers/block/umem.c
+++ b/drivers/block/umem.c
@@ -456,7 +456,7 @@ static void process_page(unsigned long data)
 				PCI_DMA_TODEVICE : PCI_DMA_FROMDEVICE);
 		if (control & DMASCR_HARD_ERROR) {
 			/* error */
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_error = -EIO;
 			dev_printk(KERN_WARNING, &card->dev->dev,
 				"I/O error on sector %d/%d\n",
 				le32_to_cpu(desc->local_addr)>>9,
@@ -505,7 +505,7 @@ static void process_page(unsigned long data)
 
 		return_bio = bio->bi_next;
 		bio->bi_next = NULL;
-		bio_endio(bio, 0);
+		bio_endio(bio);
 	}
 }
 
diff --git a/drivers/block/xen-blkback/blkback.c b/drivers/block/xen-blkback/blkback.c
index ced9677..662648e 100644
--- a/drivers/block/xen-blkback/blkback.c
+++ b/drivers/block/xen-blkback/blkback.c
@@ -1078,9 +1078,9 @@ static void __end_block_io_op(struct pending_req *pending_req, int error)
 /*
  * bio callback.
  */
-static void end_block_io_op(struct bio *bio, int error)
+static void end_block_io_op(struct bio *bio)
 {
-	__end_block_io_op(bio->bi_private, error);
+	__end_block_io_op(bio->bi_private, bio->bi_error);
 	bio_put(bio);
 }
 
diff --git a/drivers/block/xen-blkfront.c b/drivers/block/xen-blkfront.c
index 6d89ed3..d542db7 100644
--- a/drivers/block/xen-blkfront.c
+++ b/drivers/block/xen-blkfront.c
@@ -82,7 +82,6 @@ struct blk_shadow {
 struct split_bio {
 	struct bio *bio;
 	atomic_t pending;
-	int err;
 };
 
 static DEFINE_MUTEX(blkfront_mutex);
@@ -1478,16 +1477,14 @@ static int blkfront_probe(struct xenbus_device *dev,
 	return 0;
 }
 
-static void split_bio_end(struct bio *bio, int error)
+static void split_bio_end(struct bio *bio)
 {
 	struct split_bio *split_bio = bio->bi_private;
 
-	if (error)
-		split_bio->err = error;
-
 	if (atomic_dec_and_test(&split_bio->pending)) {
 		split_bio->bio->bi_phys_segments = 0;
-		bio_endio(split_bio->bio, split_bio->err);
+		split_bio->bio->bi_error = bio->bi_error;
+		bio_endio(split_bio->bio);
 		kfree(split_bio);
 	}
 	bio_put(bio);
diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index f439ad2..68c3d48 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -850,7 +850,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 
 	if (unlikely(bio->bi_rw & REQ_DISCARD)) {
 		zram_bio_discard(zram, index, offset, bio);
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return;
 	}
 
@@ -883,8 +883,7 @@ static void __zram_make_request(struct zram *zram, struct bio *bio)
 		update_position(&index, &offset, &bvec);
 	}
 
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
-	bio_endio(bio, 0);
+	bio_endio(bio);
 	return;
 
 out:
diff --git a/drivers/md/bcache/btree.c b/drivers/md/bcache/btree.c
index 00cde40..83392f8 100644
--- a/drivers/md/bcache/btree.c
+++ b/drivers/md/bcache/btree.c
@@ -278,7 +278,7 @@ err:
 	goto out;
 }
 
-static void btree_node_read_endio(struct bio *bio, int error)
+static void btree_node_read_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
@@ -305,7 +305,7 @@ static void bch_btree_node_read(struct btree *b)
 	bch_submit_bbio(bio, b->c, &b->key, 0);
 	closure_sync(&cl);
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (bio->bi_error)
 		set_btree_node_io_error(b);
 
 	bch_bbio_free(bio, b->c);
@@ -371,15 +371,15 @@ static void btree_node_write_done(struct closure *cl)
 	__btree_node_write_done(cl);
 }
 
-static void btree_node_write_endio(struct bio *bio, int error)
+static void btree_node_write_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 	struct btree *b = container_of(cl, struct btree, io);
 
-	if (error)
+	if (bio->bi_error)
 		set_btree_node_io_error(b);
 
-	bch_bbio_count_io_errors(b->c, bio, error, "writing btree");
+	bch_bbio_count_io_errors(b->c, bio, bio->bi_error, "writing btree");
 	closure_put(cl);
 }
 
diff --git a/drivers/md/bcache/closure.h b/drivers/md/bcache/closure.h
index 79a6d63..782cc2c 100644
--- a/drivers/md/bcache/closure.h
+++ b/drivers/md/bcache/closure.h
@@ -38,7 +38,7 @@
  * they are running owned by the thread that is running them. Otherwise, suppose
  * you submit some bios and wish to have a function run when they all complete:
  *
- * foo_endio(struct bio *bio, int error)
+ * foo_endio(struct bio *bio)
  * {
  *	closure_put(cl);
  * }
diff --git a/drivers/md/bcache/io.c b/drivers/md/bcache/io.c
index bf6a9ca..9440df9 100644
--- a/drivers/md/bcache/io.c
+++ b/drivers/md/bcache/io.c
@@ -55,19 +55,19 @@ static void bch_bio_submit_split_done(struct closure *cl)
 
 	s->bio->bi_end_io = s->bi_end_io;
 	s->bio->bi_private = s->bi_private;
-	bio_endio(s->bio, 0);
+	bio_endio(s->bio);
 
 	closure_debug_destroy(&s->cl);
 	mempool_free(s, s->p->bio_split_hook);
 }
 
-static void bch_bio_submit_split_endio(struct bio *bio, int error)
+static void bch_bio_submit_split_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 	struct bio_split_hook *s = container_of(cl, struct bio_split_hook, cl);
 
-	if (error)
-		clear_bit(BIO_UPTODATE, &s->bio->bi_flags);
+	if (bio->bi_error)
+		s->bio->bi_error = bio->bi_error;
 
 	bio_put(bio);
 	closure_put(cl);
diff --git a/drivers/md/bcache/journal.c b/drivers/md/bcache/journal.c
index 418607a..d6a4e16 100644
--- a/drivers/md/bcache/journal.c
+++ b/drivers/md/bcache/journal.c
@@ -24,7 +24,7 @@
  * bit.
  */
 
-static void journal_read_endio(struct bio *bio, int error)
+static void journal_read_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 	closure_put(cl);
@@ -401,7 +401,7 @@ retry:
 
 #define last_seq(j)	((j)->seq - fifo_used(&(j)->pin) + 1)
 
-static void journal_discard_endio(struct bio *bio, int error)
+static void journal_discard_endio(struct bio *bio)
 {
 	struct journal_device *ja =
 		container_of(bio, struct journal_device, discard_bio);
@@ -547,11 +547,11 @@ void bch_journal_next(struct journal *j)
 		pr_debug("journal_pin full (%zu)", fifo_used(&j->pin));
 }
 
-static void journal_write_endio(struct bio *bio, int error)
+static void journal_write_endio(struct bio *bio)
 {
 	struct journal_write *w = bio->bi_private;
 
-	cache_set_err_on(error, w->c, "journal io error");
+	cache_set_err_on(bio->bi_error, w->c, "journal io error");
 	closure_put(&w->c->journal.io);
 }
 
diff --git a/drivers/md/bcache/movinggc.c b/drivers/md/bcache/movinggc.c
index cd74903..b929fc9 100644
--- a/drivers/md/bcache/movinggc.c
+++ b/drivers/md/bcache/movinggc.c
@@ -60,20 +60,20 @@ static void write_moving_finish(struct closure *cl)
 	closure_return_with_destructor(cl, moving_io_destructor);
 }
 
-static void read_moving_endio(struct bio *bio, int error)
+static void read_moving_endio(struct bio *bio)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct moving_io *io = container_of(bio->bi_private,
 					    struct moving_io, cl);
 
-	if (error)
-		io->op.error = error;
+	if (bio->bi_error)
+		io->op.error = bio->bi_error;
 	else if (!KEY_DIRTY(&b->key) &&
 		 ptr_stale(io->op.c, &b->key, 0)) {
 		io->op.error = -EINTR;
 	}
 
-	bch_bbio_endio(io->op.c, bio, error, "reading data to move");
+	bch_bbio_endio(io->op.c, bio, bio->bi_error, "reading data to move");
 }
 
 static void moving_init(struct moving_io *io)
diff --git a/drivers/md/bcache/request.c b/drivers/md/bcache/request.c
index f292790..a09b946 100644
--- a/drivers/md/bcache/request.c
+++ b/drivers/md/bcache/request.c
@@ -173,22 +173,22 @@ static void bch_data_insert_error(struct closure *cl)
 	bch_data_insert_keys(cl);
 }
 
-static void bch_data_insert_endio(struct bio *bio, int error)
+static void bch_data_insert_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 	struct data_insert_op *op = container_of(cl, struct data_insert_op, cl);
 
-	if (error) {
+	if (bio->bi_error) {
 		/* TODO: We could try to recover from this. */
 		if (op->writeback)
-			op->error = error;
+			op->error = bio->bi_error;
 		else if (!op->replace)
 			set_closure_fn(cl, bch_data_insert_error, op->wq);
 		else
 			set_closure_fn(cl, NULL, NULL);
 	}
 
-	bch_bbio_endio(op->c, bio, error, "writing data to cache");
+	bch_bbio_endio(op->c, bio, bio->bi_error, "writing data to cache");
 }
 
 static void bch_data_insert_start(struct closure *cl)
@@ -477,7 +477,7 @@ struct search {
 	struct data_insert_op	iop;
 };
 
-static void bch_cache_read_endio(struct bio *bio, int error)
+static void bch_cache_read_endio(struct bio *bio)
 {
 	struct bbio *b = container_of(bio, struct bbio, bio);
 	struct closure *cl = bio->bi_private;
@@ -490,15 +490,15 @@ static void bch_cache_read_endio(struct bio *bio, int error)
 	 * from the backing device.
 	 */
 
-	if (error)
-		s->iop.error = error;
+	if (bio->bi_error)
+		s->iop.error = bio->bi_error;
 	else if (!KEY_DIRTY(&b->key) &&
 		 ptr_stale(s->iop.c, &b->key, 0)) {
 		atomic_long_inc(&s->iop.c->cache_read_races);
 		s->iop.error = -EINTR;
 	}
 
-	bch_bbio_endio(s->iop.c, bio, error, "reading from cache");
+	bch_bbio_endio(s->iop.c, bio, bio->bi_error, "reading from cache");
 }
 
 /*
@@ -591,13 +591,13 @@ static void cache_lookup(struct closure *cl)
 
 /* Common code for the make_request functions */
 
-static void request_endio(struct bio *bio, int error)
+static void request_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 
-	if (error) {
+	if (bio->bi_error) {
 		struct search *s = container_of(cl, struct search, cl);
-		s->iop.error = error;
+		s->iop.error = bio->bi_error;
 		/* Only cache read errors are recoverable */
 		s->recoverable = false;
 	}
@@ -613,7 +613,8 @@ static void bio_complete(struct search *s)
 				    &s->d->disk->part0, s->start_time);
 
 		trace_bcache_request_end(s->d, s->orig_bio);
-		bio_endio(s->orig_bio, s->iop.error);
+		s->orig_bio->bi_error = s->iop.error;
+		bio_endio(s->orig_bio);
 		s->orig_bio = NULL;
 	}
 }
@@ -992,7 +993,7 @@ static void cached_dev_make_request(struct request_queue *q, struct bio *bio)
 	} else {
 		if ((bio->bi_rw & REQ_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(dc->bdev)))
-			bio_endio(bio, 0);
+			bio_endio(bio);
 		else
 			bch_generic_make_request(bio, &d->bio_split_hook);
 	}
diff --git a/drivers/md/bcache/super.c b/drivers/md/bcache/super.c
index fc8e545..be01fd3 100644
--- a/drivers/md/bcache/super.c
+++ b/drivers/md/bcache/super.c
@@ -221,7 +221,7 @@ err:
 	return err;
 }
 
-static void write_bdev_super_endio(struct bio *bio, int error)
+static void write_bdev_super_endio(struct bio *bio)
 {
 	struct cached_dev *dc = bio->bi_private;
 	/* XXX: error checking */
@@ -290,11 +290,11 @@ void bch_write_bdev_super(struct cached_dev *dc, struct closure *parent)
 	closure_return_with_destructor(cl, bch_write_bdev_super_unlock);
 }
 
-static void write_super_endio(struct bio *bio, int error)
+static void write_super_endio(struct bio *bio)
 {
 	struct cache *ca = bio->bi_private;
 
-	bch_count_io_errors(ca, error, "writing superblock");
+	bch_count_io_errors(ca, bio->bi_error, "writing superblock");
 	closure_put(&ca->set->sb_write);
 }
 
@@ -339,12 +339,12 @@ void bcache_write_super(struct cache_set *c)
 
 /* UUID io */
 
-static void uuid_endio(struct bio *bio, int error)
+static void uuid_endio(struct bio *bio)
 {
 	struct closure *cl = bio->bi_private;
 	struct cache_set *c = container_of(cl, struct cache_set, uuid_write);
 
-	cache_set_err_on(error, c, "accessing uuids");
+	cache_set_err_on(bio->bi_error, c, "accessing uuids");
 	bch_bbio_free(bio, c);
 	closure_put(cl);
 }
@@ -512,11 +512,11 @@ static struct uuid_entry *uuid_find_empty(struct cache_set *c)
  * disk.
  */
 
-static void prio_endio(struct bio *bio, int error)
+static void prio_endio(struct bio *bio)
 {
 	struct cache *ca = bio->bi_private;
 
-	cache_set_err_on(error, ca->set, "accessing priorities");
+	cache_set_err_on(bio->bi_error, ca->set, "accessing priorities");
 	bch_bbio_free(bio, ca->set);
 	closure_put(&ca->prio);
 }
diff --git a/drivers/md/bcache/writeback.c b/drivers/md/bcache/writeback.c
index f1986bc..b4fc874 100644
--- a/drivers/md/bcache/writeback.c
+++ b/drivers/md/bcache/writeback.c
@@ -166,12 +166,12 @@ static void write_dirty_finish(struct closure *cl)
 	closure_return_with_destructor(cl, dirty_io_destructor);
 }
 
-static void dirty_endio(struct bio *bio, int error)
+static void dirty_endio(struct bio *bio)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
 
-	if (error)
+	if (bio->bi_error)
 		SET_KEY_DIRTY(&w->key, false);
 
 	closure_put(&io->cl);
@@ -193,15 +193,15 @@ static void write_dirty(struct closure *cl)
 	continue_at(cl, write_dirty_finish, system_wq);
 }
 
-static void read_dirty_endio(struct bio *bio, int error)
+static void read_dirty_endio(struct bio *bio)
 {
 	struct keybuf_key *w = bio->bi_private;
 	struct dirty_io *io = w->private;
 
 	bch_count_io_errors(PTR_CACHE(io->dc->disk.c, &w->key, 0),
-			    error, "reading dirty data from cache");
+			    bio->bi_error, "reading dirty data from cache");
 
-	dirty_endio(bio, error);
+	dirty_endio(bio);
 }
 
 static void read_dirty_submit(struct closure *cl)
diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
index cd6d1d2..03af174 100644
--- a/drivers/md/dm-bio-prison.c
+++ b/drivers/md/dm-bio-prison.c
@@ -236,8 +236,10 @@ void dm_cell_error(struct dm_bio_prison *prison,
 	bio_list_init(&bios);
 	dm_cell_release(prison, cell, &bios);
 
-	while ((bio = bio_list_pop(&bios)))
-		bio_endio(bio, error);
+	while ((bio = bio_list_pop(&bios))) {
+		bio->bi_error = error;
+		bio_endio(bio);
+	}
 }
 EXPORT_SYMBOL_GPL(dm_cell_error);
 
diff --git a/drivers/md/dm-bufio.c b/drivers/md/dm-bufio.c
index 86dbbc7..83cc52e 100644
--- a/drivers/md/dm-bufio.c
+++ b/drivers/md/dm-bufio.c
@@ -545,7 +545,8 @@ static void dmio_complete(unsigned long error, void *context)
 {
 	struct dm_buffer *b = context;
 
-	b->bio.bi_end_io(&b->bio, error ? -EIO : 0);
+	b->bio.bi_error = error ? -EIO : 0;
+	b->bio.bi_end_io(&b->bio);
 }
 
 static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
@@ -575,13 +576,16 @@ static void use_dmio(struct dm_buffer *b, int rw, sector_t block,
 	b->bio.bi_end_io = end_io;
 
 	r = dm_io(&io_req, 1, &region, NULL);
-	if (r)
-		end_io(&b->bio, r);
+	if (r) {
+		b->bio.bi_error = r;
+		end_io(&b->bio);
+	}
 }
 
-static void inline_endio(struct bio *bio, int error)
+static void inline_endio(struct bio *bio)
 {
 	bio_end_io_t *end_fn = bio->bi_private;
+	int error = bio->bi_error;
 
 	/*
 	 * Reset the bio to free any attached resources
@@ -589,7 +593,8 @@ static void inline_endio(struct bio *bio, int error)
 	 */
 	bio_reset(bio);
 
-	end_fn(bio, error);
+	bio->bi_error = error;
+	end_fn(bio);
 }
 
 static void use_inline_bio(struct dm_buffer *b, int rw, sector_t block,
@@ -661,13 +666,14 @@ static void submit_io(struct dm_buffer *b, int rw, sector_t block,
  * Set the error, clear B_WRITING bit and wake anyone who was waiting on
  * it.
  */
-static void write_endio(struct bio *bio, int error)
+static void write_endio(struct bio *bio)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
-	b->write_error = error;
-	if (unlikely(error)) {
+	b->write_error = bio->bi_error;
+	if (unlikely(bio->bi_error)) {
 		struct dm_bufio_client *c = b->c;
+		int error = bio->bi_error;
 		(void)cmpxchg(&c->async_write_error, 0, error);
 	}
 
@@ -1026,11 +1032,11 @@ found_buffer:
  * The endio routine for reading: set the error, clear the bit and wake up
  * anyone waiting on the buffer.
  */
-static void read_endio(struct bio *bio, int error)
+static void read_endio(struct bio *bio)
 {
 	struct dm_buffer *b = container_of(bio, struct dm_buffer, bio);
 
-	b->read_error = error;
+	b->read_error = bio->bi_error;
 
 	BUG_ON(!test_bit(B_READING, &b->state));
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1b4e175..04d0dad 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -919,14 +919,14 @@ static void defer_writethrough_bio(struct cache *cache, struct bio *bio)
 	wake_worker(cache);
 }
 
-static void writethrough_endio(struct bio *bio, int err)
+static void writethrough_endio(struct bio *bio)
 {
 	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 
 	dm_unhook_bio(&pb->hook_info, bio);
 
-	if (err) {
-		bio_endio(bio, err);
+	if (bio->bi_error) {
+		bio_endio(bio);
 		return;
 	}
 
@@ -1231,7 +1231,7 @@ static void migration_success_post_commit(struct dm_cache_migration *mg)
 			 * The block was promoted via an overwrite, so it's dirty.
 			 */
 			set_dirty(cache, mg->new_oblock, mg->cblock);
-			bio_endio(mg->new_ocell->holder, 0);
+			bio_endio(mg->new_ocell->holder);
 			cell_defer(cache, mg->new_ocell, false);
 		}
 		free_io_migration(mg);
@@ -1284,7 +1284,7 @@ static void issue_copy(struct dm_cache_migration *mg)
 	}
 }
 
-static void overwrite_endio(struct bio *bio, int err)
+static void overwrite_endio(struct bio *bio)
 {
 	struct dm_cache_migration *mg = bio->bi_private;
 	struct cache *cache = mg->cache;
@@ -1294,7 +1294,7 @@ static void overwrite_endio(struct bio *bio, int err)
 
 	dm_unhook_bio(&pb->hook_info, bio);
 
-	if (err)
+	if (bio->bi_error)
 		mg->err = true;
 
 	mg->requeue_holder = false;
@@ -1358,7 +1358,7 @@ static void issue_discard(struct dm_cache_migration *mg)
 		b = to_dblock(from_dblock(b) + 1);
 	}
 
-	bio_endio(bio, 0);
+	bio_endio(bio);
 	cell_defer(mg->cache, mg->new_ocell, false);
 	free_migration(mg);
 }
@@ -1631,7 +1631,7 @@ static void process_discard_bio(struct cache *cache, struct prealloc *structs,
 
 	calc_discard_block_range(cache, bio, &b, &e);
 	if (b == e) {
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return;
 	}
 
@@ -2213,8 +2213,10 @@ static void requeue_deferred_bios(struct cache *cache)
 	bio_list_merge(&bios, &cache->deferred_bios);
 	bio_list_init(&cache->deferred_bios);
 
-	while ((bio = bio_list_pop(&bios)))
-		bio_endio(bio, DM_ENDIO_REQUEUE);
+	while ((bio = bio_list_pop(&bios))) {
+		bio->bi_error = DM_ENDIO_REQUEUE;
+		bio_endio(bio);
+	}
 }
 
 static int more_work(struct cache *cache)
@@ -3119,7 +3121,7 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 			 * This is a duplicate writethrough io that is no
 			 * longer needed because the block has been demoted.
 			 */
-			bio_endio(bio, 0);
+			bio_endio(bio);
 			// FIXME: remap everything as a miss
 			cell_defer(cache, cell, false);
 			r = DM_MAPIO_SUBMITTED;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 0f48fed..744b80c 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1076,7 +1076,8 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
 	if (io->ctx.req)
 		crypt_free_req(cc, io->ctx.req, base_bio);
 
-	bio_endio(base_bio, error);
+	base_bio->bi_error = error;
+	bio_endio(base_bio);
 }
 
 /*
@@ -1096,15 +1097,12 @@ static void crypt_dec_pending(struct dm_crypt_io *io)
  * The work is done per CPU global for all dm-crypt instances.
  * They should not depend on each other and do not block.
  */
-static void crypt_endio(struct bio *clone, int error)
+static void crypt_endio(struct bio *clone)
 {
 	struct dm_crypt_io *io = clone->bi_private;
 	struct crypt_config *cc = io->cc;
 	unsigned rw = bio_data_dir(clone);
 
-	if (unlikely(!bio_flagged(clone, BIO_UPTODATE) && !error))
-		error = -EIO;
-
 	/*
 	 * free the processed pages
 	 */
@@ -1113,13 +1111,13 @@ static void crypt_endio(struct bio *clone, int error)
 
 	bio_put(clone);
 
-	if (rw == READ && !error) {
+	if (rw == READ && !clone->bi_error) {
 		kcryptd_queue_crypt(io);
 		return;
 	}
 
-	if (unlikely(error))
-		io->error = error;
+	if (unlikely(clone->bi_error))
+		io->error = clone->bi_error;
 
 	crypt_dec_pending(io);
 }
diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index b257e46..0448124 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -296,7 +296,7 @@ static int flakey_map(struct dm_target *ti, struct bio *bio)
 		 * Drop writes?
 		 */
 		if (test_bit(DROP_WRITES, &fc->flags)) {
-			bio_endio(bio, 0);
+			bio_endio(bio);
 			return DM_MAPIO_SUBMITTED;
 		}
 
diff --git a/drivers/md/dm-io.c b/drivers/md/dm-io.c
index 74adcd2..efc6659 100644
--- a/drivers/md/dm-io.c
+++ b/drivers/md/dm-io.c
@@ -134,12 +134,12 @@ static void dec_count(struct io *io, unsigned int region, int error)
 		complete_io(io);
 }
 
-static void endio(struct bio *bio, int error)
+static void endio(struct bio *bio)
 {
 	struct io *io;
 	unsigned region;
 
-	if (error && bio_data_dir(bio) == READ)
+	if (bio->bi_error && bio_data_dir(bio) == READ)
 		zero_fill_bio(bio);
 
 	/*
@@ -149,7 +149,7 @@ static void endio(struct bio *bio, int error)
 
 	bio_put(bio);
 
-	dec_count(io, region, error);
+	dec_count(io, region, bio->bi_error);
 }
 
 /*-----------------------------------------------------------------
diff --git a/drivers/md/dm-log-writes.c b/drivers/md/dm-log-writes.c
index ad1b049..e9d1748 100644
--- a/drivers/md/dm-log-writes.c
+++ b/drivers/md/dm-log-writes.c
@@ -146,16 +146,16 @@ static void put_io_block(struct log_writes_c *lc)
 	}
 }
 
-static void log_end_io(struct bio *bio, int err)
+static void log_end_io(struct bio *bio)
 {
 	struct log_writes_c *lc = bio->bi_private;
 	struct bio_vec *bvec;
 	int i;
 
-	if (err) {
+	if (bio->bi_error) {
 		unsigned long flags;
 
-		DMERR("Error writing log block, error=%d", err);
+		DMERR("Error writing log block, error=%d", bio->bi_error);
 		spin_lock_irqsave(&lc->blocks_lock, flags);
 		lc->logging_enabled = false;
 		spin_unlock_irqrestore(&lc->blocks_lock, flags);
@@ -205,7 +205,6 @@ static int write_metadata(struct log_writes_c *lc, void *entry,
 	bio->bi_bdev = lc->logdev->bdev;
 	bio->bi_end_io = log_end_io;
 	bio->bi_private = lc;
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
 
 	page = alloc_page(GFP_KERNEL);
 	if (!page) {
@@ -270,7 +269,6 @@ static int log_one_block(struct log_writes_c *lc,
 	bio->bi_bdev = lc->logdev->bdev;
 	bio->bi_end_io = log_end_io;
 	bio->bi_private = lc;
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
 
 	for (i = 0; i < block->vec_cnt; i++) {
 		/*
@@ -292,7 +290,6 @@ static int log_one_block(struct log_writes_c *lc,
 			bio->bi_bdev = lc->logdev->bdev;
 			bio->bi_end_io = log_end_io;
 			bio->bi_private = lc;
-			set_bit(BIO_UPTODATE, &bio->bi_flags);
 
 			ret = bio_add_page(bio, block->vecs[i].bv_page,
 					   block->vecs[i].bv_len, 0);
@@ -606,7 +603,7 @@ static int log_writes_map(struct dm_target *ti, struct bio *bio)
 		WARN_ON(flush_bio || fua_bio);
 		if (lc->device_supports_discard)
 			goto map_bio;
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
 	}
 
diff --git a/drivers/md/dm-raid1.c b/drivers/md/dm-raid1.c
index d83696b..e1eabfb 100644
--- a/drivers/md/dm-raid1.c
+++ b/drivers/md/dm-raid1.c
@@ -490,9 +490,11 @@ static void hold_bio(struct mirror_set *ms, struct bio *bio)
 		 * If device is suspended, complete the bio.
 		 */
 		if (dm_noflush_suspending(ms->ti))
-			bio_endio(bio, DM_ENDIO_REQUEUE);
+			bio->bi_error = DM_ENDIO_REQUEUE;
 		else
-			bio_endio(bio, -EIO);
+			bio->bi_error = -EIO;
+
+		bio_endio(bio);
 		return;
 	}
 
@@ -515,7 +517,7 @@ static void read_callback(unsigned long error, void *context)
 	bio_set_m(bio, NULL);
 
 	if (likely(!error)) {
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return;
 	}
 
@@ -531,7 +533,7 @@ static void read_callback(unsigned long error, void *context)
 
 	DMERR_LIMIT("Read failure on mirror device %s.  Failing I/O.",
 		    m->dev->name);
-	bio_endio(bio, -EIO);
+	bio_io_error(bio);
 }
 
 /* Asynchronous read. */
@@ -580,7 +582,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 		if (likely(m))
 			read_async_bio(m, bio);
 		else
-			bio_endio(bio, -EIO);
+			bio_io_error(bio);
 	}
 }
 
@@ -598,7 +600,7 @@ static void do_reads(struct mirror_set *ms, struct bio_list *reads)
 
 static void write_callback(unsigned long error, void *context)
 {
-	unsigned i, ret = 0;
+	unsigned i;
 	struct bio *bio = (struct bio *) context;
 	struct mirror_set *ms;
 	int should_wake = 0;
@@ -614,7 +616,7 @@ static void write_callback(unsigned long error, void *context)
 	 * regions with the same code.
 	 */
 	if (likely(!error)) {
-		bio_endio(bio, ret);
+		bio_endio(bio);
 		return;
 	}
 
@@ -623,7 +625,8 @@ static void write_callback(unsigned long error, void *context)
 	 * degrade the array.
 	 */
 	if (bio->bi_rw & REQ_DISCARD) {
-		bio_endio(bio, -EOPNOTSUPP);
+		bio->bi_error = -EOPNOTSUPP;
+		bio_endio(bio);
 		return;
 	}
 
@@ -828,13 +831,12 @@ static void do_failures(struct mirror_set *ms, struct bio_list *failures)
 		 * be wrong if the failed leg returned after reboot and
 		 * got replicated back to the good legs.)
 		 */
-
 		if (unlikely(!get_valid_mirror(ms) || (keep_log(ms) && ms->log_failure)))
-			bio_endio(bio, -EIO);
+			bio_io_error(bio);
 		else if (errors_handled(ms) && !keep_log(ms))
 			hold_bio(ms, bio);
 		else
-			bio_endio(bio, 0);
+			bio_endio(bio);
 	}
 }
 
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7c82d3c..dd8ca0b 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1490,7 +1490,7 @@ out:
 		error_bios(snapshot_bios);
 	} else {
 		if (full_bio)
-			bio_endio(full_bio, 0);
+			bio_endio(full_bio);
 		flush_bios(snapshot_bios);
 	}
 
@@ -1580,11 +1580,11 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 	dm_kcopyd_copy(s->kcopyd_client, &src, 1, &dest, 0, copy_callback, pe);
 }
 
-static void full_bio_end_io(struct bio *bio, int error)
+static void full_bio_end_io(struct bio *bio)
 {
 	void *callback_data = bio->bi_private;
 
-	dm_kcopyd_do_callback(callback_data, 0, error ? 1 : 0);
+	dm_kcopyd_do_callback(callback_data, 0, bio->bi_error ? 1 : 0);
 }
 
 static void start_full_bio(struct dm_snap_pending_exception *pe,
diff --git a/drivers/md/dm-stripe.c b/drivers/md/dm-stripe.c
index a672a15..4f94c7d 100644
--- a/drivers/md/dm-stripe.c
+++ b/drivers/md/dm-stripe.c
@@ -273,7 +273,7 @@ static int stripe_map_range(struct stripe_c *sc, struct bio *bio,
 		return DM_MAPIO_REMAPPED;
 	} else {
 		/* The range doesn't map to the target stripe */
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
 	}
 }
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index c33f61a..2ade2c4 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -614,8 +614,10 @@ static void error_bio_list(struct bio_list *bios, int error)
 {
 	struct bio *bio;
 
-	while ((bio = bio_list_pop(bios)))
-		bio_endio(bio, error);
+	while ((bio = bio_list_pop(bios))) {
+		bio->bi_error = error;
+		bio_endio(bio);
+	}
 }
 
 static void error_thin_bio_list(struct thin_c *tc, struct bio_list *master, int error)
@@ -864,14 +866,14 @@ static void copy_complete(int read_err, unsigned long write_err, void *context)
 	complete_mapping_preparation(m);
 }
 
-static void overwrite_endio(struct bio *bio, int err)
+static void overwrite_endio(struct bio *bio)
 {
 	struct dm_thin_endio_hook *h = dm_per_bio_data(bio, sizeof(struct dm_thin_endio_hook));
 	struct dm_thin_new_mapping *m = h->overwrite_mapping;
 
 	bio->bi_end_io = m->saved_bi_end_io;
 
-	m->err = err;
+	m->err = bio->bi_error;
 	complete_mapping_preparation(m);
 }
 
@@ -996,7 +998,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	 */
 	if (bio) {
 		inc_remap_and_issue_cell(tc, m->cell, m->data_block);
-		bio_endio(bio, 0);
+		bio_endio(bio);
 	} else {
 		inc_all_io_entry(tc->pool, m->cell->holder);
 		remap_and_issue(tc, m->cell->holder, m->data_block);
@@ -1026,7 +1028,7 @@ static void process_prepared_discard_fail(struct dm_thin_new_mapping *m)
 
 static void process_prepared_discard_success(struct dm_thin_new_mapping *m)
 {
-	bio_endio(m->bio, 0);
+	bio_endio(m->bio);
 	free_discard_mapping(m);
 }
 
@@ -1040,7 +1042,7 @@ static void process_prepared_discard_no_passdown(struct dm_thin_new_mapping *m)
 		metadata_operation_failed(tc->pool, "dm_thin_remove_range", r);
 		bio_io_error(m->bio);
 	} else
-		bio_endio(m->bio, 0);
+		bio_endio(m->bio);
 
 	cell_defer_no_holder(tc, m->cell);
 	mempool_free(m, tc->pool->mapping_pool);
@@ -1111,7 +1113,8 @@ static void process_prepared_discard_passdown(struct dm_thin_new_mapping *m)
 	 * Even if r is set, there could be sub discards in flight that we
 	 * need to wait for.
 	 */
-	bio_endio(m->bio, r);
+	m->bio->bi_error = r;
+	bio_endio(m->bio);
 	cell_defer_no_holder(tc, m->cell);
 	mempool_free(m, pool->mapping_pool);
 }
@@ -1487,9 +1490,10 @@ static void handle_unserviceable_bio(struct pool *pool, struct bio *bio)
 {
 	int error = should_error_unserviceable_bio(pool);
 
-	if (error)
-		bio_endio(bio, error);
-	else
+	if (error) {
+		bio->bi_error = error;
+		bio_endio(bio);
+	} else
 		retry_on_resume(bio);
 }
 
@@ -1625,7 +1629,7 @@ static void process_discard_cell_passdown(struct thin_c *tc, struct dm_bio_priso
 	 * will prevent completion until the sub range discards have
 	 * completed.
 	 */
-	bio_endio(bio, 0);
+	bio_endio(bio);
 }
 
 static void process_discard_bio(struct thin_c *tc, struct bio *bio)
@@ -1639,7 +1643,7 @@ static void process_discard_bio(struct thin_c *tc, struct bio *bio)
 		/*
 		 * The discard covers less than a block.
 		 */
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1784,7 +1788,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	if (bio_data_dir(bio) == READ) {
 		zero_fill_bio(bio);
 		cell_defer_no_holder(tc, cell);
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		return;
 	}
 
@@ -1849,7 +1853,7 @@ static void process_cell(struct thin_c *tc, struct dm_bio_prison_cell *cell)
 
 			} else {
 				zero_fill_bio(bio);
-				bio_endio(bio, 0);
+				bio_endio(bio);
 			}
 		} else
 			provision_block(tc, bio, block, cell);
@@ -1920,7 +1924,7 @@ static void __process_bio_read_only(struct thin_c *tc, struct bio *bio,
 		}
 
 		zero_fill_bio(bio);
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		break;
 
 	default:
@@ -1945,7 +1949,7 @@ static void process_cell_read_only(struct thin_c *tc, struct dm_bio_prison_cell
 
 static void process_bio_success(struct thin_c *tc, struct bio *bio)
 {
-	bio_endio(bio, 0);
+	bio_endio(bio);
 }
 
 static void process_bio_fail(struct thin_c *tc, struct bio *bio)
@@ -2581,7 +2585,8 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio)
 	thin_hook_bio(tc, bio);
 
 	if (tc->requeue_mode) {
-		bio_endio(bio, DM_ENDIO_REQUEUE);
+		bio->bi_error = DM_ENDIO_REQUEUE;
+		bio_endio(bio);
 		return DM_MAPIO_SUBMITTED;
 	}
 
diff --git a/drivers/md/dm-verity.c b/drivers/md/dm-verity.c
index bb9c6a0..4b34df8 100644
--- a/drivers/md/dm-verity.c
+++ b/drivers/md/dm-verity.c
@@ -458,8 +458,9 @@ static void verity_finish_io(struct dm_verity_io *io, int error)
 
 	bio->bi_end_io = io->orig_bi_end_io;
 	bio->bi_private = io->orig_bi_private;
+	bio->bi_error = error;
 
-	bio_endio(bio, error);
+	bio_endio(bio);
 }
 
 static void verity_work(struct work_struct *w)
@@ -469,12 +470,12 @@ static void verity_work(struct work_struct *w)
 	verity_finish_io(io, verity_verify_io(io));
 }
 
-static void verity_end_io(struct bio *bio, int error)
+static void verity_end_io(struct bio *bio)
 {
 	struct dm_verity_io *io = bio->bi_private;
 
-	if (error) {
-		verity_finish_io(io, error);
+	if (bio->bi_error) {
+		verity_finish_io(io, bio->bi_error);
 		return;
 	}
 
diff --git a/drivers/md/dm-zero.c b/drivers/md/dm-zero.c
index b9a64bb..766bc93 100644
--- a/drivers/md/dm-zero.c
+++ b/drivers/md/dm-zero.c
@@ -47,7 +47,7 @@ static int zero_map(struct dm_target *ti, struct bio *bio)
 		break;
 	}
 
-	bio_endio(bio, 0);
+	bio_endio(bio);
 
 	/* accepted bio, don't make new request */
 	return DM_MAPIO_SUBMITTED;
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index f331d88..7f367fc 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -944,7 +944,8 @@ static void dec_pending(struct dm_io *io, int error)
 		} else {
 			/* done with normal IO or empty flush */
 			trace_block_bio_complete(md->queue, bio, io_error);
-			bio_endio(bio, io_error);
+			bio->bi_error = io_error;
+			bio_endio(bio);
 		}
 	}
 }
@@ -957,17 +958,15 @@ static void disable_write_same(struct mapped_device *md)
 	limits->max_write_same_sectors = 0;
 }
 
-static void clone_endio(struct bio *bio, int error)
+static void clone_endio(struct bio *bio)
 {
+	int error = bio->bi_error;
 	int r = error;
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	struct dm_io *io = tio->io;
 	struct mapped_device *md = tio->io->md;
 	dm_endio_fn endio = tio->ti->type->end_io;
 
-	if (!bio_flagged(bio, BIO_UPTODATE) && !error)
-		error = -EIO;
-
 	if (endio) {
 		r = endio(tio->ti, bio, error);
 		if (r < 0 || r == DM_ENDIO_REQUEUE)
@@ -996,7 +995,7 @@ static void clone_endio(struct bio *bio, int error)
 /*
  * Partial completion handling for request-based dm
  */
-static void end_clone_bio(struct bio *clone, int error)
+static void end_clone_bio(struct bio *clone)
 {
 	struct dm_rq_clone_bio_info *info =
 		container_of(clone, struct dm_rq_clone_bio_info, clone);
@@ -1013,13 +1012,13 @@ static void end_clone_bio(struct bio *clone, int error)
 		 * the remainder.
 		 */
 		return;
-	else if (error) {
+	else if (bio->bi_error) {
 		/*
 		 * Don't notice the error to the upper layer yet.
 		 * The error handling decision is made by the target driver,
 		 * when the request is completed.
 		 */
-		tio->error = error;
+		tio->error = bio->bi_error;
 		return;
 	}
 
diff --git a/drivers/md/faulty.c b/drivers/md/faulty.c
index 1277eb2..4a8e150 100644
--- a/drivers/md/faulty.c
+++ b/drivers/md/faulty.c
@@ -70,7 +70,7 @@
 #include <linux/seq_file.h>
 
 
-static void faulty_fail(struct bio *bio, int error)
+static void faulty_fail(struct bio *bio)
 {
 	struct bio *b = bio->bi_private;
 
@@ -181,7 +181,7 @@ static void make_request(struct mddev *mddev, struct bio *bio)
 			/* special case - don't decrement, don't generic_make_request,
 			 * just fail immediately
 			 */
-			bio_endio(bio, -EIO);
+			bio_io_error(bio);
 			return;
 		}
 
diff --git a/drivers/md/linear.c b/drivers/md/linear.c
index fa7d577..aefd661 100644
--- a/drivers/md/linear.c
+++ b/drivers/md/linear.c
@@ -297,7 +297,7 @@ static void linear_make_request(struct mddev *mddev, struct bio *bio)
 		if (unlikely((split->bi_rw & REQ_DISCARD) &&
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
-			bio_endio(split, 0);
+			bio_endio(split);
 		} else
 			generic_make_request(split);
 	} while (split != bio);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index d429c30..ac4381a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -263,7 +263,9 @@ static void md_make_request(struct request_queue *q, struct bio *bio)
 		return;
 	}
 	if (mddev->ro == 1 && unlikely(rw == WRITE)) {
-		bio_endio(bio, bio_sectors(bio) == 0 ? 0 : -EROFS);
+		if (bio_sectors(bio) != 0)
+			bio->bi_error = -EROFS;
+		bio_endio(bio);
 		return;
 	}
 	smp_rmb(); /* Ensure implications of  'active' are visible */
@@ -377,7 +379,7 @@ static int md_mergeable_bvec(struct request_queue *q,
  * Generic flush handling for md
  */
 
-static void md_end_flush(struct bio *bio, int err)
+static void md_end_flush(struct bio *bio)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
@@ -433,7 +435,7 @@ static void md_submit_flush_data(struct work_struct *ws)
 
 	if (bio->bi_iter.bi_size == 0)
 		/* an empty barrier - all done */
-		bio_endio(bio, 0);
+		bio_endio(bio);
 	else {
 		bio->bi_rw &= ~REQ_FLUSH;
 		mddev->pers->make_request(mddev, bio);
@@ -728,15 +730,13 @@ void md_rdev_clear(struct md_rdev *rdev)
 }
 EXPORT_SYMBOL_GPL(md_rdev_clear);
 
-static void super_written(struct bio *bio, int error)
+static void super_written(struct bio *bio)
 {
 	struct md_rdev *rdev = bio->bi_private;
 	struct mddev *mddev = rdev->mddev;
 
-	if (error || !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
-		printk("md: super_written gets error=%d, uptodate=%d\n",
-		       error, test_bit(BIO_UPTODATE, &bio->bi_flags));
-		WARN_ON(test_bit(BIO_UPTODATE, &bio->bi_flags));
+	if (bio->bi_error) {
+		printk("md: super_written gets error=%d\n", bio->bi_error);
 		md_error(mddev, rdev);
 	}
 
@@ -791,7 +791,7 @@ int sync_page_io(struct md_rdev *rdev, sector_t sector, int size,
 	bio_add_page(bio, page, size, 0);
 	submit_bio_wait(rw, bio);
 
-	ret = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	ret = !bio->bi_error;
 	bio_put(bio);
 	return ret;
 }
diff --git a/drivers/md/multipath.c b/drivers/md/multipath.c
index ac3ede2..082a489 100644
--- a/drivers/md/multipath.c
+++ b/drivers/md/multipath.c
@@ -77,18 +77,18 @@ static void multipath_end_bh_io (struct multipath_bh *mp_bh, int err)
 	struct bio *bio = mp_bh->master_bio;
 	struct mpconf *conf = mp_bh->mddev->private;
 
-	bio_endio(bio, err);
+	bio->bi_error = err;
+	bio_endio(bio);
 	mempool_free(mp_bh, conf->pool);
 }
 
-static void multipath_end_request(struct bio *bio, int error)
+static void multipath_end_request(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct multipath_bh *mp_bh = bio->bi_private;
 	struct mpconf *conf = mp_bh->mddev->private;
 	struct md_rdev *rdev = conf->multipaths[mp_bh->path].rdev;
 
-	if (uptodate)
+	if (!bio->bi_error)
 		multipath_end_bh_io(mp_bh, 0);
 	else if (!(bio->bi_rw & REQ_RAHEAD)) {
 		/*
@@ -101,7 +101,7 @@ static void multipath_end_request(struct bio *bio, int error)
 		       (unsigned long long)bio->bi_iter.bi_sector);
 		multipath_reschedule_retry(mp_bh);
 	} else
-		multipath_end_bh_io(mp_bh, error);
+		multipath_end_bh_io(mp_bh, bio->bi_error);
 	rdev_dec_pending(rdev, conf->mddev);
 }
 
@@ -123,7 +123,7 @@ static void multipath_make_request(struct mddev *mddev, struct bio * bio)
 
 	mp_bh->path = multipath_map(conf);
 	if (mp_bh->path < 0) {
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 		mempool_free(mp_bh, conf->pool);
 		return;
 	}
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index efb654e..e6e0ae5 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -543,7 +543,7 @@ static void raid0_make_request(struct mddev *mddev, struct bio *bio)
 		if (unlikely((split->bi_rw & REQ_DISCARD) &&
 			 !blk_queue_discard(bdev_get_queue(split->bi_bdev)))) {
 			/* Just ignore it */
-			bio_endio(split, 0);
+			bio_endio(split);
 		} else
 			generic_make_request(split);
 	} while (split != bio);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index f80f1af..9aa7d1f 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -255,9 +255,10 @@ static void call_bio_endio(struct r1bio *r1_bio)
 		done = 1;
 
 	if (!test_bit(R1BIO_Uptodate, &r1_bio->state))
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		bio->bi_error = -EIO;
+
 	if (done) {
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		/*
 		 * Wake up any possible resync thread that waits for the device
 		 * to go idle.
@@ -312,9 +313,9 @@ static int find_bio_disk(struct r1bio *r1_bio, struct bio *bio)
 	return mirror;
 }
 
-static void raid1_end_read_request(struct bio *bio, int error)
+static void raid1_end_read_request(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int uptodate = !bio->bi_error;
 	struct r1bio *r1_bio = bio->bi_private;
 	int mirror;
 	struct r1conf *conf = r1_bio->mddev->private;
@@ -397,9 +398,8 @@ static void r1_bio_write_done(struct r1bio *r1_bio)
 	}
 }
 
-static void raid1_end_write_request(struct bio *bio, int error)
+static void raid1_end_write_request(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r1bio *r1_bio = bio->bi_private;
 	int mirror, behind = test_bit(R1BIO_BehindIO, &r1_bio->state);
 	struct r1conf *conf = r1_bio->mddev->private;
@@ -410,7 +410,7 @@ static void raid1_end_write_request(struct bio *bio, int error)
 	/*
 	 * 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate) {
+	if (bio->bi_error) {
 		set_bit(WriteErrorSeen,
 			&conf->mirrors[mirror].rdev->flags);
 		if (!test_and_set_bit(WantReplacement,
@@ -793,7 +793,7 @@ static void flush_pending_writes(struct r1conf *conf)
 			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
-				bio_endio(bio, 0);
+				bio_endio(bio);
 			else
 				generic_make_request(bio);
 			bio = next;
@@ -1068,7 +1068,7 @@ static void raid1_unplug(struct blk_plug_cb *cb, bool from_schedule)
 		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
-			bio_endio(bio, 0);
+			bio_endio(bio);
 		else
 			generic_make_request(bio);
 		bio = next;
@@ -1734,7 +1734,7 @@ abort:
 	return err;
 }
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio)
 {
 	struct r1bio *r1_bio = bio->bi_private;
 
@@ -1745,16 +1745,16 @@ static void end_sync_read(struct bio *bio, int error)
 	 * or re-read if the read failed.
 	 * We don't do much here, just schedule handling by raid1d
 	 */
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (!bio->bi_error)
 		set_bit(R1BIO_Uptodate, &r1_bio->state);
 
 	if (atomic_dec_and_test(&r1_bio->remaining))
 		reschedule_retry(r1_bio);
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int uptodate = !bio->bi_error;
 	struct r1bio *r1_bio = bio->bi_private;
 	struct mddev *mddev = r1_bio->mddev;
 	struct r1conf *conf = mddev->private;
@@ -1941,7 +1941,7 @@ static int fix_sync_read_error(struct r1bio *r1_bio)
 		idx ++;
 	}
 	set_bit(R1BIO_Uptodate, &r1_bio->state);
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
+	bio->bi_error = 0;
 	return 1;
 }
 
@@ -1965,15 +1965,14 @@ static void process_checks(struct r1bio *r1_bio)
 	for (i = 0; i < conf->raid_disks * 2; i++) {
 		int j;
 		int size;
-		int uptodate;
+		int error;
 		struct bio *b = r1_bio->bios[i];
 		if (b->bi_end_io != end_sync_read)
 			continue;
-		/* fixup the bio for reuse, but preserve BIO_UPTODATE */
-		uptodate = test_bit(BIO_UPTODATE, &b->bi_flags);
+		/* fixup the bio for reuse, but preserve errno */
+		error = b->bi_error;
 		bio_reset(b);
-		if (!uptodate)
-			clear_bit(BIO_UPTODATE, &b->bi_flags);
+		b->bi_error = error;
 		b->bi_vcnt = vcnt;
 		b->bi_iter.bi_size = r1_bio->sectors << 9;
 		b->bi_iter.bi_sector = r1_bio->sector +
@@ -1996,7 +1995,7 @@ static void process_checks(struct r1bio *r1_bio)
 	}
 	for (primary = 0; primary < conf->raid_disks * 2; primary++)
 		if (r1_bio->bios[primary]->bi_end_io == end_sync_read &&
-		    test_bit(BIO_UPTODATE, &r1_bio->bios[primary]->bi_flags)) {
+		    !r1_bio->bios[primary]->bi_error) {
 			r1_bio->bios[primary]->bi_end_io = NULL;
 			rdev_dec_pending(conf->mirrors[primary].rdev, mddev);
 			break;
@@ -2006,14 +2005,14 @@ static void process_checks(struct r1bio *r1_bio)
 		int j;
 		struct bio *pbio = r1_bio->bios[primary];
 		struct bio *sbio = r1_bio->bios[i];
-		int uptodate = test_bit(BIO_UPTODATE, &sbio->bi_flags);
+		int error = sbio->bi_error;
 
 		if (sbio->bi_end_io != end_sync_read)
 			continue;
-		/* Now we can 'fixup' the BIO_UPTODATE flag */
-		set_bit(BIO_UPTODATE, &sbio->bi_flags);
+		/* Now we can 'fixup' the error value */
+		sbio->bi_error = 0;
 
-		if (uptodate) {
+		if (!error) {
 			for (j = vcnt; j-- ; ) {
 				struct page *p, *s;
 				p = pbio->bi_io_vec[j].bv_page;
@@ -2028,7 +2027,7 @@ static void process_checks(struct r1bio *r1_bio)
 		if (j >= 0)
 			atomic64_add(r1_bio->sectors, &mddev->resync_mismatches);
 		if (j < 0 || (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)
-			      && uptodate)) {
+			      && !error)) {
 			/* No need to write to this device. */
 			sbio->bi_end_io = NULL;
 			rdev_dec_pending(conf->mirrors[i].rdev, mddev);
@@ -2269,11 +2268,11 @@ static void handle_sync_write_finished(struct r1conf *conf, struct r1bio *r1_bio
 		struct bio *bio = r1_bio->bios[m];
 		if (bio->bi_end_io == NULL)
 			continue;
-		if (test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+		if (!bio->bi_error &&
 		    test_bit(R1BIO_MadeGood, &r1_bio->state)) {
 			rdev_clear_badblocks(rdev, r1_bio->sector, s, 0);
 		}
-		if (!test_bit(BIO_UPTODATE, &bio->bi_flags) &&
+		if (bio->bi_error &&
 		    test_bit(R1BIO_WriteError, &r1_bio->state)) {
 			if (!rdev_set_badblocks(rdev, r1_bio->sector, s, 0))
 				md_error(conf->mddev, rdev);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 940f2f3..929e9a2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -101,7 +101,7 @@ static int _enough(struct r10conf *conf, int previous, int ignore);
 static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 				int *skipped);
 static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
-static void end_reshape_write(struct bio *bio, int error);
+static void end_reshape_write(struct bio *bio);
 static void end_reshape(struct r10conf *conf);
 
 static void * r10bio_pool_alloc(gfp_t gfp_flags, void *data)
@@ -307,9 +307,9 @@ static void raid_end_bio_io(struct r10bio *r10_bio)
 	} else
 		done = 1;
 	if (!test_bit(R10BIO_Uptodate, &r10_bio->state))
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+		bio->bi_error = -EIO;
 	if (done) {
-		bio_endio(bio, 0);
+		bio_endio(bio);
 		/*
 		 * Wake up any possible resync thread that waits for the device
 		 * to go idle.
@@ -358,9 +358,9 @@ static int find_bio_disk(struct r10conf *conf, struct r10bio *r10_bio,
 	return r10_bio->devs[slot].devnum;
 }
 
-static void raid10_end_read_request(struct bio *bio, int error)
+static void raid10_end_read_request(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int uptodate = !bio->bi_error;
 	struct r10bio *r10_bio = bio->bi_private;
 	int slot, dev;
 	struct md_rdev *rdev;
@@ -438,9 +438,8 @@ static void one_write_done(struct r10bio *r10_bio)
 	}
 }
 
-static void raid10_end_write_request(struct bio *bio, int error)
+static void raid10_end_write_request(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
 	int dev;
 	int dec_rdev = 1;
@@ -460,7 +459,7 @@ static void raid10_end_write_request(struct bio *bio, int error)
 	/*
 	 * this branch is our 'one mirror IO has finished' event handler:
 	 */
-	if (!uptodate) {
+	if (bio->bi_error) {
 		if (repl)
 			/* Never record new bad blocks to replacement,
 			 * just fail it.
@@ -957,7 +956,7 @@ static void flush_pending_writes(struct r10conf *conf)
 			if (unlikely((bio->bi_rw & REQ_DISCARD) &&
 			    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 				/* Just ignore it */
-				bio_endio(bio, 0);
+				bio_endio(bio);
 			else
 				generic_make_request(bio);
 			bio = next;
@@ -1133,7 +1132,7 @@ static void raid10_unplug(struct blk_plug_cb *cb, bool from_schedule)
 		if (unlikely((bio->bi_rw & REQ_DISCARD) &&
 		    !blk_queue_discard(bdev_get_queue(bio->bi_bdev))))
 			/* Just ignore it */
-			bio_endio(bio, 0);
+			bio_endio(bio);
 		else
 			generic_make_request(bio);
 		bio = next;
@@ -1916,7 +1915,7 @@ abort:
 	return err;
 }
 
-static void end_sync_read(struct bio *bio, int error)
+static void end_sync_read(struct bio *bio)
 {
 	struct r10bio *r10_bio = bio->bi_private;
 	struct r10conf *conf = r10_bio->mddev->private;
@@ -1928,7 +1927,7 @@ static void end_sync_read(struct bio *bio, int error)
 	} else
 		d = find_bio_disk(conf, r10_bio, bio, NULL, NULL);
 
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
+	if (!bio->bi_error)
 		set_bit(R10BIO_Uptodate, &r10_bio->state);
 	else
 		/* The write handler will notice the lack of
@@ -1977,9 +1976,8 @@ static void end_sync_request(struct r10bio *r10_bio)
 	}
 }
 
-static void end_sync_write(struct bio *bio, int error)
+static void end_sync_write(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
 	struct mddev *mddev = r10_bio->mddev;
 	struct r10conf *conf = mddev->private;
@@ -1996,7 +1994,7 @@ static void end_sync_write(struct bio *bio, int error)
 	else
 		rdev = conf->mirrors[d].rdev;
 
-	if (!uptodate) {
+	if (bio->bi_error) {
 		if (repl)
 			md_error(mddev, rdev);
 		else {
@@ -2044,7 +2042,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 
 	/* find the first device with a block */
 	for (i=0; i<conf->copies; i++)
-		if (test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags))
+		if (!r10_bio->devs[i].bio->bi_error)
 			break;
 
 	if (i == conf->copies)
@@ -2064,7 +2062,7 @@ static void sync_request_write(struct mddev *mddev, struct r10bio *r10_bio)
 			continue;
 		if (i == first)
 			continue;
-		if (test_bit(BIO_UPTODATE, &r10_bio->devs[i].bio->bi_flags)) {
+		if (!r10_bio->devs[i].bio->bi_error) {
 			/* We know that the bi_io_vec layout is the same for
 			 * both 'first' and 'i', so we just compare them.
 			 * All vec entries are PAGE_SIZE;
@@ -2706,8 +2704,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			rdev = conf->mirrors[dev].rdev;
 			if (r10_bio->devs[m].bio == NULL)
 				continue;
-			if (test_bit(BIO_UPTODATE,
-				     &r10_bio->devs[m].bio->bi_flags)) {
+			if (!r10_bio->devs[m].bio->bi_error) {
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
@@ -2722,8 +2719,8 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 			rdev = conf->mirrors[dev].replacement;
 			if (r10_bio->devs[m].repl_bio == NULL)
 				continue;
-			if (test_bit(BIO_UPTODATE,
-				     &r10_bio->devs[m].repl_bio->bi_flags)) {
+
+			if (!r10_bio->devs[m].repl_bio->bi_error) {
 				rdev_clear_badblocks(
 					rdev,
 					r10_bio->devs[m].addr,
@@ -2748,8 +2745,7 @@ static void handle_write_completed(struct r10conf *conf, struct r10bio *r10_bio)
 					r10_bio->devs[m].addr,
 					r10_bio->sectors, 0);
 				rdev_dec_pending(rdev, conf->mddev);
-			} else if (bio != NULL &&
-				   !test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+			} else if (bio != NULL && bio->bi_error) {
 				if (!narrow_write_error(r10_bio, m)) {
 					md_error(conf->mddev, rdev);
 					set_bit(R10BIO_Degraded,
@@ -3263,7 +3259,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 
 			bio = r10_bio->devs[i].bio;
 			bio_reset(bio);
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_error = -EIO;
 			if (conf->mirrors[d].rdev == NULL ||
 			    test_bit(Faulty, &conf->mirrors[d].rdev->flags))
 				continue;
@@ -3300,7 +3296,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 			/* Need to set up for writing to the replacement */
 			bio = r10_bio->devs[i].repl_bio;
 			bio_reset(bio);
-			clear_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_error = -EIO;
 
 			sector = r10_bio->devs[i].addr;
 			atomic_inc(&conf->mirrors[d].rdev->nr_pending);
@@ -3377,7 +3373,7 @@ static sector_t sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (bio->bi_end_io == end_sync_read) {
 			md_sync_acct(bio->bi_bdev, nr_sectors);
-			set_bit(BIO_UPTODATE, &bio->bi_flags);
+			bio->bi_error = 0;
 			generic_make_request(bio);
 		}
 	}
@@ -4380,7 +4376,7 @@ read_more:
 	read_bio->bi_end_io = end_sync_read;
 	read_bio->bi_rw = READ;
 	read_bio->bi_flags &= (~0UL << BIO_RESET_BITS);
-	__set_bit(BIO_UPTODATE, &read_bio->bi_flags);
+	read_bio->bi_error = 0;
 	read_bio->bi_vcnt = 0;
 	read_bio->bi_iter.bi_size = 0;
 	r10_bio->master_bio = read_bio;
@@ -4601,9 +4597,8 @@ static int handle_reshape_read_error(struct mddev *mddev,
 	return 0;
 }
 
-static void end_reshape_write(struct bio *bio, int error)
+static void end_reshape_write(struct bio *bio)
 {
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct r10bio *r10_bio = bio->bi_private;
 	struct mddev *mddev = r10_bio->mddev;
 	struct r10conf *conf = mddev->private;
@@ -4620,7 +4615,7 @@ static void end_reshape_write(struct bio *bio, int error)
 		rdev = conf->mirrors[d].rdev;
 	}
 
-	if (!uptodate) {
+	if (bio->bi_error) {
 		/* FIXME should record badblock */
 		md_error(mddev, rdev);
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 59e44e9..84d6eec 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -233,7 +233,7 @@ static void return_io(struct bio *return_bi)
 		bi->bi_iter.bi_size = 0;
 		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
 					 bi, 0);
-		bio_endio(bi, 0);
+		bio_endio(bi);
 		bi = return_bi;
 	}
 }
@@ -887,9 +887,9 @@ static int use_new_offset(struct r5conf *conf, struct stripe_head *sh)
 }
 
 static void
-raid5_end_read_request(struct bio *bi, int error);
+raid5_end_read_request(struct bio *bi);
 static void
-raid5_end_write_request(struct bio *bi, int error);
+raid5_end_write_request(struct bio *bi);
 
 static void ops_run_io(struct stripe_head *sh, struct stripe_head_state *s)
 {
@@ -2277,12 +2277,11 @@ static void shrink_stripes(struct r5conf *conf)
 	conf->slab_cache = NULL;
 }
 
-static void raid5_end_read_request(struct bio * bi, int error)
+static void raid5_end_read_request(struct bio * bi)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
-	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	char b[BDEVNAME_SIZE];
 	struct md_rdev *rdev = NULL;
 	sector_t s;
@@ -2291,9 +2290,9 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		if (bi == &sh->dev[i].req)
 			break;
 
-	pr_debug("end_read_request %llu/%d, count: %d, uptodate %d.\n",
+	pr_debug("end_read_request %llu/%d, count: %d, error %d.\n",
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
-		uptodate);
+		bi->bi_error);
 	if (i == disks) {
 		BUG();
 		return;
@@ -2312,7 +2311,7 @@ static void raid5_end_read_request(struct bio * bi, int error)
 		s = sh->sector + rdev->new_data_offset;
 	else
 		s = sh->sector + rdev->data_offset;
-	if (uptodate) {
+	if (!bi->bi_error) {
 		set_bit(R5_UPTODATE, &sh->dev[i].flags);
 		if (test_bit(R5_ReadError, &sh->dev[i].flags)) {
 			/* Note that this cannot happen on a
@@ -2400,13 +2399,12 @@ static void raid5_end_read_request(struct bio * bi, int error)
 	release_stripe(sh);
 }
 
-static void raid5_end_write_request(struct bio *bi, int error)
+static void raid5_end_write_request(struct bio *bi)
 {
 	struct stripe_head *sh = bi->bi_private;
 	struct r5conf *conf = sh->raid_conf;
 	int disks = sh->disks, i;
 	struct md_rdev *uninitialized_var(rdev);
-	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	sector_t first_bad;
 	int bad_sectors;
 	int replacement = 0;
@@ -2429,23 +2427,23 @@ static void raid5_end_write_request(struct bio *bi, int error)
 			break;
 		}
 	}
-	pr_debug("end_write_request %llu/%d, count %d, uptodate: %d.\n",
+	pr_debug("end_write_request %llu/%d, count %d, error: %d.\n",
 		(unsigned long long)sh->sector, i, atomic_read(&sh->count),
-		uptodate);
+		bi->bi_error);
 	if (i == disks) {
 		BUG();
 		return;
 	}
 
 	if (replacement) {
-		if (!uptodate)
+		if (bi->bi_error)
 			md_error(conf->mddev, rdev);
 		else if (is_badblock(rdev, sh->sector,
 				     STRIPE_SECTORS,
 				     &first_bad, &bad_sectors))
 			set_bit(R5_MadeGoodRepl, &sh->dev[i].flags);
 	} else {
-		if (!uptodate) {
+		if (bi->bi_error) {
 			set_bit(STRIPE_DEGRADED, &sh->state);
 			set_bit(WriteErrorSeen, &rdev->flags);
 			set_bit(R5_WriteError, &sh->dev[i].flags);
@@ -2466,7 +2464,7 @@ static void raid5_end_write_request(struct bio *bi, int error)
 	}
 	rdev_dec_pending(rdev, conf->mddev);
 
-	if (sh->batch_head && !uptodate && !replacement)
+	if (sh->batch_head && bi->bi_error && !replacement)
 		set_bit(STRIPE_BATCH_ERR, &sh->batch_head->state);
 
 	if (!test_and_clear_bit(R5_DOUBLE_LOCKED, &sh->dev[i].flags))
@@ -3107,7 +3105,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		while (bi && bi->bi_iter.bi_sector <
 			sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *nextbi = r5_next_bio(bi, sh->dev[i].sector);
-			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+
+			bi->bi_error = -EIO;
 			if (!raid5_dec_bi_active_stripes(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
@@ -3131,7 +3130,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 		while (bi && bi->bi_iter.bi_sector <
 		       sh->dev[i].sector + STRIPE_SECTORS) {
 			struct bio *bi2 = r5_next_bio(bi, sh->dev[i].sector);
-			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+
+			bi->bi_error = -EIO;
 			if (!raid5_dec_bi_active_stripes(bi)) {
 				md_write_end(conf->mddev);
 				bi->bi_next = *return_bi;
@@ -3156,7 +3156,8 @@ handle_failed_stripe(struct r5conf *conf, struct stripe_head *sh,
 			       sh->dev[i].sector + STRIPE_SECTORS) {
 				struct bio *nextbi =
 					r5_next_bio(bi, sh->dev[i].sector);
-				clear_bit(BIO_UPTODATE, &bi->bi_flags);
+
+				bi->bi_error = -EIO;
 				if (!raid5_dec_bi_active_stripes(bi)) {
 					bi->bi_next = *return_bi;
 					*return_bi = bi;
@@ -4749,12 +4750,11 @@ static struct bio *remove_bio_from_retry(struct r5conf *conf)
  *  first).
  *  If the read failed..
  */
-static void raid5_align_endio(struct bio *bi, int error)
+static void raid5_align_endio(struct bio *bi)
 {
 	struct bio* raid_bi  = bi->bi_private;
 	struct mddev *mddev;
 	struct r5conf *conf;
-	int uptodate = test_bit(BIO_UPTODATE, &bi->bi_flags);
 	struct md_rdev *rdev;
 
 	bio_put(bi);
@@ -4766,10 +4766,10 @@ static void raid5_align_endio(struct bio *bi, int error)
 
 	rdev_dec_pending(rdev, conf->mddev);
 
-	if (!error && uptodate) {
+	if (!bi->bi_error) {
 		trace_block_bio_complete(bdev_get_queue(raid_bi->bi_bdev),
 					 raid_bi, 0);
-		bio_endio(raid_bi, 0);
+		bio_endio(raid_bi);
 		if (atomic_dec_and_test(&conf->active_aligned_reads))
 			wake_up(&conf->wait_for_quiescent);
 		return;
@@ -5133,7 +5133,7 @@ static void make_discard_request(struct mddev *mddev, struct bio *bi)
 	remaining = raid5_dec_bi_active_stripes(bi);
 	if (remaining == 0) {
 		md_write_end(mddev);
-		bio_endio(bi, 0);
+		bio_endio(bi);
 	}
 }
 
@@ -5297,7 +5297,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 			release_stripe_plug(mddev, sh);
 		} else {
 			/* cannot get stripe for read-ahead, just give-up */
-			clear_bit(BIO_UPTODATE, &bi->bi_flags);
+			bi->bi_error = -EIO;
 			break;
 		}
 	}
@@ -5311,7 +5311,7 @@ static void make_request(struct mddev *mddev, struct bio * bi)
 
 		trace_block_bio_complete(bdev_get_queue(bi->bi_bdev),
 					 bi, 0);
-		bio_endio(bi, 0);
+		bio_endio(bi);
 	}
 }
 
@@ -5707,7 +5707,7 @@ static int  retry_aligned_read(struct r5conf *conf, struct bio *raid_bio)
 	if (remaining == 0) {
 		trace_block_bio_complete(bdev_get_queue(raid_bio->bi_bdev),
 					 raid_bio, 0);
-		bio_endio(raid_bio, 0);
+		bio_endio(raid_bio);
 	}
 	if (atomic_dec_and_test(&conf->active_aligned_reads))
 		wake_up(&conf->wait_for_quiescent);
diff --git a/drivers/nvdimm/blk.c b/drivers/nvdimm/blk.c
index 4f97b24..0df77cb 100644
--- a/drivers/nvdimm/blk.c
+++ b/drivers/nvdimm/blk.c
@@ -180,7 +180,7 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 	 * another kernel subsystem, and we just pass it through.
 	 */
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
-		err = -EIO;
+		bio->bi_error = -EIO;
 		goto out;
 	}
 
@@ -199,6 +199,7 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
 					(unsigned long long) iter.bi_sector, len);
+			bio->bi_error = err;
 			break;
 		}
 	}
@@ -206,7 +207,7 @@ static void nd_blk_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
  out:
-	bio_endio(bio, err);
+	bio_endio(bio);
 }
 
 static int nd_blk_rw_bytes(struct nd_namespace_common *ndns,
diff --git a/drivers/nvdimm/btt.c b/drivers/nvdimm/btt.c
index 411c7b2..341202e 100644
--- a/drivers/nvdimm/btt.c
+++ b/drivers/nvdimm/btt.c
@@ -1189,7 +1189,7 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 	 * another kernel subsystem, and we just pass it through.
 	 */
 	if (bio_integrity_enabled(bio) && bio_integrity_prep(bio)) {
-		err = -EIO;
+		bio->bi_error = -EIO;
 		goto out;
 	}
 
@@ -1211,6 +1211,7 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 					"io error in %s sector %lld, len %d,\n",
 					(rw == READ) ? "READ" : "WRITE",
 					(unsigned long long) iter.bi_sector, len);
+			bio->bi_error = err;
 			break;
 		}
 	}
@@ -1218,7 +1219,7 @@ static void btt_make_request(struct request_queue *q, struct bio *bio)
 		nd_iostat_end(bio, start);
 
 out:
-	bio_endio(bio, err);
+	bio_endio(bio);
 }
 
 static int btt_rw_page(struct block_device *bdev, sector_t sector,
diff --git a/drivers/nvdimm/pmem.c b/drivers/nvdimm/pmem.c
index ade9eb9..4c079d5 100644
--- a/drivers/nvdimm/pmem.c
+++ b/drivers/nvdimm/pmem.c
@@ -77,7 +77,7 @@ static void pmem_make_request(struct request_queue *q, struct bio *bio)
 	if (bio_data_dir(bio))
 		wmb_pmem();
 
-	bio_endio(bio, 0);
+	bio_endio(bio);
 }
 
 static int pmem_rw_page(struct block_device *bdev, sector_t sector,
diff --git a/drivers/s390/block/dcssblk.c b/drivers/s390/block/dcssblk.c
index da21281..8bcb822 100644
--- a/drivers/s390/block/dcssblk.c
+++ b/drivers/s390/block/dcssblk.c
@@ -871,7 +871,7 @@ dcssblk_make_request(struct request_queue *q, struct bio *bio)
 		}
 		bytes_done += bvec.bv_len;
 	}
-	bio_endio(bio, 0);
+	bio_endio(bio);
 	return;
 fail:
 	bio_io_error(bio);
diff --git a/drivers/s390/block/xpram.c b/drivers/s390/block/xpram.c
index 7d4e939..93856b9 100644
--- a/drivers/s390/block/xpram.c
+++ b/drivers/s390/block/xpram.c
@@ -220,8 +220,7 @@ static void xpram_make_request(struct request_queue *q, struct bio *bio)
 			index++;
 		}
 	}
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
-	bio_endio(bio, 0);
+	bio_endio(bio);
 	return;
 fail:
 	bio_io_error(bio);
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 6d88d24..5a9982f 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -306,20 +306,13 @@ static void iblock_complete_cmd(struct se_cmd *cmd)
 	kfree(ibr);
 }
 
-static void iblock_bio_done(struct bio *bio, int err)
+static void iblock_bio_done(struct bio *bio)
 {
 	struct se_cmd *cmd = bio->bi_private;
 	struct iblock_req *ibr = cmd->priv;
 
-	/*
-	 * Set -EIO if !BIO_UPTODATE and the passed is still err=0
-	 */
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags) && !err)
-		err = -EIO;
-
-	if (err != 0) {
-		pr_err("test_bit(BIO_UPTODATE) failed for bio: %p,"
-			" err: %d\n", bio, err);
+	if (bio->bi_error) {
+		pr_err("bio error: %p,  err: %d\n", bio, bio->bi_error);
 		/*
 		 * Bump the ib_bio_err_cnt and release bio.
 		 */
@@ -370,15 +363,15 @@ static void iblock_submit_bios(struct bio_list *list, int rw)
 	blk_finish_plug(&plug);
 }
 
-static void iblock_end_io_flush(struct bio *bio, int err)
+static void iblock_end_io_flush(struct bio *bio)
 {
 	struct se_cmd *cmd = bio->bi_private;
 
-	if (err)
-		pr_err("IBLOCK: cache flush failed: %d\n", err);
+	if (bio->bi_error)
+		pr_err("IBLOCK: cache flush failed: %d\n", bio->bi_error);
 
 	if (cmd) {
-		if (err)
+		if (bio->bi_error)
 			target_complete_cmd(cmd, SAM_STAT_CHECK_CONDITION);
 		else
 			target_complete_cmd(cmd, SAM_STAT_GOOD);
diff --git a/drivers/target/target_core_pscsi.c b/drivers/target/target_core_pscsi.c
index 08e9084..de18790 100644
--- a/drivers/target/target_core_pscsi.c
+++ b/drivers/target/target_core_pscsi.c
@@ -852,7 +852,7 @@ static ssize_t pscsi_show_configfs_dev_params(struct se_device *dev, char *b)
 	return bl;
 }
 
-static void pscsi_bi_endio(struct bio *bio, int error)
+static void pscsi_bi_endio(struct bio *bio)
 {
 	bio_put(bio);
 }
@@ -973,7 +973,7 @@ fail:
 	while (*hbio) {
 		bio = *hbio;
 		*hbio = (*hbio)->bi_next;
-		bio_endio(bio, 0);	/* XXX: should be error */
+		bio_endio(bio);
 	}
 	return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 }
@@ -1061,7 +1061,7 @@ fail_free_bio:
 	while (hbio) {
 		struct bio *bio = hbio;
 		hbio = hbio->bi_next;
-		bio_endio(bio, 0);	/* XXX: should be error */
+		bio_endio(bio);
 	}
 	ret = TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
 fail:
diff --git a/fs/btrfs/check-integrity.c b/fs/btrfs/check-integrity.c
index ce7dec8..541fbfa 100644
--- a/fs/btrfs/check-integrity.c
+++ b/fs/btrfs/check-integrity.c
@@ -343,7 +343,7 @@ static int btrfsic_process_written_superblock(
 		struct btrfsic_state *state,
 		struct btrfsic_block *const block,
 		struct btrfs_super_block *const super_hdr);
-static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status);
+static void btrfsic_bio_end_io(struct bio *bp);
 static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate);
 static int btrfsic_is_block_ref_by_superblock(const struct btrfsic_state *state,
 					      const struct btrfsic_block *block,
@@ -2207,7 +2207,7 @@ continue_loop:
 	goto again;
 }
 
-static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
+static void btrfsic_bio_end_io(struct bio *bp)
 {
 	struct btrfsic_block *block = (struct btrfsic_block *)bp->bi_private;
 	int iodone_w_error;
@@ -2215,7 +2215,7 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 	/* mutex is not held! This is not save if IO is not yet completed
 	 * on umount */
 	iodone_w_error = 0;
-	if (bio_error_status)
+	if (bp->bi_error)
 		iodone_w_error = 1;
 
 	BUG_ON(NULL == block);
@@ -2230,7 +2230,7 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 		     BTRFSIC_PRINT_MASK_END_IO_BIO_BH))
 			printk(KERN_INFO
 			       "bio_end_io(err=%d) for %c @%llu (%s/%llu/%d)\n",
-			       bio_error_status,
+			       bp->bi_error,
 			       btrfsic_get_block_type(dev_state->state, block),
 			       block->logical_bytenr, dev_state->name,
 			       block->dev_bytenr, block->mirror_num);
@@ -2252,7 +2252,7 @@ static void btrfsic_bio_end_io(struct bio *bp, int bio_error_status)
 		block = next_block;
 	} while (NULL != block);
 
-	bp->bi_end_io(bp, bio_error_status);
+	bp->bi_end_io(bp);
 }
 
 static void btrfsic_bh_end_io(struct buffer_head *bh, int uptodate)
diff --git a/fs/btrfs/compression.c b/fs/btrfs/compression.c
index ce62324..302266e 100644
--- a/fs/btrfs/compression.c
+++ b/fs/btrfs/compression.c
@@ -152,7 +152,7 @@ fail:
  * The compressed pages are freed here, and it must be run
  * in process context
  */
-static void end_compressed_bio_read(struct bio *bio, int err)
+static void end_compressed_bio_read(struct bio *bio)
 {
 	struct compressed_bio *cb = bio->bi_private;
 	struct inode *inode;
@@ -160,7 +160,7 @@ static void end_compressed_bio_read(struct bio *bio, int err)
 	unsigned long index;
 	int ret;
 
-	if (err)
+	if (bio->bi_error)
 		cb->errors = 1;
 
 	/* if there are more bios still pending for this compressed
@@ -210,7 +210,7 @@ csum_failed:
 		bio_for_each_segment_all(bvec, cb->orig_bio, i)
 			SetPageChecked(bvec->bv_page);
 
-		bio_endio(cb->orig_bio, 0);
+		bio_endio(cb->orig_bio);
 	}
 
 	/* finally free the cb struct */
@@ -266,7 +266,7 @@ static noinline void end_compressed_writeback(struct inode *inode,
  * This also calls the writeback end hooks for the file pages so that
  * metadata and checksums can be updated in the file.
  */
-static void end_compressed_bio_write(struct bio *bio, int err)
+static void end_compressed_bio_write(struct bio *bio)
 {
 	struct extent_io_tree *tree;
 	struct compressed_bio *cb = bio->bi_private;
@@ -274,7 +274,7 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 	struct page *page;
 	unsigned long index;
 
-	if (err)
+	if (bio->bi_error)
 		cb->errors = 1;
 
 	/* if there are more bios still pending for this compressed
@@ -293,7 +293,7 @@ static void end_compressed_bio_write(struct bio *bio, int err)
 					 cb->start,
 					 cb->start + cb->len - 1,
 					 NULL,
-					 err ? 0 : 1);
+					 bio->bi_error ? 0 : 1);
 	cb->compressed_pages[0]->mapping = NULL;
 
 	end_compressed_writeback(inode, cb);
@@ -697,8 +697,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 
 			ret = btrfs_map_bio(root, READ, comp_bio,
 					    mirror_num, 0);
-			if (ret)
-				bio_endio(comp_bio, ret);
+			if (ret) {
+				bio->bi_error = ret;
+				bio_endio(comp_bio);
+			}
 
 			bio_put(comp_bio);
 
@@ -724,8 +726,10 @@ int btrfs_submit_compressed_read(struct inode *inode, struct bio *bio,
 	}
 
 	ret = btrfs_map_bio(root, READ, comp_bio, mirror_num, 0);
-	if (ret)
-		bio_endio(comp_bio, ret);
+	if (ret) {
+		bio->bi_error = ret;
+		bio_endio(comp_bio);
+	}
 
 	bio_put(comp_bio);
 	return 0;
diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index a9aadb2..a8c0de8 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -703,7 +703,7 @@ static int btree_io_failed_hook(struct page *page, int failed_mirror)
 	return -EIO;	/* we fixed nothing */
 }
 
-static void end_workqueue_bio(struct bio *bio, int err)
+static void end_workqueue_bio(struct bio *bio)
 {
 	struct btrfs_end_io_wq *end_io_wq = bio->bi_private;
 	struct btrfs_fs_info *fs_info;
@@ -711,7 +711,7 @@ static void end_workqueue_bio(struct bio *bio, int err)
 	btrfs_work_func_t func;
 
 	fs_info = end_io_wq->info;
-	end_io_wq->error = err;
+	end_io_wq->error = bio->bi_error;
 
 	if (bio->bi_rw & REQ_WRITE) {
 		if (end_io_wq->metadata == BTRFS_WQ_ENDIO_METADATA) {
@@ -808,7 +808,8 @@ static void run_one_async_done(struct btrfs_work *work)
 
 	/* If an error occured we just want to clean up the bio and move on */
 	if (async->error) {
-		bio_endio(async->bio, async->error);
+		async->bio->bi_error = async->error;
+		bio_endio(async->bio);
 		return;
 	}
 
@@ -908,8 +909,10 @@ static int __btree_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 	 * submission context.  Just jump into btrfs_map_bio
 	 */
 	ret = btrfs_map_bio(BTRFS_I(inode)->root, rw, bio, mirror_num, 1);
-	if (ret)
-		bio_endio(bio, ret);
+	if (ret) {
+		bio->bi_error = ret;
+		bio_endio(bio);
+	}
 	return ret;
 }
 
@@ -960,10 +963,13 @@ static int btree_submit_bio_hook(struct inode *inode, int rw, struct bio *bio,
 					  __btree_submit_bio_done);
 	}
 
-	if (ret) {
+	if (ret)
+		goto out_w_error;
+	return 0;
+
 out_w_error:
-		bio_endio(bio, ret);
-	}
+	bio->bi_error = ret;
+	bio_endio(bio);
 	return ret;
 }
 
@@ -1735,16 +1741,15 @@ static void end_workqueue_fn(struct btrfs_work *work)
 {
 	struct bio *bio;
 	struct btrfs_end_io_wq *end_io_wq;
-	int error;
 
 	end_io_wq = container_of(work, struct btrfs_end_io_wq, work);
 	bio = end_io_wq->bio;
 
-	error = end_io_wq->error;
+	bio->bi_error = end_io_wq->error;
 	bio->bi_private = end_io_wq->private;
 	bio->bi_end_io = end_io_wq->end_io;
 	kmem_cache_free(btrfs_end_io_wq_cache, end_io_wq);
-	bio_endio(bio, error);
+	bio_endio(bio);
 }
 
 static int cleaner_kthread(void *arg)
@@ -3323,10 +3328,8 @@ static int write_dev_supers(struct btrfs_device *device,
  * endio for the write_dev_flush, this will wake anyone waiting
  * for the barrier when it is done
  */
-static void btrfs_end_empty_barrier(struct bio *bio, int err)
+static void btrfs_end_empty_barrier(struct bio *bio)
 {
-	if (err)
-		clear_bit(BIO_UPTODATE, &bio->bi_flags);
 	if (bio->bi_private)
 		complete(bio->bi_private);
 	bio_put(bio);
@@ -3354,8 +3357,8 @@ static int write_dev_flush(struct btrfs_device *device, int wait)
 
 		wait_for_completion(&device->flush_wait);
 
-		if (!bio_flagged(bio, BIO_UPTODATE)) {
-			ret = -EIO;
+		if (bio->bi_error) {
+			ret = bio->bi_error;
 			btrfs_dev_stat_inc_and_print(device,
 				BTRFS_DEV_STAT_FLUSH_ERRS);
 		}
diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 02d0581..c22f175 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -2486,7 +2486,7 @@ int end_extent_writepage(struct page *page, int err, u64 start, u64 end)
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_writepage(struct bio *bio, int err)
+static void end_bio_extent_writepage(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	u64 start;
@@ -2516,7 +2516,7 @@ static void end_bio_extent_writepage(struct bio *bio, int err)
 		start = page_offset(page);
 		end = start + bvec->bv_offset + bvec->bv_len - 1;
 
-		if (end_extent_writepage(page, err, start, end))
+		if (end_extent_writepage(page, bio->bi_error, start, end))
 			continue;
 
 		end_page_writeback(page);
@@ -2548,10 +2548,10 @@ endio_readpage_release_extent(struct extent_io_tree *tree, u64 start, u64 len,
  * Scheduling is not allowed, so the extent state tree is expected
  * to have one and only one object corresponding to this IO.
  */
-static void end_bio_extent_readpage(struct bio *bio, int err)
+static void end_bio_extent_readpage(struct bio *bio)
 {
 	struct bio_vec *bvec;
-	int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
+	int uptodate = !bio->bi_error;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
 	struct extent_io_tree *tree;
 	u64 offset = 0;
@@ -2564,16 +2564,13 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 	int ret;
 	int i;
 
-	if (err)
-		uptodate = 0;
-
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 		struct inode *inode = page->mapping->host;
 
 		pr_debug("end_bio_extent_readpage: bi_sector=%llu, err=%d, "
-			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector, err,
-			 io_bio->mirror_num);
+			 "mirror=%u\n", (u64)bio->bi_iter.bi_sector,
+			 bio->bi_error, io_bio->mirror_num);
 		tree = &BTRFS_I(inode)->io_tree;
 
 		/* We always issue full-page reads, but if some block
@@ -2614,8 +2611,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 
 		if (tree->ops && tree->ops->readpage_io_failed_hook) {
 			ret = tree->ops->readpage_io_failed_hook(page, mirror);
-			if (!ret && !err &&
-			    test_bit(BIO_UPTODATE, &bio->bi_flags))
+			if (!ret && !bio->bi_error)
 				uptodate = 1;
 		} else {
 			/*
@@ -2631,10 +2627,7 @@ static void end_bio_extent_readpage(struct bio *bio, int err)
 			ret = bio_readpage_error(bio, offset, page, start, end,
 						 mirror);
 			if (ret == 0) {
-				uptodate =
-					test_bit(BIO_UPTODATE, &bio->bi_flags);
-				if (err)
-					uptodate = 0;
+				uptodate = !bio->bi_error;
 				offset += len;
 				continue;
 			}
@@ -2684,7 +2677,7 @@ readpage_ok:
 		endio_readpage_release_extent(tree, extent_start, extent_len,
 					      uptodate);
 	if (io_bio->end_io)
-		io_bio->end_io(io_bio, err);
+		io_bio->end_io(io_bio, bio->bi_error);
 	bio_put(bio);
 }
 
@@ -3696,7 +3689,7 @@ static void set_btree_ioerr(struct page *page)
 	}
 }
 
-static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
+static void end_bio_extent_buffer_writepage(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	struct extent_buffer *eb;
@@ -3709,7 +3702,8 @@ static void end_bio_extent_buffer_writepage(struct bio *bio, int err)
 		BUG_ON(!eb);
 		done = atomic_dec_and_test(&eb->io_pages);
 
-		if (err || test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
+		if (bio->bi_error ||
+		    test_bit(EXTENT_BUFFER_WRITE_ERR, &eb->bflags)) {
 			ClearPageUptodate(page);
 			set_btree_ioerr(page);
 		}
diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index b33c0cf..6b8becf 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -1845,8 +1845,10 @@ static int __btrfs_submit_bio_done(struct inode *inode, int rw, struct bio *bio,
 	int ret;
 
 	ret = btrfs_map_bio(root, rw, bio, mirror_num, 1);
-	if (ret)
-		bio_endio(bio, ret);
+	if (ret) {
+		bio->bi_error = ret;
+		bio_endio(bio);
+	}
 	return ret;
 }
 
@@ -1906,8 +1908,10 @@ mapit:
 	ret = btrfs_map_bio(root, rw, bio, mirror_num, 0);
 
 out:
-	if (ret < 0)
-		bio_endio(bio, ret);
+	if (ret < 0) {
+		bio->bi_error = ret;
+		bio_endio(bio);
+	}
 	return ret;
 }
 
@@ -7689,13 +7693,13 @@ struct btrfs_retry_complete {
 	int uptodate;
 };
 
-static void btrfs_retry_endio_nocsum(struct bio *bio, int err)
+static void btrfs_retry_endio_nocsum(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct bio_vec *bvec;
 	int i;
 
-	if (err)
+	if (bio->bi_error)
 		goto end;
 
 	done->uptodate = 1;
@@ -7744,7 +7748,7 @@ try_again:
 	return 0;
 }
 
-static void btrfs_retry_endio(struct bio *bio, int err)
+static void btrfs_retry_endio(struct bio *bio)
 {
 	struct btrfs_retry_complete *done = bio->bi_private;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
@@ -7753,7 +7757,7 @@ static void btrfs_retry_endio(struct bio *bio, int err)
 	int ret;
 	int i;
 
-	if (err)
+	if (bio->bi_error)
 		goto end;
 
 	uptodate = 1;
@@ -7836,12 +7840,13 @@ static int btrfs_subio_endio_read(struct inode *inode,
 	}
 }
 
-static void btrfs_endio_direct_read(struct bio *bio, int err)
+static void btrfs_endio_direct_read(struct bio *bio)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
 	struct bio *dio_bio;
 	struct btrfs_io_bio *io_bio = btrfs_io_bio(bio);
+	int err = bio->bi_error;
 
 	if (dip->flags & BTRFS_DIO_ORIG_BIO_SUBMITTED)
 		err = btrfs_subio_endio_read(inode, io_bio, err);
@@ -7852,17 +7857,14 @@ static void btrfs_endio_direct_read(struct bio *bio, int err)
 
 	kfree(dip);
 
-	/* If we had a csum failure make sure to clear the uptodate flag */
-	if (err)
-		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
-	dio_end_io(dio_bio, err);
+	dio_end_io(dio_bio, bio->bi_error);
 
 	if (io_bio->end_io)
 		io_bio->end_io(io_bio, err);
 	bio_put(bio);
 }
 
-static void btrfs_endio_direct_write(struct bio *bio, int err)
+static void btrfs_endio_direct_write(struct bio *bio)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
 	struct inode *inode = dip->inode;
@@ -7876,7 +7878,8 @@ static void btrfs_endio_direct_write(struct bio *bio, int err)
 again:
 	ret = btrfs_dec_test_first_ordered_pending(inode, &ordered,
 						   &ordered_offset,
-						   ordered_bytes, !err);
+						   ordered_bytes,
+						   !bio->bi_error);
 	if (!ret)
 		goto out_test;
 
@@ -7899,10 +7902,7 @@ out_test:
 
 	kfree(dip);
 
-	/* If we had an error make sure to clear the uptodate flag */
-	if (err)
-		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
-	dio_end_io(dio_bio, err);
+	dio_end_io(dio_bio, bio->bi_error);
 	bio_put(bio);
 }
 
@@ -7917,9 +7917,10 @@ static int __btrfs_submit_bio_start_direct_io(struct inode *inode, int rw,
 	return 0;
 }
 
-static void btrfs_end_dio_bio(struct bio *bio, int err)
+static void btrfs_end_dio_bio(struct bio *bio)
 {
 	struct btrfs_dio_private *dip = bio->bi_private;
+	int err = bio->bi_error;
 
 	if (err)
 		btrfs_warn(BTRFS_I(dip->inode)->root->fs_info,
@@ -7948,8 +7949,8 @@ static void btrfs_end_dio_bio(struct bio *bio, int err)
 	if (dip->errors) {
 		bio_io_error(dip->orig_bio);
 	} else {
-		set_bit(BIO_UPTODATE, &dip->dio_bio->bi_flags);
-		bio_endio(dip->orig_bio, 0);
+		dip->dio_bio->bi_error = 0;
+		bio_endio(dip->orig_bio);
 	}
 out:
 	bio_put(bio);
@@ -8220,7 +8221,8 @@ free_ordered:
 	 * callbacks - they require an allocated dip and a clone of dio_bio.
 	 */
 	if (io_bio && dip) {
-		bio_endio(io_bio, ret);
+		io_bio->bi_error = -EIO;
+		bio_endio(io_bio);
 		/*
 		 * The end io callbacks free our dip, do the final put on io_bio
 		 * and all the cleanup and final put for dio_bio (through
@@ -8247,7 +8249,7 @@ free_ordered:
 			unlock_extent(&BTRFS_I(inode)->io_tree, file_offset,
 			      file_offset + dio_bio->bi_iter.bi_size - 1);
 		}
-		clear_bit(BIO_UPTODATE, &dio_bio->bi_flags);
+		dio_bio->bi_error = -EIO;
 		/*
 		 * Releases and cleans up our dio_bio, no need to bio_put()
 		 * nor bio_endio()/bio_io_error() against dio_bio.
diff --git a/fs/btrfs/raid56.c b/fs/btrfs/raid56.c
index fa72068..0a02e24 100644
--- a/fs/btrfs/raid56.c
+++ b/fs/btrfs/raid56.c
@@ -851,7 +851,7 @@ static void free_raid_bio(struct btrfs_raid_bio *rbio)
  * this frees the rbio and runs through all the bios in the
  * bio_list and calls end_io on them
  */
-static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err, int uptodate)
+static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err)
 {
 	struct bio *cur = bio_list_get(&rbio->bio_list);
 	struct bio *next;
@@ -864,9 +864,8 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err, int uptodate)
 	while (cur) {
 		next = cur->bi_next;
 		cur->bi_next = NULL;
-		if (uptodate)
-			set_bit(BIO_UPTODATE, &cur->bi_flags);
-		bio_endio(cur, err);
+		cur->bi_error = err;
+		bio_endio(cur);
 		cur = next;
 	}
 }
@@ -875,9 +874,10 @@ static void rbio_orig_end_io(struct btrfs_raid_bio *rbio, int err, int uptodate)
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
-static void raid_write_end_io(struct bio *bio, int err)
+static void raid_write_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
+	int err = bio->bi_error;
 
 	if (err)
 		fail_bio_stripe(rbio, bio);
@@ -893,7 +893,7 @@ static void raid_write_end_io(struct bio *bio, int err)
 	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
 		err = -EIO;
 
-	rbio_orig_end_io(rbio, err, 0);
+	rbio_orig_end_io(rbio, err);
 	return;
 }
 
@@ -1071,7 +1071,7 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 		 * devices or if they are not contiguous
 		 */
 		if (last_end == disk_start && stripe->dev->bdev &&
-		    test_bit(BIO_UPTODATE, &last->bi_flags) &&
+		    !last->bi_error &&
 		    last->bi_bdev == stripe->dev->bdev) {
 			ret = bio_add_page(last, page, PAGE_CACHE_SIZE, 0);
 			if (ret == PAGE_CACHE_SIZE)
@@ -1087,7 +1087,6 @@ static int rbio_add_io_page(struct btrfs_raid_bio *rbio,
 	bio->bi_iter.bi_size = 0;
 	bio->bi_bdev = stripe->dev->bdev;
 	bio->bi_iter.bi_sector = disk_start >> 9;
-	set_bit(BIO_UPTODATE, &bio->bi_flags);
 
 	bio_add_page(bio, page, PAGE_CACHE_SIZE, 0);
 	bio_list_add(bio_list, bio);
@@ -1312,13 +1311,12 @@ write_data:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_end_io;
-		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
 		submit_bio(WRITE, bio);
 	}
 	return;
 
 cleanup:
-	rbio_orig_end_io(rbio, -EIO, 0);
+	rbio_orig_end_io(rbio, -EIO);
 }
 
 /*
@@ -1441,11 +1439,11 @@ static void set_bio_pages_uptodate(struct bio *bio)
  * This will usually kick off finish_rmw once all the bios are read in, but it
  * may trigger parity reconstruction if we had any errors along the way
  */
-static void raid_rmw_end_io(struct bio *bio, int err)
+static void raid_rmw_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
-	if (err)
+	if (bio->bi_error)
 		fail_bio_stripe(rbio, bio);
 	else
 		set_bio_pages_uptodate(bio);
@@ -1455,7 +1453,6 @@ static void raid_rmw_end_io(struct bio *bio, int err)
 	if (!atomic_dec_and_test(&rbio->stripes_pending))
 		return;
 
-	err = 0;
 	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
 		goto cleanup;
 
@@ -1469,7 +1466,7 @@ static void raid_rmw_end_io(struct bio *bio, int err)
 
 cleanup:
 
-	rbio_orig_end_io(rbio, -EIO, 0);
+	rbio_orig_end_io(rbio, -EIO);
 }
 
 static void async_rmw_stripe(struct btrfs_raid_bio *rbio)
@@ -1572,14 +1569,13 @@ static int raid56_rmw_stripe(struct btrfs_raid_bio *rbio)
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
 		submit_bio(READ, bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return 0;
 
 cleanup:
-	rbio_orig_end_io(rbio, -EIO, 0);
+	rbio_orig_end_io(rbio, -EIO);
 	return -EIO;
 
 finish:
@@ -1964,7 +1960,7 @@ cleanup_io:
 		else
 			clear_bit(RBIO_CACHE_READY_BIT, &rbio->flags);
 
-		rbio_orig_end_io(rbio, err, err == 0);
+		rbio_orig_end_io(rbio, err);
 	} else if (err == 0) {
 		rbio->faila = -1;
 		rbio->failb = -1;
@@ -1976,7 +1972,7 @@ cleanup_io:
 		else
 			BUG();
 	} else {
-		rbio_orig_end_io(rbio, err, 0);
+		rbio_orig_end_io(rbio, err);
 	}
 }
 
@@ -1984,7 +1980,7 @@ cleanup_io:
  * This is called only for stripes we've read from disk to
  * reconstruct the parity.
  */
-static void raid_recover_end_io(struct bio *bio, int err)
+static void raid_recover_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
@@ -1992,7 +1988,7 @@ static void raid_recover_end_io(struct bio *bio, int err)
 	 * we only read stripe pages off the disk, set them
 	 * up to date if there were no errors
 	 */
-	if (err)
+	if (bio->bi_error)
 		fail_bio_stripe(rbio, bio);
 	else
 		set_bio_pages_uptodate(bio);
@@ -2002,7 +1998,7 @@ static void raid_recover_end_io(struct bio *bio, int err)
 		return;
 
 	if (atomic_read(&rbio->error) > rbio->bbio->max_errors)
-		rbio_orig_end_io(rbio, -EIO, 0);
+		rbio_orig_end_io(rbio, -EIO);
 	else
 		__raid_recover_end_io(rbio);
 }
@@ -2094,7 +2090,6 @@ static int __raid56_parity_recover(struct btrfs_raid_bio *rbio)
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
 		submit_bio(READ, bio);
 	}
 out:
@@ -2102,7 +2097,7 @@ out:
 
 cleanup:
 	if (rbio->operation == BTRFS_RBIO_READ_REBUILD)
-		rbio_orig_end_io(rbio, -EIO, 0);
+		rbio_orig_end_io(rbio, -EIO);
 	return -EIO;
 }
 
@@ -2277,11 +2272,12 @@ static int alloc_rbio_essential_pages(struct btrfs_raid_bio *rbio)
  * end io function used by finish_rmw.  When we finally
  * get here, we've written a full stripe
  */
-static void raid_write_parity_end_io(struct bio *bio, int err)
+static void raid_write_parity_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
+	int err = bio->bi_error;
 
-	if (err)
+	if (bio->bi_error)
 		fail_bio_stripe(rbio, bio);
 
 	bio_put(bio);
@@ -2294,7 +2290,7 @@ static void raid_write_parity_end_io(struct bio *bio, int err)
 	if (atomic_read(&rbio->error))
 		err = -EIO;
 
-	rbio_orig_end_io(rbio, err, 0);
+	rbio_orig_end_io(rbio, err);
 }
 
 static noinline void finish_parity_scrub(struct btrfs_raid_bio *rbio,
@@ -2437,7 +2433,7 @@ submit_write:
 	nr_data = bio_list_size(&bio_list);
 	if (!nr_data) {
 		/* Every parity is right */
-		rbio_orig_end_io(rbio, 0, 0);
+		rbio_orig_end_io(rbio, 0);
 		return;
 	}
 
@@ -2450,13 +2446,12 @@ submit_write:
 
 		bio->bi_private = rbio;
 		bio->bi_end_io = raid_write_parity_end_io;
-		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
 		submit_bio(WRITE, bio);
 	}
 	return;
 
 cleanup:
-	rbio_orig_end_io(rbio, -EIO, 0);
+	rbio_orig_end_io(rbio, -EIO);
 }
 
 static inline int is_data_stripe(struct btrfs_raid_bio *rbio, int stripe)
@@ -2524,7 +2519,7 @@ static void validate_rbio_for_parity_scrub(struct btrfs_raid_bio *rbio)
 	return;
 
 cleanup:
-	rbio_orig_end_io(rbio, -EIO, 0);
+	rbio_orig_end_io(rbio, -EIO);
 }
 
 /*
@@ -2535,11 +2530,11 @@ cleanup:
  * This will usually kick off finish_rmw once all the bios are read in, but it
  * may trigger parity reconstruction if we had any errors along the way
  */
-static void raid56_parity_scrub_end_io(struct bio *bio, int err)
+static void raid56_parity_scrub_end_io(struct bio *bio)
 {
 	struct btrfs_raid_bio *rbio = bio->bi_private;
 
-	if (err)
+	if (bio->bi_error)
 		fail_bio_stripe(rbio, bio);
 	else
 		set_bio_pages_uptodate(bio);
@@ -2632,14 +2627,13 @@ static void raid56_parity_scrub_stripe(struct btrfs_raid_bio *rbio)
 		btrfs_bio_wq_end_io(rbio->fs_info, bio,
 				    BTRFS_WQ_ENDIO_RAID56);
 
-		BUG_ON(!test_bit(BIO_UPTODATE, &bio->bi_flags));
 		submit_bio(READ, bio);
 	}
 	/* the actual write will happen once the reads are done */
 	return;
 
 cleanup:
-	rbio_orig_end_io(rbio, -EIO, 0);
+	rbio_orig_end_io(rbio, -EIO);
 	return;
 
 finish:
diff --git a/fs/btrfs/scrub.c b/fs/btrfs/scrub.c
index 94db0fa..ebb8260 100644
--- a/fs/btrfs/scrub.c
+++ b/fs/btrfs/scrub.c
@@ -278,7 +278,7 @@ static int scrub_pages(struct scrub_ctx *sctx, u64 logical, u64 len,
 		       u64 physical, struct btrfs_device *dev, u64 flags,
 		       u64 gen, int mirror_num, u8 *csum, int force,
 		       u64 physical_for_dev_replace);
-static void scrub_bio_end_io(struct bio *bio, int err);
+static void scrub_bio_end_io(struct bio *bio);
 static void scrub_bio_end_io_worker(struct btrfs_work *work);
 static void scrub_block_complete(struct scrub_block *sblock);
 static void scrub_remap_extent(struct btrfs_fs_info *fs_info,
@@ -295,7 +295,7 @@ static void scrub_free_wr_ctx(struct scrub_wr_ctx *wr_ctx);
 static int scrub_add_page_to_wr_bio(struct scrub_ctx *sctx,
 				    struct scrub_page *spage);
 static void scrub_wr_submit(struct scrub_ctx *sctx);
-static void scrub_wr_bio_end_io(struct bio *bio, int err);
+static void scrub_wr_bio_end_io(struct bio *bio);
 static void scrub_wr_bio_end_io_worker(struct btrfs_work *work);
 static int write_page_nocow(struct scrub_ctx *sctx,
 			    u64 physical_for_dev_replace, struct page *page);
@@ -1429,11 +1429,11 @@ struct scrub_bio_ret {
 	int error;
 };
 
-static void scrub_bio_wait_endio(struct bio *bio, int error)
+static void scrub_bio_wait_endio(struct bio *bio)
 {
 	struct scrub_bio_ret *ret = bio->bi_private;
 
-	ret->error = error;
+	ret->error = bio->bi_error;
 	complete(&ret->event);
 }
 
@@ -1790,12 +1790,12 @@ static void scrub_wr_submit(struct scrub_ctx *sctx)
 	btrfsic_submit_bio(WRITE, sbio->bio);
 }
 
-static void scrub_wr_bio_end_io(struct bio *bio, int err)
+static void scrub_wr_bio_end_io(struct bio *bio)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
 
-	sbio->err = err;
+	sbio->err = bio->bi_error;
 	sbio->bio = bio;
 
 	btrfs_init_work(&sbio->work, btrfs_scrubwrc_helper,
@@ -2098,7 +2098,7 @@ static void scrub_submit(struct scrub_ctx *sctx)
 		 */
 		printk_ratelimited(KERN_WARNING
 			"BTRFS: scrub_submit(bio bdev == NULL) is unexpected!\n");
-		bio_endio(sbio->bio, -EIO);
+		bio_io_error(sbio->bio);
 	} else {
 		btrfsic_submit_bio(READ, sbio->bio);
 	}
@@ -2260,12 +2260,12 @@ leave_nomem:
 	return 0;
 }
 
-static void scrub_bio_end_io(struct bio *bio, int err)
+static void scrub_bio_end_io(struct bio *bio)
 {
 	struct scrub_bio *sbio = bio->bi_private;
 	struct btrfs_fs_info *fs_info = sbio->dev->dev_root->fs_info;
 
-	sbio->err = err;
+	sbio->err = bio->bi_error;
 	sbio->bio = bio;
 
 	btrfs_queue_work(fs_info->scrub_workers, &sbio->work);
@@ -2672,11 +2672,11 @@ static void scrub_parity_bio_endio_worker(struct btrfs_work *work)
 	scrub_pending_bio_dec(sctx);
 }
 
-static void scrub_parity_bio_endio(struct bio *bio, int error)
+static void scrub_parity_bio_endio(struct bio *bio)
 {
 	struct scrub_parity *sparity = (struct scrub_parity *)bio->bi_private;
 
-	if (error)
+	if (bio->bi_error)
 		bitmap_or(sparity->ebitmap, sparity->ebitmap, sparity->dbitmap,
 			  sparity->nsectors);
 
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index fbe7c10..8f2ca18 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -5741,23 +5741,23 @@ int btrfs_rmap_block(struct btrfs_mapping_tree *map_tree,
 	return 0;
 }
 
-static inline void btrfs_end_bbio(struct btrfs_bio *bbio, struct bio *bio, int err)
+static inline void btrfs_end_bbio(struct btrfs_bio *bbio, struct bio *bio)
 {
 	bio->bi_private = bbio->private;
 	bio->bi_end_io = bbio->end_io;
-	bio_endio(bio, err);
+	bio_endio(bio);
 
 	btrfs_put_bbio(bbio);
 }
 
-static void btrfs_end_bio(struct bio *bio, int err)
+static void btrfs_end_bio(struct bio *bio)
 {
 	struct btrfs_bio *bbio = bio->bi_private;
 	int is_orig_bio = 0;
 
-	if (err) {
+	if (bio->bi_error) {
 		atomic_inc(&bbio->error);
-		if (err == -EIO || err == -EREMOTEIO) {
+		if (bio->bi_error == -EIO || bio->bi_error == -EREMOTEIO) {
 			unsigned int stripe_index =
 				btrfs_io_bio(bio)->stripe_index;
 			struct btrfs_device *dev;
@@ -5795,17 +5795,16 @@ static void btrfs_end_bio(struct bio *bio, int err)
 		 * beyond the tolerance of the btrfs bio
 		 */
 		if (atomic_read(&bbio->error) > bbio->max_errors) {
-			err = -EIO;
+			bio->bi_error = -EIO;
 		} else {
 			/*
 			 * this bio is actually up to date, we didn't
 			 * go over the max number of errors
 			 */
-			set_bit(BIO_UPTODATE, &bio->bi_flags);
-			err = 0;
+			bio->bi_error = 0;
 		}
 
-		btrfs_end_bbio(bbio, bio, err);
+		btrfs_end_bbio(bbio, bio);
 	} else if (!is_orig_bio) {
 		bio_put(bio);
 	}
@@ -5826,7 +5825,7 @@ static noinline void btrfs_schedule_bio(struct btrfs_root *root,
 	struct btrfs_pending_bios *pending_bios;
 
 	if (device->missing || !device->bdev) {
-		bio_endio(bio, -EIO);
+		bio_io_error(bio);
 		return;
 	}
 
@@ -5973,8 +5972,8 @@ static void bbio_error(struct btrfs_bio *bbio, struct bio *bio, u64 logical)
 
 		btrfs_io_bio(bio)->mirror_num = bbio->mirror_num;
 		bio->bi_iter.bi_sector = logical >> 9;
-
-		btrfs_end_bbio(bbio, bio, -EIO);
+		bio->bi_error = -EIO;
+		btrfs_end_bbio(bbio, bio);
 	}
 }
 
diff --git a/fs/buffer.c b/fs/buffer.c
index 1cf7a53..7a49bb8 100644
--- a/fs/buffer.c
+++ b/fs/buffer.c
@@ -2957,14 +2957,14 @@ sector_t generic_block_bmap(struct address_space *mapping, sector_t block,
 }
 EXPORT_SYMBOL(generic_block_bmap);
 
-static void end_bio_bh_io_sync(struct bio *bio, int err)
+static void end_bio_bh_io_sync(struct bio *bio)
 {
 	struct buffer_head *bh = bio->bi_private;
 
 	if (unlikely (test_bit(BIO_QUIET,&bio->bi_flags)))
 		set_bit(BH_Quiet, &bh->b_state);
 
-	bh->b_end_io(bh, test_bit(BIO_UPTODATE, &bio->bi_flags));
+	bh->b_end_io(bh, !bio->bi_error);
 	bio_put(bio);
 }
 
diff --git a/fs/direct-io.c b/fs/direct-io.c
index 745d234..e1639c8 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -285,7 +285,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio);
 /*
  * Asynchronous IO callback. 
  */
-static void dio_bio_end_aio(struct bio *bio, int error)
+static void dio_bio_end_aio(struct bio *bio)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long remaining;
@@ -318,7 +318,7 @@ static void dio_bio_end_aio(struct bio *bio, int error)
  * During I/O bi_private points at the dio.  After I/O, bi_private is used to
  * implement a singly-linked list of completed BIOs, at dio->bio_list.
  */
-static void dio_bio_end_io(struct bio *bio, int error)
+static void dio_bio_end_io(struct bio *bio)
 {
 	struct dio *dio = bio->bi_private;
 	unsigned long flags;
@@ -345,9 +345,9 @@ void dio_end_io(struct bio *bio, int error)
 	struct dio *dio = bio->bi_private;
 
 	if (dio->is_async)
-		dio_bio_end_aio(bio, error);
+		dio_bio_end_aio(bio);
 	else
-		dio_bio_end_io(bio, error);
+		dio_bio_end_io(bio);
 }
 EXPORT_SYMBOL_GPL(dio_end_io);
 
@@ -457,11 +457,10 @@ static struct bio *dio_await_one(struct dio *dio)
  */
 static int dio_bio_complete(struct dio *dio, struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec;
 	unsigned i;
 
-	if (!uptodate)
+	if (bio->bi_error)
 		dio->io_error = -EIO;
 
 	if (dio->is_async && dio->rw == READ) {
@@ -476,7 +475,7 @@ static int dio_bio_complete(struct dio *dio, struct bio *bio)
 		}
 		bio_put(bio);
 	}
-	return uptodate ? 0 : -EIO;
+	return bio->bi_error;
 }
 
 /*
diff --git a/fs/ext4/page-io.c b/fs/ext4/page-io.c
index 5602450..aa95566 100644
--- a/fs/ext4/page-io.c
+++ b/fs/ext4/page-io.c
@@ -61,7 +61,6 @@ static void buffer_io_error(struct buffer_head *bh)
 static void ext4_finish_bio(struct bio *bio)
 {
 	int i;
-	int error = !test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec;
 
 	bio_for_each_segment_all(bvec, bio, i) {
@@ -88,7 +87,7 @@ static void ext4_finish_bio(struct bio *bio)
 		}
 #endif
 
-		if (error) {
+		if (bio->bi_error) {
 			SetPageError(page);
 			set_bit(AS_EIO, &page->mapping->flags);
 		}
@@ -107,7 +106,7 @@ static void ext4_finish_bio(struct bio *bio)
 				continue;
 			}
 			clear_buffer_async_write(bh);
-			if (error)
+			if (bio->bi_error)
 				buffer_io_error(bh);
 		} while ((bh = bh->b_this_page) != head);
 		bit_spin_unlock(BH_Uptodate_Lock, &head->b_state);
@@ -310,27 +309,25 @@ ext4_io_end_t *ext4_get_io_end(ext4_io_end_t *io_end)
 }
 
 /* BIO completion function for page writeback */
-static void ext4_end_bio(struct bio *bio, int error)
+static void ext4_end_bio(struct bio *bio)
 {
 	ext4_io_end_t *io_end = bio->bi_private;
 	sector_t bi_sector = bio->bi_iter.bi_sector;
 
 	BUG_ON(!io_end);
 	bio->bi_end_io = NULL;
-	if (test_bit(BIO_UPTODATE, &bio->bi_flags))
-		error = 0;
 
-	if (error) {
+	if (bio->bi_error) {
 		struct inode *inode = io_end->inode;
 
 		ext4_warning(inode->i_sb, "I/O error %d writing to inode %lu "
 			     "(offset %llu size %ld starting block %llu)",
-			     error, inode->i_ino,
+			     bio->bi_error, inode->i_ino,
 			     (unsigned long long) io_end->offset,
 			     (long) io_end->size,
 			     (unsigned long long)
 			     bi_sector >> (inode->i_blkbits - 9));
-		mapping_set_error(inode->i_mapping, error);
+		mapping_set_error(inode->i_mapping, bio->bi_error);
 	}
 
 	if (io_end->flag & EXT4_IO_END_UNWRITTEN) {
diff --git a/fs/ext4/readpage.c b/fs/ext4/readpage.c
index ec3ef93..5de5b87 100644
--- a/fs/ext4/readpage.c
+++ b/fs/ext4/readpage.c
@@ -98,7 +98,7 @@ static inline bool ext4_bio_encrypted(struct bio *bio)
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io(struct bio *bio, int err)
+static void mpage_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
 	int i;
@@ -106,7 +106,7 @@ static void mpage_end_io(struct bio *bio, int err)
 	if (ext4_bio_encrypted(bio)) {
 		struct ext4_crypto_ctx *ctx = bio->bi_private;
 
-		if (err) {
+		if (bio->bi_error) {
 			ext4_release_crypto_ctx(ctx);
 		} else {
 			INIT_WORK(&ctx->r.work, completion_pages);
@@ -118,7 +118,7 @@ static void mpage_end_io(struct bio *bio, int err)
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
 
-		if (!err) {
+		if (!bio->bi_error) {
 			SetPageUptodate(page);
 		} else {
 			ClearPageUptodate(page);
diff --git a/fs/f2fs/data.c b/fs/f2fs/data.c
index 9bedfa8..8f0baa7 100644
--- a/fs/f2fs/data.c
+++ b/fs/f2fs/data.c
@@ -29,13 +29,13 @@
 static struct kmem_cache *extent_tree_slab;
 static struct kmem_cache *extent_node_slab;
 
-static void f2fs_read_end_io(struct bio *bio, int err)
+static void f2fs_read_end_io(struct bio *bio)
 {
 	struct bio_vec *bvec;
 	int i;
 
 	if (f2fs_bio_encrypted(bio)) {
-		if (err) {
+		if (bio->bi_error) {
 			f2fs_release_crypto_ctx(bio->bi_private);
 		} else {
 			f2fs_end_io_crypto_work(bio->bi_private, bio);
@@ -46,7 +46,7 @@ static void f2fs_read_end_io(struct bio *bio, int err)
 	bio_for_each_segment_all(bvec, bio, i) {
 		struct page *page = bvec->bv_page;
 
-		if (!err) {
+		if (!bio->bi_error) {
 			SetPageUptodate(page);
 		} else {
 			ClearPageUptodate(page);
@@ -57,7 +57,7 @@ static void f2fs_read_end_io(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static void f2fs_write_end_io(struct bio *bio, int err)
+static void f2fs_write_end_io(struct bio *bio)
 {
 	struct f2fs_sb_info *sbi = bio->bi_private;
 	struct bio_vec *bvec;
@@ -68,7 +68,7 @@ static void f2fs_write_end_io(struct bio *bio, int err)
 
 		f2fs_restore_and_release_control_page(&page);
 
-		if (unlikely(err)) {
+		if (unlikely(bio->bi_error)) {
 			set_page_dirty(page);
 			set_bit(AS_EIO, &page->mapping->flags);
 			f2fs_stop_checkpoint(sbi);
diff --git a/fs/gfs2/lops.c b/fs/gfs2/lops.c
index 2c1ae86..c0a1b96 100644
--- a/fs/gfs2/lops.c
+++ b/fs/gfs2/lops.c
@@ -202,22 +202,22 @@ static void gfs2_end_log_write_bh(struct gfs2_sbd *sdp, struct bio_vec *bvec,
  *
  */
 
-static void gfs2_end_log_write(struct bio *bio, int error)
+static void gfs2_end_log_write(struct bio *bio)
 {
 	struct gfs2_sbd *sdp = bio->bi_private;
 	struct bio_vec *bvec;
 	struct page *page;
 	int i;
 
-	if (error) {
-		sdp->sd_log_error = error;
-		fs_err(sdp, "Error %d writing to log\n", error);
+	if (bio->bi_error) {
+		sdp->sd_log_error = bio->bi_error;
+		fs_err(sdp, "Error %d writing to log\n", bio->bi_error);
 	}
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		page = bvec->bv_page;
 		if (page_has_buffers(page))
-			gfs2_end_log_write_bh(sdp, bvec, error);
+			gfs2_end_log_write_bh(sdp, bvec, bio->bi_error);
 		else
 			mempool_free(page, gfs2_page_pool);
 	}
diff --git a/fs/gfs2/ops_fstype.c b/fs/gfs2/ops_fstype.c
index 1e3a93f..02586e7 100644
--- a/fs/gfs2/ops_fstype.c
+++ b/fs/gfs2/ops_fstype.c
@@ -171,14 +171,14 @@ static int gfs2_check_sb(struct gfs2_sbd *sdp, int silent)
 	return -EINVAL;
 }
 
-static void end_bio_io_page(struct bio *bio, int error)
+static void end_bio_io_page(struct bio *bio)
 {
 	struct page *page = bio->bi_private;
 
-	if (!error)
+	if (!bio->bi_error)
 		SetPageUptodate(page);
 	else
-		pr_warn("error %d reading superblock\n", error);
+		pr_warn("error %d reading superblock\n", bio->bi_error);
 	unlock_page(page);
 }
 
diff --git a/fs/jfs/jfs_logmgr.c b/fs/jfs/jfs_logmgr.c
index bc462dc..d301acf 100644
--- a/fs/jfs/jfs_logmgr.c
+++ b/fs/jfs/jfs_logmgr.c
@@ -2011,7 +2011,7 @@ static int lbmRead(struct jfs_log * log, int pn, struct lbuf ** bpp)
 	/*check if journaling to disk has been disabled*/
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
-		lbmIODone(bio, 0);
+		lbmIODone(bio);
 	} else {
 		submit_bio(READ_SYNC, bio);
 	}
@@ -2158,7 +2158,7 @@ static void lbmStartIO(struct lbuf * bp)
 	/* check if journaling to disk has been disabled */
 	if (log->no_integrity) {
 		bio->bi_iter.bi_size = 0;
-		lbmIODone(bio, 0);
+		lbmIODone(bio);
 	} else {
 		submit_bio(WRITE_SYNC, bio);
 		INCREMENT(lmStat.submitted);
@@ -2196,7 +2196,7 @@ static int lbmIOWait(struct lbuf * bp, int flag)
  *
  * executed at INTIODONE level
  */
-static void lbmIODone(struct bio *bio, int error)
+static void lbmIODone(struct bio *bio)
 {
 	struct lbuf *bp = bio->bi_private;
 	struct lbuf *nextbp, *tail;
@@ -2212,7 +2212,7 @@ static void lbmIODone(struct bio *bio, int error)
 
 	bp->l_flag |= lbmDONE;
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (bio->bi_error) {
 		bp->l_flag |= lbmERROR;
 
 		jfs_err("lbmIODone: I/O error in JFS log");
diff --git a/fs/jfs/jfs_metapage.c b/fs/jfs/jfs_metapage.c
index 16a0922..a3eb316 100644
--- a/fs/jfs/jfs_metapage.c
+++ b/fs/jfs/jfs_metapage.c
@@ -276,11 +276,11 @@ static void last_read_complete(struct page *page)
 	unlock_page(page);
 }
 
-static void metapage_read_end_io(struct bio *bio, int err)
+static void metapage_read_end_io(struct bio *bio)
 {
 	struct page *page = bio->bi_private;
 
-	if (!test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (bio->bi_error) {
 		printk(KERN_ERR "metapage_read_end_io: I/O error\n");
 		SetPageError(page);
 	}
@@ -331,13 +331,13 @@ static void last_write_complete(struct page *page)
 	end_page_writeback(page);
 }
 
-static void metapage_write_end_io(struct bio *bio, int err)
+static void metapage_write_end_io(struct bio *bio)
 {
 	struct page *page = bio->bi_private;
 
 	BUG_ON(!PagePrivate(page));
 
-	if (! test_bit(BIO_UPTODATE, &bio->bi_flags)) {
+	if (bio->bi_error) {
 		printk(KERN_ERR "metapage_write_end_io: I/O error\n");
 		SetPageError(page);
 	}
diff --git a/fs/logfs/dev_bdev.c b/fs/logfs/dev_bdev.c
index 76279e1..cea0cc9 100644
--- a/fs/logfs/dev_bdev.c
+++ b/fs/logfs/dev_bdev.c
@@ -53,16 +53,14 @@ static int bdev_readpage(void *_sb, struct page *page)
 
 static DECLARE_WAIT_QUEUE_HEAD(wq);
 
-static void writeseg_end_io(struct bio *bio, int err)
+static void writeseg_end_io(struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct bio_vec *bvec;
 	int i;
 	struct super_block *sb = bio->bi_private;
 	struct logfs_super *super = logfs_super(sb);
 
-	BUG_ON(!uptodate); /* FIXME: Retry io or write elsewhere */
-	BUG_ON(err);
+	BUG_ON(bio->bi_error); /* FIXME: Retry io or write elsewhere */
 
 	bio_for_each_segment_all(bvec, bio, i) {
 		end_page_writeback(bvec->bv_page);
@@ -153,14 +151,12 @@ static void bdev_writeseg(struct super_block *sb, u64 ofs, size_t len)
 }
 
 
-static void erase_end_io(struct bio *bio, int err) 
+static void erase_end_io(struct bio *bio)
 { 
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags); 
 	struct super_block *sb = bio->bi_private; 
 	struct logfs_super *super = logfs_super(sb); 
 
-	BUG_ON(!uptodate); /* FIXME: Retry io or write elsewhere */ 
-	BUG_ON(err); 
+	BUG_ON(bio->bi_error); /* FIXME: Retry io or write elsewhere */ 
 	BUG_ON(bio->bi_vcnt == 0); 
 	bio_put(bio); 
 	if (atomic_dec_and_test(&super->s_pending_writes))
diff --git a/fs/mpage.c b/fs/mpage.c
index ca0244b..abac936 100644
--- a/fs/mpage.c
+++ b/fs/mpage.c
@@ -42,14 +42,14 @@
  * status of that page is hard.  See end_buffer_async_read() for the details.
  * There is no point in duplicating all that complexity.
  */
-static void mpage_end_io(struct bio *bio, int err)
+static void mpage_end_io(struct bio *bio)
 {
 	struct bio_vec *bv;
 	int i;
 
 	bio_for_each_segment_all(bv, bio, i) {
 		struct page *page = bv->bv_page;
-		page_endio(page, bio_data_dir(bio), err);
+		page_endio(page, bio_data_dir(bio), bio->bi_error);
 	}
 
 	bio_put(bio);
diff --git a/fs/nfs/blocklayout/blocklayout.c b/fs/nfs/blocklayout/blocklayout.c
index d2554fe..9cd4eb3 100644
--- a/fs/nfs/blocklayout/blocklayout.c
+++ b/fs/nfs/blocklayout/blocklayout.c
@@ -116,7 +116,7 @@ bl_submit_bio(int rw, struct bio *bio)
 
 static struct bio *
 bl_alloc_init_bio(int npg, struct block_device *bdev, sector_t disk_sector,
-		void (*end_io)(struct bio *, int err), struct parallel_io *par)
+		bio_end_io_t end_io, struct parallel_io *par)
 {
 	struct bio *bio;
 
@@ -139,8 +139,7 @@ bl_alloc_init_bio(int npg, struct block_device *bdev, sector_t disk_sector,
 static struct bio *
 do_add_page_to_bio(struct bio *bio, int npg, int rw, sector_t isect,
 		struct page *page, struct pnfs_block_dev_map *map,
-		struct pnfs_block_extent *be,
-		void (*end_io)(struct bio *, int err),
+		struct pnfs_block_extent *be, bio_end_io_t end_io,
 		struct parallel_io *par, unsigned int offset, int *len)
 {
 	struct pnfs_block_dev *dev =
@@ -183,11 +182,11 @@ retry:
 	return bio;
 }
 
-static void bl_end_io_read(struct bio *bio, int err)
+static void bl_end_io_read(struct bio *bio)
 {
 	struct parallel_io *par = bio->bi_private;
 
-	if (err) {
+	if (bio->bi_error) {
 		struct nfs_pgio_header *header = par->data;
 
 		if (!header->pnfs_error)
@@ -316,13 +315,12 @@ out:
 	return PNFS_ATTEMPTED;
 }
 
-static void bl_end_io_write(struct bio *bio, int err)
+static void bl_end_io_write(struct bio *bio)
 {
 	struct parallel_io *par = bio->bi_private;
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct nfs_pgio_header *header = par->data;
 
-	if (!uptodate) {
+	if (bio->bi_error) {
 		if (!header->pnfs_error)
 			header->pnfs_error = -EIO;
 		pnfs_set_lo_fail(header->lseg);
diff --git a/fs/nilfs2/segbuf.c b/fs/nilfs2/segbuf.c
index 42468e5..550b10e 100644
--- a/fs/nilfs2/segbuf.c
+++ b/fs/nilfs2/segbuf.c
@@ -338,12 +338,11 @@ void nilfs_add_checksums_on_logs(struct list_head *logs, u32 seed)
 /*
  * BIO operations
  */
-static void nilfs_end_bio_write(struct bio *bio, int err)
+static void nilfs_end_bio_write(struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct nilfs_segment_buffer *segbuf = bio->bi_private;
 
-	if (!uptodate)
+	if (bio->bi_error)
 		atomic_inc(&segbuf->sb_err);
 
 	bio_put(bio);
diff --git a/fs/ocfs2/cluster/heartbeat.c b/fs/ocfs2/cluster/heartbeat.c
index 16eff45..140de3c 100644
--- a/fs/ocfs2/cluster/heartbeat.c
+++ b/fs/ocfs2/cluster/heartbeat.c
@@ -372,14 +372,13 @@ static void o2hb_wait_on_io(struct o2hb_region *reg,
 	wait_for_completion(&wc->wc_io_complete);
 }
 
-static void o2hb_bio_end_io(struct bio *bio,
-			   int error)
+static void o2hb_bio_end_io(struct bio *bio)
 {
 	struct o2hb_bio_wait_ctxt *wc = bio->bi_private;
 
-	if (error) {
-		mlog(ML_ERROR, "IO Error %d\n", error);
-		wc->wc_error = error;
+	if (bio->bi_error) {
+		mlog(ML_ERROR, "IO Error %d\n", bio->bi_error);
+		wc->wc_error = bio->bi_error;
 	}
 
 	o2hb_bio_wait_dec(wc, 1);
diff --git a/fs/xfs/xfs_aops.c b/fs/xfs/xfs_aops.c
index 3859f5e..3714844 100644
--- a/fs/xfs/xfs_aops.c
+++ b/fs/xfs/xfs_aops.c
@@ -351,12 +351,11 @@ xfs_imap_valid(
  */
 STATIC void
 xfs_end_bio(
-	struct bio		*bio,
-	int			error)
+	struct bio		*bio)
 {
 	xfs_ioend_t		*ioend = bio->bi_private;
 
-	ioend->io_error = test_bit(BIO_UPTODATE, &bio->bi_flags) ? 0 : error;
+	ioend->io_error = bio->bi_error;
 
 	/* Toss bio and pass work off to an xfsdatad thread */
 	bio->bi_private = NULL;
diff --git a/fs/xfs/xfs_buf.c b/fs/xfs/xfs_buf.c
index a4b7d92..01bd678 100644
--- a/fs/xfs/xfs_buf.c
+++ b/fs/xfs/xfs_buf.c
@@ -1096,8 +1096,7 @@ xfs_bwrite(
 
 STATIC void
 xfs_buf_bio_end_io(
-	struct bio		*bio,
-	int			error)
+	struct bio		*bio)
 {
 	xfs_buf_t		*bp = (xfs_buf_t *)bio->bi_private;
 
@@ -1105,10 +1104,10 @@ xfs_buf_bio_end_io(
 	 * don't overwrite existing errors - otherwise we can lose errors on
 	 * buffers that require multiple bios to complete.
 	 */
-	if (error) {
+	if (bio->bi_error) {
 		spin_lock(&bp->b_lock);
 		if (!bp->b_io_error)
-			bp->b_io_error = error;
+			bp->b_io_error = bio->bi_error;
 		spin_unlock(&bp->b_lock);
 	}
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 5e963a6..6b91817 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -195,8 +195,6 @@ static inline bool bvec_gap_to_prev(struct bio_vec *bprv, unsigned int offset)
 	return offset || ((bprv->bv_offset + bprv->bv_len) & (PAGE_SIZE - 1));
 }
 
-#define bio_io_error(bio) bio_endio((bio), -EIO)
-
 /*
  * drivers should _never_ use the all version - the bio may have been split
  * before it got to the driver and the driver won't own all of it
@@ -426,7 +424,14 @@ static inline struct bio *bio_clone_kmalloc(struct bio *bio, gfp_t gfp_mask)
 
 }
 
-extern void bio_endio(struct bio *, int);
+extern void bio_endio(struct bio *);
+
+static inline void bio_io_error(struct bio *bio)
+{
+	bio->bi_error = -EIO;
+	bio_endio(bio);
+}
+
 struct request_queue;
 extern int bio_phys_segments(struct request_queue *, struct bio *);
 
@@ -717,7 +722,7 @@ extern void bio_integrity_free(struct bio *);
 extern int bio_integrity_add_page(struct bio *, struct page *, unsigned int, unsigned int);
 extern bool bio_integrity_enabled(struct bio *bio);
 extern int bio_integrity_prep(struct bio *);
-extern void bio_integrity_endio(struct bio *, int);
+extern void bio_integrity_endio(struct bio *);
 extern void bio_integrity_advance(struct bio *, unsigned int);
 extern void bio_integrity_trim(struct bio *, unsigned int, unsigned int);
 extern int bio_integrity_clone(struct bio *, struct bio *, gfp_t);
diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
index 7303b34..6164fb8 100644
--- a/include/linux/blk_types.h
+++ b/include/linux/blk_types.h
@@ -14,7 +14,7 @@ struct page;
 struct block_device;
 struct io_context;
 struct cgroup_subsys_state;
-typedef void (bio_end_io_t) (struct bio *, int);
+typedef void (bio_end_io_t) (struct bio *);
 typedef void (bio_destructor_t) (struct bio *);
 
 /*
@@ -53,6 +53,7 @@ struct bio {
 
 	struct bvec_iter	bi_iter;
 
+	int			bi_error;
 	/* Number of segments in this BIO after
 	 * physical address coalescing is performed.
 	 */
@@ -111,7 +112,6 @@ struct bio {
 /*
  * bio flags
  */
-#define BIO_UPTODATE	0	/* ok after I/O completion */
 #define BIO_SEG_VALID	1	/* bi_phys_segments valid */
 #define BIO_CLONED	2	/* doesn't own data */
 #define BIO_BOUNCED	3	/* bio is a bounce bio */
diff --git a/include/linux/swap.h b/include/linux/swap.h
index 3887472..31496d2 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -373,9 +373,9 @@ static inline void mem_cgroup_uncharge_swap(swp_entry_t entry)
 /* linux/mm/page_io.c */
 extern int swap_readpage(struct page *);
 extern int swap_writepage(struct page *page, struct writeback_control *wbc);
-extern void end_swap_bio_write(struct bio *bio, int err);
+extern void end_swap_bio_write(struct bio *bio);
 extern int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int));
+	bio_end_io_t end_write_func);
 extern int swap_set_page_dirty(struct page *page);
 
 int add_swap_extent(struct swap_info_struct *sis, unsigned long start_page,
diff --git a/kernel/power/swap.c b/kernel/power/swap.c
index 2f30ca9..b2066fb 100644
--- a/kernel/power/swap.c
+++ b/kernel/power/swap.c
@@ -227,27 +227,23 @@ static void hib_init_batch(struct hib_bio_batch *hb)
 	hb->error = 0;
 }
 
-static void hib_end_io(struct bio *bio, int error)
+static void hib_end_io(struct bio *bio)
 {
 	struct hib_bio_batch *hb = bio->bi_private;
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
-	if (!uptodate || error) {
+	if (bio->bi_error) {
 		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
 				imajor(bio->bi_bdev->bd_inode),
 				iminor(bio->bi_bdev->bd_inode),
 				(unsigned long long)bio->bi_iter.bi_sector);
-
-		if (!error)
-			error = -EIO;
 	}
 
 	if (bio_data_dir(bio) == WRITE)
 		put_page(page);
 
-	if (error && !hb->error)
-		hb->error = error;
+	if (bio->bi_error && !hb->error)
+		hb->error = bio->bi_error;
 	if (atomic_dec_and_test(&hb->count))
 		wake_up(&hb->wait);
 
diff --git a/kernel/trace/blktrace.c b/kernel/trace/blktrace.c
index b3e6b39..90e72a0 100644
--- a/kernel/trace/blktrace.c
+++ b/kernel/trace/blktrace.c
@@ -778,9 +778,6 @@ static void blk_add_trace_bio(struct request_queue *q, struct bio *bio,
 	if (likely(!bt))
 		return;
 
-	if (!error && !bio_flagged(bio, BIO_UPTODATE))
-		error = EIO;
-
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
 			bio->bi_rw, what, error, 0, NULL);
 }
@@ -887,8 +884,7 @@ static void blk_add_trace_split(void *ignore,
 
 		__blk_add_trace(bt, bio->bi_iter.bi_sector,
 				bio->bi_iter.bi_size, bio->bi_rw, BLK_TA_SPLIT,
-				!bio_flagged(bio, BIO_UPTODATE),
-				sizeof(rpdu), &rpdu);
+				bio->bi_error, sizeof(rpdu), &rpdu);
 	}
 }
 
@@ -920,8 +916,8 @@ static void blk_add_trace_bio_remap(void *ignore,
 	r.sector_from = cpu_to_be64(from);
 
 	__blk_add_trace(bt, bio->bi_iter.bi_sector, bio->bi_iter.bi_size,
-			bio->bi_rw, BLK_TA_REMAP,
-			!bio_flagged(bio, BIO_UPTODATE), sizeof(r), &r);
+			bio->bi_rw, BLK_TA_REMAP, bio->bi_error,
+			sizeof(r), &r);
 }
 
 /**
diff --git a/mm/page_io.c b/mm/page_io.c
index 520baa4..338ce68 100644
--- a/mm/page_io.c
+++ b/mm/page_io.c
@@ -43,12 +43,11 @@ static struct bio *get_swap_bio(gfp_t gfp_flags,
 	return bio;
 }
 
-void end_swap_bio_write(struct bio *bio, int err)
+void end_swap_bio_write(struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
-	if (!uptodate) {
+	if (bio->bi_error) {
 		SetPageError(page);
 		/*
 		 * We failed to write the page out to swap-space.
@@ -69,12 +68,11 @@ void end_swap_bio_write(struct bio *bio, int err)
 	bio_put(bio);
 }
 
-static void end_swap_bio_read(struct bio *bio, int err)
+static void end_swap_bio_read(struct bio *bio)
 {
-	const int uptodate = test_bit(BIO_UPTODATE, &bio->bi_flags);
 	struct page *page = bio->bi_io_vec[0].bv_page;
 
-	if (!uptodate) {
+	if (bio->bi_error) {
 		SetPageError(page);
 		ClearPageUptodate(page);
 		printk(KERN_ALERT "Read-error on swap-device (%u:%u:%Lu)\n",
@@ -254,7 +252,7 @@ static sector_t swap_page_sector(struct page *page)
 }
 
 int __swap_writepage(struct page *page, struct writeback_control *wbc,
-	void (*end_write_func)(struct bio *, int))
+		bio_end_io_t end_write_func)
 {
 	struct bio *bio;
 	int ret, rw = WRITE;
-- 
1.9.1
