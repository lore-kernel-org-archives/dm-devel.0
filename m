From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v5 05/13] dm snapshot: merge target should not
	allocate new exceptions
Date: Thu,  3 Dec 2009 21:23:46 -0500
Message-ID: <1259893434-10792-6-git-send-email-snitzer@redhat.com>
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

The snapshot-merge target should not allocate new exceptions because the
intent is to merge all of its exceptions as quickly and safely as
possible.

Introduce new method, snapshot_merge_map(), that won't allocate
exceptions.  Modify __origin_write() so that it doesn't allocate
exceptions in merging snapshots.

If a write request to a merging snapshot device is to be dispatched
directly to the origin (because the chunk is not remapped or was already
merged), snapshot_merge_map() must make exceptions in other snapshots.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   62 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 60 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 15c29a5..c232460 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -127,6 +127,10 @@ static int bdev_equal(struct block_device *lhs, struct block_device *rhs)
 	return lhs == rhs;
 }
 
+static const char merge_target_name[] = "snapshot-merge";
+
+#define is_merge(ti) ((ti)->type->name == merge_target_name)
+
 struct dm_snap_pending_exception {
 	struct dm_exception e;
 
@@ -1294,6 +1298,53 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	return r;
 }
 
+/*
+ * I/O to a merging snapshot will be:
+ * - submitted to the origin: if there is no remapped chunk
+ * - submitted to the snapshot: if there is a remapped chunk
+ *
+ * If a write request to a merging snapshot device is to be dispatched
+ * directly to the origin (because the chunk is not remapped or was already
+ * merged), snapshot_merge_map() will make exceptions in other snapshots.
+ */
+static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
+			      union map_info *map_context)
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
+	if (bio_rw(bio) == WRITE) {
+		up_read(&s->lock);
+		return do_origin(s->origin, bio);
+	}
+
+ out_unlock:
+	up_read(&s->lock);
+
+	return r;
+}
+
 static int snapshot_end_io(struct dm_target *ti, struct bio *bio,
 			   int error, union map_info *map_context)
 {
@@ -1446,6 +1497,13 @@ static int __origin_write(struct list_head *snapshots,
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
 
+		/*
+		 * Don't make new exceptions in a merging snapshot
+		 * because it has effectively been deleted
+		 */
+		if (is_merge(snap->ti))
+			continue;
+
 		down_write(&snap->lock);
 
 		/* Only deal with valid and active snapshots */
@@ -1669,12 +1727,12 @@ static struct target_type snapshot_target = {
 };
 
 static struct target_type merge_target = {
-	.name    = "snapshot-merge",
+	.name    = merge_target_name,
 	.version = {1, 9, 0},
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
-	.map     = snapshot_map,
+	.map     = snapshot_merge_map,
 	.end_io  = snapshot_end_io,
 	.postsuspend = snapshot_postsuspend,
 	.preresume  = snapshot_preresume,
-- 
1.6.5.2
