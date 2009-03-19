From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 7 of 30] DM Snapshot: exception function changes 2
Date: Thu, 19 Mar 2009 16:33:45 -0500
Message-ID: <200903192133.n2JLXjN1006876@hydrogen.msp.redhat.com>
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

Patch name: dm-snap-exception-function-changes-2.patch

This patch makes exception [de]allocation functions deal specifically
with the dm_exception type.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Index: linux-2.6/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-snap.c
+++ linux-2.6/drivers/md/dm-snap.c
@@ -436,7 +436,7 @@ static void free_completed_exception(str
 	kmem_cache_free(exception_cache, e);
 }
 
-static struct dm_snap_pending_exception *alloc_pending_exception(void *context)
+static struct dm_exception *alloc_pending_exception(void *context)
 {
 	struct dm_snapshot *s = context;
 	struct dm_snap_pending_exception *pe = mempool_alloc(s->pending_pool,
@@ -445,13 +445,16 @@ static struct dm_snap_pending_exception 
 	atomic_inc(&s->pending_exceptions_count);
 	pe->snap = s;
 
-	return pe;
+	return &pe->e;
 }
 
-static void free_pending_exception(struct dm_snap_pending_exception *pe,
-				   void *unused)
+static void free_pending_exception(struct dm_exception *pe, void *unused)
 {
-	struct dm_snapshot *s = pe->snap;
+	struct dm_snap_pending_exception *pe;
+	struct dm_snapshot *s;
+
+	pe = container_of(e, struct dm_snap_pending_exception, e);
+	s = pe->snap;
 
 	mempool_free(pe, s->pending_pool);
 	smp_mb__before_atomic_dec();
@@ -907,7 +910,7 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(primary_pe, NULL);
+		free_pending_exception(&primary_pe->e, NULL);
 	}
 
 	/*
@@ -915,7 +918,7 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 
 	return origin_bios;
 }
@@ -1042,7 +1045,7 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 {
-	struct dm_exception *e;
+	struct dm_exception *e, *tmp_e;
 	struct dm_snap_pending_exception *pe;
 	chunk_t chunk = sector_to_chunk(s->store, bio->bi_sector);
 
@@ -1061,17 +1064,18 @@ __find_pending_exception(struct dm_snaps
 	 * to hold the lock while we do this.
 	 */
 	up_write(&s->lock);
-	pe = alloc_pending_exception(s);
+	tmp_e = alloc_pending_exception(s);
+	pe = container_of(tmp_e, struct dm_snap_pending_exception, e);
 	down_write(&s->lock);
 
 	if (!s->valid) {
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 		return NULL;
 	}
 
 	e = dm_lookup_exception(s->pending, chunk);
 	if (e) {
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 		pe = container_of(e, struct dm_snap_pending_exception, e);
 		goto out;
 	}
@@ -1084,7 +1088,7 @@ __find_pending_exception(struct dm_snaps
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(pe, NULL);
+		free_pending_exception(&pe->e, NULL);
 		return NULL;
 	}
 
@@ -1327,7 +1331,7 @@ static int __origin_write(struct list_he
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(primary_pe, NULL);
+		free_pending_exception(&primary_pe->e, NULL);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
