From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 17/18]
	dm-snapshot-remove-completed-exception-cache
Date: Tue, 29 Sep 2009 18:53:42 -0400
Message-ID: <1254264823-11538-18-git-send-email-snitzer@redhat.com>
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

No need for snapshots to keep track of completed exceptions
anymore, since the exception store implementations can do
that (better) now.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |    8 +---
 drivers/md/dm-snap-persistent.c |   29 ++----------
 drivers/md/dm-snap-transient.c  |    5 +--
 drivers/md/dm-snap.c            |   95 ++------------------------------------
 4 files changed, 13 insertions(+), 124 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index d3e6a58..f9a54fa 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -33,13 +33,9 @@ struct dm_exception_store_type {
 
 	/*
 	 * The target shouldn't read the COW device until this is
-	 * called.  As exceptions are read from the COW, they are
-	 * reported back via the callback.
+	 * called.
 	 */
-	int (*read_metadata) (struct dm_exception_store *store,
-			      int (*callback)(void *callback_context,
-					      chunk_t old, chunk_t new),
-			      void *callback_context);
+	int (*read_metadata) (struct dm_exception_store *store);
 
 	/*
 	 * Find somewhere to store the next exception.
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index fe05bc8..d920f69 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -448,11 +448,7 @@ static int add_exception(struct pstore *ps, chunk_t old, chunk_t new)
  * 'full' is filled in to indicate if the area has been
  * filled.
  */
-static int insert_exceptions(struct pstore *ps,
-			     int (*callback)(void *callback_context,
-					     chunk_t old, chunk_t new),
-			     void *callback_context,
-			     int *full)
+static int insert_exceptions(struct pstore *ps, int *full)
 {
 	int r;
 	unsigned int i;
@@ -488,24 +484,12 @@ static int insert_exceptions(struct pstore *ps,
 		r = add_exception(ps, de.old_chunk, de.new_chunk);
 		if (r)
 			return r;
-
-		/*
-		 * Redundant until a follow-up patch pulls this out
-		 * (We leave this in for this patch to maintain working
-		 * version between patches.)
-		 */
-		r = callback(callback_context, de.old_chunk, de.new_chunk);
-		if (r)
-			return r;
 	}
 
 	return 0;
 }
 
-static int read_exceptions(struct pstore *ps,
-			   int (*callback)(void *callback_context, chunk_t old,
-					   chunk_t new),
-			   void *callback_context)
+static int read_exceptions(struct pstore *ps)
 {
 	int r, full = 1;
 
@@ -518,7 +502,7 @@ static int read_exceptions(struct pstore *ps,
 		if (r)
 			return r;
 
-		r = insert_exceptions(ps, callback, callback_context, &full);
+		r = insert_exceptions(ps, &full);
 		if (r)
 			return r;
 	}
@@ -559,10 +543,7 @@ static void persistent_dtr(struct dm_exception_store *store)
 	kfree(ps);
 }
 
-static int persistent_read_metadata(struct dm_exception_store *store,
-				    int (*callback)(void *callback_context,
-						    chunk_t old, chunk_t new),
-				    void *callback_context)
+static int persistent_read_metadata(struct dm_exception_store *store)
 {
 	int r, uninitialized_var(new_snapshot);
 	struct pstore *ps = get_info(store);
@@ -619,7 +600,7 @@ static int persistent_read_metadata(struct dm_exception_store *store,
 	/*
 	 * Read the metadata.
 	 */
-	r = read_exceptions(ps, callback, callback_context);
+	r = read_exceptions(ps);
 
 	return r;
 }
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index eabdcc1..e410f9c 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -44,10 +44,7 @@ static void transient_dtr(struct dm_exception_store *store)
 	kfree(tc);
 }
 
-static int transient_read_metadata(struct dm_exception_store *store,
-				   int (*callback)(void *callback_context,
-						   chunk_t old, chunk_t new),
-				   void *callback_context)
+static int transient_read_metadata(struct dm_exception_store *store)
 {
 	return 0;
 }
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index cb92d8f..7f00271 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -69,7 +69,6 @@ struct dm_snapshot {
 	atomic_t pending_exceptions_count;
 
 	struct dm_exception_table *pending;
-	struct dm_exception_table *complete;
 
 	/*
 	 * pe_lock protects all pending_exception operations and access
@@ -156,7 +155,6 @@ struct dm_snap_pending_exception {
  * Hash table mapping origin volumes to lists of snapshots and
  * a lock to protect it
  */
-static struct kmem_cache *exception_cache;
 static struct kmem_cache *pending_cache;
 
 struct dm_snap_tracked_chunk {
@@ -336,22 +334,6 @@ static void unregister_snapshot(struct dm_snapshot *s)
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
@@ -377,29 +359,6 @@ static void free_pending_exception(struct dm_exception *e, void *unused)
 	atomic_dec(&s->pending_exceptions_count);
 }
 
-/*
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
 #define min_not_zero(l, r) (((l) == 0) ? (r) : (((r) == 0) ? (l) : min(l, r)))
 
 /*
@@ -450,18 +409,6 @@ static int init_hash_tables(struct dm_snapshot *s)
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
@@ -469,10 +416,8 @@ static int init_hash_tables(struct dm_snapshot *s)
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
@@ -620,8 +565,7 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	spin_lock_init(&s->tracked_chunk_lock);
 
 	/* Metadata must only be loaded into one table at once */
-	r = s->store->type->read_metadata(s->store, dm_add_exception,
-					  (void *)s);
+	r = s->store->type->read_metadata(s->store);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
 		goto bad_load_and_register;
@@ -663,7 +607,6 @@ bad_pending_pool:
 
 bad_kcopyd:
 	dm_exception_table_destroy(s->pending);
-	dm_exception_table_destroy(s->complete);
 
 bad_hash_tables:
 	dm_put_device(ti, s->origin);
@@ -683,7 +626,6 @@ static void __free_exceptions(struct dm_snapshot *s)
 	s->kcopyd_client = NULL;
 
 	dm_exception_table_destroy(s->pending);
-	dm_exception_table_destroy(s->complete);
 }
 
 static void snapshot_dtr(struct dm_target *ti)
@@ -823,7 +765,6 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
-	struct dm_exception *e;
 	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
@@ -837,18 +778,8 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
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
@@ -860,12 +791,6 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
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
@@ -1461,25 +1386,18 @@ static int __init dm_snapshot_init(void)
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
@@ -1493,10 +1411,8 @@ static int __init dm_snapshot_init(void)
 
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
@@ -1518,7 +1434,6 @@ static void __exit dm_snapshot_exit(void)
 
 	exit_origin_hash();
 	kmem_cache_destroy(pending_cache);
-	kmem_cache_destroy(exception_cache);
 	kmem_cache_destroy(tracked_chunk_cache);
 
 	dm_exception_store_exit();
-- 
1.6.2.5
