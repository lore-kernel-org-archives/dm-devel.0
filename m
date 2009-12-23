From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 2/2] block: Fix topology stacking for data and
	discard alignment
Date: Wed, 23 Dec 2009 15:31:30 -0500
Message-ID: <1261600290-29627-3-git-send-email-martin.petersen@oracle.com>
References: <20091223171351.GA17896@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20091223171351.GA17896@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, snitzer@redhat.com, dm-devel@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

The stacking code incorrectly scaled up the data offset in some cases
causing misaligned devices to report alignment.  Rewrite the stacking
algorithm to remedy this and apply the same alignment principles to the
discard handling.  Clarify documentation and comments.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Tested-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-settings.c |  121 ++++++++++++++++++++++++++++++++------------------
 1 files changed, 78 insertions(+), 43 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 6ae118d..d52d4ad 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -505,21 +505,30 @@ static unsigned int lcm(unsigned int a, unsigned int b)
 
 /**
  * blk_stack_limits - adjust queue_limits for stacked devices
- * @t:	the stacking driver limits (top)
- * @b:  the underlying queue limits (bottom)
+ * @t:	the stacking driver limits (top device)
+ * @b:  the underlying queue limits (bottom, component device)
  * @offset:  offset to beginning of data within component device
  *
  * Description:
- *    Merges two queue_limit structs.  Returns 0 if alignment didn't
- *    change.  Returns -1 if adding the bottom device caused
- *    misalignment.
+ *    This function is used by stacking drivers like MD and DM to ensure
+ *    that all component devices have compatible block sizes and
+ *    alignments.  The stacking driver must provide a queue_limits
+ *    struct (top) and then iteratively call the stacking function for
+ *    all component (bottom) devices.  The stacking function will
+ *    attempt to combine the values and ensure proper alignment.
+ *
+ *    Returns 0 if the top and bottom queue_limits are compatible.  The
+ *    top device's block sizes and alignment offsets may be adjusted to
+ *    ensure alignment with the bottom device. If no compatible sizes
+ *    and alignments exist, -1 is returned and the resulting top
+ *    queue_limits will have the misaligned flag set to indicate that
+ *    the alignment_offset is undefined.
  */
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
@@ -537,6 +546,22 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 	t->max_segment_size = min_not_zero(t->max_segment_size,
 					   b->max_segment_size);
 
+	alignment = queue_limit_alignment_offset(b, offset);
+
+	/* Bottom device has different alignment.  Check that it is
+	 * compatible with the current top alignment.
+	 */
+	if (t->alignment_offset != alignment) {
+
+		top = max(t->physical_block_size, t->io_min)
+			+ t->alignment_offset;
+		bottom = max(b->physical_block_size, b->io_min) + alignment;
+
+		/* Verify that top and bottom intervals line up */
+		if (max(top, bottom) & (min(top, bottom) - 1))
+			t->misaligned = 1;
+	}
+
 	t->logical_block_size = max(t->logical_block_size,
 				    b->logical_block_size);
 
@@ -544,54 +569,64 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 				     b->physical_block_size);
 
 	t->io_min = max(t->io_min, b->io_min);
+	t->io_opt = lcm(t->io_opt, b->io_opt);
+
 	t->no_cluster |= b->no_cluster;
 	t->discard_zeroes_data &= b->discard_zeroes_data;
 
-	/* Bottom device offset aligned? */
-	if (offset &&
-	    (offset & (b->physical_block_size - 1)) != b->alignment_offset) {
+	/* Physical block size a multiple of the logical block size? */
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
+	/* Minimum I/O a multiple of the physical block size? */
+	if (t->io_min & (t->physical_block_size - 1)) {
+		t->io_min = t->physical_block_size;
+		t->misaligned = 1;
 	}
-#endif
-
-	/* If top has no alignment offset, inherit from bottom */
-	if (!t->alignment_offset)
-		t->alignment_offset =
-			b->alignment_offset & (b->physical_block_size - 1);
 
-	if (!t->discard_alignment)
-		t->discard_alignment =
-			b->discard_alignment & (b->discard_granularity - 1);
-
-	/* Top device aligned on logical block boundary? */
-	if (t->alignment_offset & (t->logical_block_size - 1)) {
+	/* Optimal I/O a multiple of the physical block size? */
+	if (t->io_opt & (t->physical_block_size - 1)) {
+		t->io_opt = 0;
 		t->misaligned = 1;
-		ret = -1;
 	}
 
-	/* Find lcm() of optimal I/O size and granularity */
-	t->io_opt = lcm(t->io_opt, b->io_opt);
-	t->discard_granularity = lcm(t->discard_granularity,
-				     b->discard_granularity);
+	/* Find lowest common alignment_offset */
+	t->alignment_offset = lcm(t->alignment_offset, alignment)
+		& (max(t->physical_block_size, t->io_min) - 1);
 
-	/* Verify that optimal I/O size is a multiple of io_min */
-	if (t->io_min && t->io_opt % t->io_min)
-		ret = -1;
+	/* Verify that new alignment_offset is on a logical block boundary */
+	if (t->alignment_offset & (t->logical_block_size - 1))
+		t->misaligned = 1;
+
+	/* Discard alignment and granularity */
+	if (b->discard_granularity) {
+		unsigned int granularity = b->discard_granularity;
+		offset &= granularity - 1;
+
+		alignment = (granularity + b->discard_alignment - offset)
+			& (granularity - 1);
+
+		if (t->discard_granularity != 0 &&
+		    t->discard_alignment != alignment) {
+			top = t->discard_granularity + t->discard_alignment;
+			bottom = b->discard_granularity + alignment;
+
+			/* Verify that top and bottom intervals line up */
+			if (max(top, bottom) & (min(top, bottom) - 1))
+				t->discard_misaligned = 1;
+		}
+
+		t->max_discard_sectors = min_not_zero(t->max_discard_sectors,
+						      b->max_discard_sectors);
+		t->discard_granularity = max(t->discard_granularity,
+					     b->discard_granularity);
+		t->discard_alignment = lcm(t->discard_alignment, alignment) &
+			(t->discard_granularity - 1);
+	}
 
-	return ret;
+	return t->misaligned ? -1 : 0;
 }
 EXPORT_SYMBOL(blk_stack_limits);
 
-- 
1.6.0.6
