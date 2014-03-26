From: heinzm@redhat.com
Subject: [PATCH] dm-cache: discard block size causes data
	corruption
Date: Wed, 26 Mar 2014 16:27:24 +0100
Message-ID: <1395847644-12458-1-git-send-email-heinzm@redhat.com>
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
Cc: Heinz Mauelshagen <heinzm@redhat.com>
List-Id: dm-devel.ids

From: Heinz Mauelshagen <heinzm@redhat.com>

Discard block size not being equal to cache block size causes data
corruption by erroneously avoiding migrations in issue_copy() because
the discard state is being cleared for a group of cache blocks when it
should not.

Drop that distinction altogether and make both sizes equal.


Signed-off-by: Heinz Mauelshagen <heinzm@redhat.com>
---
 drivers/md/dm-cache-block-types.h |  11 ----
 drivers/md/dm-cache-metadata.c    |  34 ++++++-------
 drivers/md/dm-cache-metadata.h    |   6 +--
 drivers/md/dm-cache-target.c      | 103 ++++++++++----------------------------
 4 files changed, 46 insertions(+), 108 deletions(-)

diff --git a/drivers/md/dm-cache-block-types.h b/drivers/md/dm-cache-block-types.h
index bed4ad4..aac0e2d 100644
--- a/drivers/md/dm-cache-block-types.h
+++ b/drivers/md/dm-cache-block-types.h
@@ -19,7 +19,6 @@
 
 typedef dm_block_t __bitwise__ dm_oblock_t;
 typedef uint32_t __bitwise__ dm_cblock_t;
-typedef dm_block_t __bitwise__ dm_dblock_t;
 
 static inline dm_oblock_t to_oblock(dm_block_t b)
 {
@@ -41,14 +40,4 @@ static inline uint32_t from_cblock(dm_cblock_t b)
 	return (__force uint32_t) b;
 }
 
-static inline dm_dblock_t to_dblock(dm_block_t b)
-{
-	return (__force dm_dblock_t) b;
-}
-
-static inline dm_block_t from_dblock(dm_dblock_t b)
-{
-	return (__force dm_block_t) b;
-}
-
 #endif /* DM_CACHE_BLOCK_TYPES_H */
diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 9ef0752..cbd568a 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -109,7 +109,7 @@ struct dm_cache_metadata {
 	dm_block_t discard_root;
 
 	sector_t discard_block_size;
-	dm_dblock_t discard_nr_blocks;
+	dm_oblock_t discard_nr_blocks;
 
 	sector_t data_block_size;
 	dm_cblock_t cache_blocks;
@@ -302,7 +302,7 @@ static int __write_initial_superblock(struct dm_cache_metadata *cmd)
 	disk_super->hint_root = cpu_to_le64(cmd->hint_root);
 	disk_super->discard_root = cpu_to_le64(cmd->discard_root);
 	disk_super->discard_block_size = cpu_to_le64(cmd->discard_block_size);
-	disk_super->discard_nr_blocks = cpu_to_le64(from_dblock(cmd->discard_nr_blocks));
+	disk_super->discard_nr_blocks = cpu_to_le64(from_oblock(cmd->discard_nr_blocks));
 	disk_super->metadata_block_size = cpu_to_le32(DM_CACHE_METADATA_BLOCK_SIZE >> SECTOR_SHIFT);
 	disk_super->data_block_size = cpu_to_le32(cmd->data_block_size);
 	disk_super->cache_blocks = cpu_to_le32(0);
@@ -496,7 +496,7 @@ static void read_superblock_fields(struct dm_cache_metadata *cmd,
 	cmd->hint_root = le64_to_cpu(disk_super->hint_root);
 	cmd->discard_root = le64_to_cpu(disk_super->discard_root);
 	cmd->discard_block_size = le64_to_cpu(disk_super->discard_block_size);
-	cmd->discard_nr_blocks = to_dblock(le64_to_cpu(disk_super->discard_nr_blocks));
+	cmd->discard_nr_blocks = to_oblock(le64_to_cpu(disk_super->discard_nr_blocks));
 	cmd->data_block_size = le32_to_cpu(disk_super->data_block_size);
 	cmd->cache_blocks = to_cblock(le32_to_cpu(disk_super->cache_blocks));
 	strncpy(cmd->policy_name, disk_super->policy_name, sizeof(cmd->policy_name));
@@ -594,7 +594,7 @@ static int __commit_transaction(struct dm_cache_metadata *cmd,
 	disk_super->hint_root = cpu_to_le64(cmd->hint_root);
 	disk_super->discard_root = cpu_to_le64(cmd->discard_root);
 	disk_super->discard_block_size = cpu_to_le64(cmd->discard_block_size);
-	disk_super->discard_nr_blocks = cpu_to_le64(from_dblock(cmd->discard_nr_blocks));
+	disk_super->discard_nr_blocks = cpu_to_le64(from_oblock(cmd->discard_nr_blocks));
 	disk_super->cache_blocks = cpu_to_le32(from_cblock(cmd->cache_blocks));
 	strncpy(disk_super->policy_name, cmd->policy_name, sizeof(disk_super->policy_name));
 	disk_super->policy_version[0] = cpu_to_le32(cmd->policy_version[0]);
@@ -771,15 +771,15 @@ out:
 
 int dm_cache_discard_bitset_resize(struct dm_cache_metadata *cmd,
 				   sector_t discard_block_size,
-				   dm_dblock_t new_nr_entries)
+				   dm_oblock_t new_nr_entries)
 {
 	int r;
 
 	down_write(&cmd->root_lock);
 	r = dm_bitset_resize(&cmd->discard_info,
 			     cmd->discard_root,
-			     from_dblock(cmd->discard_nr_blocks),
-			     from_dblock(new_nr_entries),
+			     from_oblock(cmd->discard_nr_blocks),
+			     from_oblock(new_nr_entries),
 			     false, &cmd->discard_root);
 	if (!r) {
 		cmd->discard_block_size = discard_block_size;
@@ -792,28 +792,28 @@ int dm_cache_discard_bitset_resize(struct dm_cache_metadata *cmd,
 	return r;
 }
 
-static int __set_discard(struct dm_cache_metadata *cmd, dm_dblock_t b)
+static int __set_discard(struct dm_cache_metadata *cmd, dm_oblock_t b)
 {
 	return dm_bitset_set_bit(&cmd->discard_info, cmd->discard_root,
-				 from_dblock(b), &cmd->discard_root);
+				 from_oblock(b), &cmd->discard_root);
 }
 
-static int __clear_discard(struct dm_cache_metadata *cmd, dm_dblock_t b)
+static int __clear_discard(struct dm_cache_metadata *cmd, dm_oblock_t b)
 {
 	return dm_bitset_clear_bit(&cmd->discard_info, cmd->discard_root,
-				   from_dblock(b), &cmd->discard_root);
+				   from_oblock(b), &cmd->discard_root);
 }
 
-static int __is_discarded(struct dm_cache_metadata *cmd, dm_dblock_t b,
+static int __is_discarded(struct dm_cache_metadata *cmd, dm_oblock_t b,
 			  bool *is_discarded)
 {
 	return dm_bitset_test_bit(&cmd->discard_info, cmd->discard_root,
-				  from_dblock(b), &cmd->discard_root,
+				  from_oblock(b), &cmd->discard_root,
 				  is_discarded);
 }
 
 static int __discard(struct dm_cache_metadata *cmd,
-		     dm_dblock_t dblock, bool discard)
+		     dm_oblock_t dblock, bool discard)
 {
 	int r;
 
@@ -826,7 +826,7 @@ static int __discard(struct dm_cache_metadata *cmd,
 }
 
 int dm_cache_set_discard(struct dm_cache_metadata *cmd,
-			 dm_dblock_t dblock, bool discard)
+			 dm_oblock_t dblock, bool discard)
 {
 	int r;
 
@@ -844,8 +844,8 @@ static int __load_discards(struct dm_cache_metadata *cmd,
 	dm_block_t b;
 	bool discard;
 
-	for (b = 0; b < from_dblock(cmd->discard_nr_blocks); b++) {
-		dm_dblock_t dblock = to_dblock(b);
+	for (b = 0; b < from_oblock(cmd->discard_nr_blocks); b++) {
+		dm_oblock_t dblock = to_oblock(b);
 
 		if (cmd->clean_when_opened) {
 			r = __is_discarded(cmd, dblock, &discard);
diff --git a/drivers/md/dm-cache-metadata.h b/drivers/md/dm-cache-metadata.h
index cd906f1..ce8468b 100644
--- a/drivers/md/dm-cache-metadata.h
+++ b/drivers/md/dm-cache-metadata.h
@@ -72,14 +72,14 @@ dm_cblock_t dm_cache_size(struct dm_cache_metadata *cmd);
 
 int dm_cache_discard_bitset_resize(struct dm_cache_metadata *cmd,
 				   sector_t discard_block_size,
-				   dm_dblock_t new_nr_entries);
+				   dm_oblock_t new_nr_entries);
 
 typedef int (*load_discard_fn)(void *context, sector_t discard_block_size,
-			       dm_dblock_t dblock, bool discarded);
+			       dm_oblock_t dblock, bool discarded);
 int dm_cache_load_discards(struct dm_cache_metadata *cmd,
 			   load_discard_fn fn, void *context);
 
-int dm_cache_set_discard(struct dm_cache_metadata *cmd, dm_dblock_t dblock, bool discard);
+int dm_cache_set_discard(struct dm_cache_metadata *cmd, dm_oblock_t dblock, bool discard);
 
 int dm_cache_remove_mapping(struct dm_cache_metadata *cmd, dm_cblock_t cblock);
 int dm_cache_insert_mapping(struct dm_cache_metadata *cmd, dm_cblock_t cblock, dm_oblock_t oblock);
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 074b9c8..6d39457 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -237,9 +237,8 @@ struct cache {
 	/*
 	 * origin_blocks entries, discarded if set.
 	 */
-	dm_dblock_t discard_nr_blocks;
+	dm_oblock_t discard_nr_blocks;
 	unsigned long *discard_bitset;
-	uint32_t discard_block_size; /* a power of 2 times sectors per block */
 
 	/*
 	 * Rather than reconstructing the table line for the status we just
@@ -526,48 +525,33 @@ static dm_block_t block_div(dm_block_t b, uint32_t n)
 	return b;
 }
 
-static dm_dblock_t oblock_to_dblock(struct cache *cache, dm_oblock_t oblock)
-{
-	uint32_t discard_blocks = cache->discard_block_size;
-	dm_block_t b = from_oblock(oblock);
-
-	if (!block_size_is_power_of_two(cache))
-		discard_blocks = discard_blocks / cache->sectors_per_block;
-	else
-		discard_blocks >>= cache->sectors_per_block_shift;
-
-	b = block_div(b, discard_blocks);
-
-	return to_dblock(b);
-}
-
-static void set_discard(struct cache *cache, dm_dblock_t b)
+static void set_discard(struct cache *cache, dm_oblock_t b)
 {
 	unsigned long flags;
 
 	atomic_inc(&cache->stats.discard_count);
 
 	spin_lock_irqsave(&cache->lock, flags);
-	set_bit(from_dblock(b), cache->discard_bitset);
+	set_bit(from_oblock(b), cache->discard_bitset);
 	spin_unlock_irqrestore(&cache->lock, flags);
 }
 
-static void clear_discard(struct cache *cache, dm_dblock_t b)
+static void clear_discard(struct cache *cache, dm_oblock_t b)
 {
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	clear_bit(from_dblock(b), cache->discard_bitset);
+	clear_bit(from_oblock(b), cache->discard_bitset);
 	spin_unlock_irqrestore(&cache->lock, flags);
 }
 
-static bool is_discarded(struct cache *cache, dm_dblock_t b)
+static bool is_discarded(struct cache *cache, dm_oblock_t b)
 {
 	int r;
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	r = test_bit(from_dblock(b), cache->discard_bitset);
+	r = test_bit(from_oblock(b), cache->discard_bitset);
 	spin_unlock_irqrestore(&cache->lock, flags);
 
 	return r;
@@ -579,8 +563,7 @@ static bool is_discarded_oblock(struct cache *cache, dm_oblock_t b)
 	unsigned long flags;
 
 	spin_lock_irqsave(&cache->lock, flags);
-	r = test_bit(from_dblock(oblock_to_dblock(cache, b)),
-		     cache->discard_bitset);
+	r = test_bit(from_oblock(b), cache->discard_bitset);
 	spin_unlock_irqrestore(&cache->lock, flags);
 
 	return r;
@@ -705,7 +688,7 @@ static void remap_to_origin_clear_discard(struct cache *cache, struct bio *bio,
 	check_if_tick_bio_needed(cache, bio);
 	remap_to_origin(cache, bio);
 	if (bio_data_dir(bio) == WRITE)
-		clear_discard(cache, oblock_to_dblock(cache, oblock));
+		clear_discard(cache, oblock);
 }
 
 static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
@@ -715,7 +698,7 @@ static void remap_to_cache_dirty(struct cache *cache, struct bio *bio,
 	remap_to_cache(cache, bio, cblock);
 	if (bio_data_dir(bio) == WRITE) {
 		set_dirty(cache, oblock, cblock);
-		clear_discard(cache, oblock_to_dblock(cache, oblock));
+		clear_discard(cache, oblock);
 	}
 }
 
@@ -1288,14 +1271,14 @@ static void process_flush_bio(struct cache *cache, struct bio *bio)
 static void process_discard_bio(struct cache *cache, struct bio *bio)
 {
 	dm_block_t start_block = dm_sector_div_up(bio->bi_iter.bi_sector,
-						  cache->discard_block_size);
+						  cache->sectors_per_block);
 	dm_block_t end_block = bio_end_sector(bio);
 	dm_block_t b;
 
-	end_block = block_div(end_block, cache->discard_block_size);
+	end_block = block_div(end_block, cache->sectors_per_block);
 
 	for (b = start_block; b < end_block; b++)
-		set_discard(cache, to_dblock(b));
+		set_discard(cache, to_oblock(b));
 
 	bio_endio(bio, 0);
 }
@@ -2171,35 +2154,6 @@ static int create_cache_policy(struct cache *cache, struct cache_args *ca,
 	return 0;
 }
 
-/*
- * We want the discard block size to be a power of two, at least the size
- * of the cache block size, and have no more than 2^14 discard blocks
- * across the origin.
- */
-#define MAX_DISCARD_BLOCKS (1 << 14)
-
-static bool too_many_discard_blocks(sector_t discard_block_size,
-				    sector_t origin_size)
-{
-	(void) sector_div(origin_size, discard_block_size);
-
-	return origin_size > MAX_DISCARD_BLOCKS;
-}
-
-static sector_t calculate_discard_block_size(sector_t cache_block_size,
-					     sector_t origin_size)
-{
-	sector_t discard_block_size;
-
-	discard_block_size = roundup_pow_of_two(cache_block_size);
-
-	if (origin_size)
-		while (too_many_discard_blocks(discard_block_size, origin_size))
-			discard_block_size *= 2;
-
-	return discard_block_size;
-}
-
 #define DEFAULT_MIGRATION_THRESHOLD 2048
 
 static int cache_create(struct cache_args *ca, struct cache **result)
@@ -2321,16 +2275,13 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	}
 	clear_bitset(cache->dirty_bitset, from_cblock(cache->cache_size));
 
-	cache->discard_block_size =
-		calculate_discard_block_size(cache->sectors_per_block,
-					     cache->origin_sectors);
-	cache->discard_nr_blocks = oblock_to_dblock(cache, cache->origin_blocks);
-	cache->discard_bitset = alloc_bitset(from_dblock(cache->discard_nr_blocks));
+	cache->discard_nr_blocks = cache->origin_blocks;
+	cache->discard_bitset = alloc_bitset(from_oblock(cache->discard_nr_blocks));
 	if (!cache->discard_bitset) {
 		*error = "could not allocate discard bitset";
 		goto bad;
 	}
-	clear_bitset(cache->discard_bitset, from_dblock(cache->discard_nr_blocks));
+	clear_bitset(cache->discard_bitset, from_oblock(cache->discard_nr_blocks));
 
 	cache->copier = dm_kcopyd_client_create(&dm_kcopyd_throttle);
 	if (IS_ERR(cache->copier)) {
@@ -2614,16 +2565,16 @@ static int write_discard_bitset(struct cache *cache)
 {
 	unsigned i, r;
 
-	r = dm_cache_discard_bitset_resize(cache->cmd, cache->discard_block_size,
-					   cache->discard_nr_blocks);
+	r = dm_cache_discard_bitset_resize(cache->cmd, cache->sectors_per_block,
+					   cache->origin_blocks);
 	if (r) {
 		DMERR("could not resize on-disk discard bitset");
 		return r;
 	}
 
-	for (i = 0; i < from_dblock(cache->discard_nr_blocks); i++) {
-		r = dm_cache_set_discard(cache->cmd, to_dblock(i),
-					 is_discarded(cache, to_dblock(i)));
+	for (i = 0; i < from_oblock(cache->discard_nr_blocks); i++) {
+		r = dm_cache_set_discard(cache->cmd, to_oblock(i),
+					 is_discarded(cache, to_oblock(i)));
 		if (r)
 			return r;
 	}
@@ -2720,16 +2671,14 @@ static int load_mapping(void *context, dm_oblock_t oblock, dm_cblock_t cblock,
 }
 
 static int load_discard(void *context, sector_t discard_block_size,
-			dm_dblock_t dblock, bool discard)
+			dm_oblock_t oblock, bool discard)
 {
 	struct cache *cache = context;
 
-	/* FIXME: handle mis-matched block size */
-
 	if (discard)
-		set_discard(cache, dblock);
+		set_discard(cache, oblock);
 	else
-		clear_discard(cache, dblock);
+		clear_discard(cache, oblock);
 
 	return 0;
 }
@@ -3120,8 +3069,8 @@ static void set_discard_limits(struct cache *cache, struct queue_limits *limits)
 	/*
 	 * FIXME: these limits may be incompatible with the cache device
 	 */
-	limits->max_discard_sectors = cache->discard_block_size * 1024;
-	limits->discard_granularity = cache->discard_block_size << SECTOR_SHIFT;
+	limits->max_discard_sectors = cache->sectors_per_block * 1024;
+	limits->discard_granularity = cache->sectors_per_block << SECTOR_SHIFT;
 }
 
 static void cache_io_hints(struct dm_target *ti, struct queue_limits *limits)
-- 
1.8.5.3
