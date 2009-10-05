From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 11/12]
	dm-snapshot-merge-redirect-to-origin-if-invalidated
Date: Mon,  5 Oct 2009 15:02:46 -0400
Message-ID: <1254769367-12111-12-git-send-email-snitzer@redhat.com>
References: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1254769367-12111-1-git-send-email-snitzer@redhat.com>
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

If we are merging invalidated snapshot, redirect all accesses to the origin
device.

Userspace code will remove the invalidated snapshot anyway after a few seconds,
but during this period, the origin device must be active (it may for example
contain root filesystem and having unbootable computer is not desirable).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 8060fe3..e0d0c30 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1458,11 +1458,9 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 
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
 	e = lookup_exception(&s->complete, chunk);
@@ -1486,6 +1484,7 @@ static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
 		goto out_unlock;
 	}
 
+ redirect_to_origin:
 	bio->bi_bdev = s->origin->bdev;
 
 	if (bio_rw(bio) == WRITE) {
-- 
1.6.2.5
