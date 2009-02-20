From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 17] dm-snap-exception-arg-changes.patch
Date: Fri, 20 Feb 2009 17:18:36 -0600
Message-ID: <1235171916.24593.31.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

More changes to allow us to extract the exception table/cache
code from dm-snap.c.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -343,52 +343,76 @@ static void unregister_snapshot(struct d
 	up_write(&_origins_lock);
 }
 
+struct dm_exception_table_internal {
+	struct dm_exception_table table;
+
+	struct dm_exception *(*alloc_exception)(void *context);
+	void *alloc_context;
+
+	void (*free_exception)(struct dm_exception *e, void *context);
+	void *free_context;
+};
+
 /*
  * Implementation of the exception hash tables.
  * The lowest hash_shift bits of the chunk number are ignored, allowing
  * some consecutive chunks to be grouped together.
  */
 static struct dm_exception_table *
-dm_exception_table_create(uint32_t size, unsigned hash_shift)
+dm_exception_table_create(uint32_t size, unsigned hash_shift,
+			  struct dm_exception *(*alloc_exception)(void *),
+			  void *alloc_context,
+			  void (*free_exception)(struct dm_exception *e, void *),
+			  void *free_context)
 {
 	unsigned int i;
 	struct dm_exception_table *et;
+	struct dm_exception_table_internal *eti;
 
-	et = kmalloc(sizeof(*et), GFP_KERNEL);
-	if (!et)
+	eti = kmalloc(sizeof(*eti), GFP_KERNEL);
+	if (!eti)
 		return NULL;
 
+	et = &eti->table;
+
 	et->hash_shift = hash_shift;
 	et->hash_mask = size - 1;
 	et->table = dm_vcalloc(size, sizeof(struct list_head));
 	if (!et->table) {
-		kfree(et);
+		kfree(eti);
 		return NULL;
 	}
 
+	eti->alloc_exception = alloc_exception;
+	eti->alloc_context = alloc_context;
+	eti->free_exception = free_exception;
+	eti->free_context = free_context;
+
 	for (i = 0; i < size; i++)
 		INIT_LIST_HEAD(et->table + i);
 
 	return et;
 }
 
-static void dm_exception_table_destroy(struct dm_exception_table *et,
-				       struct kmem_cache *mem)
+static void dm_exception_table_destroy(struct dm_exception_table *et)
 {
+	int i, size;
 	struct list_head *slot;
 	struct dm_exception *ex, *next;
-	int i, size;
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, table);
 
 	size = et->hash_mask + 1;
 	for (i = 0; i < size; i++) {
 		slot = et->table + i;
 
 		list_for_each_entry_safe (ex, next, slot, hash_list)
-			kmem_cache_free(mem, ex);
+			eti->free_exception(ex, eti->free_context);
 	}
 
 	vfree(et->table);
-	kfree(et);
+	kfree(eti);
 }
 
 static uint32_t exception_hash(struct dm_exception_table *et, chunk_t chunk)
@@ -420,7 +444,25 @@ static struct dm_exception *dm_lookup_ex
 	return NULL;
 }
 
-static struct dm_exception *alloc_completed_exception(void)
+static struct dm_exception *dm_alloc_exception(struct dm_exception_table *et)
+{
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, table);
+
+	return eti->alloc_exception(eti->alloc_context);
+}
+
+static void dm_free_exception(struct dm_exception_table *et,
+			      struct dm_exception *e)
+{
+	struct dm_exception_table_internal *eti;
+
+	eti = container_of(et, struct dm_exception_table_internal, table);
+	return eti->free_exception(e, eti->free_context);
+}
+
+static struct dm_exception *alloc_completed_exception(void *unused)
 {
 	struct dm_exception *e;
 
@@ -431,25 +473,30 @@ static struct dm_exception *alloc_comple
 	return e;
 }
 
-static void free_completed_exception(struct dm_exception *e)
+static void free_completed_exception(struct dm_exception *e, void *unused)
 {
 	kmem_cache_free(exception_cache, e);
 }
 
-static struct dm_snap_pending_exception *alloc_pending_exception(struct dm_snapshot *s)
+static struct dm_exception *alloc_pending_exception(void *context)
 {
+	struct dm_snapshot *s = context;
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
 							     GFP_NOIO);
 
 	atomic_inc(&s->pending_exceptions_count);
 	pe->snap = s;
 
-	return pe;
+	return &pe->e;
 }
 
-static void free_pending_exception(struct dm_snap_pending_exception *pe)
+static void free_pending_exception(struct dm_exception *e, void *unused)
 {
-	struct dm_snapshot *s = pe->snap;
+	struct dm_snap_pending_exception *pe;
+	struct dm_snapshot *s;
+
+	pe = container_of(e, struct dm_snap_pending_exception, e);
+	s = pe->snap;
 
 	mempool_free(pe, s->pending_pool);
 	smp_mb__before_atomic_dec();
@@ -476,7 +523,7 @@ static void dm_insert_exception(struct d
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_completed_exception(new_e);
+			dm_free_exception(eh, new_e);
 			return;
 		}
 
@@ -486,7 +533,7 @@ static void dm_insert_exception(struct d
 			dm_consecutive_chunk_count_inc(e);
 			e->old_chunk--;
 			e->new_chunk--;
-			free_completed_exception(new_e);
+			dm_free_exception(eh, new_e);
 			return;
 		}
 
@@ -507,7 +554,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception();
+	e = dm_alloc_exception(s->complete);
 	if (!e)
 		return -ENOMEM;
 
@@ -554,7 +601,9 @@ static int init_hash_tables(struct dm_sn
 	hash_size = rounddown_pow_of_two(hash_size);
 
 	s->complete = dm_exception_table_create(hash_size,
-						DM_CHUNK_CONSECUTIVE_BITS);
+						DM_CHUNK_CONSECUTIVE_BITS,
+						alloc_completed_exception, NULL,
+						free_completed_exception, NULL);
 	if (!s->complete)
 		return -ENOMEM;
 
@@ -566,9 +615,11 @@ static int init_hash_tables(struct dm_sn
 	if (hash_size < 64)
 		hash_size = 64;
 
-	s->pending = dm_exception_table_create(hash_size, 0);
+	s->pending = dm_exception_table_create(hash_size, 0,
+					       alloc_pending_exception, s,
+					       free_pending_exception, NULL);
 	if (!s->pending) {
-		dm_exception_table_destroy(s->complete, exception_cache);
+		dm_exception_table_destroy(s->complete);
 		return -ENOMEM;
 	}
 
@@ -760,8 +811,8 @@ bad_pending_pool:
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 
 bad_kcopyd:
-	dm_exception_table_destroy(s->pending, pending_cache);
-	dm_exception_table_destroy(s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending);
+	dm_exception_table_destroy(s->complete);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -780,8 +831,8 @@ static void __free_exceptions(struct dm_
 	dm_kcopyd_client_destroy(s->kcopyd_client);
 	s->kcopyd_client = NULL;
 
-	dm_exception_table_destroy(s->pending, pending_cache);
-	dm_exception_table_destroy(s->complete, exception_cache);
+	dm_exception_table_destroy(s->pending);
+	dm_exception_table_destroy(s->complete);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -905,7 +956,7 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe);
+		dm_free_exception(pe->snap->pending, &pe->e);
 	}
 
 	/*
@@ -913,7 +964,7 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe);
+		dm_free_exception(pe->snap->pending, &pe->e);
 
 	return origin_bios;
 }
@@ -934,7 +985,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_completed_exception();
+	e = dm_alloc_exception(s->complete);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -945,7 +996,7 @@ static void pending_complete(struct dm_s
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_completed_exception(e);
+		dm_free_exception(s->complete, e);
 		error = 1;
 		goto out;
 	}
@@ -1040,7 +1091,7 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 {
-	struct dm_exception *e;
+	struct dm_exception *e, *tmp_e;
 	struct dm_snap_pending_exception *pe;
 	chunk_t chunk = sector_to_chunk(s->store, bio->bi_sector);
 
@@ -1059,17 +1110,18 @@ __find_pending_exception(struct dm_snaps
 	 * to hold the lock while we do this.
 	 */
 	up_write(&s->lock);
-	pe = alloc_pending_exception(s);
+	tmp_e = dm_alloc_exception(s->pending);
+	pe = container_of(tmp_e, struct dm_snap_pending_exception, e);
 	down_write(&s->lock);
 
 	if (!s->valid) {
-		free_pending_exception(pe);
+		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
 
 	e = dm_lookup_exception(s->pending, chunk);
 	if (e) {
-		free_pending_exception(pe);
+		dm_free_exception(s->pending, &pe->e);
 		pe = container_of(e, struct dm_snap_pending_exception, e);
 		goto out;
 	}
@@ -1082,7 +1134,7 @@ __find_pending_exception(struct dm_snaps
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(pe);
+		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
 
@@ -1324,7 +1376,7 @@ static int __origin_write(struct list_he
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
+		dm_free_exception(snap->pending, &primary_pe->e);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
