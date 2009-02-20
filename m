From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 11 of 17]
	dm-exception-store-add-lookup-to-API.patch
Date: Fri, 20 Feb 2009 17:26:08 -0600
Message-ID: <1235172368.24593.41.camel@hydrogen.msp.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
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

Now that the exception store implementations are capable of
caching the exceptions on their own, we need a new function
added to the API to allow us to lookup the exceptions.

Adding 'lookup_exception' to the exception store API.

RFC-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -58,6 +58,16 @@ struct dm_exception_store_type {
 				  void *callback_context);
 
 	/*
+	 * Look up an exception.  For certain exception stores,
+	 * this function /may/ block.  The caller must specify whether
+	 * they can tolerate this.  If the function would block and the
+	 * user specified can_block=0, -EWOULDBLK will be returned.
+	 */
+	int (*lookup_exception) (struct dm_exception_store *store,
+				 struct dm_exception **e,
+				 chunk_t old, int can_block);
+
+	/*
 	 * The snapshot is invalid, note this in the metadata.
 	 */
 	void (*drop_snapshot) (struct dm_exception_store *store);
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -711,6 +711,17 @@ static void persistent_commit_exception(
 	ps->callback_count = 0;
 }
 
+static int persistent_lookup_exception(struct dm_exception_store *store,
+				       struct dm_exception **e,
+				       chunk_t old, int can_block)
+{
+	struct pstore *ps = get_info(store);
+
+	*e = dm_lookup_exception(ps->table, old);
+
+	return 0;
+}
+
 static void persistent_drop_snapshot(struct dm_exception_store *store)
 {
 	struct pstore *ps = get_info(store);
@@ -803,6 +814,7 @@ static struct dm_exception_store_type _p
 	.read_metadata = persistent_read_metadata,
 	.prepare_exception = persistent_prepare_exception,
 	.commit_exception = persistent_commit_exception,
+	.lookup_exception = persistent_lookup_exception,
 	.drop_snapshot = persistent_drop_snapshot,
 	.fraction_full = persistent_fraction_full,
 	.status = persistent_status,
@@ -817,6 +829,7 @@ static struct dm_exception_store_type _p
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
@@ -94,6 +94,17 @@ static void transient_commit_exception(s
 	callback(callback_context, 1);
 }
 
+static int transient_lookup_exception(struct dm_exception_store *store,
+				      struct dm_exception **e,
+				      chunk_t old, int can_block)
+{
+	struct transient_c *tc = store->context;
+
+	*e = dm_lookup_exception(tc->table, old);
+
+	return 0;
+}
+
 static void transient_fraction_full(struct dm_exception_store *store,
 				    sector_t *numerator, sector_t *denominator)
 {
@@ -165,6 +176,7 @@ static struct dm_exception_store_type _t
 	.read_metadata = transient_read_metadata,
 	.prepare_exception = transient_prepare_exception,
 	.commit_exception = transient_commit_exception,
+	.lookup_exception = transient_lookup_exception,
 	.fraction_full = transient_fraction_full,
 	.status = transient_status,
 };
@@ -178,6 +190,7 @@ static struct dm_exception_store_type _t
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
@@ -994,7 +994,7 @@ static int snapshot_map(struct dm_target
 {
 	struct dm_exception *e;
 	struct dm_snapshot *s = ti->private;
-	int r = DM_MAPIO_REMAPPED;
+	int rtn, r = DM_MAPIO_REMAPPED;
 	chunk_t chunk;
 	struct dm_snap_pending_exception *pe = NULL;
 
@@ -1015,7 +1015,15 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	e = dm_lookup_exception(s->complete, chunk);
+	rtn = s->store->type->lookup_exception(s->store, &e, chunk, 0);
+	if (rtn) {
+		/*
+		 * Could be -EWOULDBLOCK, but we don't handle that yet
+		 * and there are currently no exception store
+		 * implementations that would require us to.
+		 */
+		BUG();
+	}
 	if (e) {
 		remap_exception(s, e, bio, chunk);
 		goto out_unlock;
@@ -1134,7 +1142,7 @@ static int snapshot_status(struct dm_tar
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
-	int r = DM_MAPIO_REMAPPED, first = 0;
+	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
 	struct dm_exception *e;
 	struct dm_snap_pending_exception *pe, *next_pe, *primary_pe = NULL;
@@ -1168,7 +1176,16 @@ static int __origin_write(struct list_he
 		 * ref_count is initialised to 1 so pending_complete()
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
-		e = dm_lookup_exception(snap->complete, chunk);
+		rtn = snap->store->type->lookup_exception(snap->store, &e,
+							  chunk, 0);
+		if (rtn) {
+			/*
+			 * Could be -EWOULDBLOCK, but we don't handle that yet
+			 * and there are currently no exception store
+			 * implementations that would require us to.
+			 */
+			BUG();
+		}
 		if (e)
 			goto next_snapshot;
 
