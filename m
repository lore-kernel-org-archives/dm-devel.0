From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 4 of 29] dm-snap-rename-exception-functions.patch
Date: Tue, 17 Mar 2009 09:02:51 -0500
Message-ID: <200903171402.n2HE2pRI017352@hydrogen.msp.redhat.com>
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

Rename exception functions.  Preparing to pull them out of
dm-snap.c for broader use.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -348,8 +348,8 @@ static void unregister_snapshot(struct d
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
-static int init_exception_table(struct dm_exception_table *et, uint32_t size,
-				unsigned hash_shift)
+static int dm_exception_table_init(struct dm_exception_table *et,
+				   uint32_t size, unsigned hash_shift)
 {
 	unsigned int i;
 
@@ -365,8 +365,8 @@ static int init_exception_table(struct d
 	return 0;
 }
 
-static void exit_exception_table(struct dm_exception_table *et,
-				 struct kmem_cache *mem)
+static void dm_exception_table_exit(struct dm_exception_table *et,
+				    struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
@@ -388,7 +388,7 @@ static uint32_t exception_hash(struct dm
 	return (chunk >> et->hash_shift) & et->hash_mask;
 }
 
-static void remove_exception(struct dm_exception *e)
+static void dm_remove_exception(struct dm_exception *e)
 {
 	list_del(&e->hash_list);
 }
@@ -397,8 +397,8 @@ static void remove_exception(struct dm_e
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
@@ -412,7 +412,7 @@ static struct dm_exception *lookup_excep
 	return NULL;
 }
 
-static struct dm_exception *alloc_exception(void)
+static struct dm_exception *alloc_completed_exception(void)
 {
 	struct dm_exception *e;
 
@@ -423,7 +423,7 @@ static struct dm_exception *alloc_except
 	return e;
 }
 
-static void free_exception(struct dm_exception *e)
+static void free_completed_exception(struct dm_exception *e)
 {
 	kmem_cache_free(exception_cache, e);
 }
@@ -448,8 +448,8 @@ static void free_pending_exception(struc
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-static void insert_exception(struct dm_exception_table *eh,
-			     struct dm_exception *new_e)
+static void dm_insert_exception(struct dm_exception_table *eh,
+				struct dm_exception *new_e)
 {
 	struct list_head *l;
 	struct dm_exception *e = NULL;
@@ -468,7 +468,7 @@ static void insert_exception(struct dm_e
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_exception(new_e);
+			free_completed_exception(new_e);
 			return;
 		}
 
@@ -478,7 +478,7 @@ static void insert_exception(struct dm_e
 			dm_consecutive_chunk_count_inc(e);
 			e->old_chunk--;
 			e->new_chunk--;
-			free_exception(new_e);
+			free_completed_exception(new_e);
 			return;
 		}
 
@@ -499,7 +499,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_exception();
+	e = alloc_completed_exception();
 	if (!e)
 		return -ENOMEM;
 
@@ -508,7 +508,7 @@ static int dm_add_exception(void *contex
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	insert_exception(&s->complete, e);
+	dm_insert_exception(&s->complete, e);
 
 	return 0;
 }
@@ -544,8 +544,8 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
-	if (init_exception_table(&s->complete, hash_size,
-				 DM_CHUNK_CONSECUTIVE_BITS))
+	if (dm_exception_table_init(&s->complete, hash_size,
+				    DM_CHUNK_CONSECUTIVE_BITS))
 		return -ENOMEM;
 
 	/*
@@ -556,8 +556,8 @@ static int init_hash_tables(struct dm_sn
 	if (hash_size < 64)
 		hash_size = 64;
 
-	if (init_exception_table(&s->pending, hash_size, 0)) {
-		exit_exception_table(&s->complete, exception_cache);
+	if (dm_exception_table_init(&s->pending, hash_size, 0)) {
+		dm_exception_table_exit(&s->complete, exception_cache);
 		return -ENOMEM;
 	}
 
@@ -749,8 +749,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	exit_exception_table(&s->pending, pending_cache);
-	exit_exception_table(&s->complete, exception_cache);
+	dm_exception_table_exit(&s->pending, pending_cache);
+	dm_exception_table_exit(&s->complete, exception_cache);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -769,8 +769,8 @@ static void __free_exceptions(struct dm_
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	exit_exception_table(&s->pending, pending_cache);
-	exit_exception_table(&s->complete, exception_cache);
+	dm_exception_table_exit(&s->pending, pending_cache);
+	dm_exception_table_exit(&s->complete, exception_cache);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -923,7 +923,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_exception();
+	e = alloc_completed_exception();
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -934,7 +934,7 @@ static void pending_complete(struct dm_s
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_exception(e);
+		free_completed_exception(e);
 		error = 1;
 		goto out;
 	}
@@ -950,10 +950,10 @@ static void pending_complete(struct dm_s
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
 
@@ -1036,7 +1036,7 @@ __find_pending_exception(struct dm_snaps
 	/*
 	 * Is there a pending exception for this already ?
 	 */
-	e = lookup_exception(&s->pending, chunk);
+	e = dm_lookup_exception(&s->pending, chunk);
 	if (e) {
 		/* cast the exception to a pending exception */
 		pe = container_of(e, struct dm_snap_pending_exception, e);
@@ -1056,7 +1056,7 @@ __find_pending_exception(struct dm_snaps
 		return NULL;
 	}
 
-	e = lookup_exception(&s->pending, chunk);
+	e = dm_lookup_exception(&s->pending, chunk);
 	if (e) {
 		free_pending_exception(pe);
 		pe = container_of(e, struct dm_snap_pending_exception, e);
@@ -1076,7 +1076,7 @@ __find_pending_exception(struct dm_snaps
 	}
 
 	get_pending_exception(pe);
-	insert_exception(&s->pending, &pe->e);
+	dm_insert_exception(&s->pending, &pe->e);
 
 out:
 	return pe;
@@ -1119,7 +1119,7 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = lookup_exception(&s->complete, chunk);
+	e = dm_lookup_exception(&s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1261,7 +1261,7 @@ static int __origin_write(struct list_he
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = lookup_exception(&snap->complete, chunk);
+		e = dm_lookup_exception(&snap->complete, chunk);
 		if (e)
 			goto next_snapshot;
 
