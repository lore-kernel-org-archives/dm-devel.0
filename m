From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 17 of 33] DM Exception Store:  add resume to API
Date: Wed, 25 Mar 2009 16:36:25 -0500
Message-ID: <200903252136.n2PLaPWd021798@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-add-resume-to-API.patch

Add 'resume' to exception store API.

This is the first step to replace 'read_metadata' with 'resume'.
'resume' will populate the exception store implementation's
exception cache - rather than loading the snapshot's exception
cache.

Relocating the 'resume' is more in line with the way device-mapper
targets (and device-mapper mirror logs) work.  Additionally, with
future shared exception store types, we don't duplicate the cache.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -31,6 +31,8 @@ struct dm_exception_store_type {
 	 */
 	void (*dtr) (struct dm_exception_store *store);
 
+	int (*resume) (struct dm_exception_store *store);
+
 	/*
 	 * The target shouldn't read the COW device until this is
 	 * called.  As exceptions are read from the COW, they are
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -89,6 +89,7 @@ struct commit_callback {
  */
 struct pstore {
 	struct dm_exception_store *store;
+	struct dm_exception_table *table;
 	int version;
 	int valid;
 	uint32_t exceptions_per_area;
@@ -130,6 +131,24 @@ struct pstore {
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
@@ -282,7 +301,7 @@ static int read_header(struct pstore *ps
 	 */
 	if (!ps->store->chunk_size) {
 		ps->store->chunk_size = max(DM_CHUNK_SIZE_DEFAULT_SECTORS,
-		    bdev_hardsect_size(ps->store->cow->bdev) >> 9);
+					    bdev_hardsect_size(ps->store->cow->bdev) >> 9);
 		ps->store->chunk_mask = ps->store->chunk_size - 1;
 		ps->store->chunk_shift = ffs(ps->store->chunk_size) - 1;
 		chunk_size_supplied = 0;
@@ -495,6 +514,7 @@ static void persistent_dtr(struct dm_exc
 	if (ps->callbacks)
 		vfree(ps->callbacks);
 
+	dm_exception_table_destroy(ps->table);
 	kfree(ps);
 }
 
@@ -506,6 +526,13 @@ static int persistent_read_metadata(stru
 	int r, uninitialized_var(new_snapshot);
 	struct pstore *ps = get_info(store);
 
+	if (ps->callbacks)
+		/*
+		 * Temporary work around for having two different functions
+		 * that get us going... 'read_metadata' and 'resume'.
+		 */
+		goto read_metadata;
+
 	/*
 	 * Read the snapshot header.
 	 */
@@ -517,7 +544,7 @@ static int persistent_read_metadata(stru
 	 * Now we know correct chunk_size, complete the initialisation.
 	 */
 	ps->exceptions_per_area = (ps->store->chunk_size << SECTOR_SHIFT) /
-				  sizeof(struct disk_exception);
+		sizeof(struct disk_exception);
 	ps->callbacks = dm_vcalloc(ps->exceptions_per_area,
 				   sizeof(*ps->callbacks));
 	if (!ps->callbacks)
@@ -558,11 +585,44 @@ static int persistent_read_metadata(stru
 	/*
 	 * Read the metadata.
 	 */
+read_metadata:
 	r = read_exceptions(ps, callback, callback_context);
 
 	return r;
 }
 
+/* This function is temporary for patch cleanliness */
+static int add_exception(void *context, chunk_t old, chunk_t new)
+{
+	struct dm_exception_store *store = context;
+	struct pstore *ps = get_info(store);
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
+/*
+ * persistent_resume
+ * @store
+ *
+ * Read metadata of the disk and store in our exception table cache.
+ *
+ * Returns: 0 on success, -Exxx on error
+ */
+static int persistent_resume(struct dm_exception_store *store)
+{
+	return persistent_read_metadata(store, add_exception, store);
+}
+
 static int persistent_prepare_exception(struct dm_exception_store *store,
 					struct dm_exception *e)
 {
@@ -665,6 +725,7 @@ static int persistent_ctr(struct dm_exce
 			  unsigned argc, char **argv)
 {
 	struct pstore *ps;
+	sector_t hash_size, cow_dev_size, max_buckets;
 
 	/* allocate the pstore */
 	ps = kzalloc(sizeof(*ps), GFP_KERNEL);
@@ -682,8 +743,26 @@ static int persistent_ctr(struct dm_exce
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
@@ -721,6 +800,7 @@ static struct dm_exception_store_type _p
 	.module = THIS_MODULE,
 	.ctr = persistent_ctr,
 	.dtr = persistent_dtr,
+	.resume = persistent_resume,
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
@@ -734,6 +814,7 @@ static struct dm_exception_store_type _p
 	.module = THIS_MODULE,
 	.ctr = persistent_ctr,
 	.dtr = persistent_dtr,
+	.resume = persistent_resume,
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
@@ -746,9 +827,16 @@ int dm_persistent_snapshot_init(void)
 {
 	int r;
 
+	exception_cache = KMEM_CACHE(dm_exception, 0);
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
 
@@ -757,6 +845,7 @@ int dm_persistent_snapshot_init(void)
 		DMERR("Unable to register old-style persistent exception "
 		      "store type");
 		dm_exception_store_type_unregister(&_persistent_type);
+		kmem_cache_destroy(exception_cache);
 		return r;
 	}
 
@@ -767,4 +856,5 @@ void dm_persistent_snapshot_exit(void)
 {
 	dm_exception_store_type_unregister(&_persistent_type);
 	dm_exception_store_type_unregister(&_persistent_compat_type);
+	kmem_cache_destroy(exception_cache);
 }
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
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
@@ -35,6 +52,11 @@ static int transient_read_metadata(struc
 	return 0;
 }
 
+static int transient_resume(struct dm_exception_store *store)
+{
+	return 0;
+}
+
 static int transient_prepare_exception(struct dm_exception_store *store,
 				       struct dm_exception *e)
 {
@@ -70,6 +92,7 @@ static int transient_ctr(struct dm_excep
 			 unsigned argc, char **argv)
 {
 	struct transient_c *tc;
+	sector_t hash_size, cow_dev_size, max_buckets;
 
 	tc = kmalloc(sizeof(struct transient_c), GFP_KERNEL);
 	if (!tc)
@@ -78,6 +101,23 @@ static int transient_ctr(struct dm_excep
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
 
@@ -108,6 +148,7 @@ static struct dm_exception_store_type _t
 	.module = THIS_MODULE,
 	.ctr = transient_ctr,
 	.dtr = transient_dtr,
+	.resume = transient_resume,
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
@@ -120,6 +161,7 @@ static struct dm_exception_store_type _t
 	.module = THIS_MODULE,
 	.ctr = transient_ctr,
 	.dtr = transient_dtr,
+	.resume = transient_resume,
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -1078,10 +1078,22 @@ static int snapshot_end_io(struct dm_tar
 
 static void snapshot_resume(struct dm_target *ti)
 {
+	int r;
 	struct dm_snapshot *s = ti->private;
 
+	/*
+	 * Target resumes cannot fail, which leaves us in a tight spot.
+	 * We read the exception store, the snapshot may be invalid
+	 * or we may have failed to resume for a different reason (EIO?).
+	 * If invalid, mark the snapshot as such.  However, if other,
+	 * what can we do?  Mark 'not active'?
+	 */
+	r = s->store->type->resume(s->store);
+	if (r == -EINVAL)
+		r = s->valid = 0;
+
 	down_write(&s->lock);
-	s->active = 1;
+	s->active = (r) ? 0 : 1;
 	up_write(&s->lock);
 }
 
