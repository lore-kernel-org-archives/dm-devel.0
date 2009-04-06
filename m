From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 33] DM Snapshot: rename dm_snap_exception to
	dm_exception
Date: Mon, 6 Apr 2009 16:33:06 -0500
Message-ID: <200904062133.n36LX6TO019990@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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

Patch name: dm-snap-rename-dm_snap_exception-to-dm_exception.patch

The exception structure is not necessarily just a snapshot
element (especially after we pull it out of dm-snap.c).

Renaming appropriately.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
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
 
@@ -120,12 +120,12 @@ static inline chunk_t dm_chunk_number(ch
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
 
@@ -140,12 +140,12 @@ static inline chunk_t dm_chunk_number(ch
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
 
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -568,7 +568,7 @@ static int persistent_read_metadata(stru
 }
 
 static int persistent_prepare_exception(struct dm_exception_store *store,
-					struct dm_snap_exception *e)
+					struct dm_exception *e)
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
@@ -595,7 +595,7 @@ static int persistent_prepare_exception(
 }
 
 static void persistent_commit_exception(struct dm_exception_store *store,
-					struct dm_snap_exception *e,
+					struct dm_exception *e,
 					void (*callback) (void *, int success),
 					void *callback_context)
 {
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -36,7 +36,7 @@ static int transient_read_metadata(struc
 }
 
 static int transient_prepare_exception(struct dm_exception_store *store,
-				       struct dm_snap_exception *e)
+				       struct dm_exception *e)
 {
 	struct transient_c *tc = store->context;
 	sector_t size = get_dev_size(store->cow->bdev);
@@ -51,7 +51,7 @@ static int transient_prepare_exception(s
 }
 
 static void transient_commit_exception(struct dm_exception_store *store,
-				       struct dm_snap_exception *e,
+				       struct dm_exception *e,
 				       void (*callback) (void *, int success),
 				       void *callback_context)
 {
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -118,7 +118,7 @@ static int bdev_equal(struct block_devic
 }
 
 struct dm_snap_pending_exception {
-	struct dm_snap_exception e;
+	struct dm_exception e;
 
 	/*
 	 * Origin buffers waiting for this to complete are held
@@ -369,7 +369,7 @@ static void exit_exception_table(struct 
 				 struct kmem_cache *mem)
 {
 	struct list_head *slot;
-	struct dm_snap_exception *ex, *next;
+	struct dm_exception *ex, *next;
 	int i, size;
 
 	size = et->hash_mask + 1;
@@ -389,13 +389,13 @@ static uint32_t exception_hash(struct ex
 }
 
 static void insert_exception(struct exception_table *eh,
-			     struct dm_snap_exception *e)
+			     struct dm_exception *e)
 {
 	struct list_head *l = &eh->table[exception_hash(eh, e->old_chunk)];
 	list_add(&e->hash_list, l);
 }
 
-static void remove_exception(struct dm_snap_exception *e)
+static void remove_exception(struct dm_exception *e)
 {
 	list_del(&e->hash_list);
 }
@@ -404,11 +404,11 @@ static void remove_exception(struct dm_s
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
@@ -419,9 +419,9 @@ static struct dm_snap_exception *lookup_
 	return NULL;
 }
 
-static struct dm_snap_exception *alloc_exception(void)
+static struct dm_exception *alloc_exception(void)
 {
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 
 	e = kmem_cache_alloc(exception_cache, GFP_NOIO);
 	if (!e)
@@ -430,7 +430,7 @@ static struct dm_snap_exception *alloc_e
 	return e;
 }
 
-static void free_exception(struct dm_snap_exception *e)
+static void free_exception(struct dm_exception *e)
 {
 	kmem_cache_free(exception_cache, e);
 }
@@ -456,11 +456,11 @@ static void free_pending_exception(struc
 }
 
 static void insert_completed_exception(struct dm_snapshot *s,
-				       struct dm_snap_exception *new_e)
+				       struct dm_exception *new_e)
 {
 	struct exception_table *eh = &s->complete;
 	struct list_head *l;
-	struct dm_snap_exception *e = NULL;
+	struct dm_exception *e = NULL;
 
 	l = &eh->table[exception_hash(eh, new_e->old_chunk)];
 
@@ -505,7 +505,7 @@ out:
 static int dm_add_exception(void *context, chunk_t old, chunk_t new)
 {
 	struct dm_snapshot *s = context;
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 
 	e = alloc_exception();
 	if (!e)
@@ -917,7 +917,7 @@ static struct bio *put_pending_exception
 
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
@@ -1029,7 +1029,7 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 {
-	struct dm_snap_exception *e = lookup_exception(&s->pending, chunk);
+	struct dm_exception *e = lookup_exception(&s->pending, chunk);
 
 	if (!e)
 		return NULL;
@@ -1075,7 +1075,7 @@ __find_pending_exception(struct dm_snaps
 	return pe;
 }
 
-static void remap_exception(struct dm_snapshot *s, struct dm_snap_exception *e,
+static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
 			    struct bio *bio, chunk_t chunk)
 {
 	bio->bi_bdev = s->store->cow->bdev;
@@ -1089,7 +1089,7 @@ static void remap_exception(struct dm_sn
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			union map_info *map_context)
 {
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 	struct dm_snapshot *s = ti->private;
 	int r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
@@ -1242,7 +1242,7 @@ static int __origin_write(struct list_he
 {
 	int r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
-	struct dm_snap_exception *e;
+	struct dm_exception *e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1515,7 +1515,7 @@ static int __init dm_snapshot_init(void)
 		goto bad2;
 	}
 
-	exception_cache = KMEM_CACHE(dm_snap_exception, 0);
+	exception_cache = KMEM_CACHE(dm_exception, 0);
 	if (!exception_cache) {
 		DMERR("Couldn't create exception cache.");
 		r = -ENOMEM;
