From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 33] DM Snapshot: rename exception functions
Date: Fri, 1 May 2009 09:17:32 -0500
Message-ID: <200905011417.n41EHWvv028985@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-rename-exception-functions.patch

Rename exception functions.  Preparing to pull them out of
dm-snap.c for broader use.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -347,8 +347,8 @@ static void unregister_snapshot(struct d
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
-static int init_exception_table(struct dm_exception_table *et, uint32_t size,
-				unsigned hash_shift)
+static int dm_exception_table_init(struct dm_exception_table *et,
+				   uint32_t size, unsigned hash_shift)
 {
 	unsigned int i;
 
@@ -364,8 +364,8 @@ static int init_exception_table(struct d
 	return 0;
 }
 
-static void exit_exception_table(struct dm_exception_table *et,
-				 struct kmem_cache *mem)
+static void dm_exception_table_exit(struct dm_exception_table *et,
+				    struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
@@ -387,7 +387,7 @@ static uint32_t exception_hash(struct dm
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
 
-static void remove_exception(struct dm_exception *e)
+static void dm_remove_exception(struct dm_exception *e)
 {
 	list_del(&e->hash_list);
 }
@@ -396,8 +396,8 @@ static void remove_exception(struct dm_e
  * Return the exception data for a sector, or NULL if not
  * remapped.
  */
-static struct dm_exception *lookup_exception(struct dm_exception_table *et,
-						  chunk_t chunk)
+static struct dm_exception *dm_lookup_exception(struct dm_exception_table *et,
+						chunk_t chunk)
 {
 	struct list_head *slot;
 	struct dm_exception *e;
@@ -411,7 +411,7 @@ static struct dm_exception *lookup_excep
 	return NULL;
 }
 
-static struct dm_exception *alloc_exception(void)
+static struct dm_exception *alloc_completed_exception(void)
 {
 	struct dm_exception *e;
 
@@ -422,7 +422,7 @@ static struct dm_exception *alloc_except
 	return e;
 }
 
-static void free_exception(struct dm_exception *e)
+static void free_completed_exception(struct dm_exception *e)
 {
 	kmem_cache_free(exception_cache, e);
 }
@@ -447,8 +447,8 @@ static void free_pending_exception(struc
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-static void insert_exception(struct dm_exception_table *eh,
-			     struct dm_exception *new_e)
+static void dm_insert_exception(struct dm_exception_table *eh,
+				struct dm_exception *new_e)
 {
 	struct list_head *l;
 	struct dm_exception *e = NULL;
@@ -467,7 +467,7 @@ static void insert_exception(struct dm_e
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_exception(new_e);
+			free_completed_exception(new_e);
 			return;
 		}
 
@@ -477,7 +477,7 @@ static void insert_exception(struct dm_e
 			dm_consecutive_chunk_count_inc(e);
 			e->old_chunk--;
 			e->new_chunk--;
-			free_exception(new_e);
+			free_completed_exception(new_e);
 			return;
 		}
 
@@ -498,7 +498,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_exception();
+	e = alloc_completed_exception();
 	if (!e)
 		return -ENOMEM;
 
@@ -507,7 +507,7 @@ static int dm_add_exception(void *contex
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	insert_exception(&s->complete, e);
+	dm_insert_exception(&s->complete, e);
 
 	return 0;
 }
@@ -543,8 +543,8 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
-	if (init_exception_table(&s->complete, hash_size,
-				 DM_CHUNK_CONSECUTIVE_BITS))
+	if (dm_exception_table_init(&s->complete, hash_size,
+				    DM_CHUNK_CONSECUTIVE_BITS))
 		return -ENOMEM;
 
 	/*
@@ -555,8 +555,8 @@ static int init_hash_tables(struct dm_sn
 	if (hash_size < 64)
 		hash_size = 64;
 
-	if (init_exception_table(&s->pending, hash_size, 0)) {
-		exit_exception_table(&s->complete, exception_cache);
+	if (dm_exception_table_init(&s->pending, hash_size, 0)) {
+		dm_exception_table_exit(&s->complete, exception_cache);
 		return -ENOMEM;
 	}
 
@@ -748,8 +748,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	exit_exception_table(&s->pending, pending_cache);
-	exit_exception_table(&s->complete, exception_cache);
+	dm_exception_table_exit(&s->pending, pending_cache);
+	dm_exception_table_exit(&s->complete, exception_cache);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -768,8 +768,8 @@ static void __free_exceptions(struct dm_
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	exit_exception_table(&s->pending, pending_cache);
-	exit_exception_table(&s->complete, exception_cache);
+	dm_exception_table_exit(&s->pending, pending_cache);
+	dm_exception_table_exit(&s->complete, exception_cache);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -922,7 +922,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_exception();
+	e = alloc_completed_exception();
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -933,7 +933,7 @@ static void pending_complete(struct dm_s
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_exception(e);
+		free_completed_exception(e);
 		error = 1;
 		goto out;
 	}
@@ -949,10 +949,10 @@ static void pending_complete(struct dm_s
 	 * Add a proper exception, and remove the
 	 * in-flight exception from the list.
 	 */
-	insert_exception(&s->complete, e);
+	dm_insert_exception(&s->complete, e);
 
 out:
-	remove_exception(&pe->e);
+	dm_remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = put_pending_exception(pe);
 
@@ -1020,7 +1020,7 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 {
-	struct dm_exception *e = lookup_exception(&s->pending, chunk);
+	struct dm_exception *e = dm_lookup_exception(&s->pending, chunk);
 
 	if (!e)
 		return NULL;
@@ -1061,7 +1061,7 @@ __find_pending_exception(struct dm_snaps
 	}
 
 	get_pending_exception(pe);
-	insert_exception(&s->pending, &pe->e);
+	dm_insert_exception(&s->pending, &pe->e);
 
 	return pe;
 }
@@ -1103,7 +1103,7 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = lookup_exception(&s->complete, chunk);
+	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1127,7 +1127,7 @@ static int snapshot_map(struct dm_target
 				goto out_unlock;
 			}
 
-			e = lookup_exception(&s->complete, chunk);
+			e = dm_lookup_exception(&s->complete, chunk);
 			if (e) {
 				free_pending_exception(pe);
 				remap_exception(s, e, bio, chunk);
@@ -1265,7 +1265,7 @@ static int __origin_write(struct list_he
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = lookup_exception(&snap->complete, chunk);
+		e = dm_lookup_exception(&snap->complete, chunk);
 		if (e)
 			goto next_snapshot;
 
@@ -1280,7 +1280,7 @@ static int __origin_write(struct list_he
 				goto next_snapshot;
 			}
 
-			e = lookup_exception(&snap->complete, chunk);
+			e = dm_lookup_exception(&snap->complete, chunk);
 			if (e) {
 				free_pending_exception(pe);
 				goto next_snapshot;
