From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH] dm: Fix report zone remapping
Date: Fri,  5 Oct 2018 19:34:52 +0900
Message-ID: <20181005103452.7134-1-damien.lemoal@wdc.com>
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: stable@vger.kernel.org
List-Id: dm-devel.ids

If dm-linear or dm-flakey have targets on top of a partition of a zoned
block device, remapping of the start sector and write pointer position
of the zones reported by a report zones BIO must be modified to not
only account for the target table entry mapping, but also to account
for the partition first sector. This start sector must be substracted
to the start sector of all zones reported. The write pointer position
of sequential zones must also be reduced by this offset.

Since there is no easy way to access the underlying bdev of the target
table entry from the dm_target or dm_target_io pointers, modify the
interface of the function dm_remap_zone_report() to allow a target to
pass the partition block device starting sector (offset).

Fixes: 10999307c14e ("dm: introduce dm_remap_zone_report()")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: <stable@vger.kernel.org>
---
 drivers/md/dm-flakey.c        |  3 ++-
 drivers/md/dm-linear.c        |  3 ++-
 drivers/md/dm.c               | 16 ++++++++++++----
 include/linux/device-mapper.h |  2 +-
 4 files changed, 17 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 21d126a5078c..c68c2e9cde6b 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -381,7 +381,8 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 		return DM_ENDIO_DONE;
 
 	if (bio_op(bio) == REQ_OP_ZONE_REPORT) {
-		dm_remap_zone_report(ti, bio, fc->start);
+		dm_remap_zone_report(ti, bio, get_start_sect(fc->dev->bdev),
+				     fc->start);
 		return DM_ENDIO_DONE;
 	}
 
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d10964d41fd7..f8cd367abbf6 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -108,7 +108,8 @@ static int linear_end_io(struct dm_target *ti, struct bio *bio,
 	struct linear_c *lc = ti->private;
 
 	if (!*error && bio_op(bio) == REQ_OP_ZONE_REPORT)
-		dm_remap_zone_report(ti, bio, lc->start);
+		dm_remap_zone_report(ti, bio, get_start_sect(lc->dev->bdev),
+				     lc->start);
 
 	return DM_ENDIO_DONE;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20f7e4ef5342..ffd8544eedd8 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1162,7 +1162,8 @@ EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
  * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
  * from the target device mapping to the dm device.
  */
-void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
+void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
+			  sector_t dev_offset, sector_t start)
 {
 #ifdef CONFIG_BLK_DEV_ZONED
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
@@ -1195,18 +1196,25 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
 		/* Set zones start sector */
 		while (hdr->nr_zones && ofst < bvec.bv_len) {
 			zone = addr + ofst;
+			zone->start -= dev_offset;
 			if (zone->start >= start + ti->len) {
 				hdr->nr_zones = 0;
 				break;
 			}
 			zone->start = zone->start + ti->begin - start;
 			if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
-				if (zone->cond == BLK_ZONE_COND_FULL)
+				switch (zone->cond) {
+				case BLK_ZONE_COND_FULL:
 					zone->wp = zone->start + zone->len;
-				else if (zone->cond == BLK_ZONE_COND_EMPTY)
+					break;
+				case BLK_ZONE_COND_EMPTY:
 					zone->wp = zone->start;
-				else
+					break;
+				default:
+					zone->wp -= dev_offset;
 					zone->wp = zone->wp + ti->begin - start;
+					break;
+				}
 			}
 			ofst += sizeof(struct blk_zone);
 			hdr->nr_zones--;
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 6fb0808e87c8..22c1924c0ee8 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -421,7 +421,7 @@ int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
 void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
-			  sector_t start);
+			  sector_t dev_offset, sector_t start);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
-- 
2.17.1
