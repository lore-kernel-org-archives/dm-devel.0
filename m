From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 04/12] dm-snapshot-target-merge-no-new-alloc
Date: Mon,  5 Oct 2009 15:02:39 -0400
Message-ID: <1254769367-12111-5-git-send-email-snitzer@redhat.com>
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

Merge target shouldn't allocate new exceptions:
- make new method snapshot_merge_map that don't allocate exceptions.
- modify __origin_write so that it doesn't allocate exceptions in merging
  snapshots.
- disallow creating merging snapshots with exception store that doesn't
  provide .prepare_merge (e.g. transient)

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-snap.c |   53 +++++++++++++++++++++++++++++++++++++++++++++++++-
 1 files changed, 52 insertions(+), 1 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 27b2f22..31040f9 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -127,6 +127,11 @@ static int bdev_equal(struct block_device *lhs, struct block_device *rhs)
 	return lhs == rhs;
 }
 
+static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
+			       union map_info *map_context);
+
+#define is_merge(ti)	((ti)->type->map == snapshot_merge_map)
+
 struct dm_snap_pending_exception {
 	struct dm_snap_exception e;
 
@@ -655,6 +660,12 @@ static int snapshot_ctr(struct dm_target *ti, unsigned int argc, char **argv)
 	argv += args_used;
 	argc -= args_used;
 
+	if (is_merge(ti) && !s->store->type->prepare_merge) {
+		ti->error = "Merging snapshot must support snapshot-merge";
+		r = -EINVAL;
+		goto bad_merge_store;
+	}
+
 	r = dm_get_device(ti, origin_path, 0, ti->len, FMODE_READ, &s->origin);
 	if (r) {
 		ti->error = "Cannot get origin device";
@@ -756,6 +767,7 @@ bad_hash_tables:
 	dm_put_device(ti, s->origin);
 
 bad_origin:
+bad_merge_store:
 	dm_exception_store_destroy(s->store);
 
 bad_store:
@@ -1198,6 +1210,40 @@ static int snapshot_map(struct dm_target *ti, struct bio *bio,
 	return r;
 }
 
+static int snapshot_merge_map(struct dm_target *ti, struct bio *bio,
+			       union map_info *map_context)
+{
+	struct dm_snap_exception *e;
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
+	e = lookup_exception(&s->complete, chunk);
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
@@ -1305,6 +1351,11 @@ static int __origin_write(struct list_head *snapshots,
 	/* Do all the snapshots on this origin */
 	list_for_each_entry (snap, snapshots, list) {
 
+		/* If the snapshot is merging, don't make new exceptions in it
+		   - but in this case no one should be writing to the origin */
+		if (is_merge(snap->ti))
+			continue;
+
 		down_write(&snap->lock);
 
 		/* Only deal with valid and active snapshots */
@@ -1531,7 +1582,7 @@ static struct target_type snapshot_merge_target = {
 	.module  = THIS_MODULE,
 	.ctr     = snapshot_ctr,
 	.dtr     = snapshot_dtr,
-	.map     = snapshot_map,
+	.map     = snapshot_merge_map,
 	.end_io  = snapshot_end_io,
 	.resume  = snapshot_resume,
 	.status  = snapshot_status,
-- 
1.6.2.5
