From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 06/10] dm snapshot: Make find_pending_exception()
	not take a bio
Date: Tue,  1 Apr 2008 09:32:53 +0200
Message-ID: <1207035177-7156-7-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
	<1207035177-7156-5-git-send-email-markmc@redhat.com>
	<1207035177-7156-6-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-6-git-send-email-markmc@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: agk@redhat.com
Cc: Mark McLoughlin <markmc@redhat.com>, dm-devel@redhat.com
List-Id: dm-devel.ids

Change __find_pending_exception() so that it takes an old chunk index
and "prepare" flag rather than a bio structure.

Rationale is that the merged target will use the pending exception
table for tracking writes which have been mapped to the COW device. In
such cases, we won't want a new exception to be prepared in the
exception store.

Also, the merged target will want to trigger an exception in all
associated snapshots without a corresponding bio structure. We'll need
to do this when initiating a copy from the COW device to the origin
device.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 7684f8f..e64b9b4 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -881,11 +881,10 @@ static void start_copy(struct dm_snap_pending_exception *pe)
  * this.
  */
 static struct dm_snap_pending_exception *
-__find_pending_exception(struct dm_snapshot *s, struct bio *bio)
+__find_pending_exception(struct dm_snapshot *s, chunk_t chunk, int prepare)
 {
 	struct dm_snap_exception *e;
 	struct dm_snap_pending_exception *pe;
-	chunk_t chunk = sector_to_chunk(s, bio->bi_sector);
 	unsigned long flags;
 
 	spin_lock_irqsave(&s->pe_lock, flags);
@@ -934,7 +933,7 @@ __find_pending_exception(struct dm_snapshot *s, struct bio *bio)
 	insert_exception(&s->pending, &pe->e);
 
  ref_and_out:
-	if (bio_rw(bio) != WRITE)
+	if (!prepare)
 		get_pending_exception(pe);
 	else if (!pe->started) {
 		if (s->store.prepare_exception(&s->store, &pe->e)) {
@@ -992,7 +991,7 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 		goto out_unlock;
 	}
 
-	pe = __find_pending_exception(s, bio);
+	pe = __find_pending_exception(s, chunk, bio_rw(bio) == WRITE);
 	if (!pe) {
 		__invalidate_snapshot(s, -ENOMEM);
 		r = -EIO;
@@ -1142,7 +1141,7 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 		if (e)
 			goto next_snapshot;
 
-		pe = __find_pending_exception(snap, bio);
+		pe = __find_pending_exception(snap, chunk, 1);
 		if (!pe) {
 			__invalidate_snapshot(snap, -ENOMEM);
 			goto next_snapshot;
-- 
1.5.4.1
