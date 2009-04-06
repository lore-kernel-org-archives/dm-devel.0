From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 27 of 33] DM Exception Store: add arg to
	lookup_exception
Date: Mon, 6 Apr 2009 16:37:01 -0500
Message-ID: <200904062137.n36Lb1IQ021684@hydrogen.msp.redhat.com>
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

Patch name: dm-exception-store-add-arg-to-lookup_exception.patch

Add the 'group' parameter to the lookup_exception function.  This
facilitates snapshots that use the shared exception store.  When
writing to the origin, we need to know that all snapshots have
exception already (otherwise, we need to create a new one).  We
could do this one at a time, but it saves us a lot if we can tell
the shared exception store to check all the snapshots it is managing
at once (by specifying group=1).

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-exception-store.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-exception-store.h
+++ linux-2.6/drivers/md/dm-exception-store.h
@@ -15,6 +15,29 @@
 #include "dm-exception.h"
 
 /*
+ * Flags for lookup_exception:
+ * DM_ES_LOOKUP_CAN_BLOCK: Allows the function to block (possibly perform I/O)
+ * DM_ES_LOOKUP_INCLUSIVE: The exception we are looking for must exist for
+ *                         for every user.  Only shared exception stores need
+ *                         to worry about this flag.  If this flag is used, it
+ *                         it doesn't make sense to ask for the 'new_chunk'.
+ *                         For snapshots, this type of lookup would precede an
+ *                         origin write.
+ * DM_ES_LOOKUP_EXCLUSIVE: The exception we are looking up is not shared by any
+ *                         anyone else.  Only shared exception stores need to
+ *                         worry about this flag.  For snapshots, this type of
+ *                         lookup would precede a snapshot write.
+ * DM_ES_LOOKUP_EXISTS:    One or more of the items tracked by this exception
+ *                         store has an exception.  Only shared exception stores
+ *                         need to worry about this.  For snapshots, this type
+ *                         of lookup would precede a snapshot read.
+ */
+#define DM_ES_LOOKUP_CAN_BLOCK 0x1
+#define DM_ES_LOOKUP_INCLUSIVE 0x2
+#define DM_ES_LOOKUP_EXCLUSIVE 0x4
+#define DM_ES_LOOKUP_EXISTS    0x8
+
+/*
  * Abstraction to handle the meta/layout of exception stores (the
  * COW device).
  */
@@ -55,16 +78,23 @@ struct dm_exception_store_type {
 				  void *callback_context);
 
 	/*
-	 * Look up an exception.  Common errors include:
-	 * -ENOENT     : exception not found
-	 * -EWOULDBLOCK: blocking op required and can_block=0
+	 * lookup_exception - lookup an exception
+	 * @new_chunk: if !NULL, filled with new location
+	 * @flags: Can be a combination of the following (described above):
+	 *      DM_ES_LOOKUP_CAN_BLOCK
+	 *      DM_ES_LOOKUP_INCLUSIVE
+	 *      DM_ES_LOOKUP_EXCLUSIVE
+	 *      DM_ES_LOOKUP_EXISTS
 	 *
-	 * If 'new_chunk' is NULL, the caller simply wants to
-	 * know if the exception exists (0) or not (-ENOENT).
+	 * Return values should be:
+	 * 0           : Exception found
+	 * -ENOENT     : exception not found
+	 * -EWOULDBLOCK: blocking op required and DM_ES_LOOKUP_CAN_BLOCK not set
+	 * -Exxx       : Failure
 	 */
 	int (*lookup_exception) (struct dm_exception_store *store,
 				 chunk_t old, chunk_t *new_chunk,
-				 int can_block);
+				 uint32_t flags);
 
 	unsigned (*status) (struct dm_exception_store *store,
 			    status_type_t status, char *result,
Index: linux-2.6/drivers/md/dm-snap-persistent.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-persistent.c
+++ linux-2.6/drivers/md/dm-snap-persistent.c
@@ -710,7 +710,7 @@ static void persistent_commit_exception(
 
 static int persistent_lookup_exception(struct dm_exception_store *store,
 				       chunk_t old, chunk_t *new_chunk,
-				       int can_block)
+				       uint32_t flags)
 {
 	struct pstore *ps = get_info(store);
 	struct dm_exception *e;
Index: linux-2.6/drivers/md/dm-snap-transient.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap-transient.c
+++ linux-2.6/drivers/md/dm-snap-transient.c
@@ -88,7 +88,7 @@ static void transient_commit_exception(s
 
 static int transient_lookup_exception(struct dm_exception_store *store,
 				      chunk_t old, chunk_t *new_chunk,
-				      int can_block)
+				      uint32_t flags)
 {
 	struct transient_c *tc = store->context;
 	struct dm_exception *e;
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -891,6 +891,7 @@ static void remap_exception(struct dm_sn
 static int snapshot_map(struct dm_target *ti, struct bio *bio,
 			union map_info *map_context)
 {
+	uint32_t flags;
 	struct dm_exception *tmp_e;
 	struct dm_snapshot *s = ti->private;
 	int rtn, r = DM_MAPIO_REMAPPED;
@@ -913,8 +914,14 @@ static int snapshot_map(struct dm_target
 		goto out_unlock;
 	}
 
+	if (bio_rw(bio) == WRITE)
+		flags = DM_ES_LOOKUP_EXCLUSIVE | DM_ES_LOOKUP_CAN_BLOCK;
+	else
+		flags = DM_ES_LOOKUP_EXISTS | DM_ES_LOOKUP_CAN_BLOCK;
+
 	/* If the block is already remapped - use that, else remap it */
-	rtn = s->store->type->lookup_exception(s->store, chunk, &new_chunk, 0);
+	rtn = s->store->type->lookup_exception(s->store, chunk,
+					       &new_chunk, flags);
 	if (!rtn) {
 		remap_exception(s, bio, new_chunk);
 		goto out_unlock;
@@ -947,7 +954,8 @@ static int snapshot_map(struct dm_target
 				goto out_unlock;
 			}
 			rtn = s->store->type->lookup_exception(s->store, chunk,
-							       &new_chunk, 0);
+							       &new_chunk,
+							       flags);
 			if (!rtn) {
 				dm_free_exception(s->pending, &pe->e);
 				remap_exception(s, bio, new_chunk);
@@ -1090,6 +1098,7 @@ static int snapshot_message(struct dm_ta
  *---------------------------------------------------------------*/
 static int __origin_write(struct list_head *snapshots, struct bio *bio)
 {
+	uint32_t flags = DM_ES_LOOKUP_INCLUSIVE | DM_ES_LOOKUP_CAN_BLOCK;
 	int rtn, r = DM_MAPIO_REMAPPED, first = 0;
 	struct dm_snapshot *snap;
 	struct dm_exception *tmp_e;
@@ -1125,7 +1134,7 @@ static int __origin_write(struct list_he
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
 		rtn = snap->store->type->lookup_exception(snap->store, chunk,
-							  NULL, 0);
+							  NULL, flags);
 		if (!rtn)
 			goto next_snapshot;
 
@@ -1151,7 +1160,7 @@ static int __origin_write(struct list_he
 
 			rtn = snap->store->type->lookup_exception(snap->store,
 								  chunk, NULL,
-								  0);
+								  flags);
 			if (!rtn) {
 				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
