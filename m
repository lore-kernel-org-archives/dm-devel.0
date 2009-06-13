From: Mike Snitzer <snitzer@redhat.com>
Subject: [RFC][PATCH 2/2] dm: establish queue limits just before
	table resume
Date: Sat, 13 Jun 2009 19:25:42 -0400
Message-ID: <1244935542-18919-2-git-send-email-snitzer@redhat.com>
References: <1244935542-18919-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1244935542-18919-1-git-send-email-snitzer@redhat.com>
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
Cc: martin.petersen@oracle.com, agk@redhat.com
List-Id: dm-devel.ids

Initialization and validation of a DM device's queue_limits is now done
just before dm_swap_table() discards the previous table.  Doing so
allows for the limits to be properly calculated (relative to other DM
tables that may have also been loaded in the same transaction).  This
eliminates a restriction that was inadvertantly introduced on userspace
(e.g. LVM2) relative to having to resume devices that a new device was
dependent on for it's table load.

The 'limits' (struct queue_limits) member has been removed from both the
dm_table and dm_target structures (reducing DM's memory consumption).

The dm-log.c changes highlight the somewhat awkward nature of not having
queue_limits be a member of 'struct dm_target'.  The same pattern,
recalculating the target's queue_limits, is also used in various places
in dm-table.c.

dm-table.c:dm_set_device_limits now passes the 'start' of the device's
data area (aka pe_start) as the 'offset' to blk_stack_limits().

init_valid_queue_limits() was removed in favor of Martin Petersen's
pending blk_set_default_limits().

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: agk@redhat.com
Cc: martin.petersen@oracle.com
---
 drivers/md/dm-log.c           |   12 ++
 drivers/md/dm-table.c         |  188 +++++++++++++++++++++++-------------------
 drivers/md/dm.c               |   12 ++
 drivers/md/dm.h               |    4 
 include/linux/device-mapper.h |    9 --
 5 files changed, 130 insertions(+), 95 deletions(-)

Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1255,7 +1255,8 @@ static void __set_size(struct mapped_dev
 	mutex_unlock(&md->suspended_bdev->bd_inode->i_mutex);
 }
 
-static int __bind(struct mapped_device *md, struct dm_table *t)
+static int __bind(struct mapped_device *md, struct dm_table *t,
+		  struct queue_limits *limits)
 {
 	struct request_queue *q = md->queue;
 	sector_t size;
@@ -1280,7 +1281,7 @@ static int __bind(struct mapped_device *
 
 	write_lock(&md->map_lock);
 	md->map = t;
-	dm_table_set_restrictions(t, q);
+	dm_table_set_restrictions(t, q, limits);
 	write_unlock(&md->map_lock);
 
 	return 0;
@@ -1503,6 +1504,7 @@ static void dm_queue_flush(struct mapped
  */
 int dm_swap_table(struct mapped_device *md, struct dm_table *table)
 {
+	struct queue_limits limits;
 	int r = -EINVAL;
 
 	mutex_lock(&md->suspend_lock);
@@ -1516,8 +1518,12 @@ int dm_swap_table(struct mapped_device *
 		if (get_capacity(md->disk) != dm_table_get_size(table))
 			goto out;
 
+	r = dm_set_limits(table, &limits);
+	if (r)
+		goto out;
+
 	__unbind(md);
-	r = __bind(md, table);
+	r = __bind(md, table, &limits);
 
 out:
 	mutex_unlock(&md->suspend_lock);
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -62,12 +62,6 @@ struct dm_table {
 	/* a list of devices used by this table */
 	struct list_head devices;
 
-	/*
-	 * These are optimistic limits taken from all the
-	 * targets, some targets will need smaller limits.
-	 */
-	struct queue_limits limits;
-
 	/* events get handed up using this callback */
 	void (*event_fn)(void *);
 	void *event_context;
@@ -348,18 +342,21 @@ static void close_dev(struct dm_dev_inte
 /*
  * If possible, this checks an area of a destination device is valid.
  */
-static int device_area_is_valid(struct dm_target *ti, struct block_device *bdev,
-			     sector_t start, sector_t len)
+static int device_area_is_valid(struct dm_target *ti, struct dm_dev *dev,
+				sector_t start, void *data)
 {
-	sector_t dev_size = i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
+	struct queue_limits *limits = (struct queue_limits *) data;
+	struct block_device *bdev = dev->bdev;
+	sector_t dev_size =
+		i_size_read(bdev->bd_inode) >> SECTOR_SHIFT;
 	unsigned short logical_block_size_sectors =
-		ti->limits.logical_block_size >> SECTOR_SHIFT;
+		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
 		return 1;
 
-	if ((start >= dev_size) || (start + len > dev_size)) {
+	if ((start >= dev_size) || (start + ti->len > dev_size)) {
 		DMWARN("%s: %s too small for target",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 		return 0;
@@ -373,16 +370,16 @@ static int device_area_is_valid(struct d
 		       "logical block size %hu of %s",
 		       dm_device_name(ti->table->md),
 		       (unsigned long long)start,
-		       ti->limits.logical_block_size, bdevname(bdev, b));
+		       limits->logical_block_size, bdevname(bdev, b));
 		return 0;
 	}
 
-	if (len & (logical_block_size_sectors - 1)) {
+	if (ti->len & (logical_block_size_sectors - 1)) {
 		DMWARN("%s: len=%llu not aligned to h/w "
 		       "logical block size %hu of %s",
 		       dm_device_name(ti->table->md),
-		       (unsigned long long)len,
-		       ti->limits.logical_block_size, bdevname(bdev, b));
+		       (unsigned long long)ti->len,
+		       limits->logical_block_size, bdevname(bdev, b));
 		return 0;
 	}
 
@@ -481,18 +478,21 @@ static int __table_get_device(struct dm_
  */
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
 
-void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev)
+int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
+			 sector_t start, void *data)
 {
+	struct queue_limits *limits = (struct queue_limits *) data;
+	struct block_device *bdev = dev->bdev;
 	struct request_queue *q = bdev_get_queue(bdev);
 	char b[BDEVNAME_SIZE];
 
 	if (unlikely(!q)) {
 		DMWARN("%s: Cannot set limits for nonexistent device %s",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
-		return;
+		return 0;
 	}
 
-	if (blk_stack_limits(&ti->limits, &q->limits, 0) < 0)
+	if (blk_stack_limits(limits, &q->limits, start) < 0)
 		DMWARN("%s: target device %s is misaligned",
 		       dm_device_name(ti->table->md), bdevname(bdev, b));
 
@@ -503,32 +503,21 @@ void dm_set_device_limits(struct dm_targ
 	 */
 
 	if (q->merge_bvec_fn && !ti->type->merge)
-		ti->limits.max_sectors =
-			min_not_zero(ti->limits.max_sectors,
+		limits->max_sectors =
+			min_not_zero(limits->max_sectors,
 				     (unsigned int) (PAGE_SIZE >> 9));
+	return 0;
 }
 EXPORT_SYMBOL_GPL(dm_set_device_limits);
 
 int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
 		  sector_t len, fmode_t mode, struct dm_dev **result)
 {
-	int r = __table_get_device(ti->table, ti, path,
-				   start, len, mode, result);
-
-	if (r)
-		return r;
-
-	dm_set_device_limits(ti, (*result)->bdev);
-
-	if (!device_area_is_valid(ti, (*result)->bdev, start, len)) {
-		dm_put_device(ti, *result);
-		*result = NULL;
-		return -EINVAL;
-	}
-
-	return r;
+	return __table_get_device(ti->table, ti, path,
+				  start, len, mode, result);
 }
 
+
 /*
  * Decrement a devices use count and remove it if necessary.
  */
@@ -643,34 +632,6 @@ int dm_split_args(int *argc, char ***arg
 	return 0;
 }
 
-static void init_valid_queue_limits(struct queue_limits *limits)
-{
-	if (!limits->max_sectors)
-		limits->max_sectors = SAFE_MAX_SECTORS;
-	if (!limits->max_hw_sectors)
-		limits->max_hw_sectors = SAFE_MAX_SECTORS;
-	if (!limits->max_phys_segments)
-		limits->max_phys_segments = MAX_PHYS_SEGMENTS;
-	if (!limits->max_hw_segments)
-		limits->max_hw_segments = MAX_HW_SEGMENTS;
-	if (!limits->logical_block_size)
-		limits->logical_block_size = 1 << SECTOR_SHIFT;
-	if (!limits->physical_block_size)
-		limits->physical_block_size = 1 << SECTOR_SHIFT;
-	if (!limits->io_min)
-		limits->io_min = 1 << SECTOR_SHIFT;
-	if (!limits->max_segment_size)
-		limits->max_segment_size = MAX_SEGMENT_SIZE;
-	if (!limits->seg_boundary_mask)
-		limits->seg_boundary_mask = BLK_SEG_BOUNDARY_MASK;
-	if (!limits->bounce_pfn)
-		limits->bounce_pfn = -1;
-	/*
-	 * The other fields (alignment_offset, io_opt, misaligned)
-	 * hold 0 from the kzalloc().
-	 */
-}
-
 /*
  * Impose necessary and sufficient conditions on a devices's table such
  * that any incoming bio which respects its logical_block_size can be
@@ -678,14 +639,16 @@ static void init_valid_queue_limits(stru
  * two or more targets, the size of each piece it gets split into must
  * be compatible with the logical_block_size of the target processing it.
  */
-static int validate_hardware_logical_block_alignment(struct dm_table *table)
+static int
+validate_hardware_logical_block_alignment(struct dm_table *table,
+					  struct queue_limits *limits)
 {
 	/*
 	 * This function uses arithmetic modulo the logical_block_size
 	 * (in units of 512-byte sectors).
 	 */
 	unsigned short device_logical_block_size_sects =
-		table->limits.logical_block_size >> SECTOR_SHIFT;
+		limits->logical_block_size >> SECTOR_SHIFT;
 
 	/*
 	 * Offset of the start of the next table entry, mod logical_block_size.
@@ -705,14 +668,23 @@ static int validate_hardware_logical_blo
 	 * Check each entry in the table in turn.
 	 */
 	while (i < dm_table_get_num_targets(table)) {
+		struct queue_limits ti_limits;
+		blk_set_default_limits(&ti_limits);
+
 		ti = dm_table_get_target(table, i++);
 
+		/* combine all target devices' limits */
+		blk_set_default_limits(&ti_limits);
+		if (ti->type->iterate_devices)
+			ti->type->iterate_devices(ti, dm_set_device_limits,
+						  &ti_limits);
+
 		/*
 		 * If the remaining sectors fall entirely within this
 		 * table entry are they compatible with its logical_block_size?
 		 */
 		if (remaining < ti->len &&
-		    remaining & ((ti->limits.logical_block_size >>
+		    remaining & ((ti_limits.logical_block_size >>
 				  SECTOR_SHIFT) - 1))
 			break;	/* Error */
 
@@ -725,11 +697,11 @@ static int validate_hardware_logical_blo
 
 	if (remaining) {
 		DMWARN("%s: table line %u (start sect %llu len %llu) "
-		       "not aligned to hardware logical block size %hu",
+		       "not aligned to h/w logical block size %hu",
 		       dm_device_name(table->md), i,
 		       (unsigned long long) ti->begin,
 		       (unsigned long long) ti->len,
-		       table->limits.logical_block_size);
+		       limits->logical_block_size);
 		return -EINVAL;
 	}
 
@@ -788,12 +760,6 @@ int dm_table_add_target(struct dm_table 
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
-	if (blk_stack_limits(&t->limits, &tgt->limits, 0) < 0)
-		DMWARN("%s: target device (start sect %llu len %llu) "
-		       "is misaligned",
-		       dm_device_name(t->md),
-		       (unsigned long long) tgt->begin,
-		       (unsigned long long) tgt->len);
 	return 0;
 
  bad:
@@ -836,12 +802,6 @@ int dm_table_complete(struct dm_table *t
 	int r = 0;
 	unsigned int leaf_nodes;
 
-	init_valid_queue_limits(&t->limits);
-
-	r = validate_hardware_logical_block_alignment(t);
-	if (r)
-		return r;
-
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
@@ -917,6 +877,56 @@ struct dm_target *dm_table_find_target(s
 }
 
 /*
+ * Establish the new table's queue_limits and validate them
+ */
+int dm_set_limits(struct dm_table *table, struct queue_limits *limits)
+{
+	struct dm_target *uninitialized_var(ti);
+	unsigned i = 0;
+	int r = -EINVAL;
+
+	blk_set_default_limits(limits);
+
+	while (i < dm_table_get_num_targets(table)) {
+		struct queue_limits ti_limits;
+		blk_set_default_limits(&ti_limits);
+
+		ti = dm_table_get_target(table, i++);
+
+		blk_set_default_limits(&ti_limits);
+		if (!ti->type->iterate_devices)
+			goto stack_default;
+
+		/* combine limits of target's devices */
+		ti->type->iterate_devices(ti, dm_set_device_limits,
+					  &ti_limits);
+
+		/*
+		 * Target's limits are not immediately combined into
+		 * the top-level limits because they are needed
+		 * to validate the target's device area
+		 */
+		if (ti->type->iterate_devices(ti, device_area_is_valid,
+					      &ti_limits) != 0)
+			goto out;
+
+		/* combine target's limits into table's limits */
+stack_default:
+		if (blk_stack_limits(limits, &ti_limits, 0) < 0)
+			DMWARN("%s: target device "
+			       "(start sect %llu len %llu) "
+			       "is misaligned",
+			       dm_device_name(table->md),
+			       (unsigned long long) ti->begin,
+			       (unsigned long long) ti->len);
+	}
+	r = validate_hardware_logical_block_alignment(table, limits);
+
+out:
+	return r;
+}
+
+/*
  * Set the integrity profile for this device if all devices used have
  * matching profiles.
  */
@@ -955,14 +965,26 @@ no_integrity:
 	return;
 }
 
-void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
+void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
+			       struct queue_limits *limits)
 {
 	/*
+	 * Each target device in the table has a data area that is aligned
+	 * (via userspace) so the DM device's alignment_offset should be 0.
+	 * - FIXME: more work is needed to have DM (and the block layer)
+	 *   properly calculate the 'alignment_offset' for DM devices;
+	 *   e.g. blk_stack_limits() might also need to account for the
+	 *        bottom devices' offset within the top device.
+	 */
+	limits->alignment_offset = 0;
+	limits->misaligned = 0;
+
+	/*
 	 * Copy table's limits to the DM device's request_queue
 	 */
-	q->limits = t->limits;
+	q->limits = *limits;
 
-	if (t->limits.no_cluster)
+	if (limits->no_cluster)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -102,7 +102,8 @@ void dm_error(const char *message);
 /*
  * Combine device limits.
  */
-void dm_set_device_limits(struct dm_target *ti, struct block_device *bdev);
+int dm_set_device_limits(struct dm_target *ti, struct dm_dev *dev,
+			 sector_t start, void *data);
 
 struct dm_dev {
 	struct block_device *bdev;
@@ -166,12 +167,6 @@ struct dm_target {
 	/* Always a power of 2 */
 	sector_t split_io;
 
-	/*
-	 * These are automatically filled in by
-	 * dm_table_get_device.
-	 */
-	struct queue_limits limits;
-
 	/* target specific data */
 	void *private;
 
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -41,7 +41,9 @@ void dm_table_event_callback(struct dm_t
 			     void (*fn)(void *), void *context);
 struct dm_target *dm_table_get_target(struct dm_table *t, unsigned int index);
 struct dm_target *dm_table_find_target(struct dm_table *t, sector_t sector);
-void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q);
+int dm_set_limits(struct dm_table *table, struct queue_limits *limits);
+void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
+			       struct queue_limits *limits);
 struct list_head *dm_table_get_devices(struct dm_table *t);
 void dm_table_presuspend_targets(struct dm_table *t);
 void dm_table_postsuspend_targets(struct dm_table *t);
Index: linux-2.6/drivers/md/dm-log.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-log.c
+++ linux-2.6/drivers/md/dm-log.c
@@ -343,6 +343,7 @@ static int create_log_context(struct dm_
 	struct log_c *lc;
 	uint32_t region_size;
 	unsigned int region_count;
+	struct queue_limits ti_limits;
 	size_t bitset_size, buf_size;
 	int r;
 
@@ -410,11 +411,20 @@ static int create_log_context(struct dm_
 		lc->header_location.sector = 0;
 
 		/*
+		 * combine all target devices' limits
+		 * - limits are recalculated rather than stored in target
+		 */
+		blk_set_default_limits(&ti_limits);
+		if (ti->type->iterate_devices)
+			ti->type->iterate_devices(ti, dm_set_device_limits,
+						  &ti_limits);
+
+		/*
 		 * Buffer holds both header and bitset.
 		 */
 		buf_size = dm_round_up((LOG_OFFSET << SECTOR_SHIFT) +
 				       bitset_size,
-				       ti->limits.logical_block_size);
+				       ti_limits.logical_block_size);
 
 		if (buf_size > i_size_read(dev->bdev->bd_inode)) {
 			DMWARN("log device %s too small: need %llu bytes",
