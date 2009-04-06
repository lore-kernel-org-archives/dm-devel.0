From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 31 of 33] DM Snapshot: change parameters to
	__lookup_pending_exception
Date: Mon, 6 Apr 2009 16:37:42 -0500
Message-ID: <200904062137.n36Lbgfd021978@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-change-parameters-to-__lookup_pending_exception.patch

Change the parameter to '__lookup_pending_exception' so that it takes
the exception table, not the snapshot structure.  This is necessary
for future patches, because other structures (in addition to dm_snapshot)
will have exception tables that this function will need to operate on.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -835,9 +835,9 @@ static void start_copy(struct dm_snap_pe
 }
 
 static struct dm_snap_pending_exception *
-__lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
+__lookup_pending_exception(struct dm_exception_table *pending, chunk_t chunk)
 {
-	struct dm_exception *e = dm_lookup_exception(s->pending, chunk);
+	struct dm_exception *e = dm_lookup_exception(pending, chunk);
 
 	if (!e)
 		return NULL;
@@ -866,7 +866,7 @@ __find_pending_exception(struct dm_snaps
 {
 	struct dm_snap_pending_exception *pe2;
 
-	pe2 = __lookup_pending_exception(s, chunk);
+	pe2 = __lookup_pending_exception(s->pending, chunk);
 	if (pe2) {
 		dm_free_exception(s->pending, &pe->e);
 		return pe2;
@@ -950,7 +950,7 @@ static int snapshot_map(struct dm_target
 	 * writeable.
 	 */
 	if (bio_rw(bio) == WRITE) {
-		pe = __lookup_pending_exception(s, chunk);
+		pe = __lookup_pending_exception(s->pending, chunk);
 		if (!pe) {
 			up_write(&s->lock);
 			tmp_e = dm_alloc_exception(s->pending);
@@ -1155,7 +1155,7 @@ static int __origin_write(struct list_he
 		 */
 		BUG_ON(rtn != -ENOENT);
 
-		pe = __lookup_pending_exception(snap, chunk);
+		pe = __lookup_pending_exception(snap->pending, chunk);
 		if (!pe) {
 			up_write(&snap->lock);
 			tmp_e = dm_alloc_exception(snap->pending);
