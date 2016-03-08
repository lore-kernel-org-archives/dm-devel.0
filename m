From: Steven Wilton <swilton@fluentit.com.au>
Subject: [PATCH] dm cache: add writeback watermarks
Date: Tue,  8 Mar 2016 22:52:42 +0800
Message-ID: <1457448762-6784-1-git-send-email-swilton@fluentit.com.au>
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
Cc: Steven Wilton <swilton@fluentit.com.au>
List-Id: dm-devel.ids

Add 2 new options to the dm-cache code, writeback_low_watermark to
keep a section of the cache dirty in order to reduce the amount
of data being migrated from the cache to the origin, and
writeback_high_watermark to allow a threshold to be set where the
dirty cache entries are flushed as quick as possible.

Signed-off-by: Steven Wilton <swilton@fluentit.com.au>
---
 Documentation/device-mapper/cache.txt | 34 +++++++++++++++++++++++++++++
 drivers/md/dm-cache-target.c          | 40 +++++++++++++++++++++++++++++++++--
 2 files changed, 72 insertions(+), 2 deletions(-)

diff --git a/Documentation/device-mapper/cache.txt b/Documentation/device-mapper/cache.txt
index 68c0f51..fd071ed 100644
--- a/Documentation/device-mapper/cache.txt
+++ b/Documentation/device-mapper/cache.txt
@@ -121,6 +121,40 @@ For the time being, a message "migration_threshold <#sectors>"
 can be used to set the maximum number of sectors being migrated,
 the default being 204800 sectors (or 100MB).
 
+
+Writeback watermarks
+--------------------
+
+The migration between the cache and origin devices in writeback mode causes
+a large amount of I/O, since every write causes the actual data to be written
+to the cache device, and the full cache block to be read from the cache device
+and written to the origin (sequential I/O, so it does not have a big penalty).
+
+The message "writeback_low_watermark <PCT>" can be used to set a percentage
+of the cache to be kept dirty.  This will allow more writes to completely
+avoid the origin device.  Writebacks will occur at the migration_threshold
+rate once the percentage of dirty blocks exceeds the writeback_low_watermark.
+
+The message "writeback_high_watermark <PCT>" can be used to set a percentage
+that will cause the dirty blocks to be flushed as quickly as possible (exceeding
+the migration_threshold) until the number of dirty blocks drops below the high
+watermark percentage.
+
+The default values for these settings are as follows, resulting in no blocks
+being kept dirty, and always flushing at the migration_threshold rate:
+writeback_low_watermark 0
+writeback_high_watermark 100
+
+If you adjust these figures, remember that increasing the low watermark will
+reduce the amount of cache available for read caching, so starting at values
+around 20-30 percent is probably a good idea unless you have a write intensive
+workload.
+
+If you increase the low watermark, you will need to set it back to 0 before
+trying to remove the cache, otherwise the userspace program will wait forever
+for the dirty blocks to be flushed.
+
+
 Updating on-disk metadata
 -------------------------
 
diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 7755af3..e55e46d 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -221,6 +221,8 @@ struct cache {
 	struct list_head completed_migrations;
 	struct list_head need_commit_migrations;
 	sector_t migration_threshold;
+	unsigned long writeback_high_watermark;
+	unsigned long writeback_low_watermark;
 	wait_queue_head_t migration_wait;
 	atomic_t nr_allocated_migrations;
 
@@ -1433,6 +1435,20 @@ static bool spare_migration_bandwidth(struct cache *cache)
 	return current_volume < cache->migration_threshold;
 }
 
+static bool writeback_wanted(struct cache *cache)
+{
+	unsigned long dirty_pct = (atomic_read(&cache->nr_dirty) * 100) / from_cblock(cache->cache_size);
+
+	if (dirty_pct >= cache->writeback_high_watermark) {
+		return true;
+
+	} else if (dirty_pct >= cache->writeback_low_watermark && spare_migration_bandwidth(cache)) {
+		return true;
+	}
+
+	return false;
+}
+
 static void inc_hit_counter(struct cache *cache, struct bio *bio)
 {
 	atomic_inc(bio_data_dir(bio) == READ ?
@@ -1673,7 +1689,7 @@ static void writeback_some_dirty_blocks(struct cache *cache)
 
 	memset(&structs, 0, sizeof(structs));
 
-	while (spare_migration_bandwidth(cache)) {
+	while (writeback_wanted(cache)) {
 		if (prealloc_data_structs(cache, &structs))
 			break;
 
@@ -2239,6 +2255,22 @@ static int process_config_option(struct cache *cache, const char *key, const cha
 		return 0;
 	}
 
+	if (!strcasecmp(key, "writeback_high_watermark")) {
+		if (kstrtoul(value, 10, &tmp))
+			return -EINVAL;
+
+		cache->writeback_high_watermark = tmp;
+		return 0;
+	}
+
+	if (!strcasecmp(key, "writeback_low_watermark")) {
+		if (kstrtoul(value, 10, &tmp))
+			return -EINVAL;
+
+		cache->writeback_low_watermark = tmp;
+		return 0;
+	}
+
 	return NOT_CORE_OPTION;
 }
 
@@ -2332,6 +2364,8 @@ static void set_cache_size(struct cache *cache, dm_cblock_t size)
 }
 
 #define DEFAULT_MIGRATION_THRESHOLD 2048
+#define DEFAULT_WRITEBACK_HIGH_WATERMARK 100
+#define DEFAULT_WRITEBACK_LOW_WATERMARK 0
 
 static int cache_create(struct cache_args *ca, struct cache **result)
 {
@@ -2397,6 +2431,8 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 	cache->policy_nr_args = ca->policy_argc;
 	cache->migration_threshold = DEFAULT_MIGRATION_THRESHOLD;
+	cache->writeback_high_watermark = DEFAULT_WRITEBACK_HIGH_WATERMARK;
+	cache->writeback_low_watermark = DEFAULT_WRITEBACK_LOW_WATERMARK;
 
 	r = set_config_values(cache, ca->policy_argc, ca->policy_argv);
 	if (r) {
@@ -3103,7 +3139,7 @@ static void cache_status(struct dm_target *ti, status_type_t type,
 			goto err;
 		}
 
-		DMEMIT("2 migration_threshold %llu ", (unsigned long long) cache->migration_threshold);
+		DMEMIT("6 migration_threshold %llu writeback_high_watermark %llu writeback_low_watermark %llu ", (unsigned long long) cache->migration_threshold, (unsigned long long) cache->writeback_high_watermark, (unsigned long long) cache->writeback_low_watermark);
 
 		DMEMIT("%s ", dm_cache_policy_get_name(cache->policy));
 		if (sz < maxlen) {
-- 
2.1.4
