From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 8 of 33] DM Snapshot: use allocated exception
	tables
Date: Mon, 6 Apr 2009 16:33:47 -0500
Message-ID: <200904062133.n36LXlbq020284@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-use-allocated-exception-tables.patch

Change to using exception table pointers vs. just using the
whole struct from within 'stuct dm_snapshot'.  Again, this is
to facilitate extraction of the exception table/cache code from
dm-snap.c.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -75,8 +75,8 @@ struct dm_snapshot {
 
 	atomic_t pending_exceptions_count;
 
-	struct dm_exception_table pending;
-	struct dm_exception_table complete;
+	struct dm_exception_table *pending;
+	struct dm_exception_table *complete;
 
 	/*
 	 * pe_lock protects all pending_exception operations and access
@@ -348,25 +348,32 @@ static void unregister_snapshot(struct d
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
-static int dm_exception_table_init(struct dm_exception_table *et,
-				   uint32_t size, unsigned hash_shift)
+static struct dm_exception_table *
+dm_exception_table_create(uint32_t size, unsigned hash_shift)
 {
 	unsigned int i;
+	struct dm_exception_table *et;
+
+	et = kmalloc(sizeof(*et), GFP_KERNEL);
+	if (!et)
+		return NULL;
 
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
 	et->table = dm_vcalloc(size, sizeof(struct list_head));
-	if (!et->table)
-		return -ENOMEM;
+	if (!et->table) {
+		kfree(et);
+		return NULL;
+	}
 
 	for (i = 0; i < size; i++)
 		INIT_LIST_HEAD(et->table + i);
 
-	return 0;
+	return et;
 }
 
-static void dm_exception_table_exit(struct dm_exception_table *et,
-				    struct kmem_cache *mem)
+static void dm_exception_table_destroy(struct dm_exception_table *et,
+				       struct kmem_cache *mem)
 {
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
@@ -381,6 +388,7 @@ static void dm_exception_table_exit(stru
 	}
 
 	vfree(et->table);
+	kfree(et);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
@@ -508,7 +516,7 @@ static int dm_add_exception(void *contex
 	/* Consecutive_count is implicitly initialised to zero */
 	e->new_chunk = new;
 
-	dm_insert_exception(&s->complete, e);
+	dm_insert_exception(s->complete, e);
 
 	return 0;
 }
@@ -544,8 +552,10 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
-	if (dm_exception_table_init(&s->complete, hash_size,
-				    DM_CHUNK_CONSECUTIVE_BITS))
+
+	s->complete = dm_exception_table_create(hash_size,
+						DM_CHUNK_CONSECUTIVE_BITS);
+	if (!s->complete)
 		return -ENOMEM;
 
 	/*
@@ -556,8 +566,9 @@ static int init_hash_tables(struct dm_sn
 	if (hash_size < 64)
 		hash_size = 64;
 
-	if (dm_exception_table_init(&s->pending, hash_size, 0)) {
-		dm_exception_table_exit(&s->complete, exception_cache);
+	s->pending = dm_exception_table_create(hash_size, 0);
+	if (!s->pending) {
+		dm_exception_table_destroy(s->complete, exception_cache);
 		return -ENOMEM;
 	}
 
@@ -749,8 +760,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	dm_exception_table_exit(&s->pending, pending_cache);
-	dm_exception_table_exit(&s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending, pending_cache);
+	dm_exception_table_destroy(s->complete, exception_cache);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -769,8 +780,8 @@ static void __free_exceptions(struct dm_
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	dm_exception_table_exit(&s->pending, pending_cache);
-	dm_exception_table_exit(&s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending, pending_cache);
+	dm_exception_table_destroy(s->complete, exception_cache);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -950,7 +961,7 @@ static void pending_complete(struct dm_s
 	 * Add a proper exception, and remove the
 	 * in-flight exception from the list.
 	 */
-	dm_insert_exception(&s->complete, e);
+	dm_insert_exception(s->complete, e);
 
 out:
 	dm_remove_exception(&pe->e);
@@ -1021,7 +1032,7 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
 {
-	struct dm_exception *e = dm_lookup_exception(&s->pending, chunk);
+	struct dm_exception *e = dm_lookup_exception(s->pending, chunk);
 
 	if (!e)
 		return NULL;
@@ -1062,7 +1073,7 @@ __find_pending_exception(struct dm_snaps
 	}
 
 	get_pending_exception(pe);
-	dm_insert_exception(&s->pending, &pe->e);
+	dm_insert_exception(s->pending, &pe->e);
 
 	return pe;
 }
@@ -1104,7 +1115,7 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = dm_lookup_exception(&s->complete, chunk);
+	e = dm_lookup_exception(s->complete, chunk);
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1266,7 +1277,7 @@ static int __origin_write(struct list_he
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = dm_lookup_exception(&snap->complete, chunk);
+		e = dm_lookup_exception(snap->complete, chunk);
 		if (e)
 			goto next_snapshot;
 
