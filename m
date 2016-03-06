From: Steven Wilton <swilton@fluentit.com.au>
Subject: [PATCH v3] dm-cache watermarks
Date: Sun, 6 Mar 2016 17:39:55 +0800
Message-ID: <56DBFAEB.2050801@fluentit.com.au>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040205070809020607050405"
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
List-Id: dm-devel.ids

This is a multi-part message in MIME format.
--------------040205070809020607050405
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit

I realised that I over-thought the original logic.  The attached patch 
is much simpler - write back dirty cache entries at the migration 
threshold rate when we are over the low watermark, and we write back as 
fast as possible when we go over the high watermark.

The current behaviour can be replicated by setting the high watermark to 
100, and the low watermark to 0.

regards

Steven

--------------040205070809020607050405
Content-Type: text/x-patch;
 name="dm-cache-writeback-watermarks.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment; filename="dm-cache-writeback-watermarks.patch"

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 7dab682..7b8b4a3 100644
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
+#define DEFAULT_WRITEBACK_HIGH_WATERMARK 40
+#define DEFAULT_WRITEBACK_LOW_WATERMARK 30
 
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

--------------040205070809020607050405
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline


--------------040205070809020607050405--
