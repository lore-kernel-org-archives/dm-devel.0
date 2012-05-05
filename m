From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 1/3] dm: support for non power of 2 target IO
	sizes
Date: Fri,  4 May 2012 23:57:08 -0400
Message-ID: <1336190230-11243-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
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
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

Update DM core's max_io_len() to use sector_div() to support a target's
use of a non power of 2 blocksize.

Rename split_io to max_io_len in the dm_target structure and change data
type from sector_t to uint32_t.  Introduce dm_set_target_max_io_len() to
check that each target's max_io_len does not exceed UINT_MAX.

Add do_div wrappers (dm_do_div and dm_do_mod) that don't modify the
dividend; these will be used by thin-pool and striped targets.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-raid.c          |   12 +++++-------
 drivers/md/dm-raid1.c         |    4 +++-
 drivers/md/dm-snap.c          |   19 +++++++++++--------
 drivers/md/dm-stripe.c        |    4 +++-
 drivers/md/dm-thin.c          |    4 +++-
 drivers/md/dm.c               |   28 +++++++++++++++++++++-------
 include/linux/device-mapper.h |   20 ++++++++++++++++++--
 7 files changed, 64 insertions(+), 27 deletions(-)

Index: linux/drivers/md/dm-raid.c
===================================================================
--- linux.orig/drivers/md/dm-raid.c
+++ linux/drivers/md/dm-raid.c
@@ -356,6 +356,7 @@ static int parse_raid_params(struct raid
 {
 	unsigned i, rebuild_cnt = 0;
 	unsigned long value, region_size = 0;
+	sector_t max_io_len;
 	char *key;
 
 	/*
@@ -525,14 +526,11 @@ static int parse_raid_params(struct raid
 		return -EINVAL;
 
 	if (rs->md.chunk_sectors)
-		rs->ti->split_io = rs->md.chunk_sectors;
+		max_io_len = rs->md.chunk_sectors;
 	else
-		rs->ti->split_io = region_size;
-
-	if (rs->md.chunk_sectors)
-		rs->ti->split_io = rs->md.chunk_sectors;
-	else
-		rs->ti->split_io = region_size;
+		max_io_len = region_size;
+	if (dm_set_target_max_io_len(rs->ti, max_io_len) < 0)
+		return -EINVAL;
 
 	/* Assume there are no metadata devices until the drives are parsed */
 	rs->md.persistent = 0;
Index: linux/drivers/md/dm-raid1.c
===================================================================
--- linux.orig/drivers/md/dm-raid1.c
+++ linux/drivers/md/dm-raid1.c
@@ -1081,7 +1081,9 @@ static int mirror_ctr(struct dm_target *
 	}
 
 	ti->private = ms;
-	ti->split_io = dm_rh_get_region_size(ms->rh);
+	r = dm_set_target_max_io_len(ti, dm_rh_get_region_size(ms->rh));
+	if (r < 0)
+		goto err_free_context;
 	ti->num_flush_requests = 1;
 	ti->num_discard_requests = 1;
 
Index: linux/drivers/md/dm-snap.c
===================================================================
--- linux.orig/drivers/md/dm-snap.c
+++ linux/drivers/md/dm-snap.c
@@ -1172,7 +1172,10 @@ static int snapshot_ctr(struct dm_target
 		ti->error = "Chunk size not set";
 		goto bad_read_metadata;
 	}
-	ti->split_io = s->store->chunk_size;
+
+	r = dm_set_target_max_io_len(ti, s->store->chunk_size);
+	if (r < 0)
+		goto bad_read_metadata;
 
 	return 0;
 
@@ -1239,7 +1242,7 @@ static void __handover_exceptions(struct
 	snap_dest->store->snap = snap_dest;
 	snap_src->store->snap = snap_src;
 
-	snap_dest->ti->split_io = snap_dest->store->chunk_size;
+	snap_dest->ti->max_io_len = snap_dest->store->chunk_size;
 	snap_dest->valid = snap_src->valid;
 
 	/*
@@ -1838,9 +1841,9 @@ static void snapshot_merge_resume(struct
 	snapshot_resume(ti);
 
 	/*
-	 * snapshot-merge acts as an origin, so set ti->split_io
+	 * snapshot-merge acts as an origin, so set ti->max_io_len
 	 */
-	ti->split_io = get_origin_minimum_chunksize(s->origin->bdev);
+	ti->max_io_len = get_origin_minimum_chunksize(s->origin->bdev);
 
 	start_merge(s);
 }
@@ -2073,12 +2076,12 @@ static int origin_write_extent(struct dm
 	struct origin *o;
 
 	/*
-	 * The origin's __minimum_chunk_size() got stored in split_io
+	 * The origin's __minimum_chunk_size() got stored in max_io_len
 	 * by snapshot_merge_resume().
 	 */
 	down_read(&_origins_lock);
 	o = __lookup_origin(merging_snap->origin->bdev);
-	for (n = 0; n < size; n += merging_snap->ti->split_io)
+	for (n = 0; n < size; n += merging_snap->ti->max_io_len)
 		if (__origin_write(&o->snapshots, sector + n, NULL) ==
 		    DM_MAPIO_SUBMITTED)
 			must_wait = 1;
@@ -2138,14 +2141,14 @@ static int origin_map(struct dm_target *
 }
 
 /*
- * Set the target "split_io" field to the minimum of all the snapshots'
+ * Set the target "max_io_len" field to the minimum of all the snapshots'
  * chunk sizes.
  */
 static void origin_resume(struct dm_target *ti)
 {
 	struct dm_dev *dev = ti->private;
 
-	ti->split_io = get_origin_minimum_chunksize(dev->bdev);
+	ti->max_io_len = get_origin_minimum_chunksize(dev->bdev);
 }
 
 static int origin_status(struct dm_target *ti, status_type_t type, char *result,
Index: linux/drivers/md/dm-stripe.c
===================================================================
--- linux.orig/drivers/md/dm-stripe.c
+++ linux/drivers/md/dm-stripe.c
@@ -172,7 +172,9 @@ static int stripe_ctr(struct dm_target *
 		sc->stripes_mask = ((sector_t) stripes) - 1;
 	}
 
-	ti->split_io = chunk_size;
+	r = dm_set_target_max_io_len(ti, chunk_size);
+	if (r < 0)
+		return r;
 	ti->num_flush_requests = stripes;
 	ti->num_discard_requests = stripes;
 
Index: linux/drivers/md/dm-thin.c
===================================================================
--- linux.orig/drivers/md/dm-thin.c
+++ linux/drivers/md/dm-thin.c
@@ -2575,7 +2575,9 @@ static int thin_ctr(struct dm_target *ti
 		goto bad_thin_open;
 	}
 
-	ti->split_io = tc->pool->sectors_per_block;
+	r = dm_set_target_max_io_len(ti, tc->pool->sectors_per_block);
+	if (r < 0)
+		goto bad_thin_open;
 	ti->num_flush_requests = 1;
 
 	/* In case the pool supports discards, pass them on. */
Index: linux/drivers/md/dm.c
===================================================================
--- linux.orig/drivers/md/dm.c
+++ linux/drivers/md/dm.c
@@ -970,20 +970,34 @@ static sector_t max_io_len(sector_t sect
 	sector_t len = max_io_len_target_boundary(sector, ti);
 
 	/*
-	 * Does the target need to split even further ?
+	 * Does the target need to split even further?
 	 */
-	if (ti->split_io) {
-		sector_t boundary;
+	if (ti->max_io_len) {
 		sector_t offset = dm_target_offset(ti, sector);
-		boundary = ((offset + ti->split_io) & ~(ti->split_io - 1))
-			   - offset;
-		if (len > boundary)
-			len = boundary;
+		sector_t boundary = offset + ti->max_io_len;
+		sector_t max_len = ti->max_io_len - sector_div(boundary, ti->max_io_len);
+
+		if (len > max_len)
+			len = max_len;
 	}
 
 	return len;
 }
 
+int dm_set_target_max_io_len(struct dm_target *ti, sector_t len)
+{
+	if (len > UINT_MAX) {
+		DMERR("Specified maximum size of target IO (%llu) exceeds limit (%u)",
+		      (unsigned long long)len, UINT_MAX);
+		ti->error = "Maximum size of target IO is too large";
+		return -EINVAL;
+	}
+
+	ti->max_io_len = (uint32_t) len;
+	return 0;
+}
+EXPORT_SYMBOL_GPL(dm_set_target_max_io_len);
+
 static void __map_bio(struct dm_target *ti, struct bio *clone,
 		      struct dm_target_io *tio)
 {
Index: linux/include/linux/device-mapper.h
===================================================================
--- linux.orig/include/linux/device-mapper.h
+++ linux/include/linux/device-mapper.h
@@ -188,8 +188,8 @@ struct dm_target {
 	sector_t begin;
 	sector_t len;
 
-	/* Always a power of 2 */
-	sector_t split_io;
+	/* If non-zero, maximum size of I/O submitted to a target. */
+	uint32_t max_io_len;
 
 	/*
 	 * A number of zero-length barrier requests that will be submitted
@@ -503,6 +503,20 @@ static inline unsigned long to_bytes(sec
 	return (n << SECTOR_SHIFT);
 }
 
+/*
+ * do_div wrappers that don't modify the dividend
+ */
+static inline sector_t dm_do_div(sector_t a, uint32_t b)
+{
+	do_div(a, b);
+	return a;
+}
+
+static inline uint32_t dm_do_mod(sector_t a, uint32_t b)
+{
+	return do_div(a, b);
+}
+
 /*-----------------------------------------------------------------
  * Helper for block layer and dm core operations
  *---------------------------------------------------------------*/
@@ -511,4 +525,6 @@ void dm_requeue_unmapped_request(struct 
 void dm_kill_unmapped_request(struct request *rq, int error);
 int dm_underlying_device_busy(struct request_queue *q);
 
+int __must_check dm_set_target_max_io_len(struct dm_target *ti, sector_t len);
+
 #endif	/* _LINUX_DEVICE_MAPPER_H */
