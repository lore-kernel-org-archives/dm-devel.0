From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm cache: conditionally reduce the
	per_bio_data_size of the writethrough fix
Date: Wed, 27 Mar 2013 15:59:25 -0400
Message-ID: <1364414365-14523-1-git-send-email-snitzer@redhat.com>
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

When writethrough mode is used the per_bio_data structure includes a
dm_bio_details structure which is 1056 bytes.  The dm_bio_details
structure was added in "dm cache: fix writes to cache device in
writethrough mode" which fixed commit e2e74d617e ("dm cache: fix race
in writethrough implementation").  This patch significantly reduces
the cache target's per_bio_data_size when writeback mode is used.

If writeback mode is used we can avoid allocating the writethrough
specific members of the per_bio_data structure (the dm_bio_details
structure included).  So with this patch per_bio_data_size is 16 bytes
if writeback mode is used and 1096 bytes if writethrough mode is used.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-cache-target.c |   47 ++++++++++++++++++++++++++++++-----------
 1 files changed, 34 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-cache-target.c b/drivers/md/dm-cache-target.c
index 1ab122a..7c984c0 100644
--- a/drivers/md/dm-cache-target.c
+++ b/drivers/md/dm-cache-target.c
@@ -202,7 +202,11 @@ struct per_bio_data {
 	unsigned req_nr:2;
 	struct dm_deferred_entry *all_io_entry;
 
-	/* writethrough fields */
+	/*
+	 * writethrough fields.  These MUST remain at the end of this
+	 * structure and the 'cache' member must be the first as it
+	 * is used to determined the offsetof the writethrough fields.
+	 */
 	struct cache *cache;
 	dm_cblock_t cblock;
 	bio_end_io_t *saved_bi_end_io;
@@ -515,16 +519,28 @@ static void save_stats(struct cache *cache)
 /*----------------------------------------------------------------
  * Per bio data
  *--------------------------------------------------------------*/
-static struct per_bio_data *get_per_bio_data(struct bio *bio)
+
+/*
+ * If using writeback, leave out struct per_bio_data's writethrough fields.
+ */
+#define PB_DATA_SIZE_WB (offsetof(struct per_bio_data, cache))
+#define PB_DATA_SIZE_WT (sizeof(struct per_bio_data))
+
+static size_t get_per_bio_data_size(struct cache *cache)
+{
+	return cache->features.write_through ? PB_DATA_SIZE_WT : PB_DATA_SIZE_WB;
+}
+
+static struct per_bio_data *get_per_bio_data(struct bio *bio, size_t data_size)
 {
-	struct per_bio_data *pb = dm_per_bio_data(bio, sizeof(struct per_bio_data));
+	struct per_bio_data *pb = dm_per_bio_data(bio, data_size);
 	BUG_ON(!pb);
 	return pb;
 }
 
-static struct per_bio_data *init_per_bio_data(struct bio *bio)
+static struct per_bio_data *init_per_bio_data(struct bio *bio, size_t data_size)
 {
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	struct per_bio_data *pb = get_per_bio_data(bio, data_size);
 
 	pb->tick = false;
 	pb->req_nr = dm_bio_get_target_bio_nr(bio);
@@ -558,7 +574,8 @@ static void remap_to_cache(struct cache *cache, struct bio *bio,
 static void check_if_tick_bio_needed(struct cache *cache, struct bio *bio)
 {
 	unsigned long flags;
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	size_t pb_data_size = get_per_bio_data_size(cache);
+	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 
 	spin_lock_irqsave(&cache->lock, flags);
 	if (cache->need_tick_bio &&
@@ -637,7 +654,7 @@ static void defer_writethrough_bio(struct cache *cache, struct bio *bio)
 
 static void writethrough_endio(struct bio *bio, int err)
 {
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 	bio->bi_end_io = pb->saved_bi_end_io;
 
 	if (err) {
@@ -665,7 +682,7 @@ static void writethrough_endio(struct bio *bio, int err)
 static void remap_to_origin_then_cache(struct cache *cache, struct bio *bio,
 				       dm_oblock_t oblock, dm_cblock_t cblock)
 {
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	struct per_bio_data *pb = get_per_bio_data(bio, PB_DATA_SIZE_WT);
 
 	pb->cache = cache;
 	pb->cblock = cblock;
@@ -1039,7 +1056,8 @@ static void defer_bio(struct cache *cache, struct bio *bio)
 
 static void process_flush_bio(struct cache *cache, struct bio *bio)
 {
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	size_t pb_data_size = get_per_bio_data_size(cache);
+	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 
 	BUG_ON(bio->bi_size);
 	if (!pb->req_nr)
@@ -1111,7 +1129,8 @@ static void process_bio(struct cache *cache, struct prealloc *structs,
 	dm_oblock_t block = get_bio_block(cache, bio);
 	struct dm_bio_prison_cell *cell_prealloc, *old_ocell, *new_ocell;
 	struct policy_result lookup_result;
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	size_t pb_data_size = get_per_bio_data_size(cache);
+	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 	bool discarded_block = is_discarded_oblock(cache, block);
 	bool can_migrate = discarded_block || spare_migration_bandwidth(cache);
 
@@ -1885,7 +1904,6 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 
 	cache->ti = ca->ti;
 	ti->private = cache;
-	ti->per_bio_data_size = sizeof(struct per_bio_data);
 	ti->num_flush_bios = 2;
 	ti->flush_supported = true;
 
@@ -1894,6 +1912,7 @@ static int cache_create(struct cache_args *ca, struct cache **result)
 	ti->discard_zeroes_data_unsupported = true;
 
 	memcpy(&cache->features, &ca->features, sizeof(cache->features));
+	ti->per_bio_data_size = get_per_bio_data_size(cache);
 
 	cache->callbacks.congested_fn = cache_is_congested;
 	dm_table_add_target_callbacks(ti->table, &cache->callbacks);
@@ -2096,6 +2115,7 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 
 	int r;
 	dm_oblock_t block = get_bio_block(cache, bio);
+	size_t pb_data_size = get_per_bio_data_size(cache);
 	bool can_migrate = false;
 	bool discarded_block;
 	struct dm_bio_prison_cell *cell;
@@ -2112,7 +2132,7 @@ static int cache_map(struct dm_target *ti, struct bio *bio)
 		return DM_MAPIO_REMAPPED;
 	}
 
-	pb = init_per_bio_data(bio);
+	pb = init_per_bio_data(bio, pb_data_size);
 
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA | REQ_DISCARD)) {
 		defer_bio(cache, bio);
@@ -2197,7 +2217,8 @@ static int cache_end_io(struct dm_target *ti, struct bio *bio, int error)
 {
 	struct cache *cache = ti->private;
 	unsigned long flags;
-	struct per_bio_data *pb = get_per_bio_data(bio);
+	size_t pb_data_size = get_per_bio_data_size(cache);
+	struct per_bio_data *pb = get_per_bio_data(bio, pb_data_size);
 
 	if (pb->tick) {
 		policy_tick(cache->policy);
-- 
1.7.1
