From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 09/10] dm snapshot: Track snapshot-merged writes
Date: Tue,  1 Apr 2008 09:32:56 +0200
Message-ID: <1207035177-7156-10-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
	<1207035177-7156-5-git-send-email-markmc@redhat.com>
	<1207035177-7156-6-git-send-email-markmc@redhat.com>
	<1207035177-7156-7-git-send-email-markmc@redhat.com>
	<1207035177-7156-8-git-send-email-markmc@redhat.com>
	<1207035177-7156-9-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-9-git-send-email-markmc@redhat.com>
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

Add the ability to track writes to the snapshot-merged target which
have been mapped to the COW device.

Rationale is that we won't want to start merging a chunk until all
writes to that chunk have completed. Reads don't matter because the
contents of the chunk on the COW device is not affected by the merging
process.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |   36 +++++++++++++++++++++++++++++++-----
 1 files changed, 31 insertions(+), 5 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index 5236763..bc13f35 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1380,6 +1380,7 @@ static int merged_map(struct dm_target *ti, struct bio *bio,
 	struct dm_merged *merged = ti->private;
 	struct dm_snapshot *s = &merged->snap;
 	struct dm_snap_exception *e;
+	struct dm_snap_pending_exception *pe;
 	chunk_t chunk;
 	int r = DM_MAPIO_REMAPPED;;
 
@@ -1388,28 +1389,52 @@ static int merged_map(struct dm_target *ti, struct bio *bio,
 
 	chunk = sector_to_chunk(s, bio->bi_sector);
 
-	down_read(&s->lock);
+	down_write(&s->lock);
 
 	if (!s->valid) {
-		up_read(&s->lock);
+		up_write(&s->lock);
 		return -EIO;
 	}
 
 	e = lookup_exception(&s->complete, chunk);
-	if (e)
+	if (e) {
+		if (bio_rw(bio) == WRITE) {
+			pe = __find_pending_exception(s, chunk, 0);
+			if (!pe) {
+				__invalidate_snapshot(s, -ENOMEM);
+				r = -EIO;
+				goto out_unlock;
+			}
+                       map_context->ptr = pe;
+		}
+
 		remap_exception(s, e, bio, chunk);
-	else {
+	} else {
 		bio->bi_bdev = s->origin->bdev;
 
 		if (bio_rw(bio) == WRITE)
 			r = do_origin(s->origin, bio->bi_sector, bio);
 	}
 
-	up_read(&s->lock);
+out_unlock:
+	up_write(&s->lock);
 
 	return r;
 }
 
+static int merged_end_io(struct dm_target *ti, struct bio *bio,
+			 int error, union map_info *map_context)
+{
+	struct dm_snap_pending_exception *pe = map_context->ptr;
+
+	if (bio_rw(bio) != WRITE || !pe)
+		return error;
+
+	put_pending_exception(pe);
+
+	return error;
+}
+
 static void merged_resume(struct dm_target *ti)
 {
 	struct dm_merged *merged = ti->private;
@@ -1477,6 +1502,7 @@ static struct target_type merged_target = {
 	.ctr     = merged_ctr,
 	.dtr     = merged_dtr,
 	.map     = merged_map,
+	.end_io  = merged_end_io,
 	.resume  = merged_resume,
 	.status  = merged_status,
 };
-- 
1.5.4.1
