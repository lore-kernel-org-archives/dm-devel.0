From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH v2] dm: Fix report zone remapping
Date: Sat,  6 Oct 2018 14:58:07 +0900
Message-ID: <20181006055807.30104-1-damien.lemoal@wdc.com>
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
of the zones reported by a report zones BIO must be modified to not
only account for the target table entry mapping, but also to account
for the partition first sector. This start sector must be substracted
to the start sector of all zones reported. The write pointer position
of sequential zones must also be reduced by this offset.

To allow dm_remap_zone_report() to find out the device offset to be
used for remapping the zones, add a "struct dm_dev *dev" argument that
must be specified by the caller target to indicate the device that was
used for the execution. With this, the device offset can be obtained
simply with "get_start_sect(dev->bdev)".

Fixes: 10999307c14e ("dm: introduce dm_remap_zone_report()")
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
Cc: stable@vger.kernel.org
---

Changes from v1:
* Pass dm_dev arguument instead of a sector offset
* Update commit message

 drivers/md/dm-flakey.c        |  2 +-
 drivers/md/dm-linear.c        |  2 +-
 drivers/md/dm.c               | 17 +++++++++++++----
 include/linux/device-mapper.h |  4 ++--
 4 files changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/md/dm-flakey.c b/drivers/md/dm-flakey.c
index 21d126a5078c..5f3605844898 100644
--- a/drivers/md/dm-flakey.c
+++ b/drivers/md/dm-flakey.c
@@ -381,7 +381,7 @@ static int flakey_end_io(struct dm_target *ti, struct bio *bio,
 		return DM_ENDIO_DONE;
 
 	if (bio_op(bio) == REQ_OP_ZONE_REPORT) {
-		dm_remap_zone_report(ti, bio, fc->start);
+		dm_remap_zone_report(ti, fc->dev, bio, fc->start);
 		return DM_ENDIO_DONE;
 	}
 
diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index d10964d41fd7..e30b5d28c202 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -108,7 +108,7 @@ static int linear_end_io(struct dm_target *ti, struct bio *bio,
 	struct linear_c *lc = ti->private;
 
 	if (!*error && bio_op(bio) == REQ_OP_ZONE_REPORT)
-		dm_remap_zone_report(ti, bio, lc->start);
+		dm_remap_zone_report(ti, lc->dev, bio, lc->start);
 
 	return DM_ENDIO_DONE;
 }
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 20f7e4ef5342..a3424888be2e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1162,11 +1162,13 @@ EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
  * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
  * from the target device mapping to the dm device.
  */
-void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
+void dm_remap_zone_report(struct dm_target *ti, struct dm_dev *dev,
+			  struct bio *bio, sector_t start)
 {
 #ifdef CONFIG_BLK_DEV_ZONED
 	struct dm_target_io *tio = container_of(bio, struct dm_target_io, clone);
 	struct bio *report_bio = tio->io->orig_bio;
+	sector_t dev_offset = get_start_sect(dev->bdev);
 	struct blk_zone_report_hdr *hdr = NULL;
 	struct blk_zone *zone;
 	unsigned int nr_rep = 0;
@@ -1195,18 +1197,25 @@ void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
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
index 6fb0808e87c8..09e8d3f8dcfd 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -420,8 +420,8 @@ struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
-void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
-			  sector_t start);
+void dm_remap_zone_report(struct dm_target *ti, struct dm_dev *dev,
+			  struct bio *bio, sector_t start);
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
-- 
2.17.1
