From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 30 of 33] DM Snapshot:  split ctr and dtr
Date: Mon, 6 Apr 2009 16:37:31 -0500
Message-ID: <200904062137.n36LbVtC021905@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-split-ctr-and-dtr.patch

Break up the snapshot constructor and destructor functions to
isolate the portions that allocate and initialize the dm_snapshot
structure.  This structure will become the bulk of what is shared
as we move to a snapshot model that is tolerant of shared exception
stores.  This will help us minimize code change as we add the new
sharing structures to the constructor/destructor procedure.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -431,6 +431,89 @@ static int create_exception_store(struct
 					 argv + 2, store);
 }
 
+static struct dm_snapshot *alloc_snapshot(sector_t hash_size)
+{
+	int r, i;
+	struct dm_snapshot *s;
+
+	s = kzalloc(sizeof(*s), GFP_KERNEL);
+	if (!s) {
+		DMERR("Cannot allocate snapshot structure");
+		return NULL;
+	}
+
+	s->valid = 1;
+	s->active = 0;
+	atomic_set(&s->pending_exceptions_count, 0);
+	init_rwsem(&s->lock);
+	spin_lock_init(&s->pe_lock);
+
+	/* Allocate hash table for pending COW data */
+	s->pending = dm_exception_table_create(hash_size, 0,
+					       alloc_pending_exception, s,
+					       free_pending_exception, NULL);
+	if (!s->pending) {
+		DMERR("Unable to allocate hash table space");
+		goto bad_hash_table;
+	}
+
+	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
+	if (r) {
+		DMERR("Could not create kcopyd client");
+		goto bad_kcopyd;
+	}
+
+	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
+	if (!s->pending_pool) {
+		DMERR("Could not allocate mempool for pending exceptions");
+		goto bad_pending_pool;
+	}
+
+	s->tracked_chunk_pool = mempool_create_slab_pool(MIN_IOS,
+							 tracked_chunk_cache);
+	if (!s->tracked_chunk_pool) {
+		DMERR("Could not allocate tracked_chunk mempool "
+		      "for tracking reads");
+		goto bad_tracked_chunk_pool;
+	}
+
+	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
+		INIT_HLIST_HEAD(&s->tracked_chunk_hash[i]);
+
+	spin_lock_init(&s->tracked_chunk_lock);
+	bio_list_init(&s->queued_bios);
+	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
+
+	return s;
+
+bad_tracked_chunk_pool:
+	mempool_destroy(s->pending_pool);
+
+bad_pending_pool:
+	dm_kcopyd_client_destroy(s->kcopyd_client);
+
+bad_kcopyd:
+	dm_exception_table_destroy(s->pending);
+
+bad_hash_table:
+	kfree(s);
+
+	return NULL;
+}
+
+static void dealloc_snapshot(struct dm_snapshot *s)
+{
+	mempool_destroy(s->tracked_chunk_pool);
+
+	mempool_destroy(s->pending_pool);
+
+	dm_kcopyd_client_destroy(s->kcopyd_client);
+
+	dm_exception_table_destroy(s->pending);
+
+	kfree(s);
+}
+
 /*
  * snapshot_ctr
  * @ti
@@ -446,6 +529,7 @@ static int create_exception_store(struct
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
 	sector_t hash_size, cow_dev_size, origin_dev_size, max_buckets;
+	struct dm_dev *origin;
 	struct dm_snapshot *s;
 	int i;
 	int r = -EINVAL;
@@ -463,38 +547,26 @@ static int snapshot_ctr(struct dm_target
 	argc--;
 
 	r = create_exception_store(ti, argc, argv, &args_used, &store);
-	if (r)
+	if (r) {
+		ti->error = "Failed to create snapshot exception store";
 		return r;
+	}
 
 	argv += args_used;
 	argc -= args_used;
 
-	s = kmalloc(sizeof(*s), GFP_KERNEL);
-	if (!s) {
-		ti->error = "Cannot allocate snapshot private structure";
-		r = -ENOMEM;
-		goto bad_snap;
-	}
-
-	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
+	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
 		goto bad_origin;
 	}
 
-	s->store = store;
-	s->valid = 1;
-	s->active = 0;
-	atomic_set(&s->pending_exceptions_count, 0);
-	init_rwsem(&s->lock);
-	spin_lock_init(&s->pe_lock);
-
 	/*
 	 * Calculate based on the size of the original volume or
 	 * the COW volume...
 	 */
 	cow_dev_size = get_dev_size(store->cow->bdev);
-	origin_dev_size = get_dev_size(s->origin->bdev);
+	origin_dev_size = get_dev_size(origin->bdev);
 	max_buckets = calc_max_buckets();
 
 	hash_size = min(origin_dev_size, cow_dev_size) >> store->chunk_shift;
@@ -505,47 +577,24 @@ static int snapshot_ctr(struct dm_target
 	if (hash_size < 64)
 		hash_size = 64;
 
-	s->pending = dm_exception_table_create(hash_size, 0,
-					       alloc_pending_exception, s,
-					       free_pending_exception, NULL);
-	if (!s->pending) {
-		ti->error = "Unable to allocate hash table space";
+	/*
+	 * Allocate the snapshot
+	 */
+	s = alloc_snapshot(hash_size);
+	if (!s) {
 		r = -ENOMEM;
-		goto bad_hash_table;
-	}
-
-	r = dm_kcopyd_client_create(SNAPSHOT_PAGES, &s->kcopyd_client);
-	if (r) {
-		ti->error = "Could not create kcopyd client";
-		goto bad_kcopyd;
-	}
-
-	s->pending_pool = mempool_create_slab_pool(MIN_IOS, pending_cache);
-	if (!s->pending_pool) {
-		ti->error = "Could not allocate mempool for pending exceptions";
-		goto bad_pending_pool;
-	}
-
-	s->tracked_chunk_pool = mempool_create_slab_pool(MIN_IOS,
-							 tracked_chunk_cache);
-	if (!s->tracked_chunk_pool) {
-		ti->error = "Could not allocate tracked_chunk mempool for "
-			    "tracking reads";
-		goto bad_tracked_chunk_pool;
+		ti->error = "Failed to create snapshot structure";
+		goto bad_alloc_snapshot;
 	}
 
-	for (i = 0; i < DM_TRACKED_CHUNK_HASH_SIZE; i++)
-		INIT_HLIST_HEAD(&s->tracked_chunk_hash[i]);
-
-	spin_lock_init(&s->tracked_chunk_lock);
-	bio_list_init(&s->queued_bios);
-	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
+	s->origin = origin;
+	s->store = store;
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
 	if (register_snapshot(s)) {
 		r = -EINVAL;
-		ti->error = "Cannot register snapshot origin";
+		ti->error = "Cannot register snapshot with origin";
 		goto bad_load_and_register;
 	}
 
@@ -555,24 +604,12 @@ static int snapshot_ctr(struct dm_target
 	return 0;
 
 bad_load_and_register:
-	mempool_destroy(s->tracked_chunk_pool);
-
-bad_tracked_chunk_pool:
-	mempool_destroy(s->pending_pool);
-
-bad_pending_pool:
-	dm_kcopyd_client_destroy(s->kcopyd_client);
+	dealloc_snapshot(s);
 
-bad_kcopyd:
-	dm_exception_table_destroy(s->pending);
-
-bad_hash_table:
-	dm_put_device(ti, s->origin);
+bad_alloc_snapshot:
+	dm_put_device(ti, origin);
 
 bad_origin:
-	kfree(s);
-
-bad_snap:
 	dm_exception_store_destroy(store);
 
 	return r;
@@ -604,20 +641,11 @@ static void snapshot_dtr(struct dm_targe
 		BUG_ON(!hlist_empty(&s->tracked_chunk_hash[i]));
 #endif
 
-	mempool_destroy(s->tracked_chunk_pool);
-
-	dm_kcopyd_client_destroy(s->kcopyd_client);
-	s->kcopyd_client = NULL;
-
-	dm_exception_table_destroy(s->pending);
-
-	mempool_destroy(s->pending_pool);
-
 	dm_put_device(ti, s->origin);
 
 	dm_exception_store_destroy(s->store);
 
-	kfree(s);
+	dealloc_snapshot(s);
 }
 
 /*
