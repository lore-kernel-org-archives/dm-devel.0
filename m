From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 12 of 17]
	dm-snap-remove-completed-exception-cache.patch
Date: Fri, 20 Feb 2009 17:27:15 -0600
Message-ID: <1235172435.24593.42.camel@hydrogen.msp.redhat.com>
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

No need for snapshots to keep track of completed exceptions
anymore, since the exception store implementations can do
that (better) now.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -70,7 +70,6 @@ struct dm_snapshot {
 	atomic_t pending_exceptions_count;
 
 	struct dm_exception_table *pending;
-	struct dm_exception_table *complete;
 
 	/*
 	 * pe_lock protects all pending_exception operations and access
@@ -157,7 +156,6 @@ struct dm_snap_pending_exception {
  * Hash table mapping origin volumes to lists of snapshots and
  * a lock to protect it
  */
-static struct kmem_cache *exception_cache;
 static struct kmem_cache *pending_cache;
 
 struct dm_snap_tracked_chunk {
@@ -337,22 +335,6 @@ static void unregister_snapshot(struct d
 	up_write(&_origins_lock);
 }
 
-static struct dm_exception *alloc_completed_exception(void *unused)
-{
-	struct dm_exception *e;
-
-	e = kmem_cache_alloc(exception_cache, GFP_NOIO);
-	if (!e)
-		e = kmem_cache_alloc(exception_cache, GFP_ATOMIC);
-
-	return e;
-}
-
-static void free_completed_exception(struct dm_exception *e, void *unused)
-{
-	kmem_cache_free(exception_cache, e);
-}
-
 static struct dm_exception *alloc_pending_exception(void *context)
 {
 	struct dm_snapshot *s = context;
@@ -379,29 +361,6 @@ static void free_pending_exception(struc
 }
 
 /*
- * Callback used by the exception stores to load exceptions when
- * initialising.
- */
-static int dm_add_exception(void *context, chunk_t old, chunk_t new)
-{
-	struct dm_snapshot *s = context;
-	struct dm_exception *e;
-
-	e = dm_alloc_exception(s->complete);
-	if (!e)
-		return -ENOMEM;
-
-	e->old_chunk = old;
-
-	/* Consecutive_count is implicitly initialised to zero */
-	e->new_chunk = new;
-
-	dm_insert_exception(s->complete, e);
-
-	return 0;
-}
-
-/*
  * Hard coded magic.
  */
 static int calc_max_buckets(void)
@@ -432,18 +391,6 @@ static int init_hash_tables(struct dm_sn
 	hash_size = min(hash_size, max_buckets);
 
 	hash_size = rounddown_pow_of_two(hash_size);
-
-	s->complete = dm_exception_table_create(hash_size,
-						DM_CHUNK_CONSECUTIVE_BITS,
-						alloc_completed_exception, NULL,
-						free_completed_exception, NULL);
-	if (!s->complete)
-		return -ENOMEM;
-
-	/*
-	 * Allocate hash table for in-flight exceptions
-	 * Make this smaller than the real hash table
-	 */
 	hash_size >>= 3;
 	if (hash_size < 64)
 		hash_size = 64;
@@ -451,10 +398,8 @@ static int init_hash_tables(struct dm_sn
 	s->pending = dm_exception_table_create(hash_size, 0,
 					       alloc_pending_exception, s,
 					       free_pending_exception, NULL);
-	if (!s->pending) {
-		dm_exception_table_destroy(s->complete);
+	if (!s->pending)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
@@ -606,18 +551,6 @@ static int snapshot_ctr(struct dm_target
 		INIT_HLIST_HEAD(&s->tracked_chunk_hash[i]);
 
 	spin_lock_init(&s->tracked_chunk_lock);
-
-	/* Metadata must only be loaded into one table at once */
-	r = s->store->type->read_metadata(s->store, dm_add_exception,
-					  (void *)s);
-	if (r < 0) {
-		ti->error = "Failed to read snapshot metadata";
-		goto bad_load_and_register;
-	} else if (r > 0) {
-		s->valid = 0;
-		DMWARN("Snapshot is marked invalid.");
-	}
-
 	bio_list_init(&s->queued_bios);
 	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
 
@@ -645,7 +578,6 @@ bad_pending_pool:
 
 bad_kcopyd:
 	dm_exception_table_destroy(s->pending);
-	dm_exception_table_destroy(s->complete);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -665,7 +597,6 @@ static void __free_exceptions(struct dm_
 	s->kcopyd_client = NULL;
 
 	dm_exception_table_destroy(s->pending);
-	dm_exception_table_destroy(s->complete);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -804,7 +735,6 @@ static struct bio *put_pending_exception
 
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
-	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
@@ -818,18 +748,8 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = dm_alloc_exception(s->complete);
-	if (!e) {
-		down_write(&s->lock);
-		__invalidate_snapshot(s, -ENOMEM);
-		error = 1;
-		goto out;
-	}
-	*e = pe->e;
-
 	down_write(&s->lock);
 	if (!s->valid) {
-		dm_free_exception(s->complete, e);
 		error = 1;
 		goto out;
 	}
@@ -841,12 +761,6 @@ static void pending_complete(struct dm_s
 	while (__chunk_is_tracked(s, pe->e.old_chunk))
 		msleep(1);
 
-	/*
-	 * Add a proper exception, and remove the
-	 * in-flight exception from the list.
-	 */
-	dm_insert_exception(s->complete, e);
-
 out:
 	dm_remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
@@ -1408,25 +1322,18 @@ static int __init dm_snapshot_init(void)
 		goto bad2;
 	}
 
-	exception_cache = KMEM_CACHE(dm_exception, 0);
-	if (!exception_cache) {
-		DMERR("Couldn't create exception cache.");
-		r = -ENOMEM;
-		goto bad3;
-	}
-
 	pending_cache = KMEM_CACHE(dm_snap_pending_exception, 0);
 	if (!pending_cache) {
 		DMERR("Couldn't create pending cache.");
 		r = -ENOMEM;
-		goto bad4;
+		goto bad3;
 	}
 
 	tracked_chunk_cache = KMEM_CACHE(dm_snap_tracked_chunk, 0);
 	if (!tracked_chunk_cache) {
 		DMERR("Couldn't create cache to track chunks in use.");
 		r = -ENOMEM;
-		goto bad5;
+		goto bad4;
 	}
 
 	ksnapd = create_singlethread_workqueue("ksnapd");
@@ -1440,10 +1347,8 @@ static int __init dm_snapshot_init(void)
 
 bad_pending_pool:
 	kmem_cache_destroy(tracked_chunk_cache);
-bad5:
-	kmem_cache_destroy(pending_cache);
 bad4:
-	kmem_cache_destroy(exception_cache);
+	kmem_cache_destroy(pending_cache);
 bad3:
 	exit_origin_hash();
 bad2:
@@ -1464,7 +1369,6 @@ static void __exit dm_snapshot_exit(void
 
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
-	kmem_cache_destroy(exception_cache);
 	kmem_cache_destroy(tracked_chunk_cache);
 
 	dm_exception_store_exit();
