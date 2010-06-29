From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/2 v3] dm: discard support for the linear target
Date: Tue, 29 Jun 2010 01:25:46 -0400
Message-ID: <20100629052546.GA15852@redhat.com>
References: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1277584285-13774-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
List-Id: dm-devel.ids

Allow discards to be passed through to a single device linear mapping.
Introduce DM_TARGET_SUPPORTS_DISCARDS target features flag that each
target must set once discard support is added.

Verify table's underlying devices support discards prior to setting the
associated DM device as capable of discards (via QUEUE_FLAG_DISCARD).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-linear.c        |    1 
 drivers/md/dm-table.c         |   50 +++++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |   60 +++++++++++++++++++++++++++++++++---------
 drivers/md/dm.h               |    1 
 include/linux/device-mapper.h |    1 
 5 files changed, 101 insertions(+), 12 deletions(-)

Index: linux-2.6/drivers/md/dm-linear.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-linear.c
+++ linux-2.6/drivers/md/dm-linear.c
@@ -152,6 +152,7 @@ static struct target_type linear_target 
 	.ioctl  = linear_ioctl,
 	.merge  = linear_merge,
 	.iterate_devices = linear_iterate_devices,
+	.features = DM_TARGET_SUPPORTS_DISCARDS,
 };
 
 int __init dm_linear_init(void)
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -54,6 +54,8 @@ struct dm_table {
 	sector_t *highs;
 	struct dm_target *targets;
 
+	unsigned discards_supported:1;
+
 	/*
 	 * Indicates the rw permissions for the new logical
 	 * device.  This should be a combination of FMODE_READ
@@ -203,6 +205,7 @@ int dm_table_create(struct dm_table **re
 
 	INIT_LIST_HEAD(&t->devices);
 	atomic_set(&t->holders, 0);
+	t->discards_supported = 1;
 
 	if (!num_targets)
 		num_targets = KEYS_PER_NODE;
@@ -770,6 +773,9 @@ int dm_table_add_target(struct dm_table 
 
 	t->highs[t->num_targets++] = tgt->begin + tgt->len - 1;
 
+	if (!(tgt->type->features & DM_TARGET_SUPPORTS_DISCARDS))
+		t->discards_supported = 0;
+
 	return 0;
 
  bad:
@@ -905,6 +911,12 @@ int dm_table_complete(struct dm_table *t
 	int r = 0;
 	unsigned int leaf_nodes;
 
+	/*
+	 * We only support discards if there is exactly one underlying device.
+	 */
+	if (!list_is_singular(&t->devices))
+		t->discards_supported = 0;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
@@ -1086,6 +1098,9 @@ void dm_table_set_restrictions(struct dm
 	else
 		queue_flag_set_unlocked(QUEUE_FLAG_CLUSTER, q);
 
+	if (dm_table_supports_discards(t))
+		queue_flag_set_unlocked(QUEUE_FLAG_DISCARD, q);
+
 	dm_table_set_integrity(t);
 
 	/*
@@ -1232,6 +1247,41 @@ struct mapped_device *dm_table_get_md(st
 	return t->md;
 }
 
+static int device_discard_incapable(struct dm_target *ti, struct dm_dev *dev,
+				    sector_t start, sector_t len, void *data)
+{
+	struct block_device *bdev = dev->bdev;
+	struct request_queue *q = bdev_get_queue(bdev);
+
+	return (!q || !blk_queue_discard(q));
+}
+
+bool dm_table_supports_discards(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	if (!t->discards_supported)
+		return 0;
+
+	/*
+	 * table's targets support discards but do
+	 * the underlying devices?
+	 */
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!ti->type->iterate_devices)
+			return 0; /* assume DISCARD incapable */
+
+		if (ti->type->iterate_devices(ti, device_discard_incapable,
+					      NULL))
+			return 0;
+	}
+
+	return 1;
+}
+
 EXPORT_SYMBOL(dm_vcalloc);
 EXPORT_SYMBOL(dm_get_device);
 EXPORT_SYMBOL(dm_put_device);
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c
+++ linux-2.6/drivers/md/dm.c
@@ -1198,6 +1198,48 @@ static int __clone_and_map_empty_barrier
 	return 0;
 }
 
+/*
+ * Perform all io with a single clone.
+ */
+static void __clone_and_map_simple(struct clone_info *ci, struct dm_target *ti)
+{
+	struct bio *clone, *bio = ci->bio;
+	struct dm_target_io *tio;
+
+	tio = alloc_tio(ci, ti);
+	clone = clone_bio(bio, ci->sector, ci->idx,
+			  bio->bi_vcnt - ci->idx, ci->sector_count,
+			  ci->md->bs);
+	__map_bio(ti, clone, tio);
+	ci->sector_count = 0;
+}
+
+static int __clone_and_map_discard(struct clone_info *ci)
+{
+	struct dm_target *ti;
+	sector_t max;
+
+	if (!dm_table_supports_discards(ci->map))
+		return -EOPNOTSUPP;
+
+	ti = dm_table_find_target(ci->map, ci->sector);
+	if (!dm_target_is_valid(ti))
+		return -EIO;
+
+	max = max_io_len(ci->md, ci->sector, ti);
+
+	if (ci->sector_count > max) {
+		/*
+		 * FIXME: Handle a discard that spans two or more targets.
+		 */
+		return -EOPNOTSUPP;
+	}
+
+	__clone_and_map_simple(ci, ti);
+
+	return 0;
+}
+
 static int __clone_and_map(struct clone_info *ci)
 {
 	struct bio *clone, *bio = ci->bio;
@@ -1208,27 +1250,21 @@ static int __clone_and_map(struct clone_
 	if (unlikely(bio_empty_barrier(bio)))
 		return __clone_and_map_empty_barrier(ci);
 
+	if (unlikely(bio_rw_flagged(bio, BIO_RW_DISCARD)))
+		return __clone_and_map_discard(ci);
+
 	ti = dm_table_find_target(ci->map, ci->sector);
 	if (!dm_target_is_valid(ti))
 		return -EIO;
 
 	max = max_io_len(ci->md, ci->sector, ti);
 
-	/*
-	 * Allocate a target io object.
-	 */
-	tio = alloc_tio(ci, ti);
-
 	if (ci->sector_count <= max) {
 		/*
 		 * Optimise for the simple case where we can do all of
 		 * the remaining io with a single clone.
 		 */
-		clone = clone_bio(bio, ci->sector, ci->idx,
-				  bio->bi_vcnt - ci->idx, ci->sector_count,
-				  ci->md->bs);
-		__map_bio(ti, clone, tio);
-		ci->sector_count = 0;
+		__clone_and_map_simple(ci, ti);
 
 	} else if (to_sector(bio->bi_io_vec[ci->idx].bv_len) <= max) {
 		/*
@@ -1249,6 +1285,7 @@ static int __clone_and_map(struct clone_
 			len += bv_len;
 		}
 
+		tio = alloc_tio(ci, ti);
 		clone = clone_bio(bio, ci->sector, ci->idx, i - ci->idx, len,
 				  ci->md->bs);
 		__map_bio(ti, clone, tio);
@@ -1272,12 +1309,11 @@ static int __clone_and_map(struct clone_
 					return -EIO;
 
 				max = max_io_len(ci->md, ci->sector, ti);
-
-				tio = alloc_tio(ci, ti);
 			}
 
 			len = min(remaining, max);
 
+			tio = alloc_tio(ci, ti);
 			clone = split_bvec(bio, ci->sector, ci->idx,
 					   bv->bv_offset + offset, len,
 					   ci->md->bs);
Index: linux-2.6/drivers/md/dm.h
===================================================================
--- linux-2.6.orig/drivers/md/dm.h
+++ linux-2.6/drivers/md/dm.h
@@ -62,6 +62,7 @@ int dm_table_any_busy_target(struct dm_t
 int dm_table_set_type(struct dm_table *t);
 unsigned dm_table_get_type(struct dm_table *t);
 bool dm_table_request_based(struct dm_table *t);
+bool dm_table_supports_discards(struct dm_table *t);
 int dm_table_alloc_md_mempools(struct dm_table *t);
 void dm_table_free_md_mempools(struct dm_table *t);
 struct dm_md_mempools *dm_table_get_md_mempools(struct dm_table *t);
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h
+++ linux-2.6/include/linux/device-mapper.h
@@ -130,6 +130,7 @@ void dm_put_device(struct dm_target *ti,
 /*
  * Target features
  */
+#define DM_TARGET_SUPPORTS_DISCARDS 0x00000001
 
 struct target_type {
 	uint64_t features;
