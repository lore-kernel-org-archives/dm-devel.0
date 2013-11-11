From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/6] dm cache: add passthrough mode
Date: Mon, 11 Nov 2013 12:20:44 -0500
Message-ID: <1384190448-3861-3-git-send-email-snitzer@redhat.com>
References: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1384190448-3861-1-git-send-email-snitzer@redhat.com>
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

From: Joe Thornber <ejt@redhat.com>

"Passthrough" is a dm-cache operating mode (like writethrough or
writeback) which is intended to be used when the cache contents are not
known to be coherent with the origin device.  It behaves as follows:

* All reads are served from the origin device (all reads miss the cache)
* All writes are forwarded to the origin device; additionally, write
  hits cause cache block invalidates

This mode decouples cache coherency checks from cache device creation,
largely to avoid having to perform coherency checks while booting.  Boot
scripts can create cache devices in passthrough mode and put them into
service (mount cached filesystems, for example) without having to worry
about coherency.  Coherency that exists is maintained, although the
cache will gradually cool as writes take place.

Later, applications can perform coherency checks, the nature of which
will depend on the type of the underlying storage.  If coherency can be
verified, the cache device can be transitioned to writethrough or
writeback mode while still warm; otherwise, the cache contents can be
discarded prior to transitioning to the desired operating mode.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
Signed-off-by: Morgan Mears <Morgan.Mears@netapp.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 Documentation/device-mapper/cache.txt |   19 +++-
 drivers/md/dm-cache-metadata.c        |    5 +
 drivers/md/dm-cache-metadata.h        |    5 +
 drivers/md/dm-cache-target.c          |  209 +++++++++++++++++++++++++++------
 4 files changed, 200 insertions(+), 38 deletions(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index 33d45ee..ff6639f 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -68,10 +68,11 @@ So large block sizes are bad because they waste cache space.  And small
 block sizes are bad because they increase the amount of metadata (both
 in core and on disk).
 
-Writeback/writethrough
-----------------------
+Cache operating modes
+---------------------
 
-The cache has two modes, writeback and writethrough.
+The cache has three operating modes: writeback, writethrough and
+passthrough.
 
 If writeback, the default, is selected then a write to a block that is
 cached will go only to the cache and the block will be marked dirty in
@@ -81,6 +82,18 @@ If writethrough is selected then a write to a cached block will not
 complete until it has hit both the origin and cache devices.  Clean
 blocks should remain clean.
 
+If passthrough is selected, useful when the cache contents are not known
+to be coherent with the origin device, then all reads are served from
+the origin device (all reads miss the cache) and all writes are
+forwarded to the origin device; additionally, write hits cause cache
+block invalidates.  Passthrough mode allows a cache device to be
+activated without having to worry about coherency.  Coherency that
+exists is maintained, although the cache will gradually cool as writes
+take place.  If the coherency of the cache can later be verified, or
+established, the cache device can can be transitioned to writethrough or
+writeback mode while still warm.  Otherwise, the cache contents can be
+discarded prior to transitioning to the desired operating mode.
+
 A simple cleaner policy is provided, which will clean (write back) all
 dirty blocks in a cache.  Useful for decommissioning a cache.
 
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 062b83e..8601425 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1249,3 +1249,8 @@ int dm_cache_save_hint(struct dm_cache_metadata *cmd, dm_cblock_t cblock,
 
 	return r;
 }
+
+int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result)
+{
+	return blocks_are_unmapped_or_clean(cmd, 0, cmd->cache_blocks, result);
+}
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index f45cef2..cd906f1 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -137,6 +137,11 @@ int dm_cache_begin_hints(struct dm_cache_metadata *cmd, struct dm_cache_policy *
 int dm_cache_save_hint(struct dm_cache_metadata *cmd,
 		       dm_cblock_t cblock, uint32_t hint);
 
+/*
+ * Query method.  Are all the blocks in the cache clean?
+ */
+int dm_cache_metadata_all_clean(struct dm_cache_metadata *cmd, bool *result);
+
 /*----------------------------------------------------------------*/
 
 #endif /* DM_CACHE_METADATA_H */
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 183dfc9..8c02177 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -104,14 +104,37 @@ static void dm_unhook_bio(struct dm_hook_info *h, struct bio *bio)
 /*
  * FIXME: the cache is read/write for the time being.
  */
-enum cache_mode {
+enum cache_metadata_mode {
 	CM_WRITE,		/* metadata may be changed */
 	CM_READ_ONLY,		/* metadata may not be changed */
 };
 
+enum cache_io_mode {
+	/*
+	 * Data is written to cached blocks only.  These blocks are marked
+	 * dirty.  If you lose the cache device you will lose data.
+	 * Potential performance increase for both reads and writes.
+	 */
+	CM_IO_WRITEBACK,
+
+	/*
+	 * Data is written to both cache and origin.  Blocks are never
+	 * dirty.  Potential performance benfit for reads only.
+	 */
+	CM_IO_WRITETHROUGH,
+
+	/*
+	 * A degraded mode useful for various cache coherency situations
+	 * (eg, rolling back snapshots).  Reads and writes always go to the
+	 * origin.  If a write goes to a cached oblock, then the cache
+	 * block is invalidated.
+	 */
+	CM_IO_PASSTHROUGH
+};
+
 struct cache_features {
-	enum cache_mode mode;
-	bool write_through:1;
+	enum cache_metadata_mode mode;
+	enum cache_io_mode io_mode;
 };
 
 struct cache_stats {
@@ -565,9 +588,24 @@ static void save_stats(struct cache *cache)
 #define PB_DATA_SIZE_WB (offsetof(struct per_bio_data, cache))
 #define PB_DATA_SIZE_WT (sizeof(struct per_bio_data))
 
+static bool writethrough_mode(struct cache_features *f)
+{
+	return f->io_mode == CM_IO_WRITETHROUGH;
+}
+
+static bool writeback_mode(struct cache_features *f)
+{
+	return f->io_mode == CM_IO_WRITEBACK;
+}
+
+static bool passthrough_mode(struct cache_features *f)
+{
+	return f->io_mode == CM_IO_PASSTHROUGH;
+}
+
 static size_t get_per_bio_data_size(struct cache *cache)
 {
-	return cache->features.write_through ? PB_DATA_SIZE_WT : PB_DATA_SIZE_WB;
+	return writethrough_mode(&cache->features) ? PB_DATA_SIZE_WT : PB_DATA_SIZE_WB;
 }
 
 static struct per_bio_data *get_per_bio_data(struct bio *bio, size_t data_size)
@@ -1135,6 +1173,32 @@ static void demote_then_promote(struct cache *cache, struct prealloc *structs,
 	quiesce_migration(mg);
 }
 
+/*
+ * Invalidate a cache entry.  No writeback occurs; any changes in the cache
+ * block are thrown away.
+ */
+static void invalidate(struct cache *cache, struct prealloc *structs,
+		       dm_oblock_t oblock, dm_cblock_t cblock,
+		       struct dm_bio_prison_cell *cell)
+{
+	struct dm_cache_migration *mg = prealloc_get_migration(structs);
+
+	mg->err = false;
+	mg->writeback = false;
+	mg->demote = true;
+	mg->promote = false;
+	mg->requeue_holder = true;
+	mg->cache = cache;
+	mg->old_oblock = oblock;
+	mg->cblock = cblock;
+	mg->old_ocell = cell;
+	mg->new_ocell = NULL;
+	mg->start_jiffies = jiffies;
+
+	inc_nr_migrations(cache);
+	quiesce_migration(mg);
+}
+
 /*----------------------------------------------------------------
  * bio processing
  *--------------------------------------------------------------*/
@@ -1197,13 +1261,6 @@ static bool spare_migration_bandwidth(struct cache *cache)
 	return current_volume < cache->migration_threshold;
 }
 
-static bool is_writethrough_io(struct cache *cache, struct bio *bio,
-			       dm_cblock_t cblock)
-{
-	return bio_data_dir(bio) == WRITE &&
-		cache->features.write_through && !is_dirty(cache, cblock);
-}
-
 static void inc_hit_counter(struct cache *cache, struct bio *bio)
 {
 	atomic_inc(bio_data_dir(bio) == READ ?
@@ -1216,6 +1273,15 @@ static void inc_miss_counter(struct cache *cache, struct bio *bio)
 		   &cache->stats.read_miss : &cache->stats.write_miss);
 }
 
+static void issue_cache_bio(struct cache *cache, struct bio *bio,
+			    struct per_bio_data *pb,
+			    dm_oblock_t oblock, dm_cblock_t cblock)
+{
+	pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+	remap_to_cache_dirty(cache, bio, oblock, cblock);
+	issue(cache, bio);
+}
+
 static void process_bio(struct cache *cache, struct prealloc *structs,
 			struct bio *bio)
 {
@@ -1227,7 +1293,8 @@ static void process_bio(struct cache *cache, struct prealloc *structs,
 	size_t pb_data_size = get_per_bio_data_size(cache);
 	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 	bool discarded_block = is_discarded_oblock(cache, block);
-	bool can_migrate = discarded_block || spare_migration_bandwidth(cache);
+	bool passthrough = passthrough_mode(&cache->features);
+	bool can_migrate = !passthrough && (discarded_block || spare_migration_bandwidth(cache));
 
 	/*
 	 * Check to see if that block is currently migrating.
@@ -1248,15 +1315,39 @@ static void process_bio(struct cache *cache, struct prealloc *structs,
 
 	switch (lookup_result.op) {
 	case POLICY_HIT:
-		inc_hit_counter(cache, bio);
-		pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+		if (passthrough) {
+			inc_miss_counter(cache, bio);
 
-		if (is_writethrough_io(cache, bio, lookup_result.cblock))
-			remap_to_origin_then_cache(cache, bio, block, lookup_result.cblock);
-		else
-			remap_to_cache_dirty(cache, bio, block, lookup_result.cblock);
+			/*
+			 * Passthrough always maps to the origin,
+			 * invalidating any cache blocks that are written
+			 * to.
+			 */
+
+			if (bio_data_dir(bio) == WRITE) {
+				atomic_inc(&cache->stats.demotion);
+				invalidate(cache, structs, block, lookup_result.cblock, new_ocell);
+				release_cell = false;
+
+			} else {
+				/* FIXME: factor out issue_origin() */
+				pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+				remap_to_origin_clear_discard(cache, bio, block);
+				issue(cache, bio);
+			}
+		} else {
+			inc_hit_counter(cache, bio);
+
+			if (bio_data_dir(bio) == WRITE &&
+			    writethrough_mode(&cache->features) &&
+			    !is_dirty(cache, lookup_result.cblock)) {
+				pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+				remap_to_origin_then_cache(cache, bio, block, lookup_result.cblock);
+				issue(cache, bio);
+			} else
+				issue_cache_bio(cache, bio, pb, block, lookup_result.cblock);
+		}
 
-		issue(cache, bio);
 		break;
 
 	case POLICY_MISS:
@@ -1807,7 +1898,7 @@ static int parse_block_size(struct cache_args *ca, struct dm_arg_set *as,
 static void init_features(struct cache_features *cf)
 {
 	cf->mode = CM_WRITE;
-	cf->write_through = false;
+	cf->io_mode = CM_IO_WRITEBACK;
 }
 
 static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
@@ -1832,10 +1923,13 @@ static int parse_features(struct cache_args *ca, struct dm_arg_set *as,
 		arg = dm_shift_arg(as);
 
 		if (!strcasecmp(arg, "writeback"))
-			cf->write_through = false;
+			cf->io_mode = CM_IO_WRITEBACK;
 
 		else if (!strcasecmp(arg, "writethrough"))
-			cf->write_through = true;
+			cf->io_mode = CM_IO_WRITETHROUGH;
+
+		else if (!strcasecmp(arg, "passthrough"))
+			cf->io_mode = CM_IO_PASSTHROUGH;
 
 		else {
 			*error = "Unrecognised cache feature requested";
@@ -2088,6 +2182,22 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	}
 	cache->cmd = cmd;
 
+	if (passthrough_mode(&cache->features)) {
+		bool all_clean;
+
+		r = dm_cache_metadata_all_clean(cache->cmd, &all_clean);
+		if (r) {
+			*error = "dm_cache_metadata_all_clean() failed";
+			goto bad;
+		}
+
+		if (!all_clean) {
+			*error = "Cannot enter passthrough mode unless all blocks are clean";
+			r = -EINVAL;
+			goto bad;
+		}
+	}
+
 	spin_lock_init(&cache->lock);
 	bio_list_init(&cache->deferred_bios);
 	bio_list_init(&cache->deferred_flush_bios);
@@ -2303,17 +2413,37 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_SUBMITTED;
 	}
 
+	r = DM_MAPIO_REMAPPED;
 	switch (lookup_result.op) {
 	case POLICY_HIT:
-		inc_hit_counter(cache, bio);
-		pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+		if (passthrough_mode(&cache->features)) {
+			if (bio_data_dir(bio) == WRITE) {
+				/*
+				 * We need to invalidate this block, so
+				 * defer for the worker thread.
+				 */
+				cell_defer(cache, cell, true);
+				r = DM_MAPIO_SUBMITTED;
+
+			} else {
+				pb->all_io_entry = dm_deferred_entry_inc(cache->all_io_ds);
+				inc_miss_counter(cache, bio);
+				remap_to_origin_clear_discard(cache, bio, block);
+
+				cell_defer(cache, cell, false);
+			}
 
-		if (is_writethrough_io(cache, bio, lookup_result.cblock))
-			remap_to_origin_then_cache(cache, bio, block, lookup_result.cblock);
-		else
-			remap_to_cache_dirty(cache, bio, block, lookup_result.cblock);
+		} else {
+			inc_hit_counter(cache, bio);
+
+			if (bio_data_dir(bio) == WRITE && writethrough_mode(&cache->features) &&
+			    !is_dirty(cache, lookup_result.cblock))
+				remap_to_origin_then_cache(cache, bio, block, lookup_result.cblock);
+			else
+				remap_to_cache_dirty(cache, bio, block, lookup_result.cblock);
 
-		cell_defer(cache, cell, false);
+			cell_defer(cache, cell, false);
+		}
 		break;
 
 	case POLICY_MISS:
@@ -2338,10 +2468,10 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 		DMERR_LIMIT("%s: erroring bio: unknown policy op: %u", __func__,
 			    (unsigned) lookup_result.op);
 		bio_io_error(bio);
-		return DM_MAPIO_SUBMITTED;
+		r = DM_MAPIO_SUBMITTED;
 	}
 
-	return DM_MAPIO_REMAPPED;
+	return r;
 }
 
 static int cache_end_io(struct dm_target *ti, struct bio *bio, int error)
@@ -2659,10 +2789,19 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 		       (unsigned long long) from_cblock(residency),
 		       cache->nr_dirty);
 
-		if (cache->features.write_through)
+		if (writethrough_mode(&cache->features))
 			DMEMIT("1 writethrough ");
-		else
-			DMEMIT("0 ");
+
+		else if (passthrough_mode(&cache->features))
+			DMEMIT("1 passthrough ");
+
+		else if (writeback_mode(&cache->features))
+			DMEMIT("1 writeback ");
+
+		else {
+			DMERR("internal error: unknown io mode: %d", (int) cache->features.io_mode);
+			goto err;
+		}
 
 		DMEMIT("2 migration_threshold %llu ", (unsigned long long) cache->migration_threshold);
 		if (sz < maxlen) {
@@ -2771,7 +2910,7 @@ static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
 
 static struct target_type cache_target = {
 	.name = "cache",
-	.version = {1, 1, 1},
+	.version = {1, 2, 0},
 	.module = THIS_MODULE,
 	.ctr = cache_ctr,
 	.dtr = cache_dtr,
-- 
1.7.4.4
