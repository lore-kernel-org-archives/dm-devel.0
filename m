From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 13/18] dm-snapshot-exception-function-changes-6
Date: Tue, 29 Sep 2009 18:53:38 -0400
Message-ID: <1254264823-11538-14-git-send-email-snitzer@redhat.com>
References: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254264823-11538-1-git-send-email-snitzer@redhat.com>
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

From: Jon Brassow <jbrassow@redhat.com>

This patch makes use of the new dm_alloc_exception and
dm_free_exception functions.

Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   24 +++++++++++++-----------
 1 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index fabf833..4c0a5ed 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -963,6 +963,7 @@ static void get_pending_exception(struct dm_snap_pending_exception *pe)
 static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 {
 	struct dm_snap_pending_exception *primary_pe;
+	struct dm_snapshot *s = pe->snap;
 	struct bio *origin_bios = NULL;
 
 	primary_pe = pe->primary_pe;
@@ -975,7 +976,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	if (primary_pe &&
 	    atomic_dec_and_test(&primary_pe->ref_count)) {
 		origin_bios = bio_list_get(&primary_pe->origin_bios);
-		free_pending_exception(&primary_pe->e, NULL);
+		dm_free_exception(s->pending, &primary_pe->e);
 	}
 
 	/*
@@ -983,7 +984,7 @@ static struct bio *put_pending_exception(struct dm_snap_pending_exception *pe)
 	 * it's not itself a primary pe.
 	 */
 	if (!primary_pe || primary_pe != pe)
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 
 	return origin_bios;
 }
@@ -1126,7 +1127,7 @@ __find_pending_exception(struct dm_snapshot *s,
 
 	pe2 = __lookup_pending_exception(s, chunk);
 	if (pe2) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		return pe2;
 	}
 
@@ -1138,7 +1139,7 @@ __find_pending_exception(struct dm_snapshot *s,
 	pe->started = 0;
 
 	if (s->store->type->prepare_exception(s->store, &pe->e)) {
-		free_pending_exception(&pe->e, NULL);
+		dm_free_exception(s->pending, &pe->e);
 		return NULL;
 	}
 
@@ -1205,20 +1206,20 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
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
 
 			e = dm_lookup_exception(s->complete, chunk);
 			if (e) {
-				free_pending_exception(&pe->e, NULL);
+				dm_free_exception(s->pending, &pe->e);
 				remap_exception(s, e, bio, chunk);
 				goto out_unlock;
 			}
@@ -1370,19 +1371,19 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
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
 
 			e = dm_lookup_exception(snap->complete, chunk);
 			if (e) {
-				free_pending_exception(&pe->e, NULL);
+				dm_free_exception(snap->pending, &pe->e);
 				goto next_snapshot;
 			}
 
@@ -1436,7 +1437,8 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 
 	if (first && atomic_dec_and_test(&primary_pe->ref_count)) {
 		flush_bios(bio_list_get(&primary_pe->origin_bios));
-		free_pending_exception(&primary_pe->e, NULL);
+		dm_free_exception(primary_pe->snap->pending,
+				       &primary_pe->e);
 		/* If we got here, pe_queue is necessarily empty. */
 		return r;
 	}
-- 
1.6.2.5
