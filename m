From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm cache: verify metadata device is exclussive
Date: Wed, 24 Jul 2013 20:50:56 -0400
Message-ID: <1374713456-20807-1-git-send-email-snitzer@redhat.com>
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
List-Id: dm-devel.ids

Do not allow a cache device to use a metadata device that is already
in use by another cache device.

Add list member to the cache structure.  Also reorder members in the
cache structure to eliminate 6 out of 7 holes (reclaiming 24 bytes).

Example:
 echo "0 8192 linear 253:1 0" | dmsetup create metadata
 echo "0 2097152 linear 253:1 8192" | dmsetup create ssd
 echo "0 33554432 linear 253:0 0" | dmsetup create origin
 echo "0 33554432 cache /dev/mapper/metadata /dev/mapper/ssd /dev/mapper/origin 512 0 default 0" | dmsetup create cache1
 echo "0 33554432 cache /dev/mapper/metadata /dev/mapper/ssd /dev/mapper/origin 512 0 default 0" | dmsetup create cache2
device-mapper: reload ioctl on cache2 failed: Device or resource busy
Command failed

Kernel log shows:
device-mapper: table: 253:8: cache: metadata device already in use by a cache
device-mapper: ioctl: error adding target to table

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c |   95 +++++++++++++++++++++++++++++++++++-------
 1 files changed, 80 insertions(+), 15 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 0df3ec0..77b3629 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -101,6 +101,8 @@ struct cache {
 	struct dm_target *ti;
 	struct dm_target_callbacks callbacks;
 
+	struct dm_cache_metadata *cmd;
+
 	/*
 	 * Metadata is written to this device.
 	 */
@@ -117,11 +119,6 @@ struct cache {
 	struct dm_dev *cache_dev;
 
 	/*
-	 * Cache features such as write-through.
-	 */
-	struct cache_features features;
-
-	/*
 	 * Size of the origin device in _complete_ blocks and native sectors.
 	 */
 	dm_oblock_t origin_blocks;
@@ -138,8 +135,6 @@ struct cache {
 	uint32_t sectors_per_block;
 	int sectors_per_block_shift;
 
-	struct dm_cache_metadata *cmd;
-
 	spinlock_t lock;
 	struct bio_list deferred_bios;
 	struct bio_list deferred_flush_bios;
@@ -148,8 +143,8 @@ struct cache {
 	struct list_head completed_migrations;
 	struct list_head need_commit_migrations;
 	sector_t migration_threshold;
-	atomic_t nr_migrations;
 	wait_queue_head_t migration_wait;
+	atomic_t nr_migrations;
 
 	/*
 	 * cache_size entries, dirty if set
@@ -160,9 +155,16 @@ struct cache {
 	/*
 	 * origin_blocks entries, discarded if set.
 	 */
-	uint32_t discard_block_size; /* a power of 2 times sectors per block */
 	dm_dblock_t discard_nr_blocks;
 	unsigned long *discard_bitset;
+	uint32_t discard_block_size; /* a power of 2 times sectors per block */
+
+	/*
+	 * Rather than reconstructing the table line for the status we just
+	 * save it and regurgitate.
+	 */
+	unsigned nr_ctr_args;
+	const char **ctr_args;
 
 	struct dm_kcopyd_client *copier;
 	struct workqueue_struct *wq;
@@ -187,14 +189,14 @@ struct cache {
 	bool loaded_mappings:1;
 	bool loaded_discards:1;
 
-	struct cache_stats stats;
-
 	/*
-	 * Rather than reconstructing the table line for the status we just
-	 * save it and regurgitate.
+	 * Cache features such as write-through.
 	 */
-	unsigned nr_ctr_args;
-	const char **ctr_args;
+	struct cache_features features;
+
+	struct cache_stats stats;
+
+	struct list_head list;
 };
 
 struct per_bio_data {
@@ -231,6 +233,52 @@ struct dm_cache_migration {
 	struct dm_bio_prison_cell *new_ocell;
 };
 
+/*----------------------------------------------------------------*/
+
+/*
+ * A global list of caches that uses the metadata block_device as a key.
+ */
+static struct dm_cache_table {
+	struct mutex mutex;
+	struct list_head caches;
+} dm_cache_table;
+
+static void cache_table_init(void)
+{
+	mutex_init(&dm_cache_table.mutex);
+	INIT_LIST_HEAD(&dm_cache_table.caches);
+}
+
+static void __cache_table_insert(struct cache *cache)
+{
+	BUG_ON(!mutex_is_locked(&dm_cache_table.mutex));
+	list_add(&cache->list, &dm_cache_table.caches);
+}
+
+static void __cache_table_remove(struct cache *cache)
+{
+	BUG_ON(!mutex_is_locked(&dm_cache_table.mutex));
+	list_del(&cache->list);
+}
+
+static struct cache *__cache_table_lookup(struct block_device *md_dev)
+{
+	struct cache *cache = NULL, *tmp;
+
+	BUG_ON(!mutex_is_locked(&dm_cache_table.mutex));
+
+	list_for_each_entry(tmp, &dm_cache_table.caches, list) {
+		if (tmp->metadata_dev->bdev == md_dev) {
+			cache = tmp;
+			break;
+		}
+	}
+
+	return cache;
+}
+
+/*----------------------------------------------------------------*/
+
 /*
  * Processing a bio in the worker thread may require these memory
  * allocations.  We prealloc to avoid deadlocks (the same worker thread
@@ -1533,6 +1581,10 @@ static void cache_dtr(struct dm_target *ti)
 {
 	struct cache *cache = ti->private;
 
+	mutex_lock(&dm_cache_table.mutex);
+	__cache_table_remove(cache);
+	mutex_unlock(&dm_cache_table.mutex);
+
 	destroy(cache);
 }
 
@@ -2134,6 +2186,17 @@ static int cache_ctr(struct dm_target *ti, unsigned argc, char **argv)
 		goto out;
 	}
 
+	mutex_lock(&dm_cache_table.mutex);
+	if (__cache_table_lookup(cache->metadata_dev->bdev)) {
+		ti->error = "metadata device already in use by a cache";
+		r = -EBUSY;
+		mutex_unlock(&dm_cache_table.mutex);
+		destroy(cache);
+		goto out;
+	}
+	__cache_table_insert(cache);
+	mutex_unlock(&dm_cache_table.mutex);
+
 	ti->private = cache;
 
 out:
@@ -2639,6 +2702,8 @@ static int __init dm_cache_init(void)
 {
 	int r;
 
+	cache_table_init();
+
 	r = dm_register_target(&cache_target);
 	if (r) {
 		DMERR("cache target registration failed: %d", r);
