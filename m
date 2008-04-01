From: Mark McLoughlin <markmc@redhat.com>
Subject: [PATCH 07/10] dm snapshot: Make origin_write() bio arg
	optional
Date: Tue,  1 Apr 2008 09:32:54 +0200
Message-ID: <1207035177-7156-8-git-send-email-markmc@redhat.com>
References: <1207035177-7156-1-git-send-email-markmc@redhat.com>
	<1207035177-7156-2-git-send-email-markmc@redhat.com>
	<1207035177-7156-3-git-send-email-markmc@redhat.com>
	<1207035177-7156-4-git-send-email-markmc@redhat.com>
	<1207035177-7156-5-git-send-email-markmc@redhat.com>
	<1207035177-7156-6-git-send-email-markmc@redhat.com>
	<1207035177-7156-7-git-send-email-markmc@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1207035177-7156-7-git-send-email-markmc@redhat.com>
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

Similar to the previous patch, change the arguments to
__origin_write() so that rather than requiring a bio structure, we
take a origin device sector index and optional bio structure.

Rationale is that the merged target will want to trigger an exception
in all associated snapshots before merging the chunk from the COW
to the origin and at this point we don't have a bio structure
corresponding to that copy.

Signed-off-by: Mark McLoughlin <markmc@redhat.com>
---
 drivers/md/dm-snap.c |   21 ++++++++++++++-------
 1 files changed, 14 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-snap.c b/drivers/md/dm-snap.c
index e64b9b4..e4ba02c 100644
--- a/drivers/md/dm-snap.c
+++ b/drivers/md/dm-snap.c
@@ -1103,7 +1103,8 @@ static int snapshot_status(struct dm_target *ti, status_type_t type,
 /*-----------------------------------------------------------------
  * Origin methods
  *---------------------------------------------------------------*/
-static int __origin_write(struct list_head *snapshots, struct bio *bio)
+static int __origin_write(struct list_head *snapshots, sector_t sector,
+			  struct bio *bio)
 {
 	int r = DM_MAPIO_REMAPPED;
 	struct dm_snapshot *snap;
@@ -1123,14 +1124,14 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			goto next_snapshot;
 
 		/* Nothing to do if writing beyond end of snapshot */
-		if (bio->bi_sector >= dm_table_get_size(snap->table))
+		if (sector >= dm_table_get_size(snap->table))
 			goto next_snapshot;
 
 		/*
 		 * Remember, different snapshots can have
 		 * different chunk sizes.
 		 */
-		chunk = sector_to_chunk(snap, bio->bi_sector);
+		chunk = sector_to_chunk(snap, sector);
 
 		/*
 		 * Check exception table to see if block
@@ -1166,7 +1167,8 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 			 */
 			get_pending_exception(primary_pe);
 
-			bio_list_add(&primary_pe->origin_bios, bio);
+			if (bio)
+				bio_list_add(&primary_pe->origin_bios, bio);
 
 			r = DM_MAPIO_SUBMITTED;
 		}
@@ -1212,7 +1214,8 @@ static int __origin_write(struct list_head *snapshots, struct bio *bio)
 /*
  * Called on a write from the origin driver.
  */
-static int do_origin(struct dm_dev *origin, struct bio *bio)
+static int do_origin(struct dm_dev *origin, sector_t sector,
+		     struct bio *bio)
 {
 	struct origin *o;
 	int r = DM_MAPIO_REMAPPED;
@@ -1220,7 +1223,7 @@ static int do_origin(struct dm_dev *origin, struct bio *bio)
 	down_read(&_origins_lock);
 	o = __lookup_origin(origin->bdev);
 	if (o)
-		r = __origin_write(&o->snapshots, bio);
+		r = __origin_write(&o->snapshots, sector, bio);
 	up_read(&_origins_lock);
 
 	return r;
@@ -1266,10 +1269,14 @@ static int origin_map(struct dm_target *ti, struct bio *bio,
 		      union map_info *map_context)
 {
 	struct dm_dev *dev = ti->private;
+
 	bio->bi_bdev = dev->bdev;
 
 	/* Only tell snapshots if this is a write */
-	return (bio_rw(bio) == WRITE) ? do_origin(dev, bio) : DM_MAPIO_REMAPPED;
+	if (bio_rw(bio) != WRITE)
+		return DM_MAPIO_REMAPPED;
+
+	return do_origin(dev, bio->bi_sector, bio);
 }
 
 #define min_not_zero(l, r) (l == 0) ? r : ((r == 0) ? l : min(l, r))
-- 
1.5.4.1
