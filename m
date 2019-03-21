From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH] dm: rename max_io_len to io_boundary
Date: Thu, 21 Mar 2019 16:48:50 -0400 (EDT)
Message-ID: <alpine.LRH.2.02.1903211646170.994@file01.intranet.prod.int.rdu2.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, dm-devel@redhat.com, Ming Lei <ming.lei@redhat.com>, Alasdair Kergon <agk@redhat.com>
List-Id: dm-devel.ids

This patch renames dm_set_target_max_io_len to dm_set_target_io_boundary and
max_io_len to io_boundary. This variable is really a boundary, not a length.

If a bio crosses this boundary, the device mapper core splits it before
submitting it to the target.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-cache-target.c  |    2 +-
 drivers/md/dm-era-target.c    |    2 +-
 drivers/md/dm-integrity.c     |    4 ++--
 drivers/md/dm-raid.c          |    8 ++++----
 drivers/md/dm-raid1.c         |    2 +-
 drivers/md/dm-snap.c          |   14 +++++++-------
 drivers/md/dm-stripe.c        |    2 +-
 drivers/md/dm-switch.c        |    2 +-
 drivers/md/dm-table.c         |    4 ++--
 drivers/md/dm-thin.c          |    2 +-
 drivers/md/dm-unstripe.c      |    2 +-
 drivers/md/dm-zoned-target.c  |    2 +-
 drivers/md/dm.c               |   16 ++++++++--------
 include/linux/device-mapper.h |    4 ++--
 14 files changed, 33 insertions(+), 33 deletions(-)

Index: linux-2.6/drivers/md/dm-cache-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-cache-target.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-cache-target.c	2019-03-21 21:22:12.000000000 +0100
@@ -2530,7 +2530,7 @@ static int cache_create(struct cache_arg
 	cache->origin_blocks = to_oblock(origin_blocks);
 
 	cache->sectors_per_block = ca->block_size;
-	if (dm_set_target_max_io_len(ti, cache->sectors_per_block)) {
+	if (dm_set_target_io_boundary(ti, cache->sectors_per_block)) {
 		r = -EINVAL;
 		goto bad;
 	}
Index: linux-2.6/drivers/md/dm-era-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-era-target.c	2019-01-12 16:48:32.000000000 +0100
+++ linux-2.6/drivers/md/dm-era-target.c	2019-03-21 21:22:18.000000000 +0100
@@ -1460,7 +1460,7 @@ static int era_ctr(struct dm_target *ti,
 		return -EINVAL;
 	}
 
-	r = dm_set_target_max_io_len(ti, era->sectors_per_block);
+	r = dm_set_target_io_boundary(ti, era->sectors_per_block);
 	if (r) {
 		ti->error = "could not set max io len";
 		era_destroy(era);
Index: linux-2.6/drivers/md/dm-integrity.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-integrity.c	2019-03-21 17:07:37.000000000 +0100
+++ linux-2.6/drivers/md/dm-integrity.c	2019-03-21 21:25:46.000000000 +0100
@@ -3377,7 +3377,7 @@ static int dm_integrity_ctr(struct dm_ta
 		ti->error = "Corrupted superblock, journal_sections is 0";
 		goto bad;
 	}
-	/* make sure that ti->max_io_len doesn't overflow */
+	/* make sure that ti->io_boundary doesn't overflow */
 	if (!ic->meta_dev) {
 		if (ic->sb->log2_interleave_sectors < MIN_LOG2_INTERLEAVE_SECTORS ||
 		    ic->sb->log2_interleave_sectors > MAX_LOG2_INTERLEAVE_SECTORS) {
@@ -3516,7 +3516,7 @@ try_smaller_buffer:
 	}
 
 	if (!ic->meta_dev) {
-		r = dm_set_target_max_io_len(ti, 1U << ic->sb->log2_interleave_sectors);
+		r = dm_set_target_io_boundary(ti, 1U << ic->sb->log2_interleave_sectors);
 		if (r)
 			goto bad;
 	}
Index: linux-2.6/drivers/md/dm-raid.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-raid.c	2019-03-21 21:30:33.000000000 +0100
@@ -1122,7 +1122,7 @@ static int parse_raid_params(struct raid
 	unsigned int raid10_copies = 2;
 	unsigned int i, write_mostly = 0;
 	unsigned int region_size = 0;
-	sector_t max_io_len;
+	sector_t io_boundary;
 	const char *arg, *key;
 	struct raid_dev *rd;
 	struct raid_type *rt = rs->raid_type;
@@ -1482,11 +1482,11 @@ static int parse_raid_params(struct raid
 		return -EINVAL;
 
 	if (rs->md.chunk_sectors)
-		max_io_len = rs->md.chunk_sectors;
+		io_boundary = rs->md.chunk_sectors;
 	else
-		max_io_len = region_size;
+		io_boundary = region_size;
 
-	if (dm_set_target_max_io_len(rs->ti, max_io_len))
+	if (dm_set_target_io_boundary(rs->ti, io_boundary))
 		return -EINVAL;
 
 	if (rt_is_raid10(rt)) {
Index: linux-2.6/drivers/md/dm-raid1.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-raid1.c	2019-01-12 16:48:32.000000000 +0100
+++ linux-2.6/drivers/md/dm-raid1.c	2019-03-21 21:21:53.000000000 +0100
@@ -1112,7 +1112,7 @@ static int mirror_ctr(struct dm_target *
 
 	ti->private = ms;
 
-	r = dm_set_target_max_io_len(ti, dm_rh_get_region_size(ms->rh));
+	r = dm_set_target_io_boundary(ti, dm_rh_get_region_size(ms->rh));
 	if (r)
 		goto err_free_context;
 
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c	2019-03-18 10:29:35.000000000 +0100
+++ linux-2.6/drivers/md/dm-snap.c	2019-03-21 21:29:29.000000000 +0100
@@ -1328,7 +1328,7 @@ static int snapshot_ctr(struct dm_target
 		goto bad_read_metadata;
 	}
 
-	r = dm_set_target_max_io_len(ti, s->store->chunk_size);
+	r = dm_set_target_io_boundary(ti, s->store->chunk_size);
 	if (r)
 		goto bad_read_metadata;
 
@@ -1395,7 +1395,7 @@ static void __handover_exceptions(struct
 	snap_dest->store->snap = snap_dest;
 	snap_src->store->snap = snap_src;
 
-	snap_dest->ti->max_io_len = snap_dest->store->chunk_size;
+	snap_dest->ti->io_boundary = snap_dest->store->chunk_size;
 	snap_dest->valid = snap_src->valid;
 	snap_dest->snapshot_overflowed = snap_src->snapshot_overflowed;
 
@@ -2126,9 +2126,9 @@ static void snapshot_merge_resume(struct
 	snapshot_resume(ti);
 
 	/*
-	 * snapshot-merge acts as an origin, so set ti->max_io_len
+	 * snapshot-merge acts as an origin, so set ti->io_boundary
 	 */
-	ti->max_io_len = get_origin_minimum_chunksize(s->origin->bdev);
+	ti->io_boundary = get_origin_minimum_chunksize(s->origin->bdev);
 
 	start_merge(s);
 }
@@ -2370,12 +2370,12 @@ static int origin_write_extent(struct dm
 	struct origin *o;
 
 	/*
-	 * The origin's __minimum_chunk_size() got stored in max_io_len
+	 * The origin's __minimum_chunk_size() got stored in io_boundary
 	 * by snapshot_merge_resume().
 	 */
 	down_read(&_origins_lock);
 	o = __lookup_origin(merging_snap->origin->bdev);
-	for (n = 0; n < size; n += merging_snap->ti->max_io_len)
+	for (n = 0; n < size; n += merging_snap->ti->io_boundary)
 		if (__origin_write(&o->snapshots, sector + n, NULL) ==
 		    DM_MAPIO_SUBMITTED)
 			must_wait = 1;
@@ -2460,7 +2460,7 @@ static int origin_map(struct dm_target *
 }
 
 /*
- * Set the target "max_io_len" field to the minimum of all the snapshots'
+ * Set the target "io_boundary" field to the minimum of all the snapshots'
  * chunk sizes.
  */
 static void origin_resume(struct dm_target *ti)
Index: linux-2.6/drivers/md/dm-stripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-stripe.c	2019-02-25 22:19:38.000000000 +0100
+++ linux-2.6/drivers/md/dm-stripe.c	2019-03-21 21:22:05.000000000 +0100
@@ -161,7 +161,7 @@ static int stripe_ctr(struct dm_target *
 	else
 		sc->stripes_shift = __ffs(stripes);
 
-	r = dm_set_target_max_io_len(ti, chunk_size);
+	r = dm_set_target_io_boundary(ti, chunk_size);
 	if (r) {
 		kfree(sc);
 		return r;
Index: linux-2.6/drivers/md/dm-switch.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-switch.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-switch.c	2019-03-21 21:22:15.000000000 +0100
@@ -289,7 +289,7 @@ static int switch_ctr(struct dm_target *
 		return -ENOMEM;
 	}
 
-	r = dm_set_target_max_io_len(ti, region_size);
+	r = dm_set_target_io_boundary(ti, region_size);
 	if (r)
 		goto error;
 
Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-table.c	2019-03-21 21:25:02.000000000 +0100
@@ -985,7 +985,7 @@ verify_bio_based:
 		} else {
 			/* Check if upgrading to NVMe bio-based is valid or required */
 			tgt = dm_table_get_immutable_target(t);
-			if (tgt && !tgt->max_io_len && dm_table_does_not_support_partial_completion(t)) {
+			if (tgt && !tgt->io_boundary && dm_table_does_not_support_partial_completion(t)) {
 				t->type = DM_TYPE_NVME_BIO_BASED;
 				goto verify_rq_based; /* must be stacked directly on NVMe (blk-mq) */
 			} else if (list_empty(devices) && live_md_type == DM_TYPE_NVME_BIO_BASED) {
@@ -1027,7 +1027,7 @@ verify_rq_based:
 	if (!tgt) {
 		DMERR("table load rejected: immutable target is required");
 		return -EINVAL;
-	} else if (tgt->max_io_len) {
+	} else if (tgt->io_boundary) {
 		DMERR("table load rejected: immutable target that splits IO is not supported");
 		return -EINVAL;
 	}
Index: linux-2.6/drivers/md/dm-thin.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-thin.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-thin.c	2019-03-21 21:22:08.000000000 +0100
@@ -4228,7 +4228,7 @@ static int thin_ctr(struct dm_target *ti
 		goto bad_pool;
 	}
 
-	r = dm_set_target_max_io_len(ti, tc->pool->sectors_per_block);
+	r = dm_set_target_io_boundary(ti, tc->pool->sectors_per_block);
 	if (r)
 		goto bad;
 
Index: linux-2.6/drivers/md/dm-unstripe.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-unstripe.c	2019-01-12 16:48:32.000000000 +0100
+++ linux-2.6/drivers/md/dm-unstripe.c	2019-03-21 21:22:20.000000000 +0100
@@ -94,7 +94,7 @@ static int unstripe_ctr(struct dm_target
 		goto err;
 	}
 
-	if (dm_set_target_max_io_len(ti, uc->chunk_size)) {
+	if (dm_set_target_io_boundary(ti, uc->chunk_size)) {
 		ti->error = "Failed to set max io len";
 		goto err;
 	}
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2019-03-21 19:49:23.000000000 +0100
+++ linux-2.6/drivers/md/dm.c	2019-03-21 21:25:34.000000000 +0100
@@ -1018,13 +1018,13 @@ static sector_t max_io_len(sector_t sect
 	/*
 	 * Does the target need to split even further?
 	 */
-	if (ti->max_io_len) {
+	if (ti->io_boundary) {
 		offset = dm_target_offset(ti, sector);
-		if (unlikely(ti->max_io_len & (ti->max_io_len - 1)))
-			max_len = sector_div(offset, ti->max_io_len);
+		if (unlikely(ti->io_boundary & (ti->io_boundary - 1)))
+			max_len = sector_div(offset, ti->io_boundary);
 		else
-			max_len = offset & (ti->max_io_len - 1);
-		max_len = ti->max_io_len - max_len;
+			max_len = offset & (ti->io_boundary - 1);
+		max_len = ti->io_boundary - max_len;
 
 		if (len > max_len)
 			len = max_len;
@@ -1033,7 +1033,7 @@ static sector_t max_io_len(sector_t sect
 	return len;
 }
 
-int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
+int dm_set_target_io_boundary(struct dm_target *ti, sector_t len)
 {
 	if (len > UINT_MAX) {
 		DMERR("Specified maximum size of target IO (%llu) exceeds limit (%u)",
@@ -1042,11 +1042,11 @@ int dm_set_target_max_io_len(struct dm_t
 		return -EINVAL;
 	}
 
-	ti->max_io_len = (uint32_t) len;
+	ti->io_boundary = (uint32_t) len;
 
 	return 0;
 }
-EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
+EXPORT_SYMBOL_GPL(dm_set_target_io_boundary);
 
 static struct dm_target *dm_dax_get_live_target(struct mapped_device *md,
 						sector_t sector, int *srcu_idx)
Index: linux-2.6/include/linux/device-mapper.h
===================================================================
--- linux-2.6.orig/include/linux/device-mapper.h	2019-03-21 21:22:48.000000000 +0100
+++ linux-2.6/include/linux/device-mapper.h	2019-03-21 21:24:24.000000000 +0100
@@ -256,8 +256,8 @@ struct dm_target {
 	sector_t begin;
 	sector_t len;
 
-	/* If non-zero, maximum size of I/O submitted to a target. */
-	uint32_t max_io_len;
+	/* If non-zero, I/O submitted to a target must not cross this boundary. */
+	uint32_t io_boundary;
 
 	/*
 	 * A number of zero-length barrier bios that will be submitted
Index: linux-2.6/drivers/md/dm-zoned-target.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-zoned-target.c	2019-03-18 10:28:50.000000000 +0100
+++ linux-2.6/drivers/md/dm-zoned-target.c	2019-03-21 21:30:12.000000000 +0100
@@ -720,7 +720,7 @@ static int dmz_ctr(struct dm_target *ti,
 	}
 
 	/* Set target (no write same support) */
-	ti->max_io_len = dev->zone_nr_sectors << 9;
+	ti->io_boundary = dev->zone_nr_sectors << 9;
 	ti->num_flush_bios = 1;
 	ti->num_discard_bios = 1;
 	ti->num_write_zeroes_bios = 1;
