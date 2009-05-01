From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 33 of 33] DM Snapshot:  utilize snapshare
Date: Fri, 1 May 2009 09:21:57 -0500
Message-ID: <200905011421.n41ELviu030928@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-utilize-snapshare.patch

This patch finishes the integration of the snapshare structure.  It
removes the exception store from the snapshot struct and relies
on the snapshare and creates the pending exception cache for the
individual snapshots (located in the snapshare structure).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
 
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -50,10 +50,21 @@
 #define DM_TRACKED_CHUNK_HASH(x)	((unsigned long)(x) & \
 					 (DM_TRACKED_CHUNK_HASH_SIZE - 1))
 
+/*
+ * Exception table hash sizes for pending exceptions
+ * The snapshot pending exception table holds pending exceptions
+ * that affect all snapshots in the share group (due to origin write).
+ * The snapshare pending exception table holds pending exceptions
+ * that affect just one snapshot in the share group (due to a
+ * write to one of the snapshots).
+ */
+#define DM_SNAPSHARE_HASH_SIZE 16
+#define DM_SNAPSHOT_HASH_SIZE 64
+
 struct dm_snapshot {
 	struct rw_semaphore lock;
 
-	struct dm_dev *origin;
+	struct block_device *o_bdev;
 
 	/* List of snapshots per Origin */
 	struct list_head list;
@@ -66,19 +77,17 @@ struct dm_snapshot {
 
 	mempool_t *pending_pool;
 
-	atomic_t pending_exceptions_count;
-
 	struct dm_exception_table *pending;
 
+	uint64_t shared_uuid;
+	struct list_head shared_list;
+
 	/*
 	 * pe_lock protects all pending_exception operations and access
 	 * as well as the snapshot_bios list.
 	 */
 	spinlock_t pe_lock;
 
-	/* The on disk metadata handler */
-	struct dm_exception_store *store;
-
 	struct dm_kcopyd_client *kcopyd_client;
 
 	/* Queue of snapshot writes for ksnapd to flush */
@@ -108,6 +117,19 @@ struct dm_snapshare {
 static struct workqueue_struct *ksnapd;
 static void flush_queued_bios(struct work_struct *work);
 
+static struct dm_exception_store *get_first_store(struct dm_snapshot *s)
+{
+	struct dm_snapshare *ss;
+
+	list_for_each_entry(ss, &s->shared_list, shared_list)
+		return ss->store;
+
+	DMERR("No snapshares in snapshot");
+	BUG();
+
+	return NULL;
+}
+
 static sector_t chunk_to_sector(struct dm_exception_store *store,
 				chunk_t chunk)
 {
@@ -155,8 +177,12 @@ struct dm_snap_pending_exception {
 	 */
 	atomic_t ref_count;
 
-	/* Pointer back to snapshot context */
+	/*
+	 * Pointer back to snapshot or snapshare context
+	 * Only one of 'ss' or 'snap' may be populated.
+	 */
 	struct dm_snapshot *snap;
+	struct dm_snapshare *ss;
 
 	/*
 	 * 1 indicates the exception has already been sent to
@@ -298,13 +324,21 @@ static void __insert_origin(struct origi
 }
 
 /*
+ * register_snapshare
+ * @ss: snapshare - initialized and populated with 's'
+ *
  * Make a note of the snapshot and its origin so we can look it
  * up when the origin has a write on it.
+ *
+ * Returns: 0 on success, -Exxx on failure
  */
-static int register_snapshot(struct dm_snapshot *snap)
+static void dealloc_snapshot(struct dm_snapshot *s);
+static int register_snapshare(struct dm_snapshare *ss)
 {
+	int found = 0;
 	struct origin *o, *new_o;
-	struct block_device *bdev = snap->origin->bdev;
+	struct dm_snapshot *s;
+	struct block_device *bdev = ss->origin->bdev;
 
 	new_o = kmalloc(sizeof(*new_o), GFP_KERNEL);
 	if (!new_o)
@@ -326,20 +360,69 @@ static int register_snapshot(struct dm_s
 		__insert_origin(o);
 	}
 
-	list_add_tail(&snap->list, &o->snapshots);
+	if (!ss->snap->shared_uuid)
+		goto new_snapshot;
+
+	list_for_each_entry(s, &o->snapshots, list) {
+		down_write(&s->lock);
+		if (s->shared_uuid == ss->snap->shared_uuid) {
+			list_add(&ss->shared_list, &s->shared_list);
+
+			dealloc_snapshot(ss->snap);
+
+			ss->snap = s;
+
+			up_write(&s->lock);
+			found = 1;
+			break;
+		}
+		up_write(&s->lock);
+	}
+
+new_snapshot:
+	if (!found)
+		list_add_tail(&ss->snap->list, &o->snapshots);
 
 	up_write(&_origins_lock);
 	return 0;
 }
 
-static void unregister_snapshot(struct dm_snapshot *s)
+static void unregister_snapshare(struct dm_snapshare *ss)
 {
 	struct origin *o;
 
+	/*
+	 * Always origin lock, then snapshot lock
+	 */
 	down_write(&_origins_lock);
-	o = __lookup_origin(s->origin->bdev);
+	o = __lookup_origin(ss->origin->bdev);
+
+	down_write(&ss->snap->lock);
+
+	/*
+	 * Remove the snapshare, then if there are no
+	 * more snapshares left, remove the snapshot
+	 * from the origin's list
+	 */
+	list_del(&ss->shared_list);
+
+	if (list_empty(&ss->snap->shared_list)) {
+		/*
+		 * dtr will use 'list_empty' check on this...
+		 * We must use list_del_init
+		 */
+		list_del_init(&ss->snap->list);
+
+		/*
+		 * Since this is the last share, we need to leave
+		 * it in place.  Otherwise, 'get_first_store' will
+		 * fail.
+		 */
+		list_add(&ss->shared_list, &ss->snap->shared_list);
+	}
+
+	up_write(&ss->snap->lock);
 
-	list_del(&s->list);
 	if (list_empty(&o->snapshots)) {
 		list_del(&o->hash_list);
 		kfree(o);
@@ -351,11 +434,14 @@ static void unregister_snapshot(struct d
 static struct dm_exception *alloc_pending_exception(void *context)
 {
 	struct dm_snapshot *s = context;
+	struct dm_snapshare *ss;
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
 							     GFP_NOIO);
 
-	atomic_inc(&s->pending_exceptions_count);
+	list_for_each_entry(ss, &s->shared_list, shared_list)
+		atomic_inc(&ss->pending_exceptions_count);
 	pe->snap = s;
+	pe->ss = NULL;
 
 	return &pe->e;
 }
@@ -364,25 +450,44 @@ static void free_pending_exception(struc
 {
 	struct dm_snap_pending_exception *pe;
 	struct dm_snapshot *s;
+	struct dm_snapshare *ss;
 
 	pe = container_of(e, struct dm_snap_pending_exception, e);
 	s = pe->snap;
 
 	mempool_free(pe, s->pending_pool);
 	smp_mb__before_atomic_dec();
-	atomic_dec(&s->pending_exceptions_count);
+
+	list_for_each_entry(ss, &s->shared_list, shared_list)
+		atomic_dec(&ss->pending_exceptions_count);
 }
 
-/*
- * Hard coded magic.
- */
-static int calc_max_buckets(void)
+static struct dm_exception *alloc_snapshare_pending_exception(void *context)
 {
-	/* use a fixed size of 2MB */
-	unsigned long mem = 2 * 1024 * 1024;
-	mem /= sizeof(struct list_head);
+	struct dm_snapshare *ss = context;
+	struct dm_snap_pending_exception *pe;
+
+	pe = mempool_alloc(ss->snap->pending_pool, GFP_NOIO);
+
+	atomic_inc(&ss->pending_exceptions_count);
+	pe->ss = ss;
+	pe->snap = NULL;
 
-	return mem;
+	return &pe->e;
+}
+
+static void free_snapshare_pending_exception(struct dm_exception *e,
+					     void *unused)
+{
+	struct dm_snap_pending_exception *pe;
+	struct dm_snapshare *ss;
+
+	pe = container_of(e, struct dm_snap_pending_exception, e);
+	ss = pe->ss;
+
+	mempool_free(pe, ss->snap->pending_pool);
+	smp_mb__before_atomic_dec();
+	atomic_dec(&ss->pending_exceptions_count);
 }
 
 /*
@@ -444,7 +549,7 @@ static int create_exception_store(struct
 					 argv + 2, store);
 }
 
-static struct dm_snapshot *alloc_snapshot(sector_t hash_size)
+static struct dm_snapshot *alloc_snapshot(void)
 {
 	int r, i;
 	struct dm_snapshot *s;
@@ -455,14 +560,14 @@ static struct dm_snapshot *alloc_snapsho
 		return NULL;
 	}
 
+	INIT_LIST_HEAD(&s->shared_list);
 	s->valid = 1;
 	s->active = 0;
-	atomic_set(&s->pending_exceptions_count, 0);
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for pending COW data */
-	s->pending = dm_exception_table_create(hash_size, 0,
+	s->pending = dm_exception_table_create(DM_SNAPSHOT_HASH_SIZE, 0,
 					       alloc_pending_exception, s,
 					       free_pending_exception, NULL);
 	if (!s->pending) {
@@ -541,11 +646,8 @@ static void dealloc_snapshot(struct dm_s
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
-	struct dm_dev *origin;
 	struct dm_snapshare *ss;
 	struct dm_snapshot *s;
-	int i;
 	int r = -EINVAL;
 	char *origin_path;
 	struct dm_exception_store *store;
@@ -568,6 +670,14 @@ static int snapshot_ctr(struct dm_target
 	INIT_LIST_HEAD(&ss->shared_list);
 	atomic_set(&ss->pending_exceptions_count, 0);
 
+	ss->pending = dm_exception_table_create(DM_SNAPSHARE_HASH_SIZE, 0,
+						alloc_snapshare_pending_exception, ss,
+						free_snapshare_pending_exception, NULL);
+	if (!ss->pending) {
+		ti->error = "Failed to allocate exception hash table";
+		goto bad_hash_table;
+	}
+
 	r = create_exception_store(ti, argc, argv, &args_used, &store);
 	if (r) {
 		ti->error = "Failed to create snapshot exception store";
@@ -578,44 +688,29 @@ static int snapshot_ctr(struct dm_target
 	argv += args_used;
 	argc -= args_used;
 
-	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &origin);
+	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &ss->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
 		goto bad_origin;
 	}
 
 	/*
-	 * Calculate based on the size of the original volume or
-	 * the COW volume...
-	 */
-	cow_dev_size = get_dev_size(store->cow->bdev);
-	origin_dev_size = get_dev_size(origin->bdev);
-	max_buckets = calc_max_buckets();
-
-	hash_size = min(origin_dev_size, cow_dev_size) >> store->chunk_shift;
-	hash_size = min(hash_size, max_buckets);
-
-	hash_size = rounddown_pow_of_two(hash_size);
-	hash_size >>= 3;
-	if (hash_size < 64)
-		hash_size = 64;
-
-	/*
 	 * Allocate the snapshot
 	 */
-	s = alloc_snapshot(hash_size);
+	s = alloc_snapshot();
 	if (!s) {
 		r = -ENOMEM;
 		ti->error = "Failed to create snapshot structure";
 		goto bad_alloc_snapshot;
 	}
 	ss->snap = s;
-	s->origin = origin;
-	s->store = ss->store;
+	s->o_bdev = ss->origin->bdev;
+	s->shared_uuid = store->shared_uuid;
+	list_add(&ss->shared_list, &s->shared_list);
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
-	if (register_snapshot(s)) {
+	if (register_snapshare(ss)) {
 		r = -EINVAL;
 		ti->error = "Cannot register snapshot with origin";
 		goto bad_load_and_register;
@@ -630,12 +725,15 @@ bad_load_and_register:
 	dealloc_snapshot(s);
 
 bad_alloc_snapshot:
-	dm_put_device(ti, origin);
+	dm_put_device(ti, ss->origin);
 
 bad_origin:
 	dm_exception_store_destroy(store);
 
 bad_exception_store:
+	dm_exception_table_destroy(ss->pending);
+
+bad_hash_table:
 	kfree(ss);
 
 	return r;
@@ -653,9 +751,9 @@ static void snapshot_dtr(struct dm_targe
 
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
-	unregister_snapshot(s);
+	unregister_snapshare(ss);
 
-	while (atomic_read(&s->pending_exceptions_count))
+	while (atomic_read(&ss->pending_exceptions_count))
 		msleep(1);
 	/*
 	 * Ensure instructions in mempool_destroy aren't reordered
@@ -663,17 +761,24 @@ static void snapshot_dtr(struct dm_targe
 	 */
 	smp_mb();
 
+	/*
+	 * Has this snapshot been detached from the origin?
+	 * If so, deallocate it.
+	 */
+	if (list_empty(&s->list)) {
 #ifdef CONFIG_DM_DEBUG
-	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
-		BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
+		for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
+			BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
 #endif
+		dealloc_snapshot(s);
+	}
 
-	dm_put_device(ti, s->origin);
-
-	dealloc_snapshot(s);
+	dm_put_device(ti, ss->origin);
 
 	dm_exception_store_destroy(ss->store);
 
+	dm_exception_table_destroy(ss->pending);
+
 	kfree(ss);
 }
 
@@ -723,6 +828,7 @@ static void error_bios(struct bio *bio)
 
 static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 {
+	struct dm_snapshare *ss;
 	char *tmp_str = "ES_INVALIDATE";
 
 	if (!s->valid)
@@ -733,12 +839,16 @@ static void __invalidate_snapshot(struct
 	else if (err == -ENOMEM)
 		DMERR("Invalidating snapshot: Unable to allocate exception.");
 
-	if (s->store->type->message)
-		s->store->type->message(s->store, 1, &tmp_str);
 
 	s->valid = 0;
 
-	dm_table_event(s->store->ti->table);
+	/* Invalidating the snapshot will invalidate all snapshares. */
+	list_for_each_entry(ss, &s->shared_list, shared_list) {
+		if (ss->store->type->message)
+			ss->store->type->message(ss->store, 1, &tmp_str);
+
+		dm_table_event(ss->store->ti->table);
+	}
 }
 
 static void get_pending_exception(struct dm_snap_pending_exception *pe)
@@ -749,7 +859,6 @@ static void get_pending_exception(struct
 static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snap_pending_exception *primary_pe;
-	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 
 	primary_pe = pe->primary_pe;
@@ -762,7 +871,9 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		dm_free_exception(s->pending, &primary_pe->e);
+		dm_free_exception(primary_pe->ss ? primary_pe->ss->pending :
+				  primary_pe->snap->pending,
+				  &primary_pe->e);
 	}
 
 	/*
@@ -770,14 +881,15 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		dm_free_exception(s->pending, &pe->e);
+		dm_free_exception(pe->ss ? pe->ss->pending : pe->snap->pending,
+				  &pe->e);
 
 	return origin_bios;
 }
 
 static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 {
-	struct dm_snapshot *s = pe->snap;
+	struct dm_snapshot *s = pe->snap ? pe->snap : pe->ss->snap;
 	struct bio *origin_bios = NULL;
 	struct bio *snapshot_bios = NULL;
 	int error = 0;
@@ -827,15 +939,17 @@ static void commit_callback(void *contex
 static void copy_callback(int read_err, unsigned long write_err, void *context)
 {
 	struct dm_snap_pending_exception *pe = context;
-	struct dm_snapshot *s = pe->snap;
+	struct dm_exception_store *store;
+
+	store = pe->ss ? pe->ss->store : get_first_store(pe->snap);
 
 	if (read_err || write_err)
 		pending_complete(pe, 0);
 
 	else
 		/* Update the metadata if we are persistent */
-		s->store->type->commit_exception(s->store, &pe->e,
-						 commit_callback, pe);
+		store->type->commit_exception(store, &pe->e,
+					      commit_callback, pe);
 }
 
 /*
@@ -843,19 +957,24 @@ static void copy_callback(int read_err, 
  */
 static void start_copy(struct dm_snap_pending_exception *pe)
 {
-	struct dm_snapshot *s = pe->snap;
+	struct dm_exception_store *store;
+	struct dm_snapshot *s;
 	struct dm_io_region src, dest;
-	struct block_device *bdev = s->origin->bdev;
+	struct block_device *bdev;
 	sector_t dev_size;
 
+	store = (pe->ss) ? pe->ss->store : get_first_store(pe->snap);
+	s = pe->snap ? pe->snap : pe->ss->snap;
+	bdev = s->o_bdev;
+
 	dev_size = get_dev_size(bdev);
 
 	src.bdev = bdev;
-	src.sector = chunk_to_sector(s->store, pe->e.old_chunk);
-	src.count = min(s->store->chunk_size, dev_size - src.sector);
+	src.sector = chunk_to_sector(store, pe->e.old_chunk);
+	src.count = min(store->chunk_size, dev_size - src.sector);
 
-	dest.bdev = s->store->cow->bdev;
-	dest.sector = chunk_to_sector(s->store, pe->e.new_chunk);
+	dest.bdev = store->cow->bdev;
+	dest.sector = chunk_to_sector(store, pe->e.new_chunk);
 	dest.count = src.count;
 
 	/* Hand over to kcopyd */
@@ -889,16 +1008,24 @@ __lookup_pending_exception(struct dm_exc
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s,
-			 struct dm_snap_pending_exception *pe,
-			 chunk_t chunk, int group)
+__find_pending_exception(struct dm_snap_pending_exception *pe, chunk_t chunk)
 {
+	struct dm_snapshare *ss = pe->ss;
+	struct dm_snapshot *s = pe->snap ? pe->snap : ss->snap;
+	struct dm_exception_store *store = ss ? ss->store : get_first_store(s);
+	struct dm_exception_table *table = ss ? ss->pending : s->pending;
 	struct dm_snap_pending_exception *pe2;
 
+	/* First check the snapshot pending cache */
 	pe2 = __lookup_pending_exception(s->pending, chunk);
-	if (pe2) {
-		dm_free_exception(s->pending, &pe->e);
-		return pe2;
+	if (pe2)
+		goto free_it;
+
+	/* Next, check the snapshare */
+	if (ss) {
+		pe2 = __lookup_pending_exception(ss->pending, chunk);
+		if (pe2)
+			goto free_it;
 	}
 
 	pe->e.old_chunk = chunk;
@@ -908,23 +1035,27 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store->type->prepare_exception(s->store, &pe->e, group)) {
-		dm_free_exception(s->pending, &pe->e);
+	if (store->type->prepare_exception(store, &pe->e, ss ? 0 : 1)) {
+		dm_free_exception(table, &pe->e);
 		return NULL;
 	}
 
 	get_pending_exception(pe);
-	dm_insert_exception(s->pending, &pe->e);
+	dm_insert_exception(table, &pe->e);
 
 	return pe;
+
+free_it:
+	dm_free_exception(table, &pe->e);
+	return pe2;
 }
 
-static void remap_exception(struct dm_snapshot *s, struct bio *bio,
-			    chunk_t chunk)
+static void remap_exception(struct dm_snapshare *ss,
+			    struct bio *bio, chunk_t chunk)
 {
-	bio->bi_bdev = s->store->cow->bdev;
-	bio->bi_sector = chunk_to_sector(s->store, dm_chunk_number(chunk)) +
-		(bio->bi_sector & s->store->chunk_mask);
+	bio->bi_bdev = ss->store->cow->bdev;
+	bio->bi_sector = chunk_to_sector(ss->store, dm_chunk_number(chunk)) +
+		(bio->bi_sector & ss->store->chunk_mask);
 }
 
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
@@ -963,7 +1094,7 @@ static int snapshot_map(struct dm_target
 	rtn = ss->store->type->lookup_exception(ss->store, chunk,
 						&new_chunk, flags);
 	if (!rtn) {
-		remap_exception(s, bio, new_chunk);
+		remap_exception(ss, bio, new_chunk);
 		goto out_unlock;
 	}
 
@@ -981,15 +1112,18 @@ static int snapshot_map(struct dm_target
 	 */
 	if (bio_rw(bio) == WRITE) {
 		pe = __lookup_pending_exception(s->pending, chunk);
+		if (!pe)
+			pe = __lookup_pending_exception(ss->pending, chunk);
+
 		if (!pe) {
 			up_write(&s->lock);
-			tmp_e = dm_alloc_exception(s->pending);
+			tmp_e = dm_alloc_exception(ss->pending);
 			pe = container_of(tmp_e,
 					  struct dm_snap_pending_exception, e);
 			down_write(&s->lock);
 
 			if (!s->valid) {
-				dm_free_exception(s->pending, &pe->e);
+				dm_free_exception(ss->pending, &pe->e);
 				r = -EIO;
 				goto out_unlock;
 			}
@@ -997,12 +1131,12 @@ static int snapshot_map(struct dm_target
 								&new_chunk,
 								flags);
 			if (!rtn) {
-				dm_free_exception(s->pending, &pe->e);
-				remap_exception(s, bio, new_chunk);
+				dm_free_exception(ss->pending, &pe->e);
+				remap_exception(ss, bio, new_chunk);
 				goto out_unlock;
 			}
 
-			pe = __find_pending_exception(s, pe, chunk, 0);
+			pe = __find_pending_exception(pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(s, -ENOMEM);
 				r = -EIO;
@@ -1010,7 +1144,7 @@ static int snapshot_map(struct dm_target
 			}
 		}
 
-		remap_exception(s, bio, pe->e.new_chunk);
+		remap_exception(ss, bio, pe->e.new_chunk);
 		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
@@ -1023,7 +1157,7 @@ static int snapshot_map(struct dm_target
 			goto out;
 		}
 	} else {
-		bio->bi_bdev = s->origin->bdev;
+		bio->bi_bdev = ss->origin->bdev;
 		map_context->ptr = track_chunk(s, chunk);
 	}
 
@@ -1116,7 +1250,7 @@ static int snapshot_status(struct dm_tar
 		 * to make private copies if the output is to
 		 * make sense.
 		 */
-		DMEMIT("%s", s->origin->name);
+		DMEMIT("%s", ss->origin->name);
 		ss->store->type->status(ss->store, type, result + sz,
 					maxlen - sz);
 		break;
@@ -1145,6 +1279,7 @@ static int __origin_write(struct list_he
 	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
 	struct dm_exception *tmp_e;
+	struct dm_exception_store *store;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1158,26 +1293,26 @@ static int __origin_write(struct list_he
 		if (!snap->valid || !snap->active)
 			goto next_snapshot;
 
+		store = get_first_store(snap);
+
 		/* Nothing to do if writing beyond end of snapshot */
-		if (bio->bi_sector >= dm_table_get_size(snap->store->ti->table))
+		if (bio->bi_sector >= dm_table_get_size(store->ti->table))
 			goto next_snapshot;
 
 		/*
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
-		chunk = sector_to_chunk(snap->store, bio->bi_sector);
+		chunk = sector_to_chunk(store, bio->bi_sector);
 
 		/*
-		 * Check exception table to see if block
-		 * is already remapped in this snapshot
-		 * and trigger an exception if not.
+		 * Check exception table to see if block is already
+		 * remapped in this snapshot and trigger an exception if not.
 		 *
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		rtn = snap->store->type->lookup_exception(snap->store, chunk,
-							  NULL, flags);
+		rtn = store->type->lookup_exception(store, chunk, NULL, flags);
 		if (!rtn)
 			goto next_snapshot;
 
@@ -1201,15 +1336,14 @@ static int __origin_write(struct list_he
 				goto next_snapshot;
 			}
 
-			rtn = snap->store->type->lookup_exception(snap->store,
-								  chunk, NULL,
-								  flags);
+			rtn = store->type->lookup_exception(store, chunk,
+							    NULL, flags);
 			if (!rtn) {
 				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
 			}
 
-			pe = __find_pending_exception(snap, pe, chunk, 1);
+			pe = __find_pending_exception(pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(snap, -ENOMEM);
 				goto next_snapshot;
@@ -1347,15 +1481,18 @@ static void origin_resume(struct dm_targ
 {
 	struct dm_dev *dev = ti->private;
 	struct dm_snapshot *snap;
+	struct dm_exception_store *store;
 	struct origin *o;
 	chunk_t chunk_size = 0;
 
 	down_read(&_origins_lock);
 	o = __lookup_origin(dev->bdev);
 	if (o)
-		list_for_each_entry (snap, &o->snapshots, list)
+		list_for_each_entry(snap, &o->snapshots, list) {
+			store = get_first_store(snap);
 			chunk_size = min_not_zero(chunk_size,
-						  snap->store->chunk_size);
+						  store->chunk_size);
+		}
 	up_read(&_origins_lock);
 
 	ti->split_io = chunk_size;
