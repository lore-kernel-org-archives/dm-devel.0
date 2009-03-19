From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 16 of 30] DM Exception Store: add
	lookup_exception to API
Date: Thu, 19 Mar 2009 16:35:17 -0500
Message-ID: <200903192135.n2JLZH9h007540@hydrogen.msp.redhat.com>
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
@@ -979,24 +979,19 @@ out:
 	return pe;
 }
 
-static void remap_exception(struct dm_snapshot *s, struct dm_exception *e,
-			    struct bio *bio, chunk_t chunk)
+static void remap_exception(struct dm_snapshot *s, struct bio *bio, chunk_t chunk)
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
 			union map_info *map_context)
 {
-	struct dm_exception *e;
 	struct dm_snapshot *s = ti->private;
-	int r = DM_MAPIO_REMAPPED;
-	chunk_t chunk;
+	int rtn, r = DM_MAPIO_REMAPPED;
+	chunk_t chunk, new_chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
 	chunk = sector_to_chunk(s->store, bio->bi_sector);
@@ -1016,13 +1011,20 @@ static int snapshot_map(struct dm_target
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
@@ -1035,7 +1037,7 @@ static int snapshot_map(struct dm_target
 			goto out_unlock;
 		}
 
-		remap_exception(s, &pe->e, bio, chunk);
+		remap_exception(s, bio, pe->e.new_chunk);
 		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
@@ -1136,9 +1138,8 @@ static int snapshot_status(struct dm_tar
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
-	struct dm_exception *e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1170,10 +1171,18 @@ static int __origin_write(struct list_he
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
+		 * Could be -EWOULDBLOCK, but we don't handle that yet
+		 * and there are currently no exception store
+		 * implementations that would require us to.
+		 */
+		BUG_ON(rtn != -ENOENT);
+
 		pe = __find_pending_exception(snap, bio);
 		if (!pe) {
 			__invalidate_snapshot(snap, -ENOMEM);
