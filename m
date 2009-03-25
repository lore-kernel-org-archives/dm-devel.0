From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 26 of 33] DM Exception Store: add arg to
	prepare_commit
Date: Wed, 25 Mar 2009 16:37:57 -0500
Message-ID: <200903252137.n2PLbvTg022493@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-add-arg-to-prepare_commit.patch

Add the 'group' paramenter to the prepare_exception function.  This
is used to facilitate shared exception stores.  When writing to
a snapshot, an exception is created for only that snapshot (group=0).
When writing to the origin, all snapshots are affected, so rather
than preparing_exceptions for all snapshots one at a time, we can
use the group=1 to indicate that all snapshots managed by the shared
exception store be updated.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -40,9 +40,14 @@ struct dm_exception_store_type {
 
 	/*
 	 * Find somewhere to store the next exception.
+	 * If the exception store implementation is shared,
+	 * the 'group' field signifies whether to operate on
+	 * the group sharing one exception store, or whether
+	 * to operate on just one of those in the shared
+	 * exception store.
 	 */
 	int (*prepare_exception) (struct dm_exception_store *store,
-				  struct dm_exception *e);
+				  struct dm_exception *e, int group);
 
 	/*
 	 * Update the metadata with this exception.
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -604,7 +604,7 @@ read_metadata:
 }
 
 static int persistent_prepare_exception(struct dm_exception_store *store,
-					struct dm_exception *e)
+					struct dm_exception *e, int group)
 {
 	struct pstore *ps = get_info(store);
 	uint32_t stride;
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -50,7 +50,7 @@ static int transient_resume(struct dm_ex
 }
 
 static int transient_prepare_exception(struct dm_exception_store *store,
-				       struct dm_exception *e)
+				       struct dm_exception *e, int group)
 {
 	struct transient_c *tc = store->context;
 	sector_t size = get_dev_size(store->cow->bdev);
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -836,6 +836,12 @@ __lookup_pending_exception(struct dm_sna
 }
 
 /*
+ * __find_pending_exception
+ * @s
+ * @pe
+ * @chunk
+ * @group
+ *
  * Looks to see if this snapshot already has a pending exception
  * for this chunk, otherwise it allocates a new one and inserts
  * it into the pending table.
@@ -845,7 +851,8 @@ __lookup_pending_exception(struct dm_sna
  */
 static struct dm_snap_pending_exception *
 __find_pending_exception(struct dm_snapshot *s,
-			 struct dm_snap_pending_exception *pe, chunk_t chunk)
+			 struct dm_snap_pending_exception *pe,
+			 chunk_t chunk, int group)
 {
 	struct dm_snap_pending_exception *pe2;
 
@@ -862,7 +869,7 @@ __find_pending_exception(struct dm_snaps
 	atomic_set(&pe->ref_count, 0);
 	pe->started = 0;
 
-	if (s->store->type->prepare_exception(s->store, &pe->e)) {
+	if (s->store->type->prepare_exception(s->store, &pe->e, group)) {
 		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
@@ -884,7 +891,7 @@ static void remap_exception(struct dm_sn
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			union map_info *map_context)
 {
-	struct dm_exception *e, *tmp_e;
+	struct dm_exception *tmp_e;
 	struct dm_snapshot *s = ti->private;
 	int rtn, r = DM_MAPIO_REMAPPED;
 	chunk_t chunk, new_chunk;
@@ -947,7 +954,7 @@ static int snapshot_map(struct dm_target
 				goto out_unlock;
 			}
 
-			pe = __find_pending_exception(s, pe, chunk);
+			pe = __find_pending_exception(s, pe, chunk, 0);
 			if (!pe) {
 				__invalidate_snapshot(s, -ENOMEM);
 				r = -EIO;
@@ -1085,7 +1092,7 @@ static int __origin_write(struct list_he
 {
 	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
-	struct dm_exception *e, *tmp_e;
+	struct dm_exception *tmp_e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
 	chunk_t chunk;
 	LIST_HEAD(pe_queue);
@@ -1150,7 +1157,7 @@ static int __origin_write(struct list_he
 				goto next_snapshot;
 			}
 
-			pe = __find_pending_exception(snap, pe, chunk);
+			pe = __find_pending_exception(snap, pe, chunk, 1);
 			if (!pe) {
 				__invalidate_snapshot(snap, -ENOMEM);
 				goto next_snapshot;
