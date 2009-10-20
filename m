From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v2 09/17] dm snapshot: merge target should not
	allocate new exceptions
Date: Tue, 20 Oct 2009 18:46:57 -0400
Message-ID: <1256078825-11331-10-git-send-email-snitzer@redhat.com>
References: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1256078825-11331-1-git-send-email-snitzer@redhat.com>
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

Make new method, snapshot_merge_map, that won't allocate exceptions.
Modify __origin_write so that it doesn't allocate exceptions in
merging snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Reviewed-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   46 +++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 45 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index d83a26e..ea3ff81 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -147,6 +147,11 @@ static int bdev_equal(struct block_device *lhs, struct block_device *rhs)
 	return lhs == rhs;
 }
 
+static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
+			       union map_info *map_context);
+
+#define is_merge(ti)	((ti)->type->map == snapshot_merge_map)
+
 struct dm_snap_pending_exception {
 	struct dm_exception e;
 
@@ -1239,6 +1244,40 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	return r;
 }
 
+static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
+			       union map_info *map_context)
+{
+	struct dm_exception *e;
+	struct dm_snapshot *s = ti->private;
+	int r = DM_MAPIO_REMAPPED;
+	chunk_t chunk;
+
+	chunk = sector_to_chunk(s->store, bio->bi_sector);
+
+	down_read(&s->lock);
+
+	/* Full snapshots are not usable */
+	if (!s->valid) {
+		r = -EIO;
+		goto out_unlock;
+	}
+
+	/* If the block is already remapped - use that */
+	e = dm_lookup_exception(&s->complete, chunk);
+	if (e) {
+		remap_exception(s, e, bio, chunk);
+		goto out_unlock;
+	}
+
+	bio->bi_bdev = s->origin->bdev;
+
+ out_unlock:
+	up_read(&s->lock);
+
+	return r;
+}
+
+
 static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
 			   int error, union map_info *map_context)
 {
@@ -1358,6 +1397,11 @@ static int __origin_write(struct list_head *snapshots,
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
 
+		/* If the snapshot is merging, don't make new exceptions in it
+		   - but in this case no one should be writing to the origin */
+		if (is_merge(snap->ti))
+			continue;
+
 		down_write(&snap->lock);
 
 		/* Only deal with valid and active snapshots */
@@ -1585,7 +1629,7 @@ static struct target_type merge_target = {
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
-	.map     = snapshot_map,
+	.map     = snapshot_merge_map,
 	.end_io  = snapshot_end_io,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
-- 
1.6.5.rc2
