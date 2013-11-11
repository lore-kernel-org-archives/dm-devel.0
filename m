From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/6] dm cache: cache shrinking support
Date: Mon, 11 Nov 2013 12:20:43 -0500
Message-ID: <1384190448-3861-2-git-send-email-snitzer@redhat.com>
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

Allow a cache to shrink if the blocks being removed from the cache are
not dirty.

Signed-off-by: Joe Thornber <ejt@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-metadata.c |   66 ++++++++++++++++++++++++++++++++++++++++
 drivers/md/dm-cache-target.c   |   63 ++++++++++++++++++++++++++++++++-----
 2 files changed, 120 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 2262b4e..062b83e 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -667,19 +667,85 @@ void dm_cache_metadata_close(struct dm_cache_metadata *cmd)
 	kfree(cmd);
 }
 
+/*
+ * Checks that the given cache block is either unmapped or clean.
+ */
+static int block_unmapped_or_clean(struct dm_cache_metadata *cmd, dm_cblock_t b,
+				   bool *result)
+{
+	int r;
+	__le64 value;
+	dm_oblock_t ob;
+	unsigned flags;
+
+	r = dm_array_get_value(&cmd->info, cmd->root, from_cblock(b), &value);
+	if (r) {
+		DMERR("block_unmapped_or_clean failed");
+		return r;
+	}
+
+	unpack_value(value, &ob, &flags);
+	*result = !((flags & M_VALID) && (flags & M_DIRTY));
+
+	return 0;
+}
+
+static int blocks_are_unmapped_or_clean(struct dm_cache_metadata *cmd,
+					dm_cblock_t begin, dm_cblock_t end,
+					bool *result)
+{
+	int r;
+	*result = true;
+
+	while (begin != end) {
+		r = block_unmapped_or_clean(cmd, begin, result);
+		if (r)
+			return r;
+
+		if (!*result) {
+			DMERR("cache block %llu is dirty",
+			      (unsigned long long) from_cblock(begin));
+			return 0;
+		}
+
+		begin = to_cblock(from_cblock(begin) + 1);
+	}
+
+	return 0;
+}
+
 int dm_cache_resize(struct dm_cache_metadata *cmd, dm_cblock_t new_cache_size)
 {
 	int r;
+	bool clean;
 	__le64 null_mapping = pack_value(0, 0);
 
 	down_write(&cmd->root_lock);
 	__dm_bless_for_disk(&null_mapping);
+
+	if (from_cblock(new_cache_size) < from_cblock(cmd->cache_blocks)) {
+		r = blocks_are_unmapped_or_clean(cmd, new_cache_size, cmd->cache_blocks, &clean);
+		if (r) {
+			__dm_unbless_for_disk(&null_mapping);
+			goto out;
+		}
+
+		if (!clean) {
+			DMERR("unable to shrink cache due to dirty blocks");
+			r = -EINVAL;
+			__dm_unbless_for_disk(&null_mapping);
+			goto out;
+		}
+	}
+
 	r = dm_array_resize(&cmd->info, cmd->root, from_cblock(cmd->cache_blocks),
 			    from_cblock(new_cache_size),
 			    &null_mapping, &cmd->root);
 	if (!r)
 		cmd->cache_blocks = new_cache_size;
 	cmd->changed = true;
+
+out:
 	up_write(&cmd->root_lock);
 
 	return r;
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 655994f..183dfc9 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -2502,26 +2502,71 @@ static int load_discard(void *context, sector_t discard_block_size,
 	return 0;
 }
 
+static dm_cblock_t get_cache_dev_size(struct cache *cache)
+{
+	sector_t size = get_dev_size(cache->cache_dev);
+	(void) sector_div(size, cache->sectors_per_block);
+	return to_cblock(size);
+}
+
+static bool can_resize(struct cache *cache, dm_cblock_t new_size)
+{
+	if (from_cblock(new_size) > from_cblock(cache->cache_size))
+		return true;
+
+	/*
+	 * We can't drop a dirty block when shrinking the cache.
+	 */
+	while (from_cblock(new_size) < from_cblock(cache->cache_size)) {
+		new_size = to_cblock(from_cblock(new_size) + 1);
+		if (is_dirty(cache, new_size)) {
+			DMERR("unable to shrink cache; cache block %llu is dirty",
+			      (unsigned long long) from_cblock(new_size));
+			return false;
+		}
+	}
+
+	return true;
+}
+
+static int resize_cache_dev(struct cache *cache, dm_cblock_t new_size)
+{
+	int r;
+
+	r = dm_cache_resize(cache->cmd, cache->cache_size);
+	if (r) {
+		DMERR("could not resize cache metadata");
+		return r;
+	}
+
+	cache->cache_size = new_size;
+
+	return 0;
+}
+
 static int cache_preresume(struct dm_target *ti)
 {
 	int r = 0;
 	struct cache *cache = ti->private;
-	sector_t actual_cache_size = get_dev_size(cache->cache_dev);
-	(void) sector_div(actual_cache_size, cache->sectors_per_block);
+	dm_cblock_t csize = get_cache_dev_size(cache);
 
 	/*
 	 * Check to see if the cache has resized.
 	 */
-	if (from_cblock(cache->cache_size) != actual_cache_size || !cache->sized) {
-		cache->cache_size = to_cblock(actual_cache_size);
-
-		r = dm_cache_resize(cache->cmd, cache->cache_size);
-		if (r) {
-			DMERR("could not resize cache metadata");
+	if (!cache->sized) {
+		r = resize_cache_dev(cache, csize);
+		if (r)
 			return r;
-		}
 
 		cache->sized = true;
+
+	} else if (csize != cache->cache_size) {
+		if (!can_resize(cache, csize))
+			return -EINVAL;
+
+		r = resize_cache_dev(cache, csize);
+		if (r)
+			return r;
 	}
 
 	if (!cache->loaded_mappings) {
-- 
1.7.4.4
