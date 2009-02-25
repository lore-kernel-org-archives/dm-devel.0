From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 1/3] check for completed exception after dropped
	lock
Date: Wed, 25 Feb 2009 12:57:34 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0902251255550.30903@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Hi.

This is the patch broken to 3 parts, with dropping the lock moved to the 
caller as you said.

Mikulas

---

Move looking-up of a pending exception from __find_pending_exception to another
function.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   52 +++++++++++++++++++++++++++------------------------
 1 file changed, 28 insertions(+), 24 deletions(-)

Index: linux-2.6.29-rc6-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.29-rc6-devel.orig/drivers/md/dm-snap.c	2009-02-25 01:22:45.000000000 +0100
+++ linux-2.6.29-rc6-devel/drivers/md/dm-snap.c	2009-02-25 18:26:10.000000000 +0100
@@ -972,6 +972,17 @@ static void start_copy(struct dm_snap_pe
 		    &src, 1, &dest, 0, copy_callback, pe);
 }
 
+static struct dm_snap_pending_exception *
+lookup_pending_exception(struct dm_snapshot *s, chunk_t chunk)
+{
+	struct dm_snap_exception *e = lookup_exception(&s->pending, chunk);
+
+	if (e)
+		return container_of(e, struct dm_snap_pending_exception, e);
+
+	return NULL;
+}
+
 /*
  * Looks to see if this snapshot already has a pending exception
  * for this chunk, otherwise it allocates a new one and inserts
@@ -983,21 +994,10 @@ static void start_copy(struct dm_snap_pe
 static struct dm_snap_pending_exception *
 __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 {
-	struct dm_snap_exception *e;
-	struct dm_snap_pending_exception *pe;
+	struct dm_snap_pending_exception *pe, *pe2;
 	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
 
 	/*
-	 * Is there a pending exception for this already ?
-	 */
-	e = lookup_exception(&s->pending, chunk);
-	if (e) {
-		/* cast the exception to a pending exception */
-		pe = container_of(e, struct dm_snap_pending_exception, e);
-		goto out;
-	}
-
-	/*
 	 * Create a new pending exception, we don't want
 	 * to hold the lock while we do this.
 	 */
@@ -1010,11 +1010,10 @@ __find_pending_exception(struct dm_snaps
 		return NULL;
 	}
 
-	e = lookup_exception(&s->pending, chunk);
-	if (e) {
+	pe2 = lookup_pending_exception(s, chunk);
+	if (pe2) {
 		free_pending_exception(pe);
-		pe = container_of(e, struct dm_snap_pending_exception, e);
-		goto out;
+		return pe2;
 	}
 
 	pe->e.old_chunk = chunk;
@@ -1032,7 +1031,6 @@ __find_pending_exception(struct dm_snaps
 	get_pending_exception(pe);
 	insert_exception(&s->pending, &pe->e);
 
- out:
 	return pe;
 }
 
@@ -1083,11 +1081,14 @@ static int snapshot_map(struct dm_target
 	 * writeable.
 	 */
 	if (bio_rw(bio) == WRITE) {
-		pe = __find_pending_exception(s, bio);
+		pe = lookup_pending_exception(s, chunk);
 		if (!pe) {
-			__invalidate_snapshot(s, -ENOMEM);
-			r = -EIO;
-			goto out_unlock;
+			pe = __find_pending_exception(s, bio);
+			if (!pe) {
+				__invalidate_snapshot(s, -ENOMEM);
+				r = -EIO;
+				goto out_unlock;
+			}
 		}
 
 		remap_exception(s, &pe->e, bio, chunk);
@@ -1217,10 +1218,13 @@ static int __origin_write(struct list_he
 		if (e)
 			goto next_snapshot;
 
-		pe = __find_pending_exception(snap, bio);
+		pe = lookup_pending_exception(snap, chunk);
 		if (!pe) {
-			__invalidate_snapshot(snap, -ENOMEM);
-			goto next_snapshot;
+			pe = __find_pending_exception(snap, bio);
+			if (!pe) {
+				__invalidate_snapshot(snap, -ENOMEM);
+				goto next_snapshot;
+			}
 		}
 
 		if (!primary_pe) {
