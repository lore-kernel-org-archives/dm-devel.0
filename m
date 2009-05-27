From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm: add topology support
Date: Wed, 27 May 2009 17:06:53 -0400
Message-ID: <1243458413-15854-4-git-send-email-snitzer@redhat.com>
References: <1243458413-15854-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1243458413-15854-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: martin.petersen@oracle.com, agk@redhat.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

Use blk_stack_limits() to stack block limits (including topology) rather
than duplicate the equivalent within Device Mapper.

dm_table_set_restrictions() and check_for_valid_limits() must still
track the queue_limits structure's members.  To that end,
physical_block_size and other topology limit changes were added.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c         |  134 ++++++++++++------------------------------
 include/linux/device-mapper.h |   16 -----
 2 files changed, 42 insertions(+), 108 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -66,7 +66,7 @@ struct dm_table {
 	 * These are optimistic limits taken from all the
 	 * targets, some targets will need smaller limits.
 	 */
-	struct io_restrictions limits;
+	struct queue_limits limits;
 
 	/* events get handed up using this callback */
 	void (*event_fn)(void *);
@@ -89,43 +89,6 @@ static unsigned int int_log(unsigned int
 }
 
 /*
- * Returns the minimum that is _not_ zero, unless both are zero.
- */
-#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-
-/*
- * Combine two io_restrictions, always taking the lower value.
- */
-static void combine_restrictions_low(struct io_restrictions *lhs,
-				     struct io_restrictions *rhs)
-{
-	lhs->max_sectors =
-		min_not_zero(lhs->max_sectors, rhs->max_sectors);
-
-	lhs->max_phys_segments =
-		min_not_zero(lhs->max_phys_segments, rhs->max_phys_segments);
-
-	lhs->max_hw_segments =
-		min_not_zero(lhs->max_hw_segments, rhs->max_hw_segments);
-
-	lhs->logical_block_size = max(lhs->logical_block_size,
-				      rhs->logical_block_size);
-
-	lhs->max_segment_size =
-		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
-
-	lhs->max_hw_sectors =
-		min_not_zero(lhs->max_hw_sectors, rhs->max_hw_sectors);
-
-	lhs->seg_boundary_mask =
-		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
-
-	lhs->bounce_pfn = min_not_zero(lhs->bounce_pfn, rhs->bounce_pfn);
-
-	lhs->no_cluster |= rhs->no_cluster;
-}
-
-/*
  * Calculate the index of the child node of the n'th node k'th key.
  */
 static inline unsigned int get_child(unsigned int n, unsigned int k)
@@ -513,10 +476,14 @@ static int __table_get_device(struct dm_
 	return 0;
 }
 
+/*
+ * Returns the minimum that is _not_ zero, unless both are zero.
+ */
+#define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
+
 void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
-	struct io_restrictions *rs = &ti->limits;
 	char b[BDEVNAME_SIZE];
 
 	if (unlikely(!q)) {
@@ -525,15 +492,9 @@ void dm_set_device_limits(struct dm_targ
 		return;
 	}
 
-	/*
-	 * Combine the device limits low.
-	 *
-	 * FIXME: if we move an io_restriction struct
-	 *        into q this would just be a call to
-	 *        combine_restrictions_low()
-	 */
-	rs->max_sectors =
-		min_not_zero(rs->max_sectors, queue_max_sectors(q));
+	if (blk_stack_limits(&ti->limits, &q->limits, 0) < 0)
+		DMWARN("%s: target device %s is misaligned",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));
 
 	/*
 	 * Check if merge fn is supported.
@@ -542,33 +503,9 @@ void dm_set_device_limits(struct dm_targ
 	 */
 
 	if (q->merge_bvec_fn && !ti->type->merge)
-		rs->max_sectors =
-			min_not_zero(rs->max_sectors,
+		ti->limits.max_sectors =
+			min_not_zero(ti->limits.max_sectors,
 				     (unsigned int) (PAGE_SIZE >> 9));
-
-	rs->max_phys_segments =
-		min_not_zero(rs->max_phys_segments,
-			     queue_max_phys_segments(q));
-
-	rs->max_hw_segments =
-		min_not_zero(rs->max_hw_segments, queue_max_hw_segments(q));
-
-	rs->logical_block_size = max(rs->logical_block_size,
-				     queue_logical_block_size(q));
-
-	rs->max_segment_size =
-		min_not_zero(rs->max_segment_size, queue_max_segment_size(q));
-
-	rs->max_hw_sectors =
-		min_not_zero(rs->max_hw_sectors, queue_max_hw_sectors(q));
-
-	rs->seg_boundary_mask =
-		min_not_zero(rs->seg_boundary_mask,
-			     queue_segment_boundary(q));
-
-	rs->bounce_pfn = min_not_zero(rs->bounce_pfn, queue_bounce_pfn(q));
-
-	rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
@@ -706,24 +643,26 @@ int dm_split_args(int *argc, char ***arg
 	return 0;
 }
 
-static void check_for_valid_limits(struct io_restrictions *rs)
+static void check_for_valid_limits(struct queue_limits *limits)
 {
-	if (!rs->max_sectors)
-		rs->max_sectors = SAFE_MAX_SECTORS;
-	if (!rs->max_hw_sectors)
-		rs->max_hw_sectors = SAFE_MAX_SECTORS;
-	if (!rs->max_phys_segments)
-		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
-	if (!rs->max_hw_segments)
-		rs->max_hw_segments = MAX_HW_SEGMENTS;
-	if (!rs->logical_block_size)
-		rs->logical_block_size = 1 << SECTOR_SHIFT;
-	if (!rs->max_segment_size)
-		rs->max_segment_size = MAX_SEGMENT_SIZE;
-	if (!rs->seg_boundary_mask)
-		rs->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
-	if (!rs->bounce_pfn)
-		rs->bounce_pfn = -1;
+	if (!limits->max_sectors)
+		limits->max_sectors = SAFE_MAX_SECTORS;
+	if (!limits->max_hw_sectors)
+		limits->max_hw_sectors = SAFE_MAX_SECTORS;
+	if (!limits->max_phys_segments)
+		limits->max_phys_segments = MAX_PHYS_SEGMENTS;
+	if (!limits->max_hw_segments)
+		limits->max_hw_segments = MAX_HW_SEGMENTS;
+	if (!limits->logical_block_size)
+		limits->logical_block_size = 1 << SECTOR_SHIFT;
+	if (!limits->physical_block_size)
+		limits->physical_block_size = 1 << SECTOR_SHIFT;
+	if (!limits->max_segment_size)
+		limits->max_segment_size = MAX_SEGMENT_SIZE;
+	if (!limits->seg_boundary_mask)
+		limits->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
+	if (!limits->bounce_pfn)
+		limits->bounce_pfn = -1;
 }
 
 /*
@@ -843,9 +782,12 @@ int dm_table_add_target(struct dm_table 
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
-	/* FIXME: the plan is to combine high here and then have
-	 * the merge fn apply the target level restrictions. */
-	combine_restrictions_low(&t->limits, &tgt->limits);
+	if (blk_stack_limits(&t->limits, &tgt->limits, 0) < 0)
+		DMWARN("%s: target device (start sect %llu len %llu) "
+		       "is misaligned",
+		       dm_device_name(t->md),
+		       (unsigned long long) tgt->begin,
+		       (unsigned long long) tgt->len);
 	return 0;
 
  bad:
@@ -1017,10 +959,14 @@ void dm_table_set_restrictions(struct dm
 	blk_queue_max_phys_segments(q, t->limits.max_phys_segments);
 	blk_queue_max_hw_segments(q, t->limits.max_hw_segments);
 	blk_queue_logical_block_size(q, t->limits.logical_block_size);
+	blk_queue_physical_block_size(q, t->limits.physical_block_size);
 	blk_queue_max_segment_size(q, t->limits.max_segment_size);
 	blk_queue_max_hw_sectors(q, t->limits.max_hw_sectors);
 	blk_queue_segment_boundary(q, t->limits.seg_boundary_mask);
 	blk_queue_bounce_limit(q, t->limits.bounce_pfn);
+	blk_queue_io_min(q, t->limits.io_min);
+	blk_queue_io_opt(q, t->limits.io_opt);
+	blk_queue_alignment_offset(q, t->limits.alignment_offset);
 
 	if (t->limits.no_cluster)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -143,18 +143,6 @@ struct target_type {
 	struct list_head list;
 };
 
-struct io_restrictions {
-	unsigned long bounce_pfn;
-	unsigned long seg_boundary_mask;
-	unsigned max_hw_sectors;
-	unsigned max_sectors;
-	unsigned max_segment_size;
-	unsigned short logical_block_size;
-	unsigned short max_hw_segments;
-	unsigned short max_phys_segments;
-	unsigned char no_cluster; /* inverted so that 0 is default */
-};
-
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
@@ -163,7 +151,7 @@ struct dm_target {
 	sector_t begin;
 	sector_t len;
 
-	/* FIXME: turn this into a mask, and merge with io_restrictions */
+	/* FIXME: turn this into a mask, and merge with queue_limits */
 	/* Always a power of 2 */
 	sector_t split_io;
 
@@ -171,7 +159,7 @@ struct dm_target {
 	 * These are automatically filled in by
 	 * dm_table_get_device.
 	 */
-	struct io_restrictions limits;
+	struct queue_limits limits;
 
 	/* target specific data */
 	void *private;
