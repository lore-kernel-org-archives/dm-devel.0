From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 19 of 33] DM Exception Store: add
	lookup_exception to API
Date: Wed, 25 Mar 2009 16:36:46 -0500
Message-ID: <200903252136.n2PLakNw021952@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-add-lookup_exception-to-API.patch

Now that the exception store implementations are capable of
caching the exceptions on their own, we need a new function
added to the API to allow us to lookup the exceptions.

Adding 'lookup_exception' to the exception store API.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -58,6 +58,18 @@ struct dm_exception_store_type {
 				  void *callback_context);
 
 	/*
+	 * Look up an exception.  Common errors include:
+	 * -ENOENT     : exception not found
+	 * -EWOULDBLOCK: blocking op required and can_block=0
+	 *
+	 * If 'new_chunk' is NULL, the caller simply wants to
+	 * know if the exception exists (0) or not (-ENOENT).
+	 */
+	int (*lookup_exception) (struct dm_exception_store *store,
+				 chunk_t old, chunk_t *new_chunk,
+				 int can_block);
+
+	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
 	void (*drop_snapshot) (struct dm_exception_store *store);
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -721,6 +721,23 @@ static void persistent_commit_exception(
 	ps->callback_count = 0;
 }
 
+static int persistent_lookup_exception(struct dm_exception_store *store,
+				       chunk_t old, chunk_t *new_chunk,
+				       int can_block)
+{
+	struct pstore *ps = get_info(store);
+	struct dm_exception *e;
+
+	e = dm_lookup_exception(ps->table, old);
+	if (!e)
+		return -ENOENT;
+
+	if (new_chunk)
+		*new_chunk = e->new_chunk + (old - e->old_chunk);
+
+	return 0;
+}
+
 static void persistent_drop_snapshot(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
@@ -813,6 +830,7 @@ static struct dm_exception_store_type _p
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.lookup_exception = persistent_lookup_exception,
 	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
@@ -827,6 +845,7 @@ static struct dm_exception_store_type _p
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.lookup_exception = persistent_lookup_exception,
 	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -94,6 +94,23 @@ static void transient_commit_exception(s
 	callback(callback_context, 1);
 }
 
+static int transient_lookup_exception(struct dm_exception_store *store,
+				      chunk_t old, chunk_t *new_chunk,
+				      int can_block)
+{
+	struct transient_c *tc = store->context;
+	struct dm_exception *e;
+
+	e = dm_lookup_exception(tc->table, old);
+	if (!e)
+		return -ENOENT;
+
+	if (new_chunk)
+		*new_chunk = e->new_chunk + (old - e->old_chunk);
+
+	return 0;
+}
+
 static void transient_fraction_full(struct dm_exception_store *store,
 				    sector_t *numerator, sector_t *denominator)
 {
@@ -165,6 +182,7 @@ static struct dm_exception_store_type _t
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
+	.lookup_exception = transient_lookup_exception,
 	.fraction_full = transient_fraction_full,
 	.status = transient_status,
 };
@@ -178,6 +196,7 @@ static struct dm_exception_store_type _t
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
+	.lookup_exception = transient_lookup_exception,
 	.fraction_full = transient_fraction_full,
 	.status = transient_status,
 };
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -963,15 +963,12 @@ __find_pending_exception(struct dm_snaps
 	return pe;
 }
 
-static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
-			    struct bio *bio, chunk_t chunk)
+static void remap_exception(struct dm_snapshot *s, struct bio *bio,
+			    chunk_t chunk)
 {
 	bio->bi_bdev = s->store->cow->bdev;
-	bio->bi_sector = chunk_to_sector(s->store,
-					 dm_chunk_number(e->new_chunk) +
-					 (chunk - e->old_chunk)) +
-					 (bio->bi_sector &
-					  s->store->chunk_mask);
+	bio->bi_sector = chunk_to_sector(s->store, dm_chunk_number(chunk)) +
+		(bio->bi_sector & s->store->chunk_mask);
 }
 
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
@@ -979,8 +976,8 @@ static int snapshot_map(struct dm_target
 {
 	struct dm_exception *e, *tmp_e;
 	struct dm_snapshot *s = ti->private;
-	int r = DM_MAPIO_REMAPPED;
-	chunk_t chunk;
+	int rtn, r = DM_MAPIO_REMAPPED;
+	chunk_t chunk, new_chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
 	chunk = sector_to_chunk(s->store, bio->bi_sector);
@@ -1000,13 +997,20 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = dm_lookup_exception(s->complete, chunk);
-	if (e) {
-		remap_exception(s, e, bio, chunk);
+	rtn = s->store->type->lookup_exception(s->store, chunk, &new_chunk, 0);
+	if (!rtn) {
+		remap_exception(s, bio, new_chunk);
 		goto out_unlock;
 	}
 
 	/*
+	 * Could be -EWOULDBLOCK, but we don't handle that yet
+	 * and there are currently no exception store
+	 * implementations that would require us to.
+	 */
+	BUG_ON(rtn != -ENOENT);
+
+	/*
 	 * Write to snapshot - higher level takes care of RW/RO
 	 * flags so we should only get this if we are
 	 * writeable.
@@ -1025,11 +1029,11 @@ static int snapshot_map(struct dm_target
 				r = -EIO;
 				goto out_unlock;
 			}
-
-			e = dm_lookup_exception(&s->complete, chunk);
-			if (e) {
+			rtn = s->store->type->lookup_exception(s->store, chunk,
+							       &new_chunk, 0);
+			if (!rtn) {
 				dm_free_exception(s->pending, &pe->e);
-				remap_exception(s, e, bio, chunk);
+				remap_exception(s, bio, new_chunk);
 				goto out_unlock;
 			}
 
@@ -1041,7 +1045,7 @@ static int snapshot_map(struct dm_target
 			}
 		}
 
-		remap_exception(s, &pe->e, bio, chunk);
+		remap_exception(s, bio, pe->e.new_chunk);
 		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
@@ -1142,7 +1146,7 @@ static int snapshot_status(struct dm_tar
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
 	struct dm_exception *e, *tmp_e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
@@ -1176,10 +1180,18 @@ static int __origin_write(struct list_he
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = dm_lookup_exception(snap->complete, chunk);
-		if (e)
+		rtn = snap->store->type->lookup_exception(snap->store, chunk,
+							  NULL, 0);
+		if (!rtn)
 			goto next_snapshot;
 
+		/*
+		 * 'rtn' could be -EWOULDBLOCK, but we don't handle that yet
+		 * and there are currently no exception store implementations
+		 * that would require us to.
+		 */
+		BUG_ON(rtn != -ENOENT);
+
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
 			up_write(&snap->lock);
@@ -1193,8 +1205,10 @@ static int __origin_write(struct list_he
 				goto next_snapshot;
 			}
 
-			e = dm_lookup_exception(&snap->complete, chunk);
-			if (e) {
+			rtn = snap->store->type->lookup_exception(snap->store,
+								  chunk, NULL,
+								  0);
+			if (!rtn) {
 				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
 			}
