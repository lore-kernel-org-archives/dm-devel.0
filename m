From: Joe Thornber <ejt@redhat.com>
Subject: [PATCH 09/11] [dm-thin] Discard support part 1
Date: Thu,  2 Feb 2012 16:39:12 +0000
Message-ID: <1328200754-13642-10-git-send-email-ejt@redhat.com>
References: <1328200754-13642-1-git-send-email-ejt@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1328200754-13642-1-git-send-email-ejt@redhat.com>
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
Cc: Joe Thornber <ejt@redhat.com>
List-Id: dm-devel.ids

This patch contains a lot of the ground work needed for supporting
discard.

- The thin target now has an endio function, that replaces
  shared_read_endio.

- An explicit 'quiesced' flag has been introduced into the new_mapping
  structure.  Before, this was implicitly indicated by m->list being
  empty.

- The map_info->ptr remains constant for the duration of a bio's trip
  through thinp.  Making it easier to reason about it.
---
 drivers/md/dm-thin.c |  125 ++++++++++++++++++++++++++++----------------------
 1 files changed, 70 insertions(+), 55 deletions(-)

diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 922ebf2..c5e3102 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -511,7 +511,7 @@ struct pool {
 
 	struct bio_list retry_on_resume_list;
 
-	struct deferred_set ds;	/* FIXME: move to thin_c */
+	struct deferred_set shared_read_ds;
 
 	struct new_mapping *next_mapping;
 	mempool_t *mapping_pool;
@@ -606,6 +606,12 @@ static struct pool *__pool_table_lookup_metadata_dev(struct block_device *md_dev
 
 /*----------------------------------------------------------------*/
 
+struct endio_hook {
+	struct thin_c *tc;
+	struct deferred_entry *shared_read_entry;
+	struct new_mapping *overwrite_mapping;
+};
+
 static void __requeue_bio_list(struct thin_c *tc, struct bio_list *master)
 {
 	struct bio *bio;
@@ -616,7 +622,8 @@ static void __requeue_bio_list(struct thin_c *tc, struct bio_list *master)
 	bio_list_init(master);
 
 	while ((bio = bio_list_pop(&bios))) {
-		if (dm_get_mapinfo(bio)->ptr == tc)
+		struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
+		if (h->tc == tc)
 			bio_endio(bio, DM_ENDIO_REQUEUE);
 		else
 			bio_list_add(master, bio);
@@ -706,16 +713,11 @@ static void wake_worker(struct pool *pool)
 /*
  * Bio endio functions.
  */
-struct endio_hook {
-	struct thin_c *tc;
-	bio_end_io_t *saved_bi_end_io;
-	struct deferred_entry *entry;
-};
-
 struct new_mapping {
 	struct list_head list;
 
-	int prepared;
+	unsigned quiesced:1;
+	unsigned prepared:1;
 
 	struct thin_c *tc;
 	dm_block_t virt_block;
@@ -737,7 +739,7 @@ static void __maybe_add_mapping(struct new_mapping *m)
 {
 	struct pool *pool = m->tc->pool;
 
-	if (list_empty(&m->list) && m->prepared) {
+	if (m->quiesced && m->prepared) {
 		list_add(&m->list, &pool->prepared_mappings);
 		wake_worker(pool);
 	}
@@ -760,7 +762,8 @@ static void copy_complete(int read_err, unsigned long write_err, void *context)
 static void overwrite_endio(struct bio *bio, int err)
 {
 	unsigned long flags;
-	struct new_mapping *m = dm_get_mapinfo(bio)->ptr;
+	struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
+	struct new_mapping *m = h->overwrite_mapping;
 	struct pool *pool = m->tc->pool;
 
 	m->err = err;
@@ -771,31 +774,6 @@ static void overwrite_endio(struct bio *bio, int err)
 	spin_unlock_irqrestore(&pool->lock, flags);
 }
 
-static void shared_read_endio(struct bio *bio, int err)
-{
-	struct list_head mappings;
-	struct new_mapping *m, *tmp;
-	struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
-	unsigned long flags;
-	struct pool *pool = h->tc->pool;
-
-	bio->bi_end_io = h->saved_bi_end_io;
-	bio_endio(bio, err);
-
-	INIT_LIST_HEAD(&mappings);
-	ds_dec(h->entry, &mappings);
-
-	spin_lock_irqsave(&pool->lock, flags);
-	list_for_each_entry_safe(m, tmp, &mappings, list) {
-		list_del(&m->list);
-		INIT_LIST_HEAD(&m->list);
-		__maybe_add_mapping(m);
-	}
-	spin_unlock_irqrestore(&pool->lock, flags);
-
-	mempool_free(h, pool->endio_hook_pool);
-}
-
 /*----------------------------------------------------------------*/
 
 /*
@@ -934,9 +912,7 @@ static int ensure_next_mapping(struct pool *pool)
 static struct new_mapping *get_next_mapping(struct pool *pool)
 {
 	struct new_mapping *r = pool->next_mapping;
-
 	BUG_ON(!pool->next_mapping);
-
 	pool->next_mapping = NULL;
 
 	return r;
@@ -952,6 +928,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	struct new_mapping *m = get_next_mapping(pool);
 
 	INIT_LIST_HEAD(&m->list);
+	m->quiesced = 0;
 	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
@@ -960,7 +937,8 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	m->err = 0;
 	m->bio = NULL;
 
-	ds_add_work(&pool->ds, &m->list);
+	if (!ds_add_work(&pool->shared_read_ds, &m->list))
+		m->quiesced = 1;
 
 	/*
 	 * IO to pool_dev remaps to the pool target's data_dev.
@@ -969,9 +947,10 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	 * bio immediately. Otherwise we use kcopyd to clone the data first.
 	 */
 	if (io_overwrites_block(pool, bio)) {
+		struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
+		h->overwrite_mapping = m;
 		m->bio = bio;
 		save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
-		dm_get_mapinfo(bio)->ptr = m;
 		remap_and_issue(tc, bio, data_dest);
 	} else {
 		struct dm_io_region from, to;
@@ -1018,6 +997,7 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 	struct new_mapping *m = get_next_mapping(pool);
 
 	INIT_LIST_HEAD(&m->list);
+	m->quiesced = 1;
 	m->prepared = 0;
 	m->tc = tc;
 	m->virt_block = virt_block;
@@ -1035,9 +1015,10 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 		process_prepared_mapping(m);
 
 	else if (io_overwrites_block(pool, bio)) {
+		struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
+		h->overwrite_mapping = m;
 		m->bio = bio;
 		save_and_set_endio(bio, &m->saved_bi_end_io, overwrite_endio);
-		dm_get_mapinfo(bio)->ptr = m;
 		remap_and_issue(tc, bio, data_block);
 
 	} else {
@@ -1124,7 +1105,8 @@ static int alloc_data_block(struct thin_c *tc, dm_block_t *result)
  */
 static void retry_on_resume(struct bio *bio)
 {
-	struct thin_c *tc = dm_get_mapinfo(bio)->ptr;
+	struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
+	struct thin_c *tc = h->tc;
 	struct pool *pool = tc->pool;
 	unsigned long flags;
 
@@ -1190,13 +1172,9 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 	if (bio_data_dir(bio) == WRITE)
 		break_sharing(tc, bio, block, &key, lookup_result, cell);
 	else {
-		struct endio_hook *h;
-		h = mempool_alloc(pool->endio_hook_pool, GFP_NOIO);
+		struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
 
-		h->tc = tc;
-		h->entry = ds_inc(&pool->ds);
-		save_and_set_endio(bio, &h->saved_bi_end_io, shared_read_endio);
-		dm_get_mapinfo(bio)->ptr = h;
+		h->shared_read_entry = ds_inc(&pool->shared_read_ds);
 
 		cell_release_singleton(cell, bio);
 		remap_and_issue(tc, bio, lookup_result->block);
@@ -1320,7 +1298,9 @@ static void process_deferred_bios(struct pool *pool)
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	while ((bio = bio_list_pop(&bios))) {
-		struct thin_c *tc = dm_get_mapinfo(bio)->ptr;
+		struct endio_hook *h = dm_get_mapinfo(bio)->ptr;
+		struct thin_c *tc = h->tc;
+
 		/*
 		 * If we've got no free new_mapping structs, and processing
 		 * this bio might require one, we pause until there are some
@@ -1405,6 +1385,18 @@ static void thin_defer_bio(struct thin_c *tc, struct bio *bio)
 	wake_worker(pool);
 }
 
+static struct endio_hook *thin_hook_bio(struct thin_c *tc, struct bio *bio)
+{
+	struct pool *pool = tc->pool;
+	struct endio_hook *h = mempool_alloc(pool->endio_hook_pool, GFP_NOIO);
+
+	h->tc = tc;
+	h->shared_read_entry = NULL;
+	h->overwrite_mapping = NULL;
+
+	return h;
+}
+
 /*
  * Non-blocking function called from the thin target's map function.
  */
@@ -1417,11 +1409,7 @@ static int thin_bio_map(struct dm_target *ti, struct bio *bio,
 	struct dm_thin_device *td = tc->td;
 	struct dm_thin_lookup_result result;
 
-	/*
-	 * Save the thin context for easy access from the deferred bio later.
-	 */
-	map_context->ptr = tc;
-
+	map_context->ptr = thin_hook_bio(tc, bio);
 	if (bio->bi_rw & (REQ_FLUSH | REQ_FUA)) {
 		thin_defer_bio(tc, bio);
 		return DM_MAPIO_SUBMITTED;
@@ -1601,7 +1589,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->low_water_triggered = 0;
 	pool->no_free_space = 0;
 	bio_list_init(&pool->retry_on_resume_list);
-	ds_init(&pool->ds);
+	ds_init(&pool->shared_read_ds);
 
 	pool->next_mapping = NULL;
 	pool->mapping_pool =
@@ -2392,6 +2380,32 @@ static int thin_map(struct dm_target *ti, struct bio *bio,
 	return thin_bio_map(ti, bio, map_context);
 }
 
+static int thin_endio(struct dm_target *ti,
+		      struct bio *bio, int err,
+		      union map_info *map_context)
+{
+	unsigned long flags;
+	struct endio_hook *h = map_context->ptr;
+	struct list_head work;
+	struct new_mapping *m, *tmp;
+	struct pool *pool = h->tc->pool;
+
+	if (h->shared_read_entry) {
+		INIT_LIST_HEAD(&work);
+		ds_dec(h->shared_read_entry, &work);
+
+		spin_lock_irqsave(&pool->lock, flags);
+		list_for_each_entry_safe(m, tmp, &work, list) {
+			list_del(&m->list);
+			m->quiesced = 1;
+			__maybe_add_mapping(m);
+		}
+		spin_unlock_irqrestore(&pool->lock, flags);
+	}
+
+	return 0;
+}
+
 static void thin_postsuspend(struct dm_target *ti)
 {
 	if (dm_noflush_suspending(ti))
@@ -2477,6 +2491,7 @@ static struct target_type thin_target = {
 	.ctr = thin_ctr,
 	.dtr = thin_dtr,
 	.map = thin_map,
+	.end_io = thin_endio,
 	.postsuspend = thin_postsuspend,
 	.status = thin_status,
 	.iterate_devices = thin_iterate_devices,
-- 
1.7.5.4
