From: Alasdair G Kergon <agk@redhat.com>
Subject: FW: [PATCH 2/3] check for completed exception after
	dropped lock
Date: Tue, 17 Mar 2009 19:07:37 +0000
Message-ID: <20090317190737.GN3063@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
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

----- Forwarded message from Mikulas Patocka <mpatocka@redhat.com> -----

Date: Wed, 25 Feb 2009 12:58:10 -0500 (EST)
From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] check for completed exception after dropped lock
To: dm-devek@redhat.com
cc: Alasdair G Kergon <agk@redhat.com>

Move allocation of alloc_pending_exception to the caller.

It is uncommon and bug-prone to drop a lock in a function that is called with
the lock held, so this is moved up.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-snap.c |   42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

Index: linux-2.6.29-rc6-devel/drivers/md/dm-snap.c
===================================================================
--- linux-2.6.29-rc6-devel.orig/drivers/md/dm-snap.c	2009-02-25 18:26:10.000000000 +0100
+++ linux-2.6.29-rc6-devel/drivers/md/dm-snap.c	2009-02-25 18:30:30.000000000 +0100
@@ -992,23 +992,10 @@ lookup_pending_exception(struct dm_snaps
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s, struct bio *bio)
+__find_pending_exception(struct dm_snapshot *s,
+			 struct dm_snap_pending_exception *pe, chunk_t chunk)
 {
-	struct dm_snap_pending_exception *pe, *pe2;
-	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
-
-	/*
-	 * Create a new pending exception, we don't want
-	 * to hold the lock while we do this.
-	 */
-	up_write(&s->lock);
-	pe = alloc_pending_exception(s);
-	down_write(&s->lock);
-
-	if (!s->valid) {
-		free_pending_exception(pe);
-		return NULL;
-	}
+ 	struct dm_snap_pending_exception *pe2;
 
 	pe2 = lookup_pending_exception(s, chunk);
 	if (pe2) {
@@ -1083,7 +1070,17 @@ static int snapshot_map(struct dm_target
 	if (bio_rw(bio) == WRITE) {
 		pe = lookup_pending_exception(s, chunk);
 		if (!pe) {
-			pe = __find_pending_exception(s, bio);
+			up_write(&s->lock);
+			pe = alloc_pending_exception(s);
+			down_write(&s->lock);
+
+			if (!s->valid) {
+				free_pending_exception(pe);
+				r = -EIO;
+				goto out_unlock;
+			}
+
+			pe = __find_pending_exception(s, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(s, -ENOMEM);
 				r = -EIO;
@@ -1220,7 +1217,16 @@ static int __origin_write(struct list_he
 
 		pe = lookup_pending_exception(snap, chunk);
 		if (!pe) {
-			pe = __find_pending_exception(snap, bio);
+			up_write(&snap->lock);
+			pe = alloc_pending_exception(snap);
+			down_write(&snap->lock);
+
+			if (!snap->valid) {
+				free_pending_exception(pe);
+				goto next_snapshot;
+			}
+
+			pe = __find_pending_exception(snap, pe, chunk);
 			if (!pe) {
 				__invalidate_snapshot(snap, -ENOMEM);
 				goto next_snapshot;
