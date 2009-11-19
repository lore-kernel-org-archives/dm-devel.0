From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v9] dm snapshot: allow live exception store
	handover between tables
Date: Thu, 19 Nov 2009 12:43:28 -0500
Message-ID: <1258652608-13646-1-git-send-email-snitzer@redhat.com>
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

Permit in-use snapshot exception data to be 'handed over' from one
snapshot instance to another.  This is a pre-requisite for patches
that allow the changes made in a snapshot device to be merged back into
its origin device and also allows device resizing.

The basic call sequence is:

  dmsetup load new_snapshot (referencing the existing in-use cow device)
     - the ctr code detects that the cow is already in use and allows the
       two snapshot target instances to be linked together
  dmsetup suspend original_snapshot
  dmsetup resume new_snapshot
     - the new_snapshot becomes live, and if anything now tries to access
       the original one it will receive -EIO
  dmsetup remove original_snapshot

(There can only be two snapshot targets referencing the same cow device
simultaneously.)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |  258 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 231 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -303,22 +303,111 @@ static void __insert_origin(struct origi
 }
 
 /*
+ * _origins_lock must be held when calling this function.
+ * Returns number of snapshots registered using the supplied cow device, plus:
+ * snap_src - a snapshot suitable for use as a source of exception handover
+ * snap_dest - a snapshot capable of receiving exception handover.
+ *
+ * Possible return values and states:
+ *   0: NULL, NULL  - first new snapshot
+ *   1: snap_src, NULL - normal snapshot
+ *   2: snap_src, snap_dest  - waiting for handover
+ *   2: snap_src, NULL - handed over, waiting for old to be deleted
+ *   1: NULL, snap_dest - source got destroyed without handover
+ */
+static int __find_snapshots_sharing_cow(struct dm_snapshot *snap,
+					struct dm_snapshot **snap_src,
+					struct dm_snapshot **snap_dest)
+{
+	struct dm_snapshot *s;
+	struct origin *o;
+	int count = 0;
+	int active;
+
+	o = __lookup_origin(snap->origin->bdev);
+	if (!o)
+		goto out;
+
+	list_for_each_entry(s, &o->snapshots, list) {
+		if (!bdev_equal(s->cow->bdev, snap->cow->bdev))
+			continue;
+
+		down_read(&s->lock);
+		active = s->active;
+		up_read(&s->lock);
+
+		if (active) {
+			if (snap_src)
+				*snap_src = s;
+		} else if (snap_dest)
+			*snap_dest = s;
+
+		count++;
+	}
+
+out:
+	return count;
+}
+
+static int __validate_exception_handover(struct dm_snapshot *snap)
+{
+	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+	int r = 0;
+
+	/* Does snapshot need exceptions handed over to it? */
+	if ((__find_snapshots_sharing_cow(snap, &snap_src, &snap_dest) == 2) ||
+	    snap_dest) {
+		snap->ti->error = "Snapshot cow pairing for exception "
+				  "table handover failed";
+		r = -EINVAL;
+		goto out;
+	}
+
+	if (snap_src)
+		r = 1;
+
+out:
+	return r;
+}
+
+static void __insert_snapshot(struct origin *o, struct dm_snapshot *s)
+{
+	struct dm_snapshot *l;
+
+	/* Sort the list according to chunk size, largest-first smallest-last */
+	list_for_each_entry(l, &o->snapshots, list)
+		if (l->store->chunk_size < s->store->chunk_size)
+			break;
+	list_add_tail(&s->list, &l->list);
+}
+
+/*
  * Make a note of the snapshot and its origin so we can look it
  * up when the origin has a write on it.
+ *
+ * Also validate snapshot exception store handovers.
+ * On success, returns 1 if this registration is a handover destination,
+ * otherwise returns 0.
  */
 static int register_snapshot(struct dm_snapshot *snap)
 {
-	struct dm_snapshot *l;
-	struct origin *o, *new_o;
+	struct origin *o, *new_o = NULL;
 	struct block_device *bdev = snap->origin->bdev;
+	int r = 0;
 
 	new_o = kmalloc(sizeof(*new_o), GFP_KERNEL);
 	if (!new_o)
 		return -ENOMEM;
 
 	down_write(&_origins_lock);
-	o = __lookup_origin(bdev);
 
+	r = __validate_exception_handover(snap);
+	if (r < 0) {
+		kfree(new_o);
+		goto out;
+	}
+
+	o = __lookup_origin(bdev);
 	if (o)
 		kfree(new_o);
 	else {
@@ -332,14 +421,27 @@ static int register_snapshot(struct dm_s
 		__insert_origin(o);
 	}
 
-	/* Sort the list according to chunk size, largest-first smallest-last */
-	list_for_each_entry(l, &o->snapshots, list)
-		if (l->store->chunk_size < snap->store->chunk_size)
-			break;
-	list_add_tail(&snap->list, &l->list);
+	__insert_snapshot(o, snap);
+
+out:
+	up_write(&_origins_lock);
+
+	return r;
+}
+
+/*
+ * Move snapshot to correct place in list according to chunk size.
+ */
+static void reregister_snapshot(struct dm_snapshot *s)
+{
+	struct block_device *bdev = s->origin->bdev;
+
+	down_write(&_origins_lock);
+
+	list_del(&s->list);
+	__insert_snapshot(__lookup_origin(bdev), s);
 
 	up_write(&_origins_lock);
-	return 0;
 }
 
 static void unregister_snapshot(struct dm_snapshot *s)
@@ -350,7 +452,7 @@ static void unregister_snapshot(struct d
 	o = __lookup_origin(s->origin->bdev);
 
 	list_del(&s->list);
-	if (list_empty(&o->snapshots)) {
+	if (o && list_empty(&o->snapshots)) {
 		list_del(&o->hash_list);
 		kfree(o);
 	}
@@ -660,6 +762,7 @@ static int snapshot_ctr(struct dm_target
 	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
 	init_rwsem(&s->lock);
+	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for COW data */
@@ -694,39 +797,55 @@ static int snapshot_ctr(struct dm_target
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
-	/* Metadata must only be loaded into one table at once */
+	bio_list_init(&s->queued_bios);
+	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
+
+	ti->private = s;
+	ti->num_flush_requests = 1;
+
+	/* Add snapshot to the list of snapshots for this origin */
+	/* Exceptions aren't triggered till snapshot_resume() is called */
+	r = register_snapshot(s);
+	if (r == -ENOMEM) {
+		ti->error = "Snapshot origin struct allocation failed";
+		goto bad_load_and_register;
+	} else if (r < 0) {
+		/* invalid handover, register_snapshot has set ti->error */
+		goto bad_load_and_register;
+	}
+
+	/*
+	 * Metadata must only be loaded into one table at once, so skip this
+	 * if metadata will be handed over during resume.
+	 * Chunk size will be set during the handover - set it to zero to
+	 * ensure it's ignored.
+	 */
+	if (r > 0) {
+		s->store->chunk_size = 0;
+		return 0;
+	}
+
 	r = s->store->type->read_metadata(s->store, dm_add_exception,
 					  (void *)s);
 	if (r < 0) {
 		ti->error = "Failed to read snapshot metadata";
-		goto bad_load_and_register;
+		goto bad_read_metadata;
 	} else if (r > 0) {
 		s->valid = 0;
 		DMWARN("Snapshot is marked invalid.");
 	}
 
-	bio_list_init(&s->queued_bios);
-	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
-
 	if (!s->store->chunk_size) {
 		ti->error = "Chunk size not set";
-		goto bad_load_and_register;
+		goto bad_read_metadata;
 	}
-
-	/* Add snapshot to the list of snapshots for this origin */
-	/* Exceptions aren't triggered till snapshot_resume() is called */
-	if (register_snapshot(s)) {
-		r = -EINVAL;
-		ti->error = "Cannot register snapshot origin";
-		goto bad_load_and_register;
-	}
-
-	ti->private = s;
 	ti->split_io = s->store->chunk_size;
-	ti->num_flush_requests = 1;
 
 	return 0;
 
+bad_read_metadata:
+	unregister_snapshot(s);
+
 bad_load_and_register:
 	mempool_destroy(s->tracked_chunk_pool);
 
@@ -765,15 +884,58 @@ static void __free_exceptions(struct dm_
 	dm_exception_table_exit(&s->complete, exception_cache);
 }
 
+static void __handover_exceptions(struct dm_snapshot *snap_src,
+				  struct dm_snapshot *snap_dest)
+{
+	union {
+		struct dm_exception_table table_swap;
+		struct dm_exception_store *store_swap;
+	} u;
+
+	/*
+	 * Swap all snapshot context information between the two instances.
+	 */
+	u.table_swap = snap_dest->complete;
+	snap_dest->complete = snap_src->complete;
+	snap_src->complete = u.table_swap;
+
+	u.store_swap = snap_dest->store;
+	snap_dest->store = snap_src->store;
+	snap_src->store = u.store_swap;
+
+	snap_dest->store->snap = snap_dest;
+	snap_src->store->snap = snap_src;
+
+	snap_dest->ti->split_io = snap_dest->store->chunk_size;
+	snap_dest->valid = snap_src->valid;
+
+	/*
+	 * Set source invalid to ensure it receives no further I/O.
+	 */
+	snap_src->valid = 0;
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 #ifdef CONFIG_DM_DEBUG
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
 
 	flush_workqueue(ksnapd);
 
+	down_read(&_origins_lock);
+	/* Check whether exception handover must be cancelled */
+	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest);
+	if (snap_src && snap_dest && (s == snap_src)) {
+		down_write(&snap_dest->lock);
+		snap_dest->valid = 0;
+		up_write(&snap_dest->lock);
+		DMERR("Cancelling snapshot handover.");
+	}
+	up_read(&_origins_lock);
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1186,9 +1348,50 @@ static void snapshot_postsuspend(struct 
 	up_write(&s->lock);
 }
 
+static int snapshot_preresume(struct dm_target *ti)
+{
+	int r = 0;
+	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+
+	down_read(&_origins_lock);
+	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest);
+	if (snap_src && snap_dest) {
+		down_read(&snap_src->lock);
+		if (s == snap_src) {
+			DMERR("Unable to resume snapshot source until "
+			      "handover completes.");
+			r = -EINVAL;
+		} else if (!snap_src->suspended) {
+			DMERR("Unable to perform snapshot handover until "
+			      "source is suspended.");
+			r = -EINVAL;
+		}
+		up_read(&snap_src->lock);
+	}
+	up_read(&_origins_lock);
+
+	return r;
+}
+
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src = NULL, *snap_dest = NULL;
+
+	down_read(&_origins_lock);
+	(void) __find_snapshots_sharing_cow(s, &snap_src, &snap_dest);
+	if (snap_src && snap_dest) {
+		down_write_nested(&snap_src->lock, SINGLE_DEPTH_NESTING);
+		down_write(&snap_dest->lock);
+		__handover_exceptions(snap_src, snap_dest);
+		up_write(&snap_dest->lock);
+		up_write(&snap_src->lock);
+	}
+	up_read(&_origins_lock);
+
+	/* Now we have correct chunk size, reregister */
+	reregister_snapshot(s);
 
 	down_write(&s->lock);
 	s->active = 1;
@@ -1506,6 +1709,7 @@ static struct target_type snapshot_targe
 	.map     = snapshot_map,
 	.end_io  = snapshot_end_io,
 	.postsuspend = snapshot_postsuspend,
+	.preresume  = snapshot_preresume,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
