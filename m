From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm thin: elevate the bio_prison and
	deferred_set code to allow for re-use
Date: Fri,  2 Mar 2012 18:59:30 -0500
Message-ID: <1330732770-18621-2-git-send-email-snitzer@redhat.com>
References: <1330732770-18621-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1330732770-18621-1-git-send-email-snitzer@redhat.com>
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
Cc: ejt@redhat.com, snitzer@redhat.com
List-Id: dm-devel.ids

Allow other DM targets to make use of the bio_prison and deferred_set
infrastructure.  Code elevated to drivers/md/dm-bio-prison.[hc]

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/Makefile           |    2 +-
 drivers/md/dm-bio-prison.c    |  336 +++++++++++++++++++++++++++++++++++++
 drivers/md/dm-bio-prison.h    |  110 ++++++++++++
 drivers/md/dm-thin-metadata.h |    6 +-
 drivers/md/dm-thin.c          |  368 +----------------------------------------
 5 files changed, 449 insertions(+), 373 deletions(-)
 create mode 100644 drivers/md/dm-bio-prison.c
 create mode 100644 drivers/md/dm-bio-prison.h

diff --git a/drivers/md/Makefile b/drivers/md/Makefile
index 046860c..c1706ed 100644
--- a/drivers/md/Makefile
+++ b/drivers/md/Makefile
@@ -3,7 +3,7 @@
 #
 
 dm-mod-y	+= dm.o dm-table.o dm-target.o dm-linear.o dm-stripe.o \
-		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o
+		   dm-ioctl.o dm-io.o dm-kcopyd.o dm-sysfs.o dm-bio-prison.o
 dm-multipath-y	+= dm-path-selector.o dm-mpath.o
 dm-snapshot-y	+= dm-snap.o dm-exception-store.o dm-snap-transient.o \
 		    dm-snap-persistent.o
diff --git a/drivers/md/dm-bio-prison.c b/drivers/md/dm-bio-prison.c
new file mode 100644
index 0000000..ddc4afc
--- /dev/null
+++ b/drivers/md/dm-bio-prison.c
@@ -0,0 +1,336 @@
+/*
+ * Copyright (C) 2012 Red Hat.
+ *
+ * This file is released under the GPL.
+ */
+
+#include "dm-bio-prison.h"
+
+#include <linux/module.h>
+
+/*----------------------------------------------------------------*/
+
+static uint32_t calc_nr_buckets(unsigned nr_cells)
+{
+	uint32_t n = 128;
+
+	nr_cells /= 4;
+	nr_cells = min(nr_cells, 8192u);
+
+	while (n < nr_cells)
+		n <<= 1;
+
+	return n;
+}
+
+/*
+ * @nr_cells should be the number of cells you want in use _concurrently_.
+ * Don't confuse it with the number of distinct keys.
+ */
+struct bio_prison *prison_create(unsigned nr_cells)
+{
+	unsigned i;
+	uint32_t nr_buckets = calc_nr_buckets(nr_cells);
+	size_t len = sizeof(struct bio_prison) +
+		(sizeof(struct hlist_head) * nr_buckets);
+	struct bio_prison *prison = kmalloc(len, GFP_KERNEL);
+
+	if (!prison)
+		return NULL;
+
+	spin_lock_init(&prison->lock);
+	prison->cell_pool = mempool_create_kmalloc_pool(nr_cells,
+							sizeof(struct cell));
+	if (!prison->cell_pool) {
+		kfree(prison);
+		return NULL;
+	}
+
+	prison->nr_buckets = nr_buckets;
+	prison->hash_mask = nr_buckets - 1;
+	prison->cells = (struct hlist_head *) (prison + 1);
+	for (i = 0; i < nr_buckets; i++)
+		INIT_HLIST_HEAD(prison->cells + i);
+
+	return prison;
+}
+EXPORT_SYMBOL(prison_create);
+
+void prison_destroy(struct bio_prison *prison)
+{
+	mempool_destroy(prison->cell_pool);
+	kfree(prison);
+}
+EXPORT_SYMBOL(prison_destroy);
+
+static uint32_t hash_key(struct bio_prison *prison, struct cell_key *key)
+{
+	const unsigned long BIG_PRIME = 4294967291UL;
+	uint64_t hash = key->block * BIG_PRIME;
+
+	return (uint32_t) (hash & prison->hash_mask);
+}
+
+static int keys_equal(struct cell_key *lhs, struct cell_key *rhs)
+{
+	       return (lhs->virtual == rhs->virtual) &&
+		       (lhs->dev == rhs->dev) &&
+		       (lhs->block == rhs->block);
+}
+
+static struct cell *__search_bucket(struct hlist_head *bucket,
+				    struct cell_key *key)
+{
+	struct cell *cell;
+	struct hlist_node *tmp;
+
+	hlist_for_each_entry(cell, tmp, bucket, list)
+		if (keys_equal(&cell->key, key))
+			return cell;
+
+	return NULL;
+}
+
+/*
+ * This may block if a new cell needs allocating.  You must ensure that
+ * cells will be unlocked even if the calling thread is blocked.
+ *
+ * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
+ */
+int bio_detain(struct bio_prison *prison, struct cell_key *key,
+	       struct bio *inmate, struct cell **ref)
+{
+	int r;
+	unsigned long flags;
+	uint32_t hash = hash_key(prison, key);
+	struct cell *uninitialized_var(cell), *cell2 = NULL;
+
+	BUG_ON(hash > prison->nr_buckets);
+
+	spin_lock_irqsave(&prison->lock, flags);
+	cell = __search_bucket(prison->cells + hash, key);
+
+	if (!cell) {
+		/*
+		 * Allocate a new cell
+		 */
+		spin_unlock_irqrestore(&prison->lock, flags);
+		cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
+		spin_lock_irqsave(&prison->lock, flags);
+
+		/*
+		 * We've been unlocked, so we have to double check that
+		 * nobody else has inserted this cell in the meantime.
+		 */
+		cell = __search_bucket(prison->cells + hash, key);
+
+		if (!cell) {
+			cell = cell2;
+			cell2 = NULL;
+
+			cell->prison = prison;
+			memcpy(&cell->key, key, sizeof(cell->key));
+			cell->holder = inmate;
+			bio_list_init(&cell->bios);
+			hlist_add_head(&cell->list, prison->cells + hash);
+			r = 0;
+
+		} else {
+			mempool_free(cell2, prison->cell_pool);
+			cell2 = NULL;
+			r = 1;
+			bio_list_add(&cell->bios, inmate);
+		}
+
+	} else {
+		r = 1;
+		bio_list_add(&cell->bios, inmate);
+	}
+	spin_unlock_irqrestore(&prison->lock, flags);
+
+	*ref = cell;
+	return r;
+}
+EXPORT_SYMBOL(bio_detain);
+
+/*
+ * @inmates must have been initialised prior to this call
+ */
+static void __cell_release(struct cell *cell, struct bio_list *inmates)
+{
+	struct bio_prison *prison = cell->prison;
+
+	hlist_del(&cell->list);
+
+	if (inmates) {
+		bio_list_add(inmates, cell->holder);
+		bio_list_merge(inmates, &cell->bios);
+	}
+
+	mempool_free(cell, prison->cell_pool);
+}
+
+void cell_release(struct cell *cell, struct bio_list *bios)
+{
+	unsigned long flags;
+	struct bio_prison *prison = cell->prison;
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release(cell, bios);
+	spin_unlock_irqrestore(&prison->lock, flags);
+}
+EXPORT_SYMBOL(cell_release);
+
+/*
+ * There are a couple of places where we put a bio into a cell briefly
+ * before taking it out again.  In these situations we know that no other
+ * bio may be in the cell.  This function releases the cell, and also does
+ * a sanity check.
+ */
+static void __cell_release_singleton(struct cell *cell, struct bio *bio)
+{
+	hlist_del(&cell->list);
+	BUG_ON(cell->holder != bio);
+	BUG_ON(!bio_list_empty(&cell->bios));
+}
+
+void cell_release_singleton(struct cell *cell, struct bio *bio)
+{
+	unsigned long flags;
+	struct bio_prison *prison = cell->prison;
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release_singleton(cell, bio);
+	spin_unlock_irqrestore(&prison->lock, flags);
+}
+EXPORT_SYMBOL(cell_release_singleton);
+
+/*
+ * Sometimes we don't want the holder, just the additional bios.
+ */
+static void __cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	struct bio_prison *prison = cell->prison;
+
+	hlist_del(&cell->list);
+	if (inmates)
+		bio_list_merge(inmates, &cell->bios);
+
+	mempool_free(cell, prison->cell_pool);
+}
+
+void cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
+{
+	unsigned long flags;
+	struct bio_prison *prison = cell->prison;
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release_no_holder(cell, inmates);
+	spin_unlock_irqrestore(&prison->lock, flags);
+}
+EXPORT_SYMBOL(cell_release_no_holder);
+
+void cell_error(struct cell *cell)
+{
+	struct bio_prison *prison = cell->prison;
+	struct bio_list bios;
+	struct bio *bio;
+	unsigned long flags;
+
+	bio_list_init(&bios);
+
+	spin_lock_irqsave(&prison->lock, flags);
+	__cell_release(cell, &bios);
+	spin_unlock_irqrestore(&prison->lock, flags);
+
+	while ((bio = bio_list_pop(&bios)))
+		bio_io_error(bio);
+}
+EXPORT_SYMBOL(cell_error);
+
+/*----------------------------------------------------------------*/
+
+void ds_init(struct deferred_set *ds)
+{
+	int i;
+
+	spin_lock_init(&ds->lock);
+	ds->current_entry = 0;
+	ds->sweeper = 0;
+	for (i = 0; i < DEFERRED_SET_SIZE; i++) {
+		ds->entries[i].ds = ds;
+		ds->entries[i].count = 0;
+		INIT_LIST_HEAD(&ds->entries[i].work_items);
+	}
+}
+EXPORT_SYMBOL(ds_init);
+
+struct deferred_entry *ds_inc(struct deferred_set *ds)
+{
+	unsigned long flags;
+	struct deferred_entry *entry;
+
+	spin_lock_irqsave(&ds->lock, flags);
+	entry = ds->entries + ds->current_entry;
+	entry->count++;
+	spin_unlock_irqrestore(&ds->lock, flags);
+
+	return entry;
+}
+EXPORT_SYMBOL(ds_inc);
+
+unsigned ds_next(unsigned index)
+{
+	return (index + 1) % DEFERRED_SET_SIZE;
+}
+
+static void __sweep(struct deferred_set *ds, struct list_head *head)
+{
+	while ((ds->sweeper != ds->current_entry) &&
+	       !ds->entries[ds->sweeper].count) {
+		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
+		ds->sweeper = ds_next(ds->sweeper);
+	}
+
+	if ((ds->sweeper == ds->current_entry) && !ds->entries[ds->sweeper].count)
+		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
+}
+
+void ds_dec(struct deferred_entry *entry, struct list_head *head)
+{
+	unsigned long flags;
+
+	spin_lock_irqsave(&entry->ds->lock, flags);
+	BUG_ON(!entry->count);
+	--entry->count;
+	__sweep(entry->ds, head);
+	spin_unlock_irqrestore(&entry->ds->lock, flags);
+}
+EXPORT_SYMBOL(ds_dec);
+
+/*
+ * Returns 1 if deferred or 0 if no pending items to delay job.
+ */
+int ds_add_work(struct deferred_set *ds, struct list_head *work)
+{
+	int r = 1;
+	unsigned long flags;
+	unsigned next_entry;
+
+	spin_lock_irqsave(&ds->lock, flags);
+	if ((ds->sweeper == ds->current_entry) &&
+	    !ds->entries[ds->current_entry].count)
+		r = 0;
+	else {
+		list_add(work, &ds->entries[ds->current_entry].work_items);
+		next_entry = ds_next(ds->current_entry);
+		if (!ds->entries[next_entry].count)
+			ds->current_entry = next_entry;
+	}
+	spin_unlock_irqrestore(&ds->lock, flags);
+
+	return r;
+}
+EXPORT_SYMBOL(ds_add_work);
+
+/*----------------------------------------------------------------*/
diff --git a/drivers/md/dm-bio-prison.h b/drivers/md/dm-bio-prison.h
new file mode 100644
index 0000000..ba428d0
--- /dev/null
+++ b/drivers/md/dm-bio-prison.h
@@ -0,0 +1,110 @@
+/*
+ * Copyright (C) 2012 Red Hat.
+ *
+ * This file is released under the GPL.
+ */
+
+#ifndef DM_BIO_PRISON_H
+#define DM_BIO_PRISON_H
+
+#include "persistent-data/dm-block-manager.h"
+
+#include <linux/list.h>
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Device identifier
+ */
+typedef uint64_t dm_dev_id;
+
+/*----------------------------------------------------------------*/
+
+/*
+ * Sometimes we can't deal with a bio straight away.  We put them in prison
+ * where they can't cause any mischief.  Bios are put in a cell identified
+ * by a key, multiple bios can be in the same cell.  When the cell is
+ * subsequently unlocked the bios become available.
+ */
+struct bio_prison;
+
+struct cell_key {
+	int virtual;
+	dm_dev_id dev;
+	dm_block_t block;
+};
+
+struct cell {
+	struct hlist_node list;
+	struct bio_prison *prison;
+	struct cell_key key;
+	struct bio *holder;
+	struct bio_list bios;
+};
+
+struct bio_prison {
+	spinlock_t lock;
+	mempool_t *cell_pool;
+
+	unsigned nr_buckets;
+	unsigned hash_mask;
+	struct hlist_head *cells;
+};
+
+/*
+ * @nr_cells should be the number of cells you want in use _concurrently_.
+ * Don't confuse it with the number of distinct keys.
+ */
+struct bio_prison *prison_create(unsigned nr_cells);
+void prison_destroy(struct bio_prison *prison);
+
+/*
+ * This may block if a new cell needs allocating.  You must ensure that
+ * cells will be unlocked even if the calling thread is blocked.
+ *
+ * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
+ */
+int bio_detain(struct bio_prison *prison, struct cell_key *key,
+	       struct bio *inmate, struct cell **ref);
+void cell_release(struct cell *cell, struct bio_list *bios);
+void cell_release_singleton(struct cell *cell, struct bio *bio);
+void cell_release_no_holder(struct cell *cell, struct bio_list *inmates);
+void cell_error(struct cell *cell);
+
+/*----------------------------------------------------------------*/
+
+/*
+ * We use the deferred set to keep track of pending reads to shared blocks.
+ * We do this to ensure the new mapping caused by a write isn't performed
+ * until these prior reads have completed.  Otherwise the insertion of the
+ * new mapping could free the old block that the read bios are mapped to.
+ */
+#define DEFERRED_SET_SIZE 64
+
+struct deferred_set;
+struct deferred_entry {
+	struct deferred_set *ds;
+	unsigned count;
+	struct list_head work_items;
+};
+
+struct deferred_set {
+	spinlock_t lock;
+	unsigned current_entry;
+	unsigned sweeper;
+	struct deferred_entry entries[DEFERRED_SET_SIZE];
+};
+
+void ds_init(struct deferred_set *ds);
+struct deferred_entry *ds_inc(struct deferred_set *ds);
+unsigned ds_next(unsigned index);
+void ds_dec(struct deferred_entry *entry, struct list_head *head);
+
+/*
+ * Returns 1 if deferred or 0 if no pending items to delay job.
+ */
+int ds_add_work(struct deferred_set *ds, struct list_head *work);
+
+/*----------------------------------------------------------------*/
+
+#endif
diff --git a/drivers/md/dm-thin-metadata.h b/drivers/md/dm-thin-metadata.h
index 511a223..d718189 100644
--- a/drivers/md/dm-thin-metadata.h
+++ b/drivers/md/dm-thin-metadata.h
@@ -7,6 +7,7 @@
 #ifndef DM_THIN_METADATA_H
 #define DM_THIN_METADATA_H
 
+#include "dm-bio-prison.h"
 #include "persistent-data/dm-block-manager.h"
 
 #define THIN_METADATA_BLOCK_SIZE 4096
@@ -32,11 +33,6 @@ struct dm_pool_metadata;
 struct dm_thin_device;
 
 /*
- * Device identifier
- */
-typedef uint64_t dm_dev_id;
-
-/*
  * Reopens or creates a new, empty metadata volume.
  */
 struct dm_pool_metadata *dm_pool_metadata_open(struct block_device *bdev,
diff --git a/drivers/md/dm-thin.c b/drivers/md/dm-thin.c
index 536835f..d0be4b0 100644
--- a/drivers/md/dm-thin.c
+++ b/drivers/md/dm-thin.c
@@ -4,6 +4,7 @@
  * This file is released under the GPL.
  */
 
+#include "dm-bio-prison.h"
 #include "dm-thin-metadata.h"
 
 #include <linux/device-mapper.h>
@@ -20,7 +21,6 @@
  * Tunable constants
  */
 #define ENDIO_HOOK_POOL_SIZE 10240
-#define DEFERRED_SET_SIZE 64
 #define MAPPING_POOL_SIZE 1024
 #define PRISON_CELLS 1024
 #define COMMIT_PERIOD HZ
@@ -98,372 +98,6 @@
 /*----------------------------------------------------------------*/
 
 /*
- * Sometimes we can't deal with a bio straight away.  We put them in prison
- * where they can't cause any mischief.  Bios are put in a cell identified
- * by a key, multiple bios can be in the same cell.  When the cell is
- * subsequently unlocked the bios become available.
- */
-struct bio_prison;
-
-struct cell_key {
-	int virtual;
-	dm_dev_id dev;
-	dm_block_t block;
-};
-
-struct cell {
-	struct hlist_node list;
-	struct bio_prison *prison;
-	struct cell_key key;
-	struct bio *holder;
-	struct bio_list bios;
-};
-
-struct bio_prison {
-	spinlock_t lock;
-	mempool_t *cell_pool;
-
-	unsigned nr_buckets;
-	unsigned hash_mask;
-	struct hlist_head *cells;
-};
-
-static uint32_t calc_nr_buckets(unsigned nr_cells)
-{
-	uint32_t n = 128;
-
-	nr_cells /= 4;
-	nr_cells = min(nr_cells, 8192u);
-
-	while (n < nr_cells)
-		n <<= 1;
-
-	return n;
-}
-
-/*
- * @nr_cells should be the number of cells you want in use _concurrently_.
- * Don't confuse it with the number of distinct keys.
- */
-static struct bio_prison *prison_create(unsigned nr_cells)
-{
-	unsigned i;
-	uint32_t nr_buckets = calc_nr_buckets(nr_cells);
-	size_t len = sizeof(struct bio_prison) +
-		(sizeof(struct hlist_head) * nr_buckets);
-	struct bio_prison *prison = kmalloc(len, GFP_KERNEL);
-
-	if (!prison)
-		return NULL;
-
-	spin_lock_init(&prison->lock);
-	prison->cell_pool = mempool_create_kmalloc_pool(nr_cells,
-							sizeof(struct cell));
-	if (!prison->cell_pool) {
-		kfree(prison);
-		return NULL;
-	}
-
-	prison->nr_buckets = nr_buckets;
-	prison->hash_mask = nr_buckets - 1;
-	prison->cells = (struct hlist_head *) (prison + 1);
-	for (i = 0; i < nr_buckets; i++)
-		INIT_HLIST_HEAD(prison->cells + i);
-
-	return prison;
-}
-
-static void prison_destroy(struct bio_prison *prison)
-{
-	mempool_destroy(prison->cell_pool);
-	kfree(prison);
-}
-
-static uint32_t hash_key(struct bio_prison *prison, struct cell_key *key)
-{
-	const unsigned long BIG_PRIME = 4294967291UL;
-	uint64_t hash = key->block * BIG_PRIME;
-
-	return (uint32_t) (hash & prison->hash_mask);
-}
-
-static int keys_equal(struct cell_key *lhs, struct cell_key *rhs)
-{
-	       return (lhs->virtual == rhs->virtual) &&
-		       (lhs->dev == rhs->dev) &&
-		       (lhs->block == rhs->block);
-}
-
-static struct cell *__search_bucket(struct hlist_head *bucket,
-				    struct cell_key *key)
-{
-	struct cell *cell;
-	struct hlist_node *tmp;
-
-	hlist_for_each_entry(cell, tmp, bucket, list)
-		if (keys_equal(&cell->key, key))
-			return cell;
-
-	return NULL;
-}
-
-/*
- * This may block if a new cell needs allocating.  You must ensure that
- * cells will be unlocked even if the calling thread is blocked.
- *
- * Returns 1 if the cell was already held, 0 if @inmate is the new holder.
- */
-static int bio_detain(struct bio_prison *prison, struct cell_key *key,
-		      struct bio *inmate, struct cell **ref)
-{
-	int r;
-	unsigned long flags;
-	uint32_t hash = hash_key(prison, key);
-	struct cell *uninitialized_var(cell), *cell2 = NULL;
-
-	BUG_ON(hash > prison->nr_buckets);
-
-	spin_lock_irqsave(&prison->lock, flags);
-	cell = __search_bucket(prison->cells + hash, key);
-
-	if (!cell) {
-		/*
-		 * Allocate a new cell
-		 */
-		spin_unlock_irqrestore(&prison->lock, flags);
-		cell2 = mempool_alloc(prison->cell_pool, GFP_NOIO);
-		spin_lock_irqsave(&prison->lock, flags);
-
-		/*
-		 * We've been unlocked, so we have to double check that
-		 * nobody else has inserted this cell in the meantime.
-		 */
-		cell = __search_bucket(prison->cells + hash, key);
-
-		if (!cell) {
-			cell = cell2;
-			cell2 = NULL;
-
-			cell->prison = prison;
-			memcpy(&cell->key, key, sizeof(cell->key));
-			cell->holder = inmate;
-			bio_list_init(&cell->bios);
-			hlist_add_head(&cell->list, prison->cells + hash);
-			r = 0;
-
-		} else {
-			mempool_free(cell2, prison->cell_pool);
-			cell2 = NULL;
-			r = 1;
-			bio_list_add(&cell->bios, inmate);
-		}
-
-	} else {
-		r = 1;
-		bio_list_add(&cell->bios, inmate);
-	}
-	spin_unlock_irqrestore(&prison->lock, flags);
-
-	*ref = cell;
-	return r;
-}
-
-/*
- * @inmates must have been initialised prior to this call
- */
-static void __cell_release(struct cell *cell, struct bio_list *inmates)
-{
-	struct bio_prison *prison = cell->prison;
-
-	hlist_del(&cell->list);
-
-	if (inmates) {
-		bio_list_add(inmates, cell->holder);
-		bio_list_merge(inmates, &cell->bios);
-	}
-
-	mempool_free(cell, prison->cell_pool);
-}
-
-static void cell_release(struct cell *cell, struct bio_list *bios)
-{
-	unsigned long flags;
-	struct bio_prison *prison = cell->prison;
-
-	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release(cell, bios);
-	spin_unlock_irqrestore(&prison->lock, flags);
-}
-
-/*
- * There are a couple of places where we put a bio into a cell briefly
- * before taking it out again.  In these situations we know that no other
- * bio may be in the cell.  This function releases the cell, and also does
- * a sanity check.
- */
-static void __cell_release_singleton(struct cell *cell, struct bio *bio)
-{
-	hlist_del(&cell->list);
-	BUG_ON(cell->holder != bio);
-	BUG_ON(!bio_list_empty(&cell->bios));
-}
-
-static void cell_release_singleton(struct cell *cell, struct bio *bio)
-{
-	unsigned long flags;
-	struct bio_prison *prison = cell->prison;
-
-	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release_singleton(cell, bio);
-	spin_unlock_irqrestore(&prison->lock, flags);
-}
-
-/*
- * Sometimes we don't want the holder, just the additional bios.
- */
-static void __cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
-{
-	struct bio_prison *prison = cell->prison;
-
-	hlist_del(&cell->list);
-	if (inmates)
-		bio_list_merge(inmates, &cell->bios);
-
-	mempool_free(cell, prison->cell_pool);
-}
-
-static void cell_release_no_holder(struct cell *cell, struct bio_list *inmates)
-{
-	unsigned long flags;
-	struct bio_prison *prison = cell->prison;
-
-	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release_no_holder(cell, inmates);
-	spin_unlock_irqrestore(&prison->lock, flags);
-}
-
-static void cell_error(struct cell *cell)
-{
-	struct bio_prison *prison = cell->prison;
-	struct bio_list bios;
-	struct bio *bio;
-	unsigned long flags;
-
-	bio_list_init(&bios);
-
-	spin_lock_irqsave(&prison->lock, flags);
-	__cell_release(cell, &bios);
-	spin_unlock_irqrestore(&prison->lock, flags);
-
-	while ((bio = bio_list_pop(&bios)))
-		bio_io_error(bio);
-}
-
-/*----------------------------------------------------------------*/
-
-/*
- * We use the deferred set to keep track of pending reads to shared blocks.
- * We do this to ensure the new mapping caused by a write isn't performed
- * until these prior reads have completed.  Otherwise the insertion of the
- * new mapping could free the old block that the read bios are mapped to.
- */
-
-struct deferred_set;
-struct deferred_entry {
-	struct deferred_set *ds;
-	unsigned count;
-	struct list_head work_items;
-};
-
-struct deferred_set {
-	spinlock_t lock;
-	unsigned current_entry;
-	unsigned sweeper;
-	struct deferred_entry entries[DEFERRED_SET_SIZE];
-};
-
-static void ds_init(struct deferred_set *ds)
-{
-	int i;
-
-	spin_lock_init(&ds->lock);
-	ds->current_entry = 0;
-	ds->sweeper = 0;
-	for (i = 0; i < DEFERRED_SET_SIZE; i++) {
-		ds->entries[i].ds = ds;
-		ds->entries[i].count = 0;
-		INIT_LIST_HEAD(&ds->entries[i].work_items);
-	}
-}
-
-static struct deferred_entry *ds_inc(struct deferred_set *ds)
-{
-	unsigned long flags;
-	struct deferred_entry *entry;
-
-	spin_lock_irqsave(&ds->lock, flags);
-	entry = ds->entries + ds->current_entry;
-	entry->count++;
-	spin_unlock_irqrestore(&ds->lock, flags);
-
-	return entry;
-}
-
-static unsigned ds_next(unsigned index)
-{
-	return (index + 1) % DEFERRED_SET_SIZE;
-}
-
-static void __sweep(struct deferred_set *ds, struct list_head *head)
-{
-	while ((ds->sweeper != ds->current_entry) &&
-	       !ds->entries[ds->sweeper].count) {
-		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
-		ds->sweeper = ds_next(ds->sweeper);
-	}
-
-	if ((ds->sweeper == ds->current_entry) && !ds->entries[ds->sweeper].count)
-		list_splice_init(&ds->entries[ds->sweeper].work_items, head);
-}
-
-static void ds_dec(struct deferred_entry *entry, struct list_head *head)
-{
-	unsigned long flags;
-
-	spin_lock_irqsave(&entry->ds->lock, flags);
-	BUG_ON(!entry->count);
-	--entry->count;
-	__sweep(entry->ds, head);
-	spin_unlock_irqrestore(&entry->ds->lock, flags);
-}
-
-/*
- * Returns 1 if deferred or 0 if no pending items to delay job.
- */
-static int ds_add_work(struct deferred_set *ds, struct list_head *work)
-{
-	int r = 1;
-	unsigned long flags;
-	unsigned next_entry;
-
-	spin_lock_irqsave(&ds->lock, flags);
-	if ((ds->sweeper == ds->current_entry) &&
-	    !ds->entries[ds->current_entry].count)
-		r = 0;
-	else {
-		list_add(work, &ds->entries[ds->current_entry].work_items);
-		next_entry = ds_next(ds->current_entry);
-		if (!ds->entries[next_entry].count)
-			ds->current_entry = next_entry;
-	}
-	spin_unlock_irqrestore(&ds->lock, flags);
-
-	return r;
-}
-
-/*----------------------------------------------------------------*/
-
-/*
  * Key building.
  */
 static void build_data_key(struct dm_thin_device *td,
-- 
1.7.1
