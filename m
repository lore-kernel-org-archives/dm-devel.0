From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 11/13] dm snapshot: redirect accesses to
	origin if merging snap invalidated
Date: Thu,  3 Dec 2009 21:23:52 -0500
Message-ID: <1259893434-10792-12-git-send-email-snitzer@redhat.com>
References: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1259893434-10792-1-git-send-email-snitzer@redhat.com>
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
Cc: Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

From: Mikulas Patocka <mpatocka@redhat.com>

If we are merging an invalidated snapshot, redirect all accesses to the
origin device.  This is safe because snapshot_merge_process() will
stop_merge() if the merging snapshot becomes invalid.

Allowing the origin device to remain functional is important because it
may contain the root filesystem.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index c3578f5..257e2d1 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1573,11 +1573,9 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 
 	down_write(&s->lock);
 
-	/* Full snapshots are not usable */
-	if (!s->valid) {
-		r = -EIO;
-		goto out_unlock;
-	}
+	/* Full merging snapshots are redirected to the origin */
+	if (!s->valid)
+		goto redirect_to_origin;
 
 	/* If the block is already remapped - use that */
 	e = dm_lookup_exception(&s->complete, chunk);
@@ -1600,6 +1598,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 		goto out_unlock;
 	}
 
+ redirect_to_origin:
 	bio->bi_bdev = s->origin->bdev;
 
 	if (bio_rw(bio) == WRITE) {
-- 
1.6.5.2
