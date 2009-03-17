From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 6 of 29]
	dm-snap-exception-function-changes-1.patch
Date: Tue, 17 Mar 2009 09:03:11 -0500
Message-ID: <200903171403.n2HE3BFE017368@hydrogen.msp.redhat.com>
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
 
@@ -447,7 +448,7 @@ static struct dm_snap_pending_exception 
 	return pe;
 }
 
-static void free_pending_exception(struct dm_snap_pending_exception *pe)
+static void free_pending_exception(struct dm_snap_pending_exception *pe, void *unused)
 {
 	struct dm_snapshot *s = pe->snap;
 
@@ -476,7 +477,7 @@ static void dm_insert_exception(struct d
 		    new_e->new_chunk == (dm_chunk_number(e->new_chunk) +
 					 dm_consecutive_chunk_count(e) + 1)) {
 			dm_consecutive_chunk_count_inc(e);
-			free_completed_exception(new_e);
+			free_completed_exception(new_e, NULL);
 			return;
 		}
 
@@ -486,7 +487,7 @@ static void dm_insert_exception(struct d
 			dm_consecutive_chunk_count_inc(e);
 			e->old_chunk--;
 			e->new_chunk--;
-			free_completed_exception(new_e);
+			free_completed_exception(new_e, NULL);
 			return;
 		}
 
@@ -507,7 +508,7 @@ static int dm_add_exception(void *contex
 	struct dm_snapshot *s = context;
 	struct dm_exception *e;
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(NULL);
 	if (!e)
 		return -ENOMEM;
 
@@ -905,7 +906,7 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe);
+		free_pending_exception(primary_pe, NULL);
 	}
 
 	/*
@@ -913,7 +914,7 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 
 	return origin_bios;
 }
@@ -934,7 +935,7 @@ static void pending_complete(struct dm_s
 		goto out;
 	}
 
-	e = alloc_completed_exception();
+	e = alloc_completed_exception(NULL);
 	if (!e) {
 		down_write(&s->lock);
 		__invalidate_snapshot(s, -ENOMEM);
@@ -945,7 +946,7 @@ static void pending_complete(struct dm_s
 
 	down_write(&s->lock);
 	if (!s->valid) {
-		free_completed_exception(e);
+		free_completed_exception(e, NULL);
 		error = 1;
 		goto out;
 	}
@@ -1063,13 +1064,13 @@ __find_pending_exception(struct dm_snaps
 	down_write(&s->lock);
 
 	if (!s->valid) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		return NULL;
 	}
 
 	e = dm_lookup_exception(s->pending, chunk);
 	if (e) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		pe = container_of(e, struct dm_snap_pending_exception, e);
 		goto out;
 	}
@@ -1082,7 +1083,7 @@ __find_pending_exception(struct dm_snaps
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(pe);
+		free_pending_exception(pe, NULL);
 		return NULL;
 	}
 
@@ -1325,7 +1326,7 @@ static int __origin_write(struct list_he
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe);
+		free_pending_exception(primary_pe, NULL);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
