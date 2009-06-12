From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: block: Introduce helper to reset queue limits to default
	values
Date: Fri, 12 Jun 2009 00:58:40 -0400
Message-ID: <yq1r5xqhwu7.fsf_-_@sermon.lab.mkp.net>
References: <1244524492-2292-1-git-send-email-snitzer@redhat.com>
	<yq1ski860ok.fsf@sermon.lab.mkp.net>
	<20090610140028.GD25088@redhat.com>
	<yq1ocsw55t6.fsf@sermon.lab.mkp.net>
	<20090610211235.GF25088@redhat.com>
	<yq1k53j68wj.fsf@sermon.lab.mkp.net>
	<20090610230804.GR647@agk-dp.fab.redhat.com>
	<yq1y6rz4ijs.fsf@sermon.lab.mkp.net>
	<20090611094311.GT647@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20090611094311.GT647@agk-dp.fab.redhat.com> (Alasdair
	G. Kergon's message of "Thu, 11 Jun 2009 10:43:11 +0100")
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com
Cc: device-mapper development <dm-devel@redhat.com>, Mike Snitzer <snitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids


DM reuses the request queue when swapping in a new device table.
Introduce blk_set_default_limits() which can be used to reset the the
queue_limits prior to stacking devices.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Acked-by: Alasdair G Kergon <agk@redhat.com>

---

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1c4df9b..35e9828 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -96,6 +96,31 @@ void blk_queue_lld_busy(struct request_queue *q, lld_busy_fn *fn)
 EXPORT_SYMBOL_GPL(blk_queue_lld_busy);
 
 /**
+ * blk_set_default_limits - reset limits to default values
+ * @limits:  the queue_limits structure to reset
+ *
+ * Description:
+ *   Returns a queue_limit struct to its default state.  Can be used by
+ *   stacking drivers like DM that stage table swaps and reuse an
+ *   existing device queue.
+ */
+void blk_set_default_limits(struct queue_limits *lim)
+{
+	lim->max_phys_segments = MAX_PHYS_SEGMENTS;
+	lim->max_hw_segments = MAX_HW_SEGMENTS;
+	lim->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
+	lim->max_segment_size = MAX_SEGMENT_SIZE;
+	lim->max_sectors = lim->max_hw_sectors = SAFE_MAX_SECTORS;
+	lim->logical_block_size = lim->physical_block_size = lim->io_min = 512;
+	lim->bounce_pfn = BLK_BOUNCE_ANY;
+	lim->alignment_offset = 0;
+	lim->io_opt = 0;
+	lim->misaligned = 0;
+	lim->no_cluster = 0;
+}
+EXPORT_SYMBOL(blk_set_default_limits);
+
+/**
  * blk_queue_make_request - define an alternate make_request function for a device
  * @q:  the request queue for the device to be affected
  * @mfn: the alternate make_request function
@@ -123,18 +148,12 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	 * set defaults
 	 */
 	q->nr_requests = BLKDEV_MAX_RQ;
-	blk_queue_max_phys_segments(q, MAX_PHYS_SEGMENTS);
-	blk_queue_max_hw_segments(q, MAX_HW_SEGMENTS);
-	blk_queue_segment_boundary(q, BLK_SEG_BOUNDARY_MASK);
-	blk_queue_max_segment_size(q, MAX_SEGMENT_SIZE);
 
 	q->make_request_fn = mfn;
 	q->backing_dev_info.ra_pages =
 			(VM_MAX_READAHEAD * 1024) / PAGE_CACHE_SIZE;
 	q->backing_dev_info.state = 0;
 	q->backing_dev_info.capabilities = BDI_CAP_MAP_COPY;
-	blk_queue_max_sectors(q, SAFE_MAX_SECTORS);
-	blk_queue_logical_block_size(q, 512);
 	blk_queue_dma_alignment(q, 511);
 	blk_queue_congestion_threshold(q);
 	q->nr_batching = BLK_BATCH_REQ;
@@ -147,6 +166,7 @@ void blk_queue_make_request(struct request_queue *q, make_request_fn *mfn)
 	q->unplug_timer.function = blk_unplug_timeout;
 	q->unplug_timer.data = (unsigned long)q;
 
+	blk_set_default_limits(&q->limits);
 	/*
 	 * by default assume old behaviour and bounce for any highmem page
 	 */
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 5e740a1..04bbc91 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -921,6 +921,7 @@ extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
+extern void blk_set_default_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
