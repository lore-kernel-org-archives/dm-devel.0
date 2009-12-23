From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: dm: Fix alignment stacking on partitioned devices
Date: Wed, 23 Dec 2009 01:05:37 -0500
Message-ID: <yq17hse443y.fsf@sermon.lab.mkp.net>
References: <yq1aaxg7n84.fsf@sermon.lab.mkp.net>
	<20091218173322.GA4163@redhat.com>
	<yq14onk5iaa.fsf@sermon.lab.mkp.net>
	<20091221195204.GA28703@redhat.com>
	<yq1r5qn4orc.fsf@sermon.lab.mkp.net>
	<20091222143240.GA9154@redhat.com>
	<yq1my1a52k4.fsf@sermon.lab.mkp.net>
	<20091222214250.GA28497@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091222214250.GA28497@redhat.com> (Mike Snitzer's message of
	"Tue, 22 Dec 2009 16:42:52 -0500")
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

>>>>> "Mike" == Mike Snitzer <snitzer@redhat.com> writes:

Mike> I also need to review your patch further (relative to virtual
Mike> device stacking: does get_start_sect(bdev) always work?).

Yep.

I found a bug in the partition alignment reporting.  The following patch
should fix that.  Please try it out.

Concerning your test cases: It is perfectly valid for two component
devices to be misaligned with regards to their underlying physical
devices as long as they have identical alignment.  In that case the top
level device will report a suitable alignment_offset.


block: Fix topology stacking for data and discard alignment

The stacking code incorrectly scaled up the data offset in some cases
causing misaligned devices to report alignment.  Rewrite the stacking
algorithm to remedy this and apply the same alignment principles to the
discard handling.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6ae118d..ca4f0a4 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -517,9 +517,8 @@ static unsigned int lcm(unsigned int a, unsigned int b)
 int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 		     sector_t offset)
 {
-	int ret;
-
-	ret = 0;
+	sector_t alignment;
+	unsigned int top, bottom;
 
 	t->max_sectors = min_not_zero(t->max_sectors, b->max_sectors);
 	t->max_hw_sectors = min_not_zero(t->max_hw_sectors, b->max_hw_sectors);
@@ -537,6 +536,18 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	alignment = queue_limit_alignment_offset(b, offset);
+
+	if (t->alignment_offset != alignment) {
+
+		top = max(t->physical_block_size, t->io_min)
+			+ t->alignment_offset;
+		bottom = max(b->physical_block_size, b->io_min) + alignment;
+
+		if (max(top, bottom) & (min(top, bottom) - 1))
+			t->misaligned = 1;
+	}
+
 	t->logical_block_size = max(t->logical_block_size,
 				    b->logical_block_size);
 
@@ -544,54 +555,55 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 				     b->physical_block_size);
 
 	t->io_min = max(t->io_min, b->io_min);
+	t->io_opt = lcm(t->io_opt, b->io_opt);
+
 	t->no_cluster |= b->no_cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
 
-	/* Bottom device offset aligned? */
-	if (offset &&
-	    (offset & (b->physical_block_size - 1)) != b->alignment_offset) {
+	if (t->physical_block_size & (t->logical_block_size - 1)) {
+		t->physical_block_size = t->logical_block_size;
 		t->misaligned = 1;
-		ret = -1;
 	}
 
-	/*
-	 * Temporarily disable discard granularity. It's currently buggy
-	 * since we default to 0 for discard_granularity, hence this
-	 * "failure" will always trigger for non-zero offsets.
-	 */
-#if 0
-	if (offset &&
-	    (offset & (b->discard_granularity - 1)) != b->discard_alignment) {
-		t->discard_misaligned = 1;
-		ret = -1;
+	if (t->io_min & (t->physical_block_size - 1)) {
+		t->io_min = t->physical_block_size;
+		t->misaligned = 1;
 	}
-#endif
 
-	/* If top has no alignment offset, inherit from bottom */
-	if (!t->alignment_offset)
-		t->alignment_offset =
-			b->alignment_offset & (b->physical_block_size - 1);
+	if (t->io_opt & (t->physical_block_size - 1)) {
+		t->io_opt = 0;
+		t->misaligned = 1;
+	}
 
-	if (!t->discard_alignment)
-		t->discard_alignment =
-			b->discard_alignment & (b->discard_granularity - 1);
+	t->alignment_offset = lcm(t->alignment_offset, alignment)
+		& (max(t->physical_block_size, t->io_min) - 1);
 
-	/* Top device aligned on logical block boundary? */
-	if (t->alignment_offset & (t->logical_block_size - 1)) {
+	if (t->alignment_offset & (t->logical_block_size - 1))
 		t->misaligned = 1;
-		ret = -1;
-	}
 
-	/* Find lcm() of optimal I/O size and granularity */
-	t->io_opt = lcm(t->io_opt, b->io_opt);
-	t->discard_granularity = lcm(t->discard_granularity,
-				     b->discard_granularity);
+	/* Discard alignment and granularity */
+	if (b->discard_granularity) {
+
+		alignment = b->discard_alignment -
+			(offset & (b->discard_granularity - 1));
+
+		if (t->discard_granularity != 0 &&
+		    t->discard_alignment != alignment) {
+			top = t->discard_granularity + t->discard_alignment;
+			bottom = b->discard_granularity + alignment;
 
-	/* Verify that optimal I/O size is a multiple of io_min */
-	if (t->io_min && t->io_opt % t->io_min)
-		ret = -1;
+			/* Verify that top and bottom intervals line up */
+			if (max(top, bottom) & (min(top, bottom) - 1))
+				t->discard_misaligned = 1;
+		}
+
+		t->discard_granularity = max(t->discard_granularity,
+					     b->discard_granularity);
+		t->discard_alignment = lcm(t->discard_alignment, alignment) &
+			(t->discard_granularity - 1);
+	}
 
-	return ret;
+	return t->misaligned ? -1 : 0;
 }
 EXPORT_SYMBOL(blk_stack_limits);
 
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
