From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [RFD] BIO_RW_BARRIER - what it means for devices, filesystems, and dm/md.
Date: Wed, 30 May 2007 11:35:04 +0200
Message-ID: <20070530093503.GA15559@kernel.dk>
References: <18006.38689.818186.221707@notabene.brown> <18010.12472.209452.148229@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-fsdevel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18010.12472.209452.148229@notabene.brown>
Sender: linux-fsdevel-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, David Chinner <dgc@sgi.com>, Phillip Susi <psusi@cfl.rr.com>, Stefan Bader <Stefan.Bader@de.ibm.com>, Andreas Dilger <adilger@clusterfs.com>, Tejun Heo <htejun@gmail.com>
List-Id: dm-devel.ids

On Mon, May 28 2007, Neil Brown wrote:
> I think the implementation priorities here are:
> 
> 1/ implement a zero-length BIO_RW_BARRIER option.
> 2/ Use it (or otherwise) to make all dm and md modules handle
>    barriers (and loop?).
> 3/ Devise and implement appropriate fall-backs with-in the block layer
>    so that  -EOPNOTSUP is never returned.
> 4/ Remove unneeded cruft from filesystems (and elsewhere).

This is the start of 1/ above. It's very lightly tested, it's verified
to DTRT here at least and not crash :-)

It gets rid of the ->issue_flush_fn() queue callback, all the driver
knowledge resides in ->prepare_flush_fn() anyways. blkdev_issue_flush()
then just reuses the empty-bio approach to queue an empty barrier, this
should work equally well for stacked and non-stacked devices.

While this patch isn't complete yet, it's clearly the right direction to
go.

I didn't convert drivers/md/* to support this approach, I'm leaving that
to you :-)

 block/elevator.c                |   12 ++
 block/ll_rw_blk.c               |  173 ++++++++++++++++++--------------
 drivers/ide/ide-disk.c          |   29 -----
 drivers/message/i2o/i2o_block.c |   24 ----
 drivers/scsi/scsi_lib.c         |   17 ---
 drivers/scsi/sd.c               |   15 --
 fs/bio.c                        |    8 -
 include/linux/bio.h             |   18 ++-
 include/linux/blkdev.h          |    3 
 include/scsi/scsi_driver.h      |    1 
 include/scsi/sd.h               |    1 
 mm/bounce.c                     |    6 +
 12 files changed, 141 insertions(+), 166 deletions(-)

diff --git a/block/elevator.c b/block/elevator.c
index ce866eb..af5e58d 100644
--- a/block/elevator.c
+++ b/block/elevator.c
@@ -715,6 +715,18 @@ struct request *elv_next_request(request_queue_t *q)
 	int ret;
 
 	while ((rq = __elv_next_request(q)) != NULL) {
+		/*
+		 * Kill the empty barrier place holder, the driver must
+		 * not ever see it.
+		 */
+		if (blk_fs_request(rq) && blk_barrier_rq(rq) &&
+		    !rq->hard_nr_sectors) {
+			blkdev_dequeue_request(rq);
+			rq->cmd_flags |= REQ_QUIET;
+			end_that_request_chunk(rq, 1, 0);
+			end_that_request_last(rq, 1);
+			continue;
+		}
 		if (!(rq->cmd_flags & REQ_STARTED)) {
 			/*
 			 * This is the first time the device driver
diff --git a/block/ll_rw_blk.c b/block/ll_rw_blk.c
index 6b5173a..8680083 100644
--- a/block/ll_rw_blk.c
+++ b/block/ll_rw_blk.c
@@ -300,23 +300,6 @@ int blk_queue_ordered(request_queue_t *q, unsigned ordered,
 
 EXPORT_SYMBOL(blk_queue_ordered);
 
-/**
- * blk_queue_issue_flush_fn - set function for issuing a flush
- * @q:     the request queue
- * @iff:   the function to be called issuing the flush
- *
- * Description:
- *   If a driver supports issuing a flush command, the support is notified
- *   to the block layer by defining it through this call.
- *
- **/
-void blk_queue_issue_flush_fn(request_queue_t *q, issue_flush_fn *iff)
-{
-	q->issue_flush_fn = iff;
-}
-
-EXPORT_SYMBOL(blk_queue_issue_flush_fn);
-
 /*
  * Cache flushing for ordered writes handling
  */
@@ -433,7 +416,8 @@ static inline struct request *start_ordered(request_queue_t *q,
 	rq_init(q, rq);
 	if (bio_data_dir(q->orig_bar_rq->bio) == WRITE)
 		rq->cmd_flags |= REQ_RW;
-	rq->cmd_flags |= q->ordered & QUEUE_ORDERED_FUA ? REQ_FUA : 0;
+	if (q->ordered & QUEUE_ORDERED_FUA)
+		rq->cmd_flags |= REQ_FUA;
 	rq->elevator_private = NULL;
 	rq->elevator_private2 = NULL;
 	init_request_from_bio(rq, q->orig_bar_rq->bio);
@@ -445,7 +429,7 @@ static inline struct request *start_ordered(request_queue_t *q,
 	 * no fs request uses ELEVATOR_INSERT_FRONT and thus no fs
 	 * request gets inbetween ordered sequence.
 	 */
-	if (q->ordered & QUEUE_ORDERED_POSTFLUSH)
+	if ((q->ordered & QUEUE_ORDERED_POSTFLUSH) && rq->hard_nr_sectors)
 		queue_flush(q, QUEUE_ORDERED_POSTFLUSH);
 	else
 		q->ordseq |= QUEUE_ORDSEQ_POSTFLUSH;
@@ -469,7 +453,7 @@ static inline struct request *start_ordered(request_queue_t *q,
 int blk_do_ordered(request_queue_t *q, struct request **rqp)
 {
 	struct request *rq = *rqp;
-	int is_barrier = blk_fs_request(rq) && blk_barrier_rq(rq);
+	const int is_barrier = blk_fs_request(rq) && blk_barrier_rq(rq);
 
 	if (!q->ordseq) {
 		if (!is_barrier)
@@ -2635,6 +2619,16 @@ int blk_execute_rq(request_queue_t *q, struct gendisk *bd_disk,
 
 EXPORT_SYMBOL(blk_execute_rq);
 
+static int bio_end_empty_barrier(struct bio *bio, unsigned int bytes_done,
+				 int err)
+{
+	if (err)
+		clear_bit(BIO_UPTODATE, &bio->bi_flags);
+
+	complete(bio->bi_private);
+	return 0;
+}
+
 /**
  * blkdev_issue_flush - queue a flush
  * @bdev:	blockdev to issue flush for
@@ -2647,7 +2641,10 @@ EXPORT_SYMBOL(blk_execute_rq);
  */
 int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 {
+	DECLARE_COMPLETION_ONSTACK(wait);
 	request_queue_t *q;
+	struct bio *bio;
+	int ret;
 
 	if (bdev->bd_disk == NULL)
 		return -ENXIO;
@@ -2655,10 +2652,32 @@ int blkdev_issue_flush(struct block_device *bdev, sector_t *error_sector)
 	q = bdev_get_queue(bdev);
 	if (!q)
 		return -ENXIO;
-	if (!q->issue_flush_fn)
-		return -EOPNOTSUPP;
 
-	return q->issue_flush_fn(q, bdev->bd_disk, error_sector);
+	bio = bio_alloc(GFP_KERNEL, 0);
+	if (!bio)
+		return -ENOMEM;
+
+	bio->bi_end_io = bio_end_empty_barrier;
+	bio->bi_private = &wait;
+	bio->bi_bdev = bdev;
+	submit_bio(1 << BIO_RW_BARRIER, bio);
+
+	wait_for_completion(&wait);
+
+	/*
+	 * The driver must store the error location in ->bi_sector, if
+	 * it supports it. For non-stacked drivers, this should be copied
+	 * from rq->sector.
+	 */
+	if (error_sector)
+		*error_sector = bio->bi_sector;
+
+	ret = 0;
+	if (!bio_flagged(bio, BIO_UPTODATE))
+		ret = -EIO;
+
+	bio_put(bio);
+	return ret;
 }
 
 EXPORT_SYMBOL(blkdev_issue_flush);
@@ -3030,7 +3049,7 @@ static inline void blk_partition_remap(struct bio *bio)
 {
 	struct block_device *bdev = bio->bi_bdev;
 
-	if (bdev != bdev->bd_contains) {
+	if (bio_sectors(bio) && bdev != bdev->bd_contains) {
 		struct hd_struct *p = bdev->bd_part;
 		const int rw = bio_data_dir(bio);
 
@@ -3092,6 +3111,35 @@ static inline int should_fail_request(struct bio *bio)
 
 #endif /* CONFIG_FAIL_MAKE_REQUEST */
 
+/*
+ * Check whether this bio extends beyond the end of the device.
+ */
+static inline int bio_check_eod(struct bio *bio, unsigned int nr_sectors)
+{
+	sector_t maxsector;
+
+	if (!nr_sectors)
+		return 0;
+
+	/* Test device or partition size, when known. */
+	maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
+	if (maxsector) {
+		sector_t sector = bio->bi_sector;
+
+		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
+			/*
+			 * This may well happen - the kernel calls bread()
+			 * without checking the size of the device, e.g., when
+			 * mounting a device.
+			 */
+			handle_bad_sector(bio);
+			return 1;
+		}
+	}
+
+	return 0;
+}
+
 /**
  * generic_make_request: hand a buffer to its device driver for I/O
  * @bio:  The bio describing the location in memory and on the device.
@@ -3119,27 +3167,14 @@ static inline int should_fail_request(struct bio *bio)
 static inline void __generic_make_request(struct bio *bio)
 {
 	request_queue_t *q;
-	sector_t maxsector;
 	sector_t old_sector;
 	int ret, nr_sectors = bio_sectors(bio);
 	dev_t old_dev;
 
 	might_sleep();
-	/* Test device or partition size, when known. */
-	maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
-	if (maxsector) {
-		sector_t sector = bio->bi_sector;
 
-		if (maxsector < nr_sectors || maxsector - nr_sectors < sector) {
-			/*
-			 * This may well happen - the kernel calls bread()
-			 * without checking the size of the device, e.g., when
-			 * mounting a device.
-			 */
-			handle_bad_sector(bio);
-			goto end_io;
-		}
-	}
+	if (bio_check_eod(bio, nr_sectors))
+		goto end_io;
 
 	/*
 	 * Resolve the mapping until finished. (drivers are
@@ -3166,7 +3201,7 @@ end_io:
 			break;
 		}
 
-		if (unlikely(bio_sectors(bio) > q->max_hw_sectors)) {
+		if (unlikely(nr_sectors > q->max_hw_sectors)) {
 			printk("bio too big device %s (%u > %u)\n", 
 				bdevname(bio->bi_bdev, b),
 				bio_sectors(bio),
@@ -3187,7 +3222,7 @@ end_io:
 		blk_partition_remap(bio);
 
 		if (old_sector != -1)
-			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector, 
+			blk_add_trace_remap(q, bio, old_dev, bio->bi_sector,
 					    old_sector);
 
 		blk_add_trace_bio(q, bio, BLK_TA_QUEUE);
@@ -3195,21 +3230,8 @@ end_io:
 		old_sector = bio->bi_sector;
 		old_dev = bio->bi_bdev->bd_dev;
 
-		maxsector = bio->bi_bdev->bd_inode->i_size >> 9;
-		if (maxsector) {
-			sector_t sector = bio->bi_sector;
-
-			if (maxsector < nr_sectors ||
-					maxsector - nr_sectors < sector) {
-				/*
-				 * This may well happen - partitions are not
-				 * checked to make sure they are within the size
-				 * of the whole device.
-				 */
-				handle_bad_sector(bio);
-				goto end_io;
-			}
-		}
+		if (bio_check_eod(bio, nr_sectors))
+			goto end_io;
 
 		ret = q->make_request_fn(q, bio);
 	} while (ret);
@@ -3282,23 +3304,32 @@ void submit_bio(int rw, struct bio *bio)
 {
 	int count = bio_sectors(bio);
 
-	BIO_BUG_ON(!bio->bi_size);
-	BIO_BUG_ON(!bio->bi_io_vec);
 	bio->bi_rw |= rw;
-	if (rw & WRITE) {
-		count_vm_events(PGPGOUT, count);
-	} else {
-		task_io_account_read(bio->bi_size);
-		count_vm_events(PGPGIN, count);
-	}
 
-	if (unlikely(block_dump)) {
-		char b[BDEVNAME_SIZE];
-		printk(KERN_DEBUG "%s(%d): %s block %Lu on %s\n",
-			current->comm, current->pid,
-			(rw & WRITE) ? "WRITE" : "READ",
-			(unsigned long long)bio->bi_sector,
-			bdevname(bio->bi_bdev,b));
+	/*
+	 * If it's a regular read/write or a barrier with data attached,
+	 * go through the normal accounting stuff before submission.
+	 */
+	if (!bio_barrier(bio) || count) {
+
+		BIO_BUG_ON(!bio->bi_size);
+		BIO_BUG_ON(!bio->bi_io_vec);
+
+		if (rw & WRITE) {
+			count_vm_events(PGPGOUT, count);
+		} else {
+			task_io_account_read(bio->bi_size);
+			count_vm_events(PGPGIN, count);
+		}
+
+		if (unlikely(block_dump)) {
+			char b[BDEVNAME_SIZE];
+			printk(KERN_DEBUG "%s(%d): %s block %Lu on %s\n",
+				current->comm, current->pid,
+				(rw & WRITE) ? "WRITE" : "READ",
+				(unsigned long long)bio->bi_sector,
+				bdevname(bio->bi_bdev,b));
+		}
 	}
 
 	generic_make_request(bio);
diff --git a/drivers/ide/ide-disk.c b/drivers/ide/ide-disk.c
index 7fff773..23f8181 100644
--- a/drivers/ide/ide-disk.c
+++ b/drivers/ide/ide-disk.c
@@ -697,32 +697,6 @@ static void idedisk_prepare_flush(request_queue_t *q, struct request *rq)
 	rq->buffer = rq->cmd;
 }
 
-static int idedisk_issue_flush(request_queue_t *q, struct gendisk *disk,
-			       sector_t *error_sector)
-{
-	ide_drive_t *drive = q->queuedata;
-	struct request *rq;
-	int ret;
-
-	if (!drive->wcache)
-		return 0;
-
-	rq = blk_get_request(q, WRITE, __GFP_WAIT);
-
-	idedisk_prepare_flush(q, rq);
-
-	ret = blk_execute_rq(q, disk, rq, 0);
-
-	/*
-	 * if we failed and caller wants error offset, get it
-	 */
-	if (ret && error_sector)
-		*error_sector = ide_get_error_location(drive, rq->cmd);
-
-	blk_put_request(rq);
-	return ret;
-}
-
 /*
  * This is tightly woven into the driver->do_special can not touch.
  * DON'T do it again until a total personality rewrite is committed.
@@ -762,7 +736,6 @@ static void update_ordered(ide_drive_t *drive)
 	struct hd_driveid *id = drive->id;
 	unsigned ordered = QUEUE_ORDERED_NONE;
 	prepare_flush_fn *prep_fn = NULL;
-	issue_flush_fn *issue_fn = NULL;
 
 	if (drive->wcache) {
 		unsigned long long capacity;
@@ -786,13 +759,11 @@ static void update_ordered(ide_drive_t *drive)
 		if (barrier) {
 			ordered = QUEUE_ORDERED_DRAIN_FLUSH;
 			prep_fn = idedisk_prepare_flush;
-			issue_fn = idedisk_issue_flush;
 		}
 	} else
 		ordered = QUEUE_ORDERED_DRAIN;
 
 	blk_queue_ordered(drive->queue, ordered, prep_fn);
-	blk_queue_issue_flush_fn(drive->queue, issue_fn);
 }
 
 static int write_cache(ide_drive_t *drive, int arg)
diff --git a/drivers/message/i2o/i2o_block.c b/drivers/message/i2o/i2o_block.c
index b17c4b2..e794074 100644
--- a/drivers/message/i2o/i2o_block.c
+++ b/drivers/message/i2o/i2o_block.c
@@ -149,29 +149,6 @@ static int i2o_block_device_flush(struct i2o_device *dev)
 };
 
 /**
- *	i2o_block_issue_flush - device-flush interface for block-layer
- *	@queue: the request queue of the device which should be flushed
- *	@disk: gendisk
- *	@error_sector: error offset
- *
- *	Helper function to provide flush functionality to block-layer.
- *
- *	Returns 0 on success or negative error code on failure.
- */
-
-static int i2o_block_issue_flush(request_queue_t * queue, struct gendisk *disk,
-				 sector_t * error_sector)
-{
-	struct i2o_block_device *i2o_blk_dev = queue->queuedata;
-	int rc = -ENODEV;
-
-	if (likely(i2o_blk_dev))
-		rc = i2o_block_device_flush(i2o_blk_dev->i2o_dev);
-
-	return rc;
-}
-
-/**
  *	i2o_block_device_mount - Mount (load) the media of device dev
  *	@dev: I2O device which should receive the mount request
  *	@media_id: Media Identifier
@@ -1009,7 +986,6 @@ static struct i2o_block_device *i2o_block_device_alloc(void)
 	}
 
 	blk_queue_prep_rq(queue, i2o_block_prep_req_fn);
-	blk_queue_issue_flush_fn(queue, i2o_block_issue_flush);
 
 	gd->major = I2O_MAJOR;
 	gd->queue = queue;
diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 1f5a07b..4712456 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1038,22 +1038,6 @@ static int scsi_init_io(struct scsi_cmnd *cmd)
 	return BLKPREP_KILL;
 }
 
-static int scsi_issue_flush_fn(request_queue_t *q, struct gendisk *disk,
-			       sector_t *error_sector)
-{
-	struct scsi_device *sdev = q->queuedata;
-	struct scsi_driver *drv;
-
-	if (sdev->sdev_state != SDEV_RUNNING)
-		return -ENXIO;
-
-	drv = *(struct scsi_driver **) disk->private_data;
-	if (drv->issue_flush)
-		return drv->issue_flush(&sdev->sdev_gendev, error_sector);
-
-	return -EOPNOTSUPP;
-}
-
 static struct scsi_cmnd *scsi_get_cmd_from_req(struct scsi_device *sdev,
 		struct request *req)
 {
@@ -1596,7 +1580,6 @@ struct request_queue *scsi_alloc_queue(struct scsi_device *sdev)
 		return NULL;
 
 	blk_queue_prep_rq(q, scsi_prep_fn);
-	blk_queue_issue_flush_fn(q, scsi_issue_flush_fn);
 	blk_queue_softirq_done(q, scsi_softirq_done);
 	return q;
 }
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 3d8c9cb..19f2655 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -241,7 +241,6 @@ static struct scsi_driver sd_template = {
 	},
 	.rescan			= sd_rescan,
 	.init_command		= sd_init_command,
-	.issue_flush		= sd_issue_flush,
 };
 
 /*
@@ -800,20 +799,6 @@ static int sd_sync_cache(struct scsi_disk *sdkp)
 	return 0;
 }
 
-static int sd_issue_flush(struct device *dev, sector_t *error_sector)
-{
-	int ret = 0;
-	struct scsi_disk *sdkp = scsi_disk_get_from_dev(dev);
-
-	if (!sdkp)
-               return -ENODEV;
-
-	if (sdkp->WCE)
-		ret = sd_sync_cache(sdkp);
-	scsi_disk_put(sdkp);
-	return ret;
-}
-
 static void sd_prepare_flush(request_queue_t *q, struct request *rq)
 {
 	memset(rq->cmd, 0, sizeof(rq->cmd));
diff --git a/fs/bio.c b/fs/bio.c
index 093345f..413bb19 100644
--- a/fs/bio.c
+++ b/fs/bio.c
@@ -109,11 +109,13 @@ static inline struct bio_vec *bvec_alloc_bs(gfp_t gfp_mask, int nr, unsigned lon
 
 void bio_free(struct bio *bio, struct bio_set *bio_set)
 {
-	const int pool_idx = BIO_POOL_IDX(bio);
+	if (bio->bi_io_vec) {
+		const int pool_idx = BIO_POOL_IDX(bio);
 
-	BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
+		BIO_BUG_ON(pool_idx >= BIOVEC_NR_POOLS);
+		mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
+	}
 
-	mempool_free(bio->bi_io_vec, bio_set->bvec_pools[pool_idx]);
 	mempool_free(bio, bio_set->bio_pool);
 }
 
diff --git a/include/linux/bio.h b/include/linux/bio.h
index 4d85262..82a4420 100644
--- a/include/linux/bio.h
+++ b/include/linux/bio.h
@@ -174,14 +174,28 @@ struct bio {
 #define bio_offset(bio)		bio_iovec((bio))->bv_offset
 #define bio_segments(bio)	((bio)->bi_vcnt - (bio)->bi_idx)
 #define bio_sectors(bio)	((bio)->bi_size >> 9)
-#define bio_cur_sectors(bio)	(bio_iovec(bio)->bv_len >> 9)
-#define bio_data(bio)		(page_address(bio_page((bio))) + bio_offset((bio)))
 #define bio_barrier(bio)	((bio)->bi_rw & (1 << BIO_RW_BARRIER))
 #define bio_sync(bio)		((bio)->bi_rw & (1 << BIO_RW_SYNC))
 #define bio_failfast(bio)	((bio)->bi_rw & (1 << BIO_RW_FAILFAST))
 #define bio_rw_ahead(bio)	((bio)->bi_rw & (1 << BIO_RW_AHEAD))
 #define bio_rw_meta(bio)	((bio)->bi_rw & (1 << BIO_RW_META))
 
+static inline unsigned int bio_cur_sectors(struct bio *bio)
+{
+	if (bio->bi_vcnt)
+		return bio_iovec(bio)->bv_len >> 9;
+
+	return 0;
+}
+
+static inline void *bio_data(struct bio *bio)
+{
+	if (bio->bi_vcnt)
+		return page_address(bio_page(bio)) + bio_offset(bio);
+
+	return NULL;
+}
+
 /*
  * will die
  */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index db5b00a..47c8540 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -338,7 +338,6 @@ typedef void (unplug_fn) (request_queue_t *);
 
 struct bio_vec;
 typedef int (merge_bvec_fn) (request_queue_t *, struct bio *, struct bio_vec *);
-typedef int (issue_flush_fn) (request_queue_t *, struct gendisk *, sector_t *);
 typedef void (prepare_flush_fn) (request_queue_t *, struct request *);
 typedef void (softirq_done_fn)(struct request *);
 
@@ -376,7 +375,6 @@ struct request_queue
 	prep_rq_fn		*prep_rq_fn;
 	unplug_fn		*unplug_fn;
 	merge_bvec_fn		*merge_bvec_fn;
-	issue_flush_fn		*issue_flush_fn;
 	prepare_flush_fn	*prepare_flush_fn;
 	softirq_done_fn		*softirq_done_fn;
 
@@ -749,7 +747,6 @@ extern void blk_queue_dma_alignment(request_queue_t *, int);
 extern void blk_queue_softirq_done(request_queue_t *, softirq_done_fn *);
 extern struct backing_dev_info *blk_get_backing_dev_info(struct block_device *bdev);
 extern int blk_queue_ordered(request_queue_t *, unsigned, prepare_flush_fn *);
-extern void blk_queue_issue_flush_fn(request_queue_t *, issue_flush_fn *);
 extern int blk_do_ordered(request_queue_t *, struct request **);
 extern unsigned blk_ordered_cur_seq(request_queue_t *);
 extern unsigned blk_ordered_req_seq(struct request *);
diff --git a/include/scsi/scsi_driver.h b/include/scsi/scsi_driver.h
index 02e26c1..7017d3e 100644
--- a/include/scsi/scsi_driver.h
+++ b/include/scsi/scsi_driver.h
@@ -13,7 +13,6 @@ struct scsi_driver {
 
 	int (*init_command)(struct scsi_cmnd *);
 	void (*rescan)(struct device *);
-	int (*issue_flush)(struct device *, sector_t *);
 	int (*prepare_flush)(struct request_queue *, struct request *);
 };
 #define to_scsi_driver(drv) \
diff --git a/include/scsi/sd.h b/include/scsi/sd.h
index 5261488..607a6a1 100644
--- a/include/scsi/sd.h
+++ b/include/scsi/sd.h
@@ -56,7 +56,6 @@ static int sd_suspend(struct device *dev, pm_message_t state);
 static int sd_resume(struct device *dev);
 static void sd_rescan(struct device *);
 static int  sd_init_command(struct scsi_cmnd *);
-static int  sd_issue_flush(struct device *, sector_t *);
 static void sd_prepare_flush(request_queue_t *, struct request *);
 static void sd_read_capacity(struct scsi_disk *sdkp, unsigned char *buffer);
 static void scsi_disk_release(struct class_device *cdev);
diff --git a/mm/bounce.c b/mm/bounce.c
index ad401fc..95d0127 100644
--- a/mm/bounce.c
+++ b/mm/bounce.c
@@ -280,6 +280,12 @@ void blk_queue_bounce(request_queue_t *q, struct bio **bio_orig)
 	mempool_t *pool;
 
 	/*
+	 * Data-less bio, nothing to bounce
+	 */
+	if (!bio_sectors(*bio_orig))
+		return;
+
+	/*
 	 * for non-isa bounce case, just check if the bounce pfn is equal
 	 * to or bigger than the highest pfn in the system -- in that case,
 	 * don't waste time iterating over bio segments

-- 
Jens Axboe

