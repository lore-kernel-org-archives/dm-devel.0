From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 3/3] dm bio prison: add "dm_" prefix to bio
	prison and deferred set interfaces
Date: Tue, 25 Sep 2012 18:35:29 -0400
Message-ID: <1348612529-2437-3-git-send-email-snitzer@redhat.com>
References: <1348612529-2437-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1348612529-2437-1-git-send-email-snitzer@redhat.com>
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

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-bio-prison.c |   94 ++++++++++++++++++++--------------------
 drivers/md/dm-bio-prison.h |   40 ++++++++---------
 drivers/md/dm-thin.c       |  102 ++++++++++++++++++++++----------------------
 3 files changed, 117 insertions(+), 119 deletions(-)

diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
index fdf9c19..b3b7d60 100644
--- a/drivers/md/dm-bio-prison.c
+++ b/drivers/md/dm-bio-prison.c
@@ -16,13 +16,13 @@
 
 struct dm_bio_prison_cell {
 	struct hlist_node list;
-	struct bio_prison *prison;
-	struct cell_key key;
+	struct dm_bio_prison *prison;
+	struct dm_cell_key key;
 	struct bio *holder;
 	struct bio_list bios;
 };
 
-struct bio_prison {
+struct dm_bio_prison {
 	spinlock_t lock;
 	mempool_t *cell_pool;
 
@@ -52,13 +52,13 @@ static struct kmem_cache *_cell_cache;
  * @nr_cells should be the number of cells you want in use _concurrently_.
  * Don't confuse it with the number of distinct keys.
  */
-struct bio_prison *prison_create(unsigned nr_cells)
+struct dm_bio_prison *dm_bio_prison_create(unsigned nr_cells)
 {
 	unsigned i;
 	uint32_t nr_buckets = calc_nr_buckets(nr_cells);
-	size_t len = sizeof(struct bio_prison) +
+	size_t len = sizeof(struct dm_bio_prison) +
 		(sizeof(struct hlist_head) * nr_buckets);
-	struct bio_prison *prison = kmalloc(len, GFP_KERNEL);
+	struct dm_bio_prison *prison = kmalloc(len, GFP_KERNEL);
 
 	if (!prison)
 		return NULL;
@@ -78,16 +78,16 @@ struct bio_prison *prison_create(unsigned nr_cells)
 
 	return prison;
 }
-EXPORT_SYMBOL_GPL(prison_create);
+EXPORT_SYMBOL_GPL(dm_bio_prison_create);
 
-void prison_destroy(struct bio_prison *prison)
+void dm_bio_prison_destroy(struct dm_bio_prison *prison)
 {
 	mempool_destroy(prison->cell_pool);
 	kfree(prison);
 }
-EXPORT_SYMBOL_GPL(prison_destroy);
+EXPORT_SYMBOL_GPL(dm_bio_prison_destroy);
 
-static uint32_t hash_key(struct bio_prison *prison, struct cell_key *key)
+static uint32_t hash_key(struct dm_bio_prison *prison, struct dm_cell_key *key)
 {
 	const unsigned long BIG_PRIME = 4294967291UL;
 	uint64_t hash = key->block * BIG_PRIME;
@@ -95,7 +95,7 @@ static uint32_t hash_key(struct bio_prison *prison, struct cell_key *key)
 	return (uint32_t) (hash & prison->hash_mask);
 }
 
-static int keys_equal(struct cell_key *lhs, struct cell_key *rhs)
+static int keys_equal(struct dm_cell_key *lhs, struct dm_cell_key *rhs)
 {
 	       return (lhs->virtual == rhs->virtual) &&
 		       (lhs->dev == rhs->dev) &&
@@ -103,7 +103,7 @@ static int keys_equal(struct cell_key *lhs, struct cell_key *rhs)
 }
 
 static struct dm_bio_prison_cell *__search_bucket(struct hlist_head *bucket,
-						  struct cell_key *key)
+						  struct dm_cell_key *key)
 {
 	struct dm_bio_prison_cell *cell;
 	struct hlist_node *tmp;
@@ -115,8 +115,8 @@ static struct dm_bio_prison_cell *__search_bucket(struct hlist_head *bucket,
 	return NULL;
 }
 
-int bio_detain(struct bio_prison *prison, struct cell_key *key,
-	       struct bio *inmate, struct dm_bio_prison_cell **ref)
+int dm_bio_detain(struct dm_bio_prison *prison, struct dm_cell_key *key,
+		  struct bio *inmate, struct dm_bio_prison_cell **ref)
 {
 	int r = 1;
 	unsigned long flags;
@@ -170,9 +170,9 @@ out:
 	*ref = cell;
 	return r;
 }
-EXPORT_SYMBOL_GPL(bio_detain);
+EXPORT_SYMBOL_GPL(dm_bio_detain);
 
-int bio_detain_if_occupied(struct bio_prison *prison, struct cell_key *key,
+int bio_detain_if_occupied(struct dm_bio_prison *prison, struct dm_cell_key *key,
 			   struct bio *inmate)
 {
 	int r = 0;
@@ -200,7 +200,7 @@ EXPORT_SYMBOL_GPL(bio_detain_if_occupied);
  */
 static void __cell_release(struct dm_bio_prison_cell *cell, struct bio_list *inmates)
 {
-	struct bio_prison *prison = cell->prison;
+	struct dm_bio_prison *prison = cell->prison;
 
 	hlist_del(&cell->list);
 
@@ -212,16 +212,16 @@ static void __cell_release(struct dm_bio_prison_cell *cell, struct bio_list *inm
 	mempool_free(cell, prison->cell_pool);
 }
 
-void cell_release(struct dm_bio_prison_cell *cell, struct bio_list *bios)
+void dm_cell_release(struct dm_bio_prison_cell *cell, struct bio_list *bios)
 {
 	unsigned long flags;
-	struct bio_prison *prison = cell->prison;
+	struct dm_bio_prison *prison = cell->prison;
 
 	spin_lock_irqsave(&prison->lock, flags);
 	__cell_release(cell, bios);
 	spin_unlock_irqrestore(&prison->lock, flags);
 }
-EXPORT_SYMBOL_GPL(cell_release);
+EXPORT_SYMBOL_GPL(dm_cell_release);
 
 /*
  * There are a couple of places where we put a bio into a cell briefly
@@ -237,23 +237,23 @@ static void __cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio
 	__cell_release(cell, NULL);
 }
 
-void cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio)
+void dm_cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio)
 {
 	unsigned long flags;
-	struct bio_prison *prison = cell->prison;
+	struct dm_bio_prison *prison = cell->prison;
 
 	spin_lock_irqsave(&prison->lock, flags);
 	__cell_release_singleton(cell, bio);
 	spin_unlock_irqrestore(&prison->lock, flags);
 }
-EXPORT_SYMBOL_GPL(cell_release_singleton);
+EXPORT_SYMBOL_GPL(dm_cell_release_singleton);
 
 /*
  * Sometimes we don't want the holder, just the additional bios.
  */
 static void __cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates)
 {
-	struct bio_prison *prison = cell->prison;
+	struct dm_bio_prison *prison = cell->prison;
 
 	hlist_del(&cell->list);
 	bio_list_merge(inmates, &cell->bios);
@@ -261,20 +261,20 @@ static void __cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio
 	mempool_free(cell, prison->cell_pool);
 }
 
-void cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates)
+void dm_cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates)
 {
 	unsigned long flags;
-	struct bio_prison *prison = cell->prison;
+	struct dm_bio_prison *prison = cell->prison;
 
 	spin_lock_irqsave(&prison->lock, flags);
 	__cell_release_no_holder(cell, inmates);
 	spin_unlock_irqrestore(&prison->lock, flags);
 }
-EXPORT_SYMBOL_GPL(cell_release_no_holder);
+EXPORT_SYMBOL_GPL(dm_cell_release_no_holder);
 
-void cell_error(struct dm_bio_prison_cell *cell)
+void dm_cell_error(struct dm_bio_prison_cell *cell)
 {
-	struct bio_prison *prison = cell->prison;
+	struct dm_bio_prison *prison = cell->prison;
 	struct bio_list bios;
 	struct bio *bio;
 	unsigned long flags;
@@ -288,29 +288,29 @@ void cell_error(struct dm_bio_prison_cell *cell)
 	while ((bio = bio_list_pop(&bios)))
 		bio_io_error(bio);
 }
-EXPORT_SYMBOL_GPL(cell_error);
+EXPORT_SYMBOL_GPL(dm_cell_error);
 
 /*----------------------------------------------------------------*/
 
 #define DEFERRED_SET_SIZE 64
 
-struct deferred_entry {
-	struct deferred_set *ds;
+struct dm_deferred_entry {
+	struct dm_deferred_set *ds;
 	unsigned count;
 	struct list_head work_items;
 };
 
-struct deferred_set {
+struct dm_deferred_set {
 	spinlock_t lock;
 	unsigned current_entry;
 	unsigned sweeper;
-	struct deferred_entry entries[DEFERRED_SET_SIZE];
+	struct dm_deferred_entry entries[DEFERRED_SET_SIZE];
 };
 
-struct deferred_set *ds_create(void)
+struct dm_deferred_set *dm_ds_create(void)
 {
 	int i;
-	struct deferred_set *ds;
+	struct dm_deferred_set *ds;
 
 	ds = kmalloc(sizeof(*ds), GFP_KERNEL);
 
@@ -325,18 +325,18 @@ struct deferred_set *ds_create(void)
 
 	return ds;
 }
-EXPORT_SYMBOL_GPL(ds_create);
+EXPORT_SYMBOL_GPL(dm_ds_create);
 
-void ds_destroy(struct deferred_set *ds)
+void dm_ds_destroy(struct dm_deferred_set *ds)
 {
 	kfree(ds);
 }
-EXPORT_SYMBOL_GPL(ds_destroy);
+EXPORT_SYMBOL_GPL(dm_ds_destroy);
 
-struct deferred_entry *ds_inc(struct deferred_set *ds)
+struct dm_deferred_entry *dm_ds_inc(struct dm_deferred_set *ds)
 {
 	unsigned long flags;
-	struct deferred_entry *entry;
+	struct dm_deferred_entry *entry;
 
 	spin_lock_irqsave(&ds->lock, flags);
 	entry = ds->entries + ds->current_entry;
@@ -345,14 +345,14 @@ struct deferred_entry *ds_inc(struct deferred_set *ds)
 
 	return entry;
 }
-EXPORT_SYMBOL_GPL(ds_inc);
+EXPORT_SYMBOL_GPL(dm_ds_inc);
 
 static unsigned ds_next(unsigned index)
 {
 	return (index + 1) % DEFERRED_SET_SIZE;
 }
 
-static void __sweep(struct deferred_set *ds, struct list_head *head)
+static void __sweep(struct dm_deferred_set *ds, struct list_head *head)
 {
 	while ((ds->sweeper != ds->current_entry) &&
 	       !ds->entries[ds->sweeper].count) {
@@ -364,7 +364,7 @@ static void __sweep(struct deferred_set *ds, struct list_head *head)
 		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
 }
 
-void ds_dec(struct deferred_entry *entry, struct list_head *head)
+void dm_ds_dec(struct dm_deferred_entry *entry, struct list_head *head)
 {
 	unsigned long flags;
 
@@ -374,12 +374,12 @@ void ds_dec(struct deferred_entry *entry, struct list_head *head)
 	__sweep(entry->ds, head);
 	spin_unlock_irqrestore(&entry->ds->lock, flags);
 }
-EXPORT_SYMBOL_GPL(ds_dec);
+EXPORT_SYMBOL_GPL(dm_ds_dec);
 
 /*
  * Returns 1 if deferred or 0 if no pending items to delay job.
  */
-int ds_add_work(struct deferred_set *ds, struct list_head *work)
+int dm_ds_add_work(struct dm_deferred_set *ds, struct list_head *work)
 {
 	int r = 1;
 	unsigned long flags;
@@ -399,7 +399,7 @@ int ds_add_work(struct deferred_set *ds, struct list_head *work)
 
 	return r;
 }
-EXPORT_SYMBOL_GPL(ds_add_work);
+EXPORT_SYMBOL_GPL(dm_ds_add_work);
 
 /*----------------------------------------------------------------*/
 
diff --git a/drivers/md/dm-bio-prison.h b/drivers/md/dm-bio-prison.h
index 0d9d270..76bf9c7 100644
--- a/drivers/md/dm-bio-prison.h
+++ b/drivers/md/dm-bio-prison.h
@@ -15,26 +15,24 @@
 
 /*----------------------------------------------------------------*/
 
-/* FIXME: prefix everything */
-
 /*
  * Sometimes we can't deal with a bio straight away.  We put them in prison
  * where they can't cause any mischief.  Bios are put in a cell identified
  * by a key, multiple bios can be in the same cell.  When the cell is
  * subsequently unlocked the bios become available.
  */
-struct bio_prison;
+struct dm_bio_prison;
 struct dm_bio_prison_cell;
 
 /* FIXME: this needs to be more abstract */
-struct cell_key {
+struct dm_cell_key {
 	int virtual;
 	dm_thin_id dev;
 	dm_block_t block;
 };
 
-struct bio_prison *prison_create(unsigned nr_cells);
-void prison_destroy(struct bio_prison *prison);
+struct dm_bio_prison *dm_bio_prison_create(unsigned nr_cells);
+void dm_bio_prison_destroy(struct dm_bio_prison *prison);
 
 /*
  * This may block if a new cell needs allocating.  You must ensure that
@@ -42,15 +40,15 @@ void prison_destroy(struct bio_prison *prison);
  *
  * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
  */
-int bio_detain(struct bio_prison *prison, struct cell_key *key,
-	       struct bio *inmate, struct dm_bio_prison_cell **ref);
-int bio_detain_if_occupied(struct bio_prison *prison, struct cell_key *key,
-			   struct bio *inmate);
+int dm_bio_detain(struct dm_bio_prison *prison, struct dm_cell_key *key,
+		  struct bio *inmate, struct dm_bio_prison_cell **ref);
+int dm_bio_detain_if_occupied(struct dm_bio_prison *prison, struct dm_cell_key *key,
+			      struct bio *inmate);
 
-void cell_release(struct dm_bio_prison_cell *cell, struct bio_list *bios);
-void cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio); // FIXME: bio arg not needed
-void cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates);
-void cell_error(struct dm_bio_prison_cell *cell);
+void dm_cell_release(struct dm_bio_prison_cell *cell, struct bio_list *bios);
+void dm_cell_release_singleton(struct dm_bio_prison_cell *cell, struct bio *bio); // FIXME: bio arg not needed
+void dm_cell_release_no_holder(struct dm_bio_prison_cell *cell, struct bio_list *inmates);
+void dm_cell_error(struct dm_bio_prison_cell *cell);
 
 /*----------------------------------------------------------------*/
 
@@ -61,15 +59,15 @@ void cell_error(struct dm_bio_prison_cell *cell);
  * new mapping could free the old block that the read bios are mapped to.
  */
 
-struct deferred_set;
-struct deferred_entry;
+struct dm_deferred_set;
+struct dm_deferred_entry;
 
-struct deferred_set *ds_create(void);
-void ds_destroy(struct deferred_set *ds);
+struct dm_deferred_set *dm_ds_create(void);
+void dm_ds_destroy(struct dm_deferred_set *ds);
 
-struct deferred_entry *ds_inc(struct deferred_set *ds);
-void ds_dec(struct deferred_entry *entry, struct list_head *head);
-int ds_add_work(struct deferred_set *ds, struct list_head *work);
+struct dm_deferred_entry *dm_ds_inc(struct dm_deferred_set *ds);
+void dm_ds_dec(struct dm_deferred_entry *entry, struct list_head *head);
+int dm_ds_add_work(struct dm_deferred_set *ds, struct list_head *work);
 
 /*----------------------------------------------------------------*/
 
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 1d4831f..ef9ce66 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -102,7 +102,7 @@
  * Key building.
  */
 static void build_data_key(struct dm_thin_device *td,
-			   dm_block_t b, struct cell_key *key)
+			   dm_block_t b, struct dm_cell_key *key)
 {
 	key->virtual = 0;
 	key->dev = dm_thin_dev_id(td);
@@ -110,7 +110,7 @@ static void build_data_key(struct dm_thin_device *td,
 }
 
 static void build_virtual_key(struct dm_thin_device *td, dm_block_t b,
-			      struct cell_key *key)
+			      struct dm_cell_key *key)
 {
 	key->virtual = 1;
 	key->dev = dm_thin_dev_id(td);
@@ -163,7 +163,7 @@ struct pool {
 	unsigned low_water_triggered:1;	/* A dm event has been sent */
 	unsigned no_free_space:1;	/* A -ENOSPC warning has been issued */
 
-	struct bio_prison *prison;
+	struct dm_bio_prison *prison;
 	struct dm_kcopyd_client *copier;
 
 	struct workqueue_struct *wq;
@@ -181,8 +181,8 @@ struct pool {
 
 	struct bio_list retry_on_resume_list;
 
-	struct deferred_set *shared_read_ds;
-	struct deferred_set *all_io_ds;
+	struct dm_deferred_set *shared_read_ds;
+	struct dm_deferred_set *all_io_ds;
 
 	struct dm_thin_new_mapping *next_mapping;
 	mempool_t *mapping_pool;
@@ -289,8 +289,8 @@ static struct pool *__pool_table_lookup_metadata_dev(struct block_device *md_dev
 
 struct dm_thin_endio_hook {
 	struct thin_c *tc;
-	struct deferred_entry *shared_read_entry;
-	struct deferred_entry *all_io_entry;
+	struct dm_deferred_entry *shared_read_entry;
+	struct dm_deferred_entry *all_io_entry;
 	struct dm_thin_new_mapping *overwrite_mapping;
 };
 
@@ -506,7 +506,7 @@ static void cell_defer(struct thin_c *tc, struct dm_bio_prison_cell *cell,
 	unsigned long flags;
 
 	spin_lock_irqsave(&pool->lock, flags);
-	cell_release(cell, &pool->deferred_bios);
+	dm_cell_release(cell, &pool->deferred_bios);
 	spin_unlock_irqrestore(&tc->pool->lock, flags);
 
 	wake_worker(pool);
@@ -525,7 +525,7 @@ static void cell_defer_except(struct thin_c *tc, struct dm_bio_prison_cell *cell
 	bio_list_init(&bios);
 
 	spin_lock_irqsave(&pool->lock, flags);
-	cell_release_no_holder(cell, &pool->deferred_bios);
+	dm_cell_release_no_holder(cell, &pool->deferred_bios);
 	spin_unlock_irqrestore(&pool->lock, flags);
 
 	wake_worker(pool);
@@ -535,7 +535,7 @@ static void process_prepared_mapping_fail(struct dm_thin_new_mapping *m)
 {
 	if (m->bio)
 		m->bio->bi_end_io = m->saved_bi_end_io;
-	cell_error(m->cell);
+	dm_cell_error(m->cell);
 	list_del(&m->list);
 	mempool_free(m, m->tc->pool->mapping_pool);
 }
@@ -550,7 +550,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 		bio->bi_end_io = m->saved_bi_end_io;
 
 	if (m->err) {
-		cell_error(m->cell);
+		dm_cell_error(m->cell);
 		goto out;
 	}
 
@@ -562,7 +562,7 @@ static void process_prepared_mapping(struct dm_thin_new_mapping *m)
 	r = dm_thin_insert_block(tc->td, m->virt_block, m->data_block);
 	if (r) {
 		DMERR("dm_thin_insert_block() failed");
-		cell_error(m->cell);
+		dm_cell_error(m->cell);
 		goto out;
 	}
 
@@ -696,7 +696,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 	m->err = 0;
 	m->bio = NULL;
 
-	if (!ds_add_work(pool->shared_read_ds, &m->list))
+	if (!dm_ds_add_work(pool->shared_read_ds, &m->list))
 		m->quiesced = 1;
 
 	/*
@@ -728,7 +728,7 @@ static void schedule_copy(struct thin_c *tc, dm_block_t virt_block,
 		if (r < 0) {
 			mempool_free(m, pool->mapping_pool);
 			DMERR("dm_kcopyd_copy() failed");
-			cell_error(cell);
+			dm_cell_error(cell);
 		}
 	}
 }
@@ -793,7 +793,7 @@ static void schedule_zero(struct thin_c *tc, dm_block_t virt_block,
 		if (r < 0) {
 			mempool_free(m, pool->mapping_pool);
 			DMERR("dm_kcopyd_zero() failed");
-			cell_error(cell);
+			dm_cell_error(cell);
 		}
 	}
 }
@@ -905,7 +905,7 @@ static void no_space(struct dm_bio_prison_cell *cell)
 	struct bio_list bios;
 
 	bio_list_init(&bios);
-	cell_release(cell, &bios);
+	dm_cell_release(cell, &bios);
 
 	while ((bio = bio_list_pop(&bios)))
 		retry_on_resume(bio);
@@ -917,13 +917,13 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 	unsigned long flags;
 	struct pool *pool = tc->pool;
 	struct dm_bio_prison_cell *cell, *cell2;
-	struct cell_key key, key2;
+	struct dm_cell_key key, key2;
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_thin_lookup_result lookup_result;
 	struct dm_thin_new_mapping *m;
 
 	build_virtual_key(tc->td, block, &key);
-	if (bio_detain(tc->pool->prison, &key, bio, &cell))
+	if (dm_bio_detain(tc->pool->prison, &key, bio, &cell))
 		return;
 
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
@@ -935,8 +935,8 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		 * on this block.
 		 */
 		build_data_key(tc->td, lookup_result.block, &key2);
-		if (bio_detain(tc->pool->prison, &key2, bio, &cell2)) {
-			cell_release_singleton(cell, bio);
+		if (dm_bio_detain(tc->pool->prison, &key2, bio, &cell2)) {
+			dm_cell_release_singleton(cell, bio);
 			break;
 		}
 
@@ -955,7 +955,7 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			m->err = 0;
 			m->bio = bio;
 
-			if (!ds_add_work(pool->all_io_ds, &m->list)) {
+			if (!dm_ds_add_work(pool->all_io_ds, &m->list)) {
 				spin_lock_irqsave(&pool->lock, flags);
 				list_add(&m->list, &pool->prepared_discards);
 				spin_unlock_irqrestore(&pool->lock, flags);
@@ -967,8 +967,8 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 			 * a block boundary.  So we submit the discard of a
 			 * partial block appropriately.
 			 */
-			cell_release_singleton(cell, bio);
-			cell_release_singleton(cell2, bio);
+			dm_cell_release_singleton(cell, bio);
+			dm_cell_release_singleton(cell2, bio);
 			if ((!lookup_result.shared) && pool->pf.discard_passdown)
 				remap_and_issue(tc, bio, lookup_result.block);
 			else
@@ -980,20 +980,20 @@ static void process_discard(struct thin_c *tc, struct bio *bio)
 		/*
 		 * It isn't provisioned, just forget it.
 		 */
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 		bio_endio(bio, 0);
 		break;
 
 	default:
 		DMERR("discard: find block unexpectedly returned %d", r);
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 		bio_io_error(bio);
 		break;
 	}
 }
 
 static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
-			  struct cell_key *key,
+			  struct dm_cell_key *key,
 			  struct dm_thin_lookup_result *lookup_result,
 			  struct dm_bio_prison_cell *cell)
 {
@@ -1013,7 +1013,7 @@ static void break_sharing(struct thin_c *tc, struct bio *bio, dm_block_t block,
 
 	default:
 		DMERR("%s: alloc_data_block() failed, error = %d", __func__, r);
-		cell_error(cell);
+		dm_cell_error(cell);
 		break;
 	}
 }
@@ -1024,14 +1024,14 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 {
 	struct dm_bio_prison_cell *cell;
 	struct pool *pool = tc->pool;
-	struct cell_key key;
+	struct dm_cell_key key;
 
 	/*
 	 * If cell is already occupied, then sharing is already in the process
 	 * of being broken so we have nothing further to do here.
 	 */
 	build_data_key(tc->td, lookup_result->block, &key);
-	if (bio_detain(pool->prison, &key, bio, &cell))
+	if (dm_bio_detain(pool->prison, &key, bio, &cell))
 		return;
 
 	if (bio_data_dir(bio) == WRITE && bio->bi_size)
@@ -1039,9 +1039,9 @@ static void process_shared_bio(struct thin_c *tc, struct bio *bio,
 	else {
 		struct dm_thin_endio_hook *h = dm_get_mapinfo(bio)->ptr;
 
-		h->shared_read_entry = ds_inc(pool->shared_read_ds);
+		h->shared_read_entry = dm_ds_inc(pool->shared_read_ds);
 
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 		remap_and_issue(tc, bio, lookup_result->block);
 	}
 }
@@ -1056,7 +1056,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	 * Remap empty bios (flushes) immediately, without provisioning.
 	 */
 	if (!bio->bi_size) {
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 		remap_and_issue(tc, bio, 0);
 		return;
 	}
@@ -1066,7 +1066,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	 */
 	if (bio_data_dir(bio) == READ) {
 		zero_fill_bio(bio);
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 		bio_endio(bio, 0);
 		return;
 	}
@@ -1087,7 +1087,7 @@ static void provision_block(struct thin_c *tc, struct bio *bio, dm_block_t block
 	default:
 		DMERR("%s: alloc_data_block() failed, error = %d", __func__, r);
 		set_pool_mode(tc->pool, PM_READ_ONLY);
-		cell_error(cell);
+		dm_cell_error(cell);
 		break;
 	}
 }
@@ -1097,7 +1097,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 	int r;
 	dm_block_t block = get_bio_block(tc, bio);
 	struct dm_bio_prison_cell *cell;
-	struct cell_key key;
+	struct dm_cell_key key;
 	struct dm_thin_lookup_result lookup_result;
 
 	/*
@@ -1105,7 +1105,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 	 * being provisioned so we have nothing further to do here.
 	 */
 	build_virtual_key(tc->td, block, &key);
-	if (bio_detain(tc->pool->prison, &key, bio, &cell))
+	if (dm_bio_detain(tc->pool->prison, &key, bio, &cell))
 		return;
 
 	r = dm_thin_find_block(tc->td, block, 1, &lookup_result);
@@ -1120,7 +1120,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 		 * TODO: this will probably have to change when discard goes
 		 * back in.
 		 */
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 
 		if (lookup_result.shared)
 			process_shared_bio(tc, bio, block, &lookup_result);
@@ -1130,7 +1130,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 
 	case -ENODATA:
 		if (bio_data_dir(bio) == READ && tc->origin_dev) {
-			cell_release_singleton(cell, bio);
+			dm_cell_release_singleton(cell, bio);
 			remap_to_origin_and_issue(tc, bio);
 		} else
 			provision_block(tc, bio, block, cell);
@@ -1138,7 +1138,7 @@ static void process_bio(struct thin_c *tc, struct bio *bio)
 
 	default:
 		DMERR("dm_thin_find_block() failed, error = %d", r);
-		cell_release_singleton(cell, bio);
+		dm_cell_release_singleton(cell, bio);
 		bio_io_error(bio);
 		break;
 	}
@@ -1347,7 +1347,7 @@ static struct dm_thin_endio_hook *thin_hook_bio(struct thin_c *tc, struct bio *b
 
 	h->tc = tc;
 	h->shared_read_entry = NULL;
-	h->all_io_entry = bio->bi_rw & REQ_DISCARD ? NULL : ds_inc(pool->all_io_ds);
+	h->all_io_entry = bio->bi_rw & REQ_DISCARD ? NULL : dm_ds_inc(pool->all_io_ds);
 	h->overwrite_mapping = NULL;
 
 	return h;
@@ -1557,7 +1557,7 @@ static void __pool_destroy(struct pool *pool)
 	if (dm_pool_metadata_close(pool->pmd) < 0)
 		DMWARN("%s: dm_pool_metadata_close() failed.", __func__);
 
-	prison_destroy(pool->prison);
+	dm_bio_prison_destroy(pool->prison);
 	dm_kcopyd_client_destroy(pool->copier);
 
 	if (pool->wq)
@@ -1567,8 +1567,8 @@ static void __pool_destroy(struct pool *pool)
 		mempool_free(pool->next_mapping, pool->mapping_pool);
 	mempool_destroy(pool->mapping_pool);
 	mempool_destroy(pool->endio_hook_pool);
-	ds_destroy(pool->shared_read_ds);
-	ds_destroy(pool->all_io_ds);
+	dm_ds_destroy(pool->shared_read_ds);
+	dm_ds_destroy(pool->all_io_ds);
 	kfree(pool);
 }
 
@@ -1607,7 +1607,7 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 		pool->sectors_per_block_shift = __ffs(block_size);
 	pool->low_water_blocks = 0;
 	pool_features_init(&pool->pf);
-	pool->prison = prison_create(PRISON_CELLS);
+	pool->prison = dm_bio_prison_create(PRISON_CELLS);
 	if (!pool->prison) {
 		*error = "Error creating pool's bio prison";
 		err_p = ERR_PTR(-ENOMEM);
@@ -1644,11 +1644,11 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 	pool->no_free_space = 0;
 	bio_list_init(&pool->retry_on_resume_list);
 
-	pool->shared_read_ds = ds_create();
+	pool->shared_read_ds = dm_ds_create();
 	if (!pool->shared_read_ds)
 		goto bad_shared_ds;
 
-	pool->all_io_ds = ds_create();
+	pool->all_io_ds = dm_ds_create();
 	if (!pool->all_io_ds)
 		goto bad_all_io_ds;
 
@@ -1679,15 +1679,15 @@ static struct pool *pool_create(struct mapped_device *pool_md,
 bad_endio_hook_pool:
 	mempool_destroy(pool->mapping_pool);
 bad_mapping_pool:
-	ds_destroy(pool->all_io_ds);
+	dm_ds_destroy(pool->all_io_ds);
 bad_all_io_ds:
-	ds_destroy(pool->shared_read_ds);
+	dm_ds_destroy(pool->shared_read_ds);
 bad_shared_ds:
 	destroy_workqueue(pool->wq);
 bad_wq:
 	dm_kcopyd_client_destroy(pool->copier);
 bad_kcopyd_client:
-	prison_destroy(pool->prison);
+	dm_bio_prison_destroy(pool->prison);
 bad_prison:
 	kfree(pool);
 bad_pool:
@@ -2624,7 +2624,7 @@ static int thin_endio(struct dm_target *ti,
 
 	if (h->shared_read_entry) {
 		INIT_LIST_HEAD(&work);
-		ds_dec(h->shared_read_entry, &work);
+		dm_ds_dec(h->shared_read_entry, &work);
 
 		spin_lock_irqsave(&pool->lock, flags);
 		list_for_each_entry_safe(m, tmp, &work, list) {
@@ -2637,7 +2637,7 @@ static int thin_endio(struct dm_target *ti,
 
 	if (h->all_io_entry) {
 		INIT_LIST_HEAD(&work);
-		ds_dec(h->all_io_entry, &work);
+		dm_ds_dec(h->all_io_entry, &work);
 		spin_lock_irqsave(&pool->lock, flags);
 		list_for_each_entry_safe(m, tmp, &work, list)
 			list_add(&m->list, &pool->prepared_discards);
-- 
1.7.1
