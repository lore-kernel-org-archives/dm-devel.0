From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 14 of 33] DM Snapshot: exception function changes
	6
Date: Fri, 1 May 2009 09:18:43 -0500
Message-ID: <200905011418.n41EIhrD029498@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-exception-function-changes-6.patch

This patch makes use of the new dm_alloc_exception and
dm_free_exception functions.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -944,6 +944,7 @@ static void get_pending_exception(struct
 static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snap_pending_exception *primary_pe;
+	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 
 	primary_pe = pe->primary_pe;
@@ -956,7 +957,7 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(&primary_pe->e, NULL);
+		dm_free_exception(s->pending, &primary_pe->e);
 	}
 
 	/*
@@ -964,7 +965,7 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 
 	return origin_bios;
 }
@@ -1107,7 +1108,7 @@ __find_pending_exception(struct dm_snaps
 
 	pe2 = __lookup_pending_exception(s, chunk);
 	if (pe2) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		return pe2;
 	}
 
@@ -1119,7 +1120,7 @@ __find_pending_exception(struct dm_snaps
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
 
@@ -1181,20 +1182,20 @@ static int snapshot_map(struct dm_target
 		pe = __lookup_pending_exception(s, chunk);
 		if (!pe) {
 			up_write(&s->lock);
-			tmp_e = alloc_pending_exception(s);
+			tmp_e = dm_alloc_exception(s->pending);
 			pe = container_of(tmp_e,
 					  struct dm_snap_pending_exception, e);
 			down_write(&s->lock);
 
 			if (!s->valid) {
-				free_pending_exception(&pe->e, NULL);
+				dm_free_exception(s->pending, &pe->e);
 				r = -EIO;
 				goto out_unlock;
 			}
 
 			e = dm_lookup_exception(&s->complete, chunk);
 			if (e) {
-				free_pending_exception(&pe->e, NULL);
+				dm_free_exception(s->pending, &pe->e);
 				remap_exception(s, e, bio, chunk);
 				goto out_unlock;
 			}
@@ -1337,19 +1338,19 @@ static int __origin_write(struct list_he
 		pe = __lookup_pending_exception(snap, chunk);
 		if (!pe) {
 			up_write(&snap->lock);
-			tmp_e = alloc_pending_exception(snap);
+			tmp_e = dm_alloc_exception(snap->pending);
 			pe = container_of(tmp_e,
 					  struct dm_snap_pending_exception, e);
 			down_write(&snap->lock);
 
 			if (!snap->valid) {
-				free_pending_exception(&pe->e, NULL);
+				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
 			}
 
 			e = dm_lookup_exception(&snap->complete, chunk);
 			if (e) {
-				free_pending_exception(&pe->e, NULL);
+				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
 			}
 
@@ -1403,7 +1404,8 @@ static int __origin_write(struct list_he
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(&primary_pe->e, NULL);
+		dm_free_exception(primary_pe->snap->pending,
+				       &primary_pe->e);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
