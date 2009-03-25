From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 27 of 33] DM Exception Store: add arg to
	lookup_exception
Date: Wed, 25 Mar 2009 16:38:07 -0500
Message-ID: <200903252138.n2PLc76k022569@hydrogen.msp.redhat.com>
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
@@ -67,7 +67,7 @@ struct dm_exception_store_type {
 	 */
 	int (*lookup_exception) (struct dm_exception_store *store,
 				 chunk_t old, chunk_t *new_chunk,
-				 int can_block);
+				 int group, int can_block);
 
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
+				       int group, int can_block)
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
+				      int group, int can_block)
 {
 	struct transient_c *tc = store->context;
 	struct dm_exception *e;
Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -914,7 +914,8 @@ static int snapshot_map(struct dm_target
 	}
 
 	/* If the block is already remapped - use that, else remap it */
-	rtn = s->store->type->lookup_exception(s->store, chunk, &new_chunk, 0);
+	rtn = s->store->type->lookup_exception(s->store, chunk,
+					       &new_chunk, 0, 0);
 	if (!rtn) {
 		remap_exception(s, bio, new_chunk);
 		goto out_unlock;
@@ -947,7 +948,8 @@ static int snapshot_map(struct dm_target
 				goto out_unlock;
 			}
 			rtn = s->store->type->lookup_exception(s->store, chunk,
-							       &new_chunk, 0);
+							       &new_chunk,
+							       0, 0);
 			if (!rtn) {
 				dm_free_exception(s->pending, &pe->e);
 				remap_exception(s, bio, new_chunk);
@@ -1125,7 +1127,7 @@ static int __origin_write(struct list_he
 		 * won't destroy the primary_pe while we're inside this loop.
 		 */
 		rtn = snap->store->type->lookup_exception(snap->store, chunk,
-							  NULL, 0);
+							  NULL, 1, 0);
 		if (!rtn)
 			goto next_snapshot;
 
@@ -1151,7 +1153,7 @@ static int __origin_write(struct list_he
 
 			rtn = snap->store->type->lookup_exception(snap->store,
 								  chunk, NULL,
-								  0);
+								  1, 0);
 			if (!rtn) {
 				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
