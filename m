From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2] dm snapshot: allow live exception store
	handover between tables
Date: Fri,  6 Nov 2009 14:46:52 -0500
Message-ID: <1257536812-22840-1-git-send-email-snitzer@redhat.com>
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
 drivers/md/dm-snap.c |  236 +++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 228 insertions(+), 8 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -75,6 +75,27 @@ struct dm_snapshot {
 	/* Whether or not owning mapped_device is suspended */
 	int suspended;
 
+	/*
+	 * 'is_handover_destination' denotes another snapshot with the same
+	 * cow block device (as identified with find_snapshot_using_cow)
+	 * will hand over its exception store to this snapshot.
+	 *
+	 * 'is_handover_destination' is set in snapshot_ctr if an existing
+	 * snapshot has the same cow device. The handover is performed,
+	 * and 'is_handover_destination' is cleared, when one of the
+	 * following occurs:
+	 * - src (old) snapshot, that is handing over, is destructed
+	 * - src (old) snapshot, that is handing over, is resumed
+	 * - dest (new) snapshot, that is accepting the handover, is resumed
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
@@ -528,6 +549,31 @@ static int dm_add_exception(void *contex
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
@@ -599,11 +645,64 @@ static int init_hash_tables(struct dm_sn
 }
 
 /*
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
+ */
+static int unlink_snapshots_for_handover(struct dm_snapshot *snap_src,
+					 struct dm_snapshot *snap_dest)
+{
+	int r = -EINVAL;
+
+	down_write(&snap_src->lock);
+
+	/* make sure these snapshots are already linked */
+	if ((snap_src->handover_snap != snap_dest) ||
+	    (snap_dest->handover_snap != snap_src))
+		goto out;
+
+	snap_src->handover_snap = NULL;
+
+	snap_dest->handover_snap = NULL;
+	snap_dest->is_handover_destination = 0;
+
+	r = 0;
+
+out:
+	up_write(&snap_src->lock);
+	return r;
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
@@ -659,6 +758,8 @@ static int snapshot_ctr(struct dm_target
 	s->active = 0;
 	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->is_handover_destination = 0;
+	s->handover_snap = NULL;
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
@@ -694,6 +795,27 @@ static int snapshot_ctr(struct dm_target
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
+	/* Does snapshot need exceptions handing over to it? */
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
@@ -705,13 +827,11 @@ static int snapshot_ctr(struct dm_target
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
@@ -721,10 +841,6 @@ static int snapshot_ctr(struct dm_target
 		goto bad_load_and_register;
 	}
 
-	ti->private = s;
-	ti->split_io = s->store->chunk_size;
-	ti->num_flush_requests = 1;
-
 	return 0;
 
 bad_load_and_register:
@@ -765,15 +881,90 @@ static void __free_exceptions(struct dm_
 	dm_exception_table_exit(&s->complete, exception_cache);
 }
 
+static void handover_exceptions(struct dm_snapshot *old,
+				struct dm_snapshot *new)
+{
+	union {
+		struct dm_exception_table table_swap;
+		struct dm_exception_store *store_swap;
+	} u;
+
+	BUG_ON((old->handover_snap != new) ||
+	       (new->handover_snap != old));
+	BUG_ON((old->is_handover_destination != 0) ||
+	       (new->is_handover_destination != 1));
+	BUG_ON(!old->suspended);
+
+	/* make sure old snapshot is still valid */
+	if (!old->valid) {
+		new->valid = 0;
+		DMERR("Unable to handover exceptions "
+		      "from an invalid snapshot.");
+		return;
+	}
+
+	/* swap exceptions tables and stores */
+	u.table_swap = new->complete;
+	new->complete = old->complete;
+	old->complete = u.table_swap;
+	u.store_swap = new->store;
+	new->store = old->store;
+	old->store = u.store_swap;
+
+	new->store->snap = new;
+	old->store->snap = old;
+
+	/* reset split_io to store's chunk_size */
+	if (new->ti->split_io != new->store->chunk_size)
+		new->ti->split_io = new->store->chunk_size;
+
+	/* Mark old snapshot invalid and inactive */
+	old->valid = 0;
+	old->active = 0;
+
+	/* Reset handover_snap references */
+	old->handover_snap = NULL;
+	new->handover_snap = NULL;
+
+	new->is_handover_destination = 0;
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 #ifdef CONFIG_DM_DEBUG
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *new_snap = NULL;
 
 	flush_workqueue(ksnapd);
 
+	/* This snapshot may need to handover its exception store */
+	down_write(&s->lock);
+	if (s->handover_snap) {
+		if (!s->is_handover_destination) {
+			/* Handover exceptions to another snapshot */
+			new_snap = s->handover_snap;
+
+			down_write_nested(&new_snap->lock,
+					  SINGLE_DEPTH_NESTING);
+			handover_exceptions(s, new_snap);
+			up_write(&new_snap->lock);
+		} else {
+			/* allow table_clear to cancel handover */
+			unlink_snapshots_for_handover(s->handover_snap, s);
+		}
+	}
+	/* An incomplete exception handover is not allowed */
+	BUG_ON(s->handover_snap);
+	up_write(&s->lock);
+
+	if (new_snap && register_snapshot(new_snap)) {
+		DMERR("Unable to register snapshot "
+		      "after exception handover.");
+		new_snap->valid = 0;
+	}
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1189,11 +1380,40 @@ static void snapshot_presuspend(struct d
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *lock_snap, *old_snap, *new_snap = NULL;
 
 	down_write(&s->lock);
+	if (s->handover_snap) {
+		/*
+		 * Initially assumes this snapshot will get
+		 * exception store from another snapshot
+		 */
+		old_snap = s->handover_snap;
+		new_snap = s;
+		lock_snap = old_snap;
+
+		if (!s->is_handover_destination) {
+			/* Handover exceptions to another snapshot */
+			old_snap = s;
+			new_snap = s->handover_snap;
+			lock_snap = new_snap;
+		}
+		down_write_nested(&lock_snap->lock,
+				  SINGLE_DEPTH_NESTING);
+		handover_exceptions(old_snap, new_snap);
+		up_write(&lock_snap->lock);
+	}
+	/* An incomplete exception handover is not allowed */
+	BUG_ON(s->handover_snap);
 	s->active = 1;
 	s->suspended = 0;
 	up_write(&s->lock);
+
+	if (new_snap && register_snapshot(new_snap)) {
+		DMERR("Unable to register snapshot "
+		      "after exception handover.");
+		new_snap->valid = 0;
+	}
 }
 
 static int snapshot_status(struct dm_target *ti, status_type_t type,
