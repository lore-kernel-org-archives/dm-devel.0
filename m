From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 04/18]
	dm-snapshot-rename-dm_snap_exception-to-dm_exception
Date: Tue, 29 Sep 2009 18:53:29 -0400
Message-ID: <1254264823-11538-5-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
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

From: Jon Brassow <jbrassow@redhat.com>

The exception structure is not necessarily just a snapshot
element (especially after we pull it out of dm-snap.c).

Renaming appropriately.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |   14 +++++++-------
 drivers/md/dm-snap-persistent.c |    4 ++--
 drivers/md/dm-snap-transient.c  |    4 ++--
 drivers/md/dm-snap.c            |   34 +++++++++++++++++-----------------
 4 files changed, 28 insertions(+), 28 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index 2110e3b..4a33dd0 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -26,7 +26,7 @@ typedef sector_t chunk_t;
  * of chunks that follow contiguously.  Remaining bits hold the number of the
  * chunk within the device.
  */
-struct dm_snap_exception {
+struct dm_exception {
 	struct list_head hash_list;
 
 	chunk_t old_chunk;
@@ -64,13 +64,13 @@ struct dm_exception_store_type {
 	 * Find somewhere to store the next exception.
 	 */
 	int (*prepare_exception) (struct dm_exception_store *store,
-				  struct dm_snap_exception *e);
+				  struct dm_exception *e);
 
 	/*
 	 * Update the metadata with this exception.
 	 */
 	void (*commit_exception) (struct dm_exception_store *store,
-				  struct dm_snap_exception *e,
+				  struct dm_exception *e,
 				  void (*callback) (void *, int success),
 				  void *callback_context);
 
@@ -120,12 +120,12 @@ static inline chunk_t dm_chunk_number(chunk_t chunk)
 	return chunk & (chunk_t)((1ULL << DM_CHUNK_NUMBER_BITS) - 1ULL);
 }
 
-static inline unsigned dm_consecutive_chunk_count(struct dm_snap_exception *e)
+static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
 {
 	return e->new_chunk >> DM_CHUNK_NUMBER_BITS;
 }
 
-static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
+static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
 {
 	e->new_chunk += (1ULL << DM_CHUNK_NUMBER_BITS);
 
@@ -140,12 +140,12 @@ static inline chunk_t dm_chunk_number(chunk_t chunk)
 	return chunk;
 }
 
-static inline unsigned dm_consecutive_chunk_count(struct dm_snap_exception *e)
+static inline unsigned dm_consecutive_chunk_count(struct dm_exception *e)
 {
 	return 0;
 }
 
-static inline void dm_consecutive_chunk_count_inc(struct dm_snap_exception *e)
+static inline void dm_consecutive_chunk_count_inc(struct dm_exception *e)
 {
 }
 
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 7887e25..d181957 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -580,7 +580,7 @@ static int persistent_read_metadata(struct dm_exception_store *store,
 }
 
 static int persistent_prepare_exception(struct dm_exception_store *store,
-					struct dm_snap_exception *e)
+					struct dm_exception *e)
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
@@ -607,7 +607,7 @@ static int persistent_prepare_exception(struct dm_exception_store *store,
 }
 
 static void persistent_commit_exception(struct dm_exception_store *store,
-					struct dm_snap_exception *e,
+					struct dm_exception *e,
 					void (*callback) (void *, int success),
 					void *callback_context)
 {
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index 786d96d..f2ec79c 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -36,7 +36,7 @@ static int transient_read_metadata(struct dm_exception_store *store,
 }
 
 static int transient_prepare_exception(struct dm_exception_store *store,
-				       struct dm_snap_exception *e)
+				       struct dm_exception *e)
 {
 	struct transient_c *tc = store->context;
 	sector_t size = get_dev_size(store->cow->bdev);
@@ -51,7 +51,7 @@ static int transient_prepare_exception(struct dm_exception_store *store,
 }
 
 static void transient_commit_exception(struct dm_exception_store *store,
-				       struct dm_snap_exception *e,
+				       struct dm_exception *e,
 				       void (*callback) (void *, int success),
 				       void *callback_context)
 {
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index b3cb063..2da5b2b 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -117,7 +117,7 @@ static int bdev_equal(struct block_device *lhs, struct block_device *rhs)
 }
 
 struct dm_snap_pending_exception {
-	struct dm_snap_exception e;
+	struct dm_exception e;
 
 	/*
 	 * Origin buffers waiting for this to complete are held
@@ -367,7 +367,7 @@ static int init_exception_table(struct exception_table *et, uint32_t size,
 static void exit_exception_table(struct exception_table *et, struct kmem_cache *mem)
 {
 	struct list_head *slot;
-	struct dm_snap_exception *ex, *next;
+	struct dm_exception *ex, *next;
 	int i, size;
 
 	size = et->hash_mask + 1;
@@ -386,7 +386,7 @@ static uint32_t exception_hash(struct exception_table *et, chunk_t chunk)
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
 
-static void remove_exception(struct dm_snap_exception *e)
+static void remove_exception(struct dm_exception *e)
 {
 	list_del(&e->hash_list);
 }
@@ -395,11 +395,11 @@ static void remove_exception(struct dm_snap_exception *e)
  * Return the exception data for a sector, or NULL if not
  * remapped.
  */
-static struct dm_snap_exception *lookup_exception(struct exception_table *et,
+static struct dm_exception *lookup_exception(struct exception_table *et,
 						  chunk_t chunk)
 {
 	struct list_head *slot;
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 
 	slot = &et->table[exception_hash(et, chunk)];
 	list_for_each_entry (e, slot, hash_list)
@@ -410,9 +410,9 @@ static struct dm_snap_exception *lookup_exception(struct exception_table *et,
 	return NULL;
 }
 
-static struct dm_snap_exception *alloc_exception(void)
+static struct dm_exception *alloc_exception(void)
 {
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 
 	e = kmem_cache_alloc(exception_cache, GFP_NOIO);
 	if (!e)
@@ -421,7 +421,7 @@ static struct dm_snap_exception *alloc_exception(void)
 	return e;
 }
 
-static void free_exception(struct dm_snap_exception *e)
+static void free_exception(struct dm_exception *e)
 {
 	kmem_cache_free(exception_cache, e);
 }
@@ -447,10 +447,10 @@ static void free_pending_exception(struct dm_snap_pending_exception *pe)
 }
 
 static void insert_exception(struct exception_table *eh,
-			     struct dm_snap_exception *new_e)
+			     struct dm_exception *new_e)
 {
 	struct list_head *l;
-	struct dm_snap_exception *e = NULL;
+	struct dm_exception *e = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
 
@@ -495,7 +495,7 @@ out:
 static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 {
 	struct dm_snapshot *s = context;
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 
 	e = alloc_exception();
 	if (!e)
@@ -926,7 +926,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
@@ -1038,7 +1038,7 @@ static void start_copy(struct dm_snap_pending_exception *pe)
 static struct dm_snap_pending_exception *
 __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 {
-	struct dm_snap_exception *e = lookup_exception(&s->pending, chunk);
+	struct dm_exception *e = lookup_exception(&s->pending, chunk);
 
 	if (!e)
 		return NULL;
@@ -1084,7 +1084,7 @@ __find_pending_exception(struct dm_snapshot *s,
 	return pe;
 }
 
-static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
+static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 			    struct bio *bio, chunk_t chunk)
 {
 	bio->bi_bdev = s->store->cow->bdev;
@@ -1098,7 +1098,7 @@ static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			union map_info *map_context)
 {
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 	struct dm_snapshot *s = ti->private;
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
@@ -1265,7 +1265,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
 	int r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1544,7 +1544,7 @@ static int __init dm_snapshot_init(void)
 		goto bad2;
 	}
 
-	exception_cache = KMEM_CACHE(dm_snap_exception, 0);
+	exception_cache = KMEM_CACHE(dm_exception, 0);
 	if (!exception_cache) {
 		DMERR("Couldn't create exception cache.");
 		r = -ENOMEM;
-- 
1.6.2.5
