From: Mike Snitzer <snitzer@redhat.com>
Subject: Re: dm snapshot: allow live exception store handover
	between tables
Date: Fri, 6 Nov 2009 13:46:42 -0500
Message-ID: <20091106184642.GC13427@redhat.com>
References: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1257532814-17100-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Alasdair G Kergon <agk@redhat.com>, Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

On Fri, Nov 06 2009 at  1:40pm -0500,
Mike Snitzer <snitzer@redhat.com> wrote:

> Permit in-use snapshot exception data to be 'handed over' from one
> snapshot instance to another.  This is a pre-requisite for patches
> that allow the changes made in a snapshot device to be merged back into
> its origin device and also allows device resizing.
> 
> The basic call sequence is:
> 
>   dmsetup load new_snapshot (referencing the existing in-use cow device)
>      - the ctr code detects that the cow is already in use and links the
>        two snapshot target instances together
>   dmsetup suspend original_snapshot
>   dmsetup resume new_snapshot
>      - the new_snapshot becomes live, and if anything now tries to access
>        the original one it will receive EIO
>   dmsetup remove original_snapshot
> 
> (There can only be two snapshot targets referencing the same cow device
> simultaneously.)
> 
> Signed-off-by: Mike Snitzer <snitzer@redhat.com>
> Cc: Mikulas Patocka <mpatocka@redhat.com>

Mikulas,

I removed your 'Signed-off-by' because handover has changed considerably
from your initial version.  Please review the new patch and reply with
the appropriate tag of your chosing.

Alasdair,

Here is the incremental patch that illustrates the relevant changes that
I layered ontop of the current patch you have in your tree.

. changed snapshot_ctr() to avoid read_metadata entirely for
  snapshot-merge (unnecessary if handover will occur)
  - adjusted a few other things in snapshot_ctr to accomodate early
    return in the case of handover

. new snapshot's ti->split_io is now reset in handover_exceptions() to
  match the chunk_size of the store that was just handed over

. register_snapshot() for snapshot-merge snapshot is now done after
  handover_exceptions rather than in snapshot_ctr()
  - not done in handover_exceptions() to avoid lock order issues between
    s->lock and _origins_lock

. remove support for old->resume handover
  - now that snapshot_ctr no longer does read_metadata() this is no
    longer needed to support 'lvchange --refresh'

. allow table_clear to cancel handover (in snapshot_dtr)

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |  115 +++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 88 insertions(+), 27 deletions(-)

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -644,7 +644,7 @@ static int init_hash_tables(struct dm_sn
 }
 
 /*
- * Reserve snap_source for handover to snap_dest.
+ * Reserve snap_src for handover to snap_dest.
  */
 static int link_snapshots_for_handover(struct dm_snapshot *snap_src,
 				       struct dm_snapshot *snap_dest)
@@ -670,6 +670,33 @@ out:
 }
 
 /*
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
@@ -778,6 +805,16 @@ static int snapshot_ctr(struct dm_target
 		}
 	}
 
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
@@ -789,13 +826,11 @@ static int snapshot_ctr(struct dm_target
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
@@ -805,10 +840,6 @@ static int snapshot_ctr(struct dm_target
 		goto bad_load_and_register;
 	}
 
-	ti->private = s;
-	ti->split_io = s->store->chunk_size;
-	ti->num_flush_requests = 1;
-
 	return 0;
 
 bad_load_and_register:
@@ -863,6 +894,15 @@ static void handover_exceptions(struct d
 	       (new->is_handover_destination != 1));
 	BUG_ON(!old->suspended);
 
+	/* make sure old snapshot is still valid */
+	if (!old->valid) {
+		new->valid = 0;
+		DMERR("Unable to handover exceptions "
+		      "from an invalid snapshot.");
+		return;
+	}
+
+	/* swap exceptions tables and stores */
 	u.table_swap = new->complete;
 	new->complete = old->complete;
 	old->complete = u.table_swap;
@@ -873,6 +913,10 @@ static void handover_exceptions(struct d
 	new->store->snap = new;
 	old->store->snap = old;
 
+	/* reset split_io to store's chunk_size */
+	if (new->ti->split_io != new->store->chunk_size)
+		new->ti->split_io = new->store->chunk_size;
+
 	/* Mark old snapshot invalid and inactive */
 	old->valid = 0;
 	old->active = 0;
@@ -890,23 +934,36 @@ static void snapshot_dtr(struct dm_targe
 	int i;
 #endif
 	struct dm_snapshot *s = ti->private;
-	struct dm_snapshot *new_snap;
+	struct dm_snapshot *new_snap = NULL;
 
 	flush_workqueue(ksnapd);
 
 	/* This snapshot may need to handover its exception store */
 	down_write(&s->lock);
 	if (s->handover_snap) {
-		new_snap = s->handover_snap;
+		if (!s->is_handover_destination) {
+			/* Handover exceptions to another snapshot */
+			new_snap = s->handover_snap;
 
-		down_write_nested(&new_snap->lock, SINGLE_DEPTH_NESTING);
-		handover_exceptions(s, new_snap);
-		up_write(&new_snap->lock);
+			down_write_nested(&new_snap->lock,
+					  SINGLE_DEPTH_NESTING);
+			handover_exceptions(s, new_snap);
+			up_write(&new_snap->lock);
+		} else {
+			/* allow table_clear to cancel handover */
+			unlink_snapshots_for_handover(s->handover_snap, s);
+		}
 	}
 	/* An incomplete exception handover is not allowed */
 	BUG_ON(s->handover_snap);
 	up_write(&s->lock);
 
+	if (new_snap && register_snapshot(new_snap)) {
+		DMERR("Unable to register snapshot "
+		      "after exception handover.");
+		new_snap->valid = 0;
+	}
+
 	/* Prevent further origin writes from using this snapshot. */
 	/* After this returns there can be no new kcopyd jobs. */
 	unregister_snapshot(s);
@@ -1322,33 +1379,37 @@ static void snapshot_presuspend(struct d
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
-	struct dm_snapshot *old_snap, *new_snap, *lock_snap;
+	struct dm_snapshot *old_snap, *new_snap = NULL;
 
 	down_write(&s->lock);
 	if (s->handover_snap) {
-		/*
-		 * Initially assumes this snapshot will get
-		 * exception store from another snapshot
-		 */
+		if (!s->is_handover_destination) {
+			DMERR("Unable to handover exceptions to "
+			      "another snapshot on resume.");
+			goto out;
+		}
+		/* Get exception store from another snapshot */
 		old_snap = s->handover_snap;
 		new_snap = s;
-		lock_snap = old_snap;
 
-		if (!s->is_handover_destination) {
-			/* Handover exceptions to another snapshot */
-			old_snap = s;
-			new_snap = s->handover_snap;
-			lock_snap = new_snap;
-		}
-		down_write_nested(&lock_snap->lock,
+		down_write_nested(&old_snap->lock,
 				  SINGLE_DEPTH_NESTING);
 		handover_exceptions(old_snap, new_snap);
-		up_write(&lock_snap->lock);
+		up_write(&old_snap->lock);
 	}
 	/* An incomplete exception handover is not allowed */
 	BUG_ON(s->handover_snap);
+
+	if (new_snap && register_snapshot(new_snap)) {
+		DMERR("Unable to register snapshot "
+		      "after exception handover.");
+		new_snap->valid = 0;
+		goto out;
+	}
+
 	s->active = 1;
 	s->suspended = 0;
+out:
 	up_write(&s->lock);
 }
 
