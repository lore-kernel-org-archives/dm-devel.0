From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v6] dm snapshot: allow live exception store
	handover between tables
Date: Wed, 11 Nov 2009 11:48:52 -0500
Message-ID: <1257958132-19737-1-git-send-email-snitzer@redhat.com>
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
     - the ctr code detects that the cow is already in use and links the
       two snapshot target instances together
  dmsetup suspend original_snapshot
  dmsetup resume new_snapshot
     - the new_snapshot becomes live, and if anything now tries to access
       the original one it will receive EIO
  dmsetup remove original_snapshot

(There can only be two snapshot targets referencing the same cow device
simultaneously.)

Snapshot locking is such that:
0) snapshot that is passed to find_snapshot_using_cow() is not locked
1) only need handover-source lock to determine if handover is needed
   - handover-source lock is primary lock used in handover code paths
   - only need handover-destination lock before handover_exceptions()
2) handover-source lock is taken before handover-destination lock
   - but this is only ever needed before calling handover_exceptions()

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |  193 ++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 184 insertions(+), 9 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -75,6 +75,22 @@ struct dm_snapshot {
 	/* Whether or not owning mapped_device is suspended */
 	int suspended;
 
+	/*
+	 * 'is_handover_source' denotes this snapshot will handover its
+	 * exception store to another snapshot.  This handover-source
+	 * snapshot is using the same cow block device that the
+	 * handover-destination will use.
+	 *
+	 * The handover-destination snapshot identifies the
+	 * handover-source using find_snapshot_using_cow.
+	 *
+	 * 'is_handover_source' is set in snapshot_ctr if an existing
+	 * snapshot has the same cow device. The handover is performed,
+	 * and 'is_handover_source' is cleared, when the
+	 * handover-destination snapshot is resumed.
+	 */
+	int is_handover_source;
+
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -350,7 +366,7 @@ static void unregister_snapshot(struct d
 	o = __lookup_origin(s->origin->bdev);
 
 	list_del(&s->list);
-	if (list_empty(&o->snapshots)) {
+	if (o && list_empty(&o->snapshots)) {
 		list_del(&o->hash_list);
 		kfree(o);
 	}
@@ -528,6 +544,31 @@ static int dm_add_exception(void *contex
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
@@ -603,7 +644,7 @@ static int init_hash_tables(struct dm_sn
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	struct dm_snapshot *s;
+	struct dm_snapshot *s, *handover_snap;
 	int i;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
@@ -659,7 +700,9 @@ static int snapshot_ctr(struct dm_target
 	s->active = 0;
 	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
+	s->is_handover_source = 0;
 	init_rwsem(&s->lock);
+	INIT_LIST_HEAD(&s->list);
 	spin_lock_init(&s->pe_lock);
 
 	/* Allocate hash table for COW data */
@@ -694,6 +737,30 @@ static int snapshot_ctr(struct dm_target
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
+	/* Does snapshot need exceptions handed over to it? */
+	handover_snap = find_snapshot_using_cow(s);
+	if (handover_snap) {
+		down_write(&handover_snap->lock);
+		if (handover_snap->is_handover_source) {
+			ti->error = "Unable to handover snapshot to "
+				    "two devices at once.";
+			up_write(&handover_snap->lock);
+			goto bad_load_and_register;
+		}
+		handover_snap->is_handover_source = 1;
+		up_write(&handover_snap->lock);
+	}
+
+	bio_list_init(&s->queued_bios);
+	INIT_WORK(&s->queued_bios_work, flush_queued_bios);
+
+	ti->private = s;
+	ti->num_flush_requests = 1;
+
+	if (handover_snap)
+		/* defer register_snapshot until after handover_exceptions */
+		return 0;
+
 	/* Metadata must only be loaded into one table at once */
 	r = s->store->type->read_metadata(s->store, dm_add_exception,
 					  (void *)s);
@@ -705,13 +772,11 @@ static int snapshot_ctr(struct dm_target
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
@@ -721,10 +786,6 @@ static int snapshot_ctr(struct dm_target
 		goto bad_load_and_register;
 	}
 
-	ti->private = s;
-	ti->split_io = s->store->chunk_size;
-	ti->num_flush_requests = 1;
-
 	return 0;
 
 bad_load_and_register:
@@ -765,15 +826,68 @@ static void __free_exceptions(struct dm_
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
+	BUG_ON((snap_src->is_handover_source != 1) ||
+	       (snap_dest->is_handover_source != 0));
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
+	snap_src->is_handover_source = 0;
+}
+
 static void snapshot_dtr(struct dm_target *ti)
 {
 #ifdef CONFIG_DM_DEBUG
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src = NULL;
 
 	flush_workqueue(ksnapd);
 
+	/* Check if exception handover must be cancelled */
+	snap_src = find_snapshot_using_cow(s);
+	if (snap_src) {
+		down_write(&snap_src->lock);
+		if (!snap_src->is_handover_source) {
+			up_write(&snap_src->lock);
+			goto normal_snapshot;
+		}
+		if (s == snap_src) {
+			DMERR("Unable to handover exceptions to another "
+			      "snapshot from dtr, cancelling handover.");
+			snap_src->valid = 0;
+		}
+		/* allow table_clear to cancel handover */
+		snap_src->is_handover_source = 0;
+		up_write(&snap_src->lock);
+	}
+
+normal_snapshot:
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1186,9 +1300,69 @@ static void snapshot_presuspend(struct d
 	up_write(&s->lock);
 }
 
+static int snapshot_preresume(struct dm_target *ti)
+{
+	int r = 0;
+	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src = NULL;
+
+	snap_src = find_snapshot_using_cow(s);
+	if (snap_src) {
+		down_write(&snap_src->lock);
+		if (!snap_src->is_handover_source) {
+			up_write(&snap_src->lock);
+			goto normal_snapshot;
+		}
+		if (s == snap_src) {
+			/* handover source must not resume before destination */
+			DMERR("Unable to handover exceptions on "
+			      "resume of source snapshot.\n"
+			      "Deferring handover until destination "
+			      "snapshot is resumed.");
+			r = -EINVAL;
+		} else {
+			/* if handover-destination, source must be suspended */
+			if (!snap_src->suspended) {
+				DMERR("Unable to accept exceptions from a "
+				      "snapshot that is not suspended.");
+				r = -EINVAL;
+			}
+		}
+		up_write(&snap_src->lock);
+	}
+
+normal_snapshot:
+	return r;
+}
+
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
+	struct dm_snapshot *snap_src = NULL;
+	struct dm_snapshot *snap_dest = NULL;
+
+	/* Check if snapshot needs exceptions handed over to it */
+	snap_src = find_snapshot_using_cow(s);
+	if (snap_src) {
+		down_write(&snap_src->lock);
+		if (snap_src->is_handover_source) {
+			BUG_ON(s == snap_src);
+			snap_dest = s;
+			down_write(&snap_dest->lock);
+			/* Get exception store from another snapshot */
+			handover_exceptions(snap_src, snap_dest);
+			up_write(&snap_dest->lock);
+		}
+		up_write(&snap_src->lock);
+
+		if (snap_dest && register_snapshot(snap_dest)) {
+			DMERR("Unable to register snapshot "
+			      "after exception handover.");
+			down_write(&snap_dest->lock);
+			snap_dest->valid = 0;
+			up_write(&snap_dest->lock);
+		}
+	}
 
 	down_write(&s->lock);
 	s->active = 1;
@@ -1506,6 +1680,7 @@ static struct target_type snapshot_targe
 	.map     = snapshot_map,
 	.end_io  = snapshot_end_io,
 	.presuspend = snapshot_presuspend,
+	.preresume  = snapshot_preresume,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
 	.iterate_devices = snapshot_iterate_devices,
