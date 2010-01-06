From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Tue, 05 Jan 2010 21:23:53 -0500
Message-ID: <yq1637gt1hi.fsf@sermon.lab.mkp.net>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20100105182735.GC6042@agk-dp.fab.redhat.com> (Alasdair
	G. Kergon's message of "Tue, 5 Jan 2010 18:27:35 +0000")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
List-Id: dm-devel.ids

>>>>> "Alasdair" == Alasdair G Kergon <agk@redhat.com> writes:

Alasdair> extern int blk_stack_limits(struct queue_limits *t, struct
Alasdair> queue_limits *b,
Alasdair>                             sector_t offset);

Alasdair> This function is asking for the offset to be supplied as
Alasdair> sector_t i.e.  in units of sectors, but this patch uses bytes.
Alasdair> Please either change that to sectors as per the prototype, or
Alasdair> if it really does want bytes, fix the prototype to make that
Alasdair> clear.

It is sector_t because we don't have an existing type that fits the bill
(i.e. >= sector_t and dependent on whether LBD is on or not).  We're
trying to move away from counting in sectors because the notion is
confusing in the light of the logical vs. physical block size, device
alignment reporting, etc.

So maybe something like this?


block: Introduce blk_off_t

There are several places we want to communicate alignment and offsets in
bytes to avoid confusion with regards to underlying physical and logical
block sizes.  Introduce blk_off_t for block device byte offsets.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d52d4ad..9404666 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -525,9 +525,9 @@ static unsigned int lcm(unsigned int a, unsigned int b)
  *    the alignment_offset is undefined.
  */
 int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
-		     sector_t offset)
+		     blk_off_t offset)
 {
-	sector_t alignment;
+	blk_off_t alignment;
 	unsigned int top, bottom;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
@@ -642,7 +642,7 @@ EXPORT_SYMBOL(blk_stack_limits);
  *    misalignment.
  */
 void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
-		       sector_t offset)
+		       blk_off_t offset)
 {
 	struct request_queue *t = disk->queue;
 	struct request_queue *b = bdev_get_queue(bdev);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9b98173..4b4436a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -937,9 +937,9 @@ extern void blk_limits_io_opt(struct queue_limits *limits, unsigned int opt);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_default_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
-			    sector_t offset);
+			    blk_off_t offset);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
-			      sector_t offset);
+			      blk_off_t offset);
 extern void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b);
 extern void blk_queue_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
@@ -1110,7 +1110,7 @@ static inline int queue_alignment_offset(struct request_queue *q)
 	return q->limits.alignment_offset;
 }
 
-static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t offset)
+static inline int queue_limit_alignment_offset(struct queue_limits *lim, blk_off_t offset)
 {
 	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
 
diff --git a/include/linux/types.h b/include/linux/types.h
index c42724f..729f87a 100644
--- a/include/linux/types.h
+++ b/include/linux/types.h
@@ -134,9 +134,11 @@ typedef		__s64		int64_t;
 #ifdef CONFIG_LBDAF
 typedef u64 sector_t;
 typedef u64 blkcnt_t;
+typedef u64 blk_off_t;
 #else
 typedef unsigned long sector_t;
 typedef unsigned long blkcnt_t;
+typedef unsigned long blk_off_t;
 #endif
 
 /*
