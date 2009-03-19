From: Jonathan Brassow <jbrassow@redhat.com>
Subject: [PATCH 11 of 30] DM Snapshot: exception function changes
	6
Date: Thu, 19 Mar 2009 16:34:26 -0500
Message-ID: <200903192134.n2JLYQtu007170@hydrogen.msp.redhat.com>
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
@@ -945,6 +945,7 @@ static void get_pending_exception(struct
 static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snap_pending_exception *primary_pe;
+	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 
 	primary_pe = pe->primary_pe;
@@ -957,7 +958,7 @@ static struct bio *put_pending_exception
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(&primary_pe->e, NULL);
+		dm_free_exception(s->pending, &primary_pe->e);
 	}
 
 	/*
@@ -965,7 +966,7 @@ static struct bio *put_pending_exception
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 
 	return origin_bios;
 }
@@ -1111,18 +1112,18 @@ __find_pending_exception(struct dm_snaps
 	 * to hold the lock while we do this.
 	 */
 	up_write(&s->lock);
-	tmp_e = alloc_pending_exception(s);
+	tmp_e = dm_alloc_exception(s->pending);
 	pe = container_of(tmp_e, struct dm_snap_pending_exception, e);
 	down_write(&s->lock);
 
 	if (!s->valid) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
 
 	e = dm_lookup_exception(s->pending, chunk);
 	if (e) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		pe = container_of(e, struct dm_snap_pending_exception, e);
 		goto out;
 	}
@@ -1135,7 +1136,7 @@ __find_pending_exception(struct dm_snaps
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
 
@@ -1378,7 +1379,8 @@ static int __origin_write(struct list_he
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(&primary_pe->e, NULL);
+		dm_free_exception(primary_pe->snap->pending,
+				       &primary_pe->e);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
