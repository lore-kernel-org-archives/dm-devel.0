From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 16/18]
	dm-exception-store-add-lookup_exception-to-API
Date: Tue, 29 Sep 2009 18:53:41 -0400
Message-ID: <1254264823-11538-17-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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

From: Jon Brassow <jbrassow@redhat.com>

Now that the exception store implementations are capable of
caching the exceptions on their own, we need a new function
added to the API to allow us to lookup the exceptions.

Adding 'lookup_exception' to the exception store API.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-exception-store.h |   12 +++++++
 drivers/md/dm-snap-persistent.c |   19 ++++++++++++
 drivers/md/dm-snap-transient.c  |   19 ++++++++++++
 drivers/md/dm-snap.c            |   61 ++++++++++++++++++++++++--------------
 4 files changed, 88 insertions(+), 23 deletions(-)

diff --git a/drivers/md/dm-exception-store.h b/drivers/md/dm-exception-store.h
index db22284..d3e6a58 100644
--- a/drivers/md/dm-exception-store.h
+++ b/drivers/md/dm-exception-store.h
@@ -56,6 +56,18 @@ struct dm_exception_store_type {
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
diff --git a/drivers/md/dm-snap-persistent.c b/drivers/md/dm-snap-persistent.c
index 03b1b6e..fe05bc8 100644
--- a/drivers/md/dm-snap-persistent.c
+++ b/drivers/md/dm-snap-persistent.c
@@ -722,6 +722,23 @@ static void persistent_commit_exception(struct dm_exception_store *store,
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
@@ -815,6 +832,7 @@ static struct dm_exception_store_type _persistent_type = {
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.lookup_exception = persistent_lookup_exception,
 	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
@@ -828,6 +846,7 @@ static struct dm_exception_store_type _persistent_compat_type = {
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.lookup_exception = persistent_lookup_exception,
 	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
diff --git a/drivers/md/dm-snap-transient.c b/drivers/md/dm-snap-transient.c
index d499083..eabdcc1 100644
--- a/drivers/md/dm-snap-transient.c
+++ b/drivers/md/dm-snap-transient.c
@@ -90,6 +90,23 @@ static void transient_commit_exception(struct dm_exception_store *store,
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
@@ -160,6 +177,8 @@ static struct dm_exception_store_type _transient_type = {
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
+	.lookup_exception = transient_lookup_exception,
+	.lookup_exception = transient_lookup_exception,
 	.fraction_full = transient_fraction_full,
 	.status = transient_status,
 };
diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 3b8ae1e..cb92d8f 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -981,24 +981,21 @@ __find_pending_exception(struct dm_snapshot *s,
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
 			union map_info *map_context)
 {
-	struct dm_exception *e, *tmp_e;
+	struct dm_exception *tmp_e;
 	struct dm_snapshot *s = ti->private;
-	int r = DM_MAPIO_REMAPPED;
-	chunk_t chunk;
+	int rtn, r = DM_MAPIO_REMAPPED;
+	chunk_t chunk, new_chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
 	if (unlikely(bio_empty_barrier(bio))) {
@@ -1023,13 +1020,20 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = dm_lookup_exception(s->complete, chunk);
-	if (e) {
-		remap_exception(s, e, bio, chunk);
+	rtn = s->store->type->lookup_exception(s->store, chunk, &new_chunk, 1);
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
@@ -1049,10 +1053,11 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 				goto out_unlock;
 			}
 
-			e = dm_lookup_exception(s->complete, chunk);
-			if (e) {
+			rtn = s->store->type->lookup_exception(s->store, chunk,
+							       &new_chunk, 1);
+			if (!rtn) {
 				dm_free_exception(s->pending, &pe->e);
-				remap_exception(s, e, bio, chunk);
+				remap_exception(s, bio, new_chunk);
 				goto out_unlock;
 			}
 
@@ -1064,7 +1069,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			}
 		}
 
-		remap_exception(s, &pe->e, bio, chunk);
+		remap_exception(s, bio, pe->e.new_chunk);
 		bio_list_add(&pe->snapshot_bios, bio);
 
 		r = DM_MAPIO_SUBMITTED;
@@ -1162,9 +1167,9 @@ static int snapshot_iterate_devices(struct dm_target *ti,
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
-	struct dm_exception *e, *tmp_e;
+	struct dm_exception *tmp_e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1196,10 +1201,18 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = dm_lookup_exception(snap->complete, chunk);
-		if (e)
+		rtn = snap->store->type->lookup_exception(snap->store, chunk,
+							  NULL, 1);
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
@@ -1213,8 +1226,10 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 				goto next_snapshot;
 			}
 
-			e = dm_lookup_exception(snap->complete, chunk);
-			if (e) {
+			rtn = snap->store->type->lookup_exception(snap->store,
+								  chunk, NULL,
+								  1);
+			if (!rtn) {
 				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
 			}
-- 
1.6.2.5
