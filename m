From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 02/10] dm snapshot: Track snapshot reads
Date: Tue,  1 Apr 2008 09:32:49 +0200
Message-ID: <1207035177-7156-3-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-2-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Once a read request for an unmodified chunk in a snapshot has been
passed to the underlying original device, it is no longer tracked.

If, subsequently, a write is issued to the snapshot origin for the
same blocks, the code knows nothing about the outstanding read. It
blithely goes ahead and copies the original data across to the COW
device and submits the write request to the original device.

It does not wait for the read to complete first, so if the read from
the snapshot got delayed for any reason it could return changed data
from the origin write! Fortunately this is very rare because the read
is simple and quick but the write involves a series of slow steps.

This patch addresses the problem by adding code to track reads from
snapshot devices.

The pending_exception structure, which previously was only used for
tracking uncommitted writes, is now also used to track reads that get
mapped to original device.

The ref_count variable now keeps track of outstanding reads against
the snapshot, in addition to the already tracked number of chunks in
the process of being copied to the COW device. This prevents
pending_complete() from submitting origin writes to the original
device until all reads have been completed.

Device-mapper offers us private per-bio storage in map_context->ptr,
so we store the pending_exception structure there when mapping the bio
so we can retrieve it in our end_io function.

When the snapshot read is complete, snapshot_end_io will be called.
If there are no more snapshot reads outstanding, and the chunk is not
in the process of being copied to any COW device, then all pending
origin writes are queued for ksnapd to flush.

The scope of the pe_lock spinlock is expanded to protect ref_count,
the pending exception table and the origin_bios list to allow for
snapshot_end_io() to run concurrently in interrupt context.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |  151 +++++++++++++++++++++++++++++++++-----------------
 1 files changed, 101 insertions(+), 50 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index ae24eab..3b71f53 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -67,7 +67,8 @@ struct dm_snap_pending_exception {
 	struct dm_snap_pending_exception *primary_pe;
 
 	/*
-	 * Number of pending_exceptions processing this chunk.
+	 * Number of exception copies or snapshot reads pending on
+	 * this chunk.
 	 * When this drops to zero we must complete the origin bios.
 	 * If incrementing or decrementing this, hold pe->snap->lock for
 	 * the sibling concerned and not pe->primary_pe->snap->lock unless
@@ -705,12 +706,18 @@ static void __invalidate_snapshot(struct dm_snapshot *s, int err)
 static void get_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	atomic_inc(&pe->ref_count);
+	if (pe->primary_pe && pe->primary_pe != pe)
+		atomic_inc(&pe->primary_pe->ref_count);
 }
 
 static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 {
+	struct dm_snapshot *s = pe->snap;
 	struct dm_snap_pending_exception *primary_pe;
 	struct bio *origin_bios = NULL;
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->pe_lock, flags);
 
 	primary_pe = pe->primary_pe;
 
@@ -727,14 +734,21 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	 * Free the pe if it's not linked to an origin write or if
 	 * it's not itself a primary pe.
 	 */
-	if (!primary_pe || primary_pe != pe)
+	if ((!primary_pe || primary_pe != pe) &&
+	    atomic_dec_and_test(&pe->ref_count)) {
+		remove_exception(&pe->e);
 		free_pending_exception(pe);
+	}
 
 	/*
 	 * Free the primary pe if nothing references it.
 	 */
-	if (primary_pe && !atomic_read(&primary_pe->ref_count))
+	if (primary_pe && !atomic_read(&primary_pe->ref_count)) {
+		remove_exception(&primary_pe->e);
 		free_pending_exception(primary_pe);
+	}
+
+	spin_unlock_irqrestore(&s->pe_lock, flags);
 
 	return origin_bios;
 }
@@ -778,7 +792,6 @@ static void pending_complete(struct dm_snap_pending_exception *pe, int success)
 	insert_completed_exception(s, e);
 
  out:
-	remove_exception(&pe->e);
 	snapshot_bios = bio_list_get(&pe->snapshot_bios);
 	origin_bios = put_pending_exception(pe);
 
@@ -857,6 +870,9 @@ __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe;
 	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
+	unsigned long flags;
+
+	spin_lock_irqsave(&s->pe_lock, flags);
 
 	/*
 	 * Is there a pending exception for this already ?
@@ -865,27 +881,30 @@ __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 	if (e) {
 		/* cast the exception to a pending exception */
 		pe = container_of(e, struct dm_snap_pending_exception, e);
-		goto out;
+		goto ref_and_out;
 	}
 
 	/*
 	 * Create a new pending exception, we don't want
 	 * to hold the lock while we do this.
 	 */
+	spin_unlock_irqrestore(&s->pe_lock, flags);
 	up_write(&s->lock);
 	pe = alloc_pending_exception();
 	down_write(&s->lock);
+	spin_lock_irqsave(&s->pe_lock, flags);
 
 	if (!s->valid) {
 		free_pending_exception(pe);
-		return NULL;
+		pe = NULL;
+		goto out;
 	}
 
 	e = lookup_exception(&s->pending, chunk);
 	if (e) {
 		free_pending_exception(pe);
 		pe = container_of(e, struct dm_snap_pending_exception, e);
-		goto out;
+		goto ref_and_out;
 	}
 
 	pe->e.old_chunk = chunk;
@@ -896,15 +915,23 @@ __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 	pe->snap = s;
 	pe->started = 0;
 
-	if (s->store.prepare_exception(&s->store, &pe->e)) {
-		free_pending_exception(pe);
-		return NULL;
-	}
-
-	get_pending_exception(pe);
 	insert_exception(&s->pending, &pe->e);
 
+ ref_and_out:
+	if (bio_rw(bio) != WRITE)
+		get_pending_exception(pe);
+	else if (!pe->started) {
+		if (s->store.prepare_exception(&s->store, &pe->e)) {
+			free_pending_exception(pe);
+			pe = NULL;
+			goto out;
+		}
+		get_pending_exception(pe);
+	}
+
  out:
+	spin_unlock_irqrestore(&s->pe_lock, flags);
+
 	return pe;
 }
 
@@ -949,39 +976,29 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 		goto out_unlock;
 	}
 
-	/*
-	 * Write to snapshot - higher level takes care of RW/RO
-	 * flags so we should only get this if we are
-	 * writeable.
-	 */
-	if (bio_rw(bio) == WRITE) {
-		pe = __find_pending_exception(s, bio);
-		if (!pe) {
-			__invalidate_snapshot(s, -ENOMEM);
-			r = -EIO;
-			goto out_unlock;
-		}
+	pe = __find_pending_exception(s, bio);
+	if (!pe) {
+		__invalidate_snapshot(s, -ENOMEM);
+		r = -EIO;
+		goto out_unlock;
+	}
 
+	if (bio_rw(bio) == WRITE) {
 		remap_exception(s, &pe->e, bio, chunk);
 		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
 
 		if (!pe->started) {
-			/* this is protected by snap->lock */
 			pe->started = 1;
 			up_write(&s->lock);
 			start_copy(pe);
 			goto out;
 		}
-	} else
-		/*
-		 * FIXME: this read path scares me because we
-		 * always use the origin when we have a pending
-		 * exception.  However I can't think of a
-		 * situation where this is wrong - ejt.
-		 */
+	} else {
 		bio->bi_bdev = s->origin->bdev;
+		map_context->ptr = pe;
+	}
 
  out_unlock:
 	up_write(&s->lock);
@@ -989,6 +1006,36 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	return r;
 }
 
+static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
+			   int error, union map_info *map_context)
+{
+	struct dm_snapshot *s = ti->private;
+	struct dm_snap_pending_exception *pe = map_context->ptr;
+	struct bio *flush;
+	unsigned long flags;
+
+	if (bio_rw(bio) == WRITE || !pe)
+		return error;
+
+	flush = put_pending_exception(pe);
+	if (!flush)
+		return error;
+
+	spin_lock_irqsave(&s->pe_lock, flags);
+
+	while (flush) {
+		struct bio *next = flush->bi_next;
+		bio_list_add(&s->queued_bios, flush);
+		flush = next;
+	}
+
+	queue_work(ksnapd, &s->queued_bios_work);
+
+	spin_unlock_irqrestore(&s->pe_lock, flags);
+
+	return error;
+}
+
 static void snapshot_resume(struct dm_target *ti)
 {
 	struct dm_snapshot *s = ti->private;
@@ -1043,11 +1090,12 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int r = DM_MAPIO_REMAPPED;
 	struct dm_snapshot *snap;
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
+	unsigned long flags;
 	LIST_HEAD(pe_queue);
 
 	/* Do all the snapshots on this origin */
@@ -1073,9 +1121,6 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		 * Check exception table to see if block
 		 * is already remapped in this snapshot
 		 * and trigger an exception if not.
-		 *
-		 * ref_count is initialised to 1 so pending_complete()
-		 * won't destroy the primary_pe while we're inside this loop.
 		 */
 		e = lookup_exception(&snap->complete, chunk);
 		if (e)
@@ -1087,6 +1132,8 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			goto next_snapshot;
 		}
 
+		spin_lock_irqsave(&snap->pe_lock, flags);
+
 		if (!primary_pe) {
 			/*
 			 * Either every pe here has same
@@ -1094,10 +1141,15 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			 */
 			if (pe->primary_pe)
 				primary_pe = pe->primary_pe;
-			else {
+			else
 				primary_pe = pe;
-				first = 1;
-			}
+
+			/*
+			 * we take a ref here so primary_pe won't
+			 * be destroyed while we're inside this
+			 * loop.
+			 */
+			get_pending_exception(primary_pe);
 
 			bio_list_add(&primary_pe->origin_bios, bio);
 
@@ -1106,9 +1158,14 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 
 		if (!pe->primary_pe) {
 			pe->primary_pe = primary_pe;
-			get_pending_exception(primary_pe);
+			atomic_inc(&pe->ref_count);
+			if (primary_pe != pe)
+				atomic_add(atomic_read(&pe->ref_count),
+					   &primary_pe->ref_count);
 		}
 
+		spin_unlock_irqrestore(&snap->pe_lock, flags);
+
 		if (!pe->started) {
 			pe->started = 1;
 			list_add_tail(&pe->list, &pe_queue);
@@ -1122,18 +1179,11 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		return r;
 
 	/*
-	 * If this is the first time we're processing this chunk and
-	 * ref_count is now 1 it means all the pending exceptions
+	 * If ref_count is now 1 it means all the pending exceptions
 	 * got completed while we were in the loop above, so it falls to
 	 * us here to remove the primary_pe and submit any origin_bios.
 	 */
-
-	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
-		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
-		/* If we got here, pe_queue is necessarily empty. */
-		return r;
-	}
+	flush_bios(put_pending_exception(primary_pe));
 
 	/*
 	 * Now that we have a complete pe list we can start the copying.
@@ -1266,6 +1316,7 @@ static struct target_type snapshot_target = {
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
 	.map     = snapshot_map,
+	.end_io  = snapshot_end_io,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
 };
-- 
1.5.4.1
