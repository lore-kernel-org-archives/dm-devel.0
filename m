From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v4] dm snapshot: allow live exception store
	handover between tables
Date: Mon,  9 Nov 2009 22:55:16 -0500
Message-ID: <1257825316-23227-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>, agk@redhat.com
List-Id: dm-devel.ids

Permit in-use snapshot exception data to be 'handed over' from one
snapshot instance to another.  This is a pre-requisite for patches
that allow the changes made in a snapshot device to be merged back into
its origin device and also allows device resizing.

The basic call sequence is:

  dmsetup load new_snapshot (referencing the existing in-use cow device)
     - the ctr code detects that the cow is already in use and links the
       two snapshot target instances together
  dmsetup suspend original_snapshot
  dmsetup resume new_snapshot
     - the new_snapshot becomes live, and if anything now tries to access
       the original one it will receive EIO
  dmsetup remove original_snapshot

(There can only be two snapshot targets referencing the same cow device
simultaneously.)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
---
 drivers/md/dm-snap.c |  267 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 258 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -75,6 +75,24 @@ struct dm_snapshot {
 	/* Whether or not owning mapped_device is suspended */
 	int suspended;
 
+	/*
+	 * 'is_handover_destination' denotes another snapshot with the same
+	 * cow block device (as identified with find_snapshot_using_cow)
+	 * will hand over its exception store to this snapshot.
+	 *
+	 * 'is_handover_destination' is set in snapshot_ctr if an existing
+	 * snapshot has the same cow device. The handover is performed,
+	 * and 'is_handover_destination' is cleared, when the destination
+	 * (new) snapshot, that is accepting the handover, is resumed.
+	 */
+	int is_handover_destination;
+
+	/*
+	 * reference to the other snapshot that will participate in the
+	 * exception store handover; src references dest, dest references src
+	 */
+	struct dm_snapshot *handover_snap;
+
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -350,7 +368,7 @@ static void unregister_snapshot(struct d
 	o = __lookup_origin(s->origin->bdev);
 
 	list_del(&s->list);
-	if (list_empty(&o->snapshots)) {
+	if (o && list_empty(&o->snapshots)) {
 		list_del(&o->hash_list);
 		kfree(o);
 	}
@@ -528,6 +546,31 @@ static int dm_add_exception(void *contex
 	return 0;
 }
 
+static struct dm_snapshot *find_snapshot_using_cow(struct dm_snapshot *snap)
+{
+	struct dm_snapshot *s, *handover_snap = NULL;
+	struct origin *o;
+
+	down_read(&_origins_lock);
+
+	o = __lookup_origin(snap->origin->bdev);
+	if (!o)
+		goto out;
+
+	list_for_each_entry(s, &o->snapshots, list) {
+		if (s == snap || !bdev_equal(s->cow->bdev, snap->cow->bdev))
+			continue;
+
+		handover_snap = s;
+		break;
+	}
+
+out:
+	up_read(&_origins_lock);
+
+	return handover_snap;
+}
+
 #define min_not_zero(l, r) (((l) == 0) ? (r) : (((r) == 0) ? (l) : min(l, r)))
 
 /*
@@ -599,11 +642,105 @@ static int init_hash_tables(struct dm_sn
 }
 
 /*
+ * Ensure proper lock order for snapshots involved in handover:
+ * lock the source snapshot then lock the destination snapshot.
+ * Returns 0 if exception handover is not necessary.
+ * Returns 1 if both snapshots were locked, also sets pointers
+ * for which snapshot is the src and which is the dest.
+ */
+static int lock_snapshots_for_handover(struct dm_snapshot *s,
+				       struct dm_snapshot **snap_src,
+				       struct dm_snapshot **snap_dest)
+{
+	down_write(&s->lock);
+	if (!s->handover_snap) {
+		up_write(&s->lock);
+		return 0;
+	}
+
+	/*
+	 * determine the src and dest snapshots from 's';
+	 * lock the source then lock the destination
+	 */
+	if (s->is_handover_destination) {
+		/* 's' is getting exceptions from another snapshot */
+		/* must drop lock and then get locks in proper order */
+		up_write(&s->lock);
+		*snap_src = s->handover_snap;
+		*snap_dest = s;
+		down_write_nested(&(*snap_src)->lock,
+				  SINGLE_DEPTH_NESTING);
+		down_write(&(*snap_dest)->lock);
+	} else {
+		/* already have the 'snap_src' lock */
+		*snap_src = s;
+		*snap_dest = s->handover_snap;
+		down_write_nested(&(*snap_dest)->lock,
+				  SINGLE_DEPTH_NESTING);
+	}
+
+	return 1;
+}
+
+static void unlock_snapshots_for_handover(struct dm_snapshot *snap_src,
+					  struct dm_snapshot *snap_dest)
+{
+	up_write(&snap_dest->lock);
+	up_write(&snap_src->lock);
+}
+
+/*
+ * Reserve snap_src for handover to snap_dest.
+ */
+static int link_snapshots_for_handover(struct dm_snapshot *snap_src,
+				       struct dm_snapshot *snap_dest)
+{
+	int r = -EINVAL;
+
+	down_write(&snap_src->lock);
+
+	/* Another handover already set? */
+	if (snap_src->handover_snap)
+		goto out;
+
+	snap_src->handover_snap = snap_dest;
+
+	snap_dest->handover_snap = snap_src;
+	snap_dest->is_handover_destination = 1;
+
+	r = 0;
+
+out:
+	up_write(&snap_src->lock);
+	return r;
+}
+
+/*
+ * Unreserve snap_src for handover to snap_dest.
+ * Must take associated locks with lock_snapshots_for_handover().
+ */
+static int __unlink_snapshots_for_handover(struct dm_snapshot *snap_src,
+					   struct dm_snapshot *snap_dest)
+{
+	/* make sure these snapshots are already linked */
+	if ((snap_src->handover_snap != snap_dest) ||
+	    (snap_dest->handover_snap != snap_src))
+		return -EINVAL;
+
+	snap_src->handover_snap = NULL;
+
+	snap_dest->handover_snap = NULL;
+	snap_dest->is_handover_destination = 0;
+
+	return 0;
+}
+
+/*
  * Construct a snapshot mapping: <origin_dev> <COW-dev> <p/n> <chunk-size>
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	struct dm_snapshot *s;
+	struct dm_snapshot *s, *handover_snap;
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
@@ -659,7 +796,10 @@ static int snapshot_ctr(struct dm_target
 	s->active = 0;
 	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->is_handover_destination = 0;
+	s->handover_snap = NULL;
 	init_rwsem(&s->lock);
+	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for COW data */
@@ -694,6 +834,27 @@ static int snapshot_ctr(struct dm_target
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
+	/* Does snapshot need exceptions handed over to it? */
+	handover_snap = find_snapshot_using_cow(s);
+	if (handover_snap) {
+		r = link_snapshots_for_handover(handover_snap, s);
+		if (r) {
+			ti->error = "Unable to handover snapshot to "
+				    "two devices at once.";
+			goto bad_load_and_register;
+		}
+	}
+
+	bio_list_init(&s->queued_bios);
+	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
+
+	ti->private = s;
+	ti->num_flush_requests = 1;
+
+	if (handover_snap)
+		/* register_snapshot is deferred until after handover_exceptions */
+		return 0;
+
 	/* Metadata must only be loaded into one table at once */
 	r = s->store->type->read_metadata(s->store, dm_add_exception,
 					  (void *)s);
@@ -705,13 +866,11 @@ static int snapshot_ctr(struct dm_target
 		DMWARN("Snapshot is marked invalid.");
 	}
 
-	bio_list_init(&s->queued_bios);
-	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
-
 	if (!s->store->chunk_size) {
 		ti->error = "Chunk size not set";
 		goto bad_load_and_register;
 	}
+	ti->split_io = s->store->chunk_size;
 
 	/* Add snapshot to the list of snapshots for this origin */
 	/* Exceptions aren't triggered till snapshot_resume() is called */
@@ -721,10 +880,6 @@ static int snapshot_ctr(struct dm_target
 		goto bad_load_and_register;
 	}
 
-	ti->private = s;
-	ti->split_io = s->store->chunk_size;
-	ti->num_flush_requests = 1;
-
 	return 0;
 
 bad_load_and_register:
@@ -765,15 +920,62 @@ static void __free_exceptions(struct dm_
 	dm_exception_table_exit(&s->complete, exception_cache);
 }
 
+static void handover_exceptions(struct dm_snapshot *snap_src,
+				struct dm_snapshot *snap_dest)
+{
+	union {
+		struct dm_exception_table table_swap;
+		struct dm_exception_store *store_swap;
+	} u;
+
+	BUG_ON((snap_src->handover_snap != snap_dest) ||
+	       (snap_dest->handover_snap != snap_src));
+	BUG_ON((snap_src->is_handover_destination != 0) ||
+	       (snap_dest->is_handover_destination != 1));
+
+	/* swap exceptions tables and stores */
+	u.table_swap = snap_dest->complete;
+	snap_dest->complete = snap_src->complete;
+	snap_src->complete = u.table_swap;
+	u.store_swap = snap_dest->store;
+	snap_dest->store = snap_src->store;
+	snap_src->store = u.store_swap;
+
+	snap_dest->store->snap = snap_dest;
+	snap_src->store->snap = snap_src;
+
+	/* reset split_io to store's chunk_size */
+	if (snap_dest->ti->split_io != snap_dest->store->chunk_size)
+		snap_dest->ti->split_io = snap_dest->store->chunk_size;
+
+	/* transfer 'valid' state, mark snap_src snapshot invalid */
+	snap_dest->valid = snap_src->valid;
+	snap_src->valid = 0;
+
+	__unlink_snapshots_for_handover(snap_src, snap_dest);
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 #ifdef CONFIG_DM_DEBUG
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src, *snap_dest;
 
 	flush_workqueue(ksnapd);
 
+	if (lock_snapshots_for_handover(s, &snap_src, &snap_dest)) {
+		if (s == snap_src) {
+			DMERR("Unable to handover exceptions to another "
+			      "snapshot from dtr, cancelling handover.");
+			s->valid = 0;
+		}
+		/* allow table_clear to cancel handover */
+		__unlink_snapshots_for_handover(snap_src, snap_dest);
+		unlock_snapshots_for_handover(snap_src, snap_dest);
+	}
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1186,11 +1388,57 @@ static void snapshot_presuspend(struct d
 	up_write(&s->lock);
 }
 
+static int snapshot_preresume(struct dm_target *ti)
+{
+	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src, *snap_dest;
+
+	if (lock_snapshots_for_handover(s, &snap_src, &snap_dest)) {
+		if (s == snap_dest && !snap_src->suspended) {
+			/* make sure snap_src is suspended */
+			DMERR("Unable to accept exceptions from a "
+			      "snapshot that is not suspended, "
+			      "cancelling handover.");
+			__unlink_snapshots_for_handover(snap_src, snap_dest);
+			snap_dest->valid = 0;
+		} else if (s == snap_src) {
+			/*
+			 * snap_dest is invalid if snap_src is
+			 * resumed before it
+			 */
+			DMERR("Unable to handover exceptions to another "
+			      "snapshot on resume, cancelling handover.");
+			__unlink_snapshots_for_handover(snap_src, snap_dest);
+			snap_dest->valid = 0;
+		}
+		unlock_snapshots_for_handover(snap_src, snap_dest);
+	}
+
+	/* returning failure leaves target suspended, best to avoid hung IO */
+	return 0;
+}
+
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src, *snap_dest;
+
+	if (lock_snapshots_for_handover(s, &snap_src, &snap_dest)) {
+		BUG_ON(s == snap_src);
+		/* Get exception store from another snapshot */
+		handover_exceptions(snap_src, snap_dest);
+		unlock_snapshots_for_handover(snap_src, snap_dest);
+
+		if (register_snapshot(snap_dest)) {
+			DMERR("Unable to register snapshot "
+			      "after exception handover.");
+			snap_dest->valid = 0;
+		}
+	}
 
 	down_write(&s->lock);
+	/* An incomplete exception handover is not allowed */
+	BUG_ON(s->handover_snap);
 	s->active = 1;
 	s->suspended = 0;
 	up_write(&s->lock);
@@ -1506,6 +1754,7 @@ static struct target_type snapshot_targe
 	.map     = snapshot_map,
 	.end_io  = snapshot_end_io,
 	.presuspend = snapshot_presuspend,
+	.preresume  = snapshot_preresume,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
