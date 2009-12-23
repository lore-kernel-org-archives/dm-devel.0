From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Wed, 23 Dec 2009 09:26:49 -0500
Message-ID: <20091223142649.GA4462@redhat.com>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
	<20091222143240.GA9154@redhat.com>
	<yq1my1a52k4.fsf@sermon.lab.mkp.net>
	<20091222214250.GA28497@redhat.com>
	<yq17hse443y.fsf@sermon.lab.mkp.net>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <yq17hse443y.fsf@sermon.lab.mkp.net>
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
Cc: device-mapper development <dm-devel@redhat.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

On Wed, Dec 23 2009 at  1:05am -0500,
Martin K. Petersen <martin.petersen@oracle.com> wrote:

> >>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:
> 
> Mike> I also need to review your patch further (relative to virtual
> Mike> device stacking: does get_start_sect(bdev) always work?).
> 
> Yep.
> 
> I found a bug in the partition alignment reporting.  The following patch
> should fix that.  Please try it out.

alignment_offset(s) look good now.  Though I have one observation below.

> Concerning your test cases: It is perfectly valid for two component
> devices to be misaligned with regards to their underlying physical
> devices as long as they have identical alignment.  In that case the top
> level device will report a suitable alignment_offset.

One thing I noticed along the way is that: when stacking one or more
misaligned devices there is the potential for misleading error messages,
e.g.:

foo-bar: 0 212992 striped 2 32 8:18 384 8:17 384

sdb alignment_offset is 3584
sdb1 alignment_offset is 0
sdb2 alignment_offset is 3072

when loading this table sdb2 is stacked before sdb1; sdb2 is misaligned
but sdb1 is not, yet:

device-mapper: table: 254:2: target device sdb2 call to blk_stack_limits(): physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=534839808
device-mapper: table: 254:2: target device sdb1 is misaligned: physical_block_size=4096, logical_block_size=512, alignment_offset=3584, start=228864

>>> 228864 % 4096
3584
>>> 534839808 % 4096
512

So sdb2 is taken to be aligned (even though it isn't, relative to the
queue's alignment_offset of 3584) and then when sdb1 is stacked it is
flagged as misaligned.  Doesn't seem right.

> block: Fix topology stacking for data and discard alignment
> 
> The stacking code incorrectly scaled up the data offset in some cases
> causing misaligned devices to report alignment.  Rewrite the stacking
> algorithm to remedy this and apply the same alignment principles to the
> discard handling.
> 
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

With this patch the alignment_offset values are correct.  They
accurately reflect the established baseline (queue's limits
alignment_offset).

Here is the incremental diff (for those following along):

---
 block/blk-settings.c   |    7 +++----
 include/linux/blkdev.h |   12 ++++++++++--
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index e14fcbc..ca4f0a4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -518,7 +518,7 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		     sector_t offset)
 {
 	sector_t alignment;
-	unsigned int top, bottom, granularity;
+	unsigned int top, bottom;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
@@ -536,14 +536,13 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
-	granularity = max(b->physical_block_size, b->io_min);
-	alignment = b->alignment_offset - (offset & (granularity - 1));
+	alignment = queue_limit_alignment_offset(b, offset);
 
 	if (t->alignment_offset != alignment) {
 
 		top = max(t->physical_block_size, t->io_min)
 			+ t->alignment_offset;
-		bottom = granularity + alignment;
+		bottom = max(b->physical_block_size, b->io_min) + alignment;
 
 		if (max(top, bottom) & (min(top, bottom) - 1))
 			t->misaligned = 1;
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 784a919..af0ffac 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1116,11 +1116,19 @@ static inline int queue_alignment_offset(struct request_queue *q)
 	return q->limits.alignment_offset;
 }
 
+static inline int queue_limit_alignment_offset(struct queue_limits *lim, sector_t offset)
+{
+	unsigned int granularity = max(lim->physical_block_size, lim->io_min);
+
+	offset &= granularity - 1;
+
+	return (granularity + lim->alignment_offset - offset) & (granularity - 1);
+}
+
 static inline int queue_sector_alignment_offset(struct request_queue *q,
 						sector_t sector)
 {
-	return ((sector << 9) - q->limits.alignment_offset)
-		& (q->limits.io_min - 1);
+	return queue_limit_alignment_offset(&q->limits, sector << 9);
 }
 
 static inline int bdev_alignment_offset(struct block_device *bdev)
