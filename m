From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v3] dm: Fix report zone remapping
Date: Tue,  9 Oct 2018 14:24:31 +0900
Message-ID: <20181009052431.1348-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: linux-block@vger.kernel.org
List-Id: dm-devel.ids

If dm-linear or dm-flakey have targets on top of a partition of a zoned
block device, remapping of the start sector and write pointer position
of the zones reported by a report zones BIO must be modified to account
for the target table entry mapping (start offset within the device and
entry mapping with the dm device). If the target backing device is a
partition of a whole disk, the start sector on the physical device of
the partition must also be accounted for when modifying the zone
information. However, dm_remap_zone_report() was not considering this
last case, resulting in incorrect zone information remapping with
targets using disk partitions.

Fix this by calculating the target backing device start sector using
the position of the completed report zones BIO and the unchanged
position and size of the original report zone BIO. With this value
calculated, the start sector and write pointer position of the target
zones can be correctly remapped.

Fixes: 10999307c14e ("dm: introduce dm_remap_zone_report()")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
---
 drivers/md/dm.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20f7e4ef5342..f73c8a6b3f47 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1155,12 +1155,14 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
 /*
- * The zone descriptors obtained with a zone report indicate
- * zone positions within the target device. The zone descriptors
- * must be remapped to match their position within the dm device.
- * A target may call dm_remap_zone_report after completion of a
- * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
- * from the target device mapping to the dm device.
+ * The zone descriptors obtained with a zone report indicate zone positions
+ * within the target backing device, regardless of that device is a partition
+ * and regardless of the target mapping start sector on the device or partition.
+ * The zone descriptors start sector and write pointer position must be adjusted
+ * to match their relative position within the dm device.
+ * A target may call dm_remap_zone_report() after completion of a
+ * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained from the
+ * backing device.
  */
 void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
 {
@@ -1171,6 +1173,7 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
 	struct blk_zone *zone;
 	unsigned int nr_rep = 0;
 	unsigned int ofst;
+	sector_t part_offset;
 	struct bio_vec bvec;
 	struct bvec_iter iter;
 	void *addr;
@@ -1178,6 +1181,16 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
 	if (bio->bi_status)
 		return;
 
+	/*
+	 * bio sector was incremented by the request size on completion. Taking
+	 * into account the original request sector, the target start offset on
+	 * the backing device and the target mapping offset (ti->begin), the
+	 * start sector of the backing device. The partition offset is always 0
+	 * if the target uses a whole device.
+	 */
+	part_offset = bio->bi_iter.bi_sector + ti->begin
+		- (start + bio_end_sector(report_bio));
+
 	/*
 	 * Remap the start sector of the reported zones. For sequential zones,
 	 * also remap the write pointer position.
@@ -1195,6 +1208,7 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
 		/* Set zones start sector */
 		while (hdr->nr_zones && ofst < bvec.bv_len) {
 			zone = addr + ofst;
+			zone->start -= part_offset;
 			if (zone->start >= start + ti->len) {
 				hdr->nr_zones = 0;
 				break;
@@ -1206,7 +1220,8 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
 				else if (zone->cond == BLK_ZONE_COND_EMPTY)
 					zone->wp = zone->start;
 				else
-					zone->wp = zone->wp + ti->begin - start;
+					zone->wp = zone->wp + ti->begin
+						- start - part_offset;
 			}
 			ofst += sizeof(struct blk_zone);
 			hdr->nr_zones--;
-- 
2.17.1
