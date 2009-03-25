From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 9 of 33] DM Snapshot: exception function changes 1
Date: Wed, 25 Mar 2009 16:35:04 -0500
Message-ID: <200903252135.n2PLZ4m1021205@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-exception-function-changes-1.patch

This patch moves towards a generalized interface for functions that
allocate and deallocate exceptions.  So, we add an additional parameter
for context pointers.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -420,7 +420,7 @@ static struct dm_exception *dm_lookup_ex
 	return NULL;
 }
 
-static struct dm_exception *alloc_completed_exception(void)
+static struct dm_exception *alloc_completed_exception(void *unused)
 {
 	struct dm_exception *e;
 
@@ -431,13 +431,14 @@ static struct dm_exception *alloc_comple
 	return e;
 }
 
-static void free_completed_exception(struct dm_exception *e)
+static void free_completed_exception(struct dm_exception *e, void *unused)
 {
 	kmem_cache_free(exception_cache, e);
 }
 
-static struct dm_snap_pending_exception *alloc_pending_exception(struct dm_snapshot *s)
+static struct dm_snap_pending_exception *alloc_pending_exception(void *context)
 {
+	struct dm_snapshot *s = context;
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
 							     GFP_NOIO);
 
@@ -447,7 +448,8 @@ static struct dm_snap_pending_exception 
 	return pe;
 }
 
-static void free_pending_exception(struct dm_snap_pending_exception *pe)
+static void free_pending_exception(struct dm_snap_pending_exception *pe,
+				   void *unused)
 {
 	struct dm_snapshot *s = pe->snap;
 
@@ -476,7 +478,7 @@ static void dm_insert_exception(struct d
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_completed_exception(new_e);
+			free_completed_exception(new_e, NULL);
 			return;
 		}
 
@@ -486,7 +488,7 @@ static void dm_insert_exception(struct d
 			dm_consecutive_chunk_count_inc(e);
 			e->old_chunk--;
 			e->new_chunk--;
-			free_completed_exception(new_e);
+			free_completed_exception(new_e, NULL);
 			return;
 		}
 
@@ -507,7 +509,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(NULL);
 	if (!e)
 		return -ENOMEM;
 
@@ -905,7 +907,7 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe);
+		free_pending_exception(primary_pe, NULL);
 	}
 
 	/*
@@ -913,7 +915,7 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 
 	return origin_bios;
 }
@@ -934,7 +936,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(NULL);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -945,7 +947,7 @@ static void pending_complete(struct dm_s
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_completed_exception(e);
+		free_completed_exception(e, NULL);
 		error = 1;
 		goto out;
 	}
@@ -1056,7 +1058,7 @@ __find_pending_exception(struct dm_snaps
 
 	pe2 = __lookup_pending_exception(s, chunk);
 	if (pe2) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		return pe2;
 	}
 
@@ -1068,7 +1070,7 @@ __find_pending_exception(struct dm_snaps
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		return NULL;
 	}
 
@@ -1134,14 +1136,14 @@ static int snapshot_map(struct dm_target
 			down_write(&s->lock);
 
 			if (!s->valid) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				r = -EIO;
 				goto out_unlock;
 			}
 
 			e = dm_lookup_exception(&s->complete, chunk);
 			if (e) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				remap_exception(s, e, bio, chunk);
 				goto out_unlock;
 			}
@@ -1288,13 +1290,13 @@ static int __origin_write(struct list_he
 			down_write(&snap->lock);
 
 			if (!snap->valid) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				goto next_snapshot;
 			}
 
 			e = dm_lookup_exception(&snap->complete, chunk);
 			if (e) {
-				free_pending_exception(pe);
+				free_pending_exception(pe, NULL);
 				goto next_snapshot;
 			}
 
@@ -1348,7 +1350,7 @@ static int __origin_write(struct list_he
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
+		free_pending_exception(primary_pe, NULL);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
