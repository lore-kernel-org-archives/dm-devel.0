From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: [PATCH v2] dm: Fix alignment stacking on partitioned
	devices
Date: Tue, 5 Jan 2010 21:57:32 -0500
Message-ID: <20100106025731.GA16154@redhat.com>
References: <1261591640-24380-1-git-send-email-snitzer@redhat.com>
	<20100105182735.GC6042@agk-dp.fab.redhat.com>
	<yq1637gt1hi.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq1637gt1hi.fsf@sermon.lab.mkp.net>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dm-devel@redhat.com, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

On Tue, Jan 05 2010 at  9:23pm -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Alasdair" == Alasdair G Kergon <agk@redhat.com> writes:
> 
> Alasdair> extern int blk_stack_limits(struct queue_limits *t, struct
> Alasdair> queue_limits *b,
> Alasdair>                             sector_t offset);
> 
> Alasdair> This function is asking for the offset to be supplied as
> Alasdair> sector_t i.e.  in units of sectors, but this patch uses bytes.
> Alasdair> Please either change that to sectors as per the prototype, or
> Alasdair> if it really does want bytes, fix the prototype to make that
> Alasdair> clear.
> 
> It is sector_t because we don't have an existing type that fits the bill
> (i.e. >= sector_t and dependent on whether LBD is on or not).  We're
> trying to move away from counting in sectors because the notion is
> confusing in the light of the logical vs. physical block size, device
> alignment reporting, etc.
> 
> So maybe something like this?
> 
> 
> block: Introduce blk_off_t
> 
> There are several places we want to communicate alignment and offsets in
> bytes to avoid confusion with regards to underlying physical and logical
> block sizes.  Introduce blk_off_t for block device byte offsets.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
...
> diff --git a/include/linux/types.h b/include/linux/types.h
> index c42724f..729f87a 100644
> --- a/include/linux/types.h
> +++ b/include/linux/types.h
> @@ -134,9 +134,11 @@ typedef		__s64		int64_t;
>  #ifdef CONFIG_LBDAF
>  typedef u64 sector_t;
>  typedef u64 blkcnt_t;
> +typedef u64 blk_off_t;
>  #else
>  typedef unsigned long sector_t;
>  typedef unsigned long blkcnt_t;
> +typedef unsigned long blk_off_t;
>  #endif
>  
>  /*

After looking closer there seems to be various type inconsistencies in
the alignment_offset and discard_alignment related routines (returning
'int' in places, etc).

The following patch is what I found; I have no problem with switching
from 'unsigned long' to blk_off_t for LBD though.

Martin, would like to carry forward with this?  Have I gone overboard
with this patch?

---
 block/blk-settings.c   |    8 ++++----
 block/genhd.c          |    4 ++--
 include/linux/blkdev.h |   21 +++++++++++----------
 3 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index d52d4ad..446eeef 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -493,7 +493,7 @@ void blk_queue_stack_limits(struct request_queue *t, struct request_queue *b)
 }
 EXPORT_SYMBOL(blk_queue_stack_limits);
 
-static unsigned int lcm(unsigned int a, unsigned int b)
+static unsigned long lcm(unsigned long a, unsigned long b)
 {
 	if (a && b)
 		return (a * b) / gcd(a, b);
@@ -525,10 +525,10 @@ static unsigned int lcm(unsigned int a, unsigned int b)
  *    the alignment_offset is undefined.
  */
 int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
-		     sector_t offset)
+		     unsigned long offset)
 {
-	sector_t alignment;
-	unsigned int top, bottom;
+	unsigned long alignment;
+	unsigned long top, bottom;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
diff --git a/block/genhd.c b/block/genhd.c
index b11a4ad..94fc2b0 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -858,7 +858,7 @@ static ssize_t disk_alignment_offset_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%d\n", queue_alignment_offset(disk->queue));
+	return sprintf(buf, "%lu\n", queue_alignment_offset(disk->queue));
 }
 
 static ssize_t disk_discard_alignment_show(struct device *dev,
@@ -867,7 +867,7 @@ static ssize_t disk_discard_alignment_show(struct device *dev,
 {
 	struct gendisk *disk = dev_to_disk(dev);
 
-	return sprintf(buf, "%u\n", queue_discard_alignment(disk->queue));
+	return sprintf(buf, "%lu\n", queue_discard_alignment(disk->queue));
 }
 
 static DEVICE_ATTR(range, S_IRUGO, disk_range_show, NULL);
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 9b98173..92f9eac 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -308,12 +308,12 @@ struct queue_limits {
 	unsigned int		max_sectors;
 	unsigned int		max_segment_size;
 	unsigned int		physical_block_size;
-	unsigned int		alignment_offset;
+	unsigned long		alignment_offset;
 	unsigned int		io_min;
 	unsigned int		io_opt;
 	unsigned int		max_discard_sectors;
 	unsigned int		discard_granularity;
-	unsigned int		discard_alignment;
+	unsigned long		discard_alignment;
 
 	unsigned short		logical_block_size;
 	unsigned short		max_hw_segments;
@@ -1102,7 +1102,7 @@ static inline int bdev_io_opt(struct block_device *bdev)
 	return queue_io_opt(bdev_get_queue(bdev));
 }
 
-static inline int queue_alignment_offset(struct request_queue *q)
+static inline unsigned long queue_alignment_offset(struct request_queue *q)
 {
 	if (q->limits.misaligned)
 		return -1;
@@ -1110,7 +1110,8 @@ static inline int queue_alignment_offset(struct request_queue *q)
 	return q->limits.alignment_offset;
 }
 
-static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t offset)
+static inline unsigned long queue_limit_alignment_offset(struct queue_limits *lim,
+							 unsigned long offset)
 {
 	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
 
@@ -1118,13 +1119,13 @@ static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_
 	return (granularity + lim->alignment_offset - offset) & (granularity - 1);
 }
 
-static inline int queue_sector_alignment_offset(struct request_queue *q,
-						sector_t sector)
+static inline unsigned long queue_sector_alignment_offset(struct request_queue *q,
+							  sector_t sector)
 {
 	return queue_limit_alignment_offset(&q->limits, sector << 9);
 }
 
-static inline int bdev_alignment_offset(struct block_device *bdev)
+static inline unsigned long bdev_alignment_offset(struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
@@ -1137,7 +1138,7 @@ static inline int bdev_alignment_offset(struct block_device *bdev)
 	return q->limits.alignment_offset;
 }
 
-static inline int queue_discard_alignment(struct request_queue *q)
+static inline unsigned long queue_discard_alignment(struct request_queue *q)
 {
 	if (q->limits.discard_misaligned)
 		return -1;
@@ -1145,8 +1146,8 @@ static inline int queue_discard_alignment(struct request_queue *q)
 	return q->limits.discard_alignment;
 }
 
-static inline int queue_sector_discard_alignment(struct request_queue *q,
-						 sector_t sector)
+static inline unsigned long queue_sector_discard_alignment(struct request_queue *q,
+							   sector_t sector)
 {
 	return ((sector << 9) - q->limits.discard_alignment)
 		& (q->limits.discard_granularity - 1);
