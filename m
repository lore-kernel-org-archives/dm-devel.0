From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 04/17] dm snapshot: exception handover
	improvements
Date: Fri, 23 Oct 2009 12:15:53 -0400
Message-ID: <20091023161553.GA2651@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

Simplify exception handover so that the duplicate snapshot is found in
one location (snapshot_ctr) and recorded in the associated (old and new)
snapshots that will be participating in the handover.

Confines handover to be from a specific snapshot to another specific
snapshot without additional __find_duplicate() calls.

Documents the exception handover state diagram with relevant comments
in the associated code.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Mikulas Patocka <mpatocka@redhat.com>
Cc: Jonathan Brassow <jbrassow@redhat.com>
---
 drivers/md/dm-snap.c |  103 ++++++++++++++++++++++++++++++++++-----------------
 1 file changed, 70 insertions(+), 33 deletions(-)

Index: linux-2.6-dev/drivers/md/dm-snap.c
===================================================================
--- linux-2.6-dev.orig/drivers/md/dm-snap.c
+++ linux-2.6-dev/drivers/md/dm-snap.c
@@ -75,9 +75,26 @@ struct dm_snapshot {
 	/* Set if the parent device is suspended */
 	int suspended;
 
-	/* Exception store will be handed over from another snapshot */
+	/*
+	 * 'handover' denotes exception store will be handed over from
+	 * another snapshot with the same cow block device (as identified
+	 * with __find_duplicate).
+	 *
+	 * 'handover' is set during a new snapshot's constructor if it finds
+	 * a single old snapshot is using the same cow block device as it.
+	 * Handover operation is performed, and 'handover' is cleared,
+	 * when either of the following occurs:
+	 * - old snapshot, that is handing over, is destructed
+	 * - new snapshot, that is accepting the handover, is resumed
+	 */
 	int handover;
 
+	/*
+	 * reference to the other snapshot that will participate in the
+	 * exception store handover; new references old, old references new
+	 */
+	struct dm_snapshot *handover_snap;
+
 	mempool_t *pending_pool;
 
 	atomic_t pending_exceptions_count;
@@ -510,7 +527,8 @@ static int dm_add_exception(void *contex
 }
 
 /* _origins_lock must be held */
-static struct dm_snapshot *__find_duplicate(struct dm_snapshot *snap)
+static struct dm_snapshot *__find_duplicate(struct dm_snapshot *snap,
+					    int *duplicate_count)
 {
 	struct dm_snapshot *dup;
 	struct dm_snapshot *l;
@@ -521,16 +539,13 @@ static struct dm_snapshot *__find_duplic
 		return NULL;
 
 	dup = NULL;
+	*duplicate_count = 0;
 	list_for_each_entry(l, &o->snapshots, list)
 		if (l != snap && bdev_equal(l->cow->bdev,
 					    snap->cow->bdev)) {
-			if (!dup) {
+			if (!dup)
 				dup = l;
-			} else {
-				DMERR("Multiple active duplicates, "
-				      "user misuses dmsetup.");
-				return NULL;
-			}
+			(*duplicate_count)++;
 		}
 
 	return dup;
@@ -611,8 +626,8 @@ static int init_hash_tables(struct dm_sn
  */
 static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 {
-	struct dm_snapshot *s;
-	int i;
+	struct dm_snapshot *s, *dup;
+	int i, duplicate_count = 0;
 	int r = -EINVAL;
 	char *origin_path, *cow_path;
 	unsigned args_used;
@@ -668,6 +683,7 @@ static int snapshot_ctr(struct dm_target
 	s->suspended = 0;
 	atomic_set(&s->pending_exceptions_count, 0);
 	s->handover = 0;
+	s->handover_snap = NULL;
 	init_rwsem(&s->lock);
 	spin_lock_init(&s->pe_lock);
 
@@ -703,10 +719,26 @@ static int snapshot_ctr(struct dm_target
 
 	spin_lock_init(&s->tracked_chunk_lock);
 
+	/* Snapshot may need to have exceptions handed over to it */
+	r = -EINVAL;
 	down_read(&_origins_lock);
-	if (__find_duplicate(s))
-		s->handover = 1;
+	dup = __find_duplicate(s, &duplicate_count);
 	up_read(&_origins_lock);
+	if (dup) {
+		if (duplicate_count > 1) {
+			ti->error = "More than one other snapshot has been "
+				    "constructed with the same cow device.";
+			goto bad_load_and_register;
+		}
+		/* cross reference snapshots that will do handover */
+		down_write(&dup->lock);
+		dup->handover_snap = s;
+		up_write(&dup->lock);
+		s->handover_snap = dup;
+
+		/* this new snapshot will accept the handover */
+		s->handover = 1;
+	}
 
 	/* Metadata must only be loaded into one table at once */
 	r = s->store->type->read_metadata(s->store, dm_add_exception,
@@ -787,6 +819,11 @@ static void handover_exceptions(struct d
 		struct dm_exception_store *store_swap;
 	} u;
 
+	BUG_ON((old->handover_snap != new) ||
+	       (new->handover_snap != old));
+	BUG_ON((old->handover != 0) || (new->handover != 1));
+	BUG_ON(!old->suspended);
+
 	u.table_swap = new->complete;
 	new->complete = old->complete;
 	old->complete = u.table_swap;
@@ -797,7 +834,14 @@ static void handover_exceptions(struct d
 	new->store->snap = new;
 	old->store->snap = old;
 
+	/* Mark old snapshot invalid and inactive */
+	old->valid = 0;
 	old->active = 0;
+
+	/* Reset handover_snap references */
+	old->handover_snap = NULL;
+	new->handover_snap = NULL;
+
 	new->handover = 0;
 }
 
@@ -807,20 +851,18 @@ static void snapshot_dtr(struct dm_targe
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
-	struct dm_snapshot *dup;
 
 	flush_workqueue(ksnapd);
 
-	down_write(&_origins_lock);
+	/* This snapshot may need to handover its exception store */
 	down_write(&s->lock);
-	dup = __find_duplicate(s);
-	if (dup && dup->handover) {
-		down_write_nested(&dup->lock, SINGLE_DEPTH_NESTING);
-		handover_exceptions(s, dup);
-		up_write(&dup->lock);
+	if (s->handover_snap) {
+		struct dm_snapshot *new_snap = s->handover_snap;
+		down_write_nested(&new_snap->lock, SINGLE_DEPTH_NESTING);
+		handover_exceptions(s, new_snap);
+		up_write(&new_snap->lock);
 	}
 	up_write(&s->lock);
-	up_write(&_origins_lock);
 
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
@@ -1225,25 +1267,20 @@ static void snapshot_resume(struct dm_ta
 {
 	struct dm_snapshot *s = ti->private;
 
-	down_write(&_origins_lock);
 	down_write(&s->lock);
 	if (s->handover) {
-		struct dm_snapshot *dup;
-		dup = __find_duplicate(s);
-		if (!dup) {
-			DMERR("duplicate not found");
-			s->valid = 0;
-			goto ret;
-		}
-		down_write_nested(&dup->lock, SINGLE_DEPTH_NESTING);
-		handover_exceptions(dup, s);
-		up_write(&dup->lock);
+		/* Get exception store from another snapshot */
+		struct dm_snapshot *old_snap = s->handover_snap;
+		BUG_ON(!old_snap);
+		down_write_nested(&old_snap->lock, SINGLE_DEPTH_NESTING);
+		handover_exceptions(old_snap, s);
+		up_write(&old_snap->lock);
 	}
+	/* An incomplete exception handover is not allowed */
+	BUG_ON(s->handover || s->handover_snap);
 	s->active = 1;
 	s->suspended = 0;
- ret:
 	up_write(&s->lock);
-	up_write(&_origins_lock);
 }
 
 static int snapshot_status(struct dm_target *ti, status_type_t type,
