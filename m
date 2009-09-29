From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 15/18]
	dm-exception-store-create-local-exception-caches
Date: Tue, 29 Sep 2009 18:53:40 -0400
Message-ID: <1254264823-11538-16-git-send-email-snitzer@redhat.com>
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

This patch puts the cache for the completed exceptions into the
exception store implementations.  This will allow us to remove
the exception cache from dm-snap.c giving flexibility to the
exception store implementations and providing a cleaner lookup
interface in up-coming patches.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap-persistent.c |   87 ++++++++++++++++++++++++++++++++++++++-
 drivers/md/dm-snap-transient.c  |   51 ++++++++++++++++++++++-
 2 files changed, 136 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index d181957..03b1b6e 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -89,6 +89,7 @@ struct commit_callback {
  */
 struct pstore {
 	struct dm_exception_store *store;
+	struct dm_exception_table *table;
 	int version;
 	int valid;
 	uint32_t exceptions_per_area;
@@ -137,6 +138,24 @@ struct pstore {
 	struct workqueue_struct *metadata_wq;
 };
 
+static struct kmem_cache *exception_cache;
+
+static struct dm_exception *alloc_exception(void *unused)
+{
+	struct dm_exception *e;
+
+	e = kmem_cache_alloc(exception_cache, GFP_NOIO);
+	if (!e)
+		e = kmem_cache_alloc(exception_cache, GFP_ATOMIC);
+
+	return e;
+}
+
+static void free_exception(struct dm_exception *e, void *unused)
+{
+	kmem_cache_free(exception_cache, e);
+}
+
 static unsigned sectors_to_pages(unsigned sectors)
 {
 	return DIV_ROUND_UP(sectors, PAGE_SIZE >> 9);
@@ -408,6 +427,22 @@ static void write_exception(struct pstore *ps,
 	e->new_chunk = cpu_to_le64(de->new_chunk);
 }
 
+static int add_exception(struct pstore *ps, chunk_t old, chunk_t new)
+{
+	struct dm_exception *e;
+
+	e = dm_alloc_exception(ps->table);
+	if (!e)
+		return -ENOMEM;
+
+	e->old_chunk = old;
+	e->new_chunk = new;
+
+	dm_insert_exception(ps->table, e);
+
+	return 0;
+}
+
 /*
  * Registers the exceptions that are present in the current area.
  * 'full' is filled in to indicate if the area has been
@@ -448,7 +483,16 @@ static int insert_exceptions(struct pstore *ps,
 			ps->next_free = de.new_chunk + 1;
 
 		/*
-		 * Otherwise we add the exception to the snapshot.
+		 * Add the exception to our local cache
+		 */
+		r = add_exception(ps, de.old_chunk, de.new_chunk);
+		if (r)
+			return r;
+
+		/*
+		 * Redundant until a follow-up patch pulls this out
+		 * (We leave this in for this patch to maintain working
+		 * version between patches.)
 		 */
 		r = callback(callback_context, de.old_chunk, de.new_chunk);
 		if (r)
@@ -511,6 +555,7 @@ static void persistent_dtr(struct dm_exception_store *store)
 	if (ps->callbacks)
 		vfree(ps->callbacks);
 
+	dm_exception_table_destroy(ps->table);
 	kfree(ps);
 }
 
@@ -621,6 +666,15 @@ static void persistent_commit_exception(struct dm_exception_store *store,
 	write_exception(ps, ps->current_committed++, &de);
 
 	/*
+	 * We are safe to add the exception to our cache before we
+	 * issue the callbacks.  If we fail to allocate the memory
+	 * to put it in the cache though, the callbacks will have to
+	 * report the failure.
+	 */
+	if (add_exception(ps, de.old_chunk, de.new_chunk))
+		ps->valid = 0;
+
+	/*
 	 * Add the callback to the back of the array.  This code
 	 * is the only place where the callback array is
 	 * manipulated, and we know that it will never be called
@@ -681,6 +735,7 @@ static int persistent_ctr(struct dm_exception_store *store,
 			  unsigned argc, char **argv)
 {
 	struct pstore *ps;
+	sector_t hash_size, cow_dev_size, max_buckets;
 
 	/* allocate the pstore */
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
@@ -700,8 +755,26 @@ static int persistent_ctr(struct dm_exception_store *store,
 	atomic_set(&ps->pending_count, 0);
 	ps->callbacks = NULL;
 
+	cow_dev_size = get_dev_size(store->cow->bdev);
+	max_buckets = (2 * 1024 * 1024)/sizeof(struct list_head);
+
+	hash_size = cow_dev_size >> store->chunk_shift;
+	hash_size = min(hash_size, max_buckets);
+
+	hash_size = rounddown_pow_of_two(hash_size);
+
+	ps->table = dm_exception_table_create(hash_size,
+					      DM_CHUNK_CONSECUTIVE_BITS,
+					      alloc_exception, NULL,
+					      free_exception, NULL);
+	if (!ps->table) {
+		kfree(ps);
+		return -ENOMEM;
+	}
+
 	ps->metadata_wq = create_singlethread_workqueue("ksnaphd");
 	if (!ps->metadata_wq) {
+		dm_exception_table_destroy(ps->table);
 		kfree(ps);
 		DMERR("couldn't start header metadata update thread");
 		return -ENOMEM;
@@ -764,9 +837,19 @@ int dm_persistent_snapshot_init(void)
 {
 	int r;
 
+	exception_cache = kmem_cache_create("persistent_exception_cache",
+					    sizeof(struct dm_exception),
+					    __alignof__(struct dm_exception),
+					    0, NULL);
+	if (!exception_cache) {
+		DMERR("Couldn't create persistent exception cache.");
+		return -ENOMEM;
+	}
+
 	r = dm_exception_store_type_register(&_persistent_type);
 	if (r) {
 		DMERR("Unable to register persistent exception store type");
+		kmem_cache_destroy(exception_cache);
 		return r;
 	}
 
@@ -775,6 +858,7 @@ int dm_persistent_snapshot_init(void)
 		DMERR("Unable to register old-style persistent exception "
 		      "store type");
 		dm_exception_store_type_unregister(&_persistent_type);
+		kmem_cache_destroy(exception_cache);
 		return r;
 	}
 
@@ -785,4 +869,5 @@ void dm_persistent_snapshot_exit(void)
 {
 	dm_exception_store_type_unregister(&_persistent_type);
 	dm_exception_store_type_unregister(&_persistent_compat_type);
+	kmem_cache_destroy(exception_cache);
 }
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index f2ec79c..d499083 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -19,12 +19,29 @@
  * Implementation of the store for non-persistent snapshots.
  *---------------------------------------------------------------*/
 struct transient_c {
+	struct dm_exception_table *table;
+
 	sector_t next_free;
 };
 
+/* Could use better allocation policies - like in dm-snap-persistent.c */
+static struct dm_exception *alloc_exception(void *unused)
+{
+	return kmalloc(sizeof(struct dm_exception), GFP_KERNEL);
+}
+
+static void free_exception(struct dm_exception *e, void *unused)
+{
+	kfree(e);
+}
+
 static void transient_dtr(struct dm_exception_store *store)
 {
-	kfree(store->context);
+	struct transient_c *tc = store->context;
+
+	dm_exception_table_destroy(tc->table);
+
+	kfree(tc);
 }
 
 static int transient_read_metadata(struct dm_exception_store *store,
@@ -55,6 +72,20 @@ static void transient_commit_exception(struct dm_exception_store *store,
 				       void (*callback) (void *, int success),
 				       void *callback_context)
 {
+	struct transient_c *tc = store->context;
+	struct dm_exception *new;
+
+	new = dm_alloc_exception(tc->table);
+	if (!new) {
+		callback(callback_context, 0);
+		return;
+	}
+
+	new->old_chunk = e->old_chunk;
+	new->new_chunk = e->new_chunk;
+
+	dm_insert_exception(tc->table, new);
+
 	/* Just succeed */
 	callback(callback_context, 1);
 }
@@ -70,6 +101,7 @@ static int transient_ctr(struct dm_exception_store *store,
 			 unsigned argc, char **argv)
 {
 	struct transient_c *tc;
+	sector_t hash_size, cow_dev_size, max_buckets;
 
 	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
 	if (!tc)
@@ -78,6 +110,23 @@ static int transient_ctr(struct dm_exception_store *store,
 	tc->next_free = 0;
 	store->context = tc;
 
+	cow_dev_size = get_dev_size(store->cow->bdev);
+	max_buckets = (2 * 1024 * 1024)/sizeof(struct list_head);
+
+	hash_size = cow_dev_size >> store->chunk_shift;
+	hash_size = min(hash_size, max_buckets);
+
+	hash_size = rounddown_pow_of_two(hash_size);
+
+	tc->table = dm_exception_table_create(hash_size,
+					      DM_CHUNK_CONSECUTIVE_BITS,
+					      alloc_exception, NULL,
+					      free_exception, NULL);
+	if (!tc->table) {
+		kfree(tc);
+		return -ENOMEM;
+	}
+
 	return 0;
 }
 
-- 
1.6.2.5
