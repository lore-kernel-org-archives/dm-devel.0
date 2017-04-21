From: damien.lemoal@wdc.com
Subject: [PATCH 06/10] dm: Introduce dm_remap_zone_report()
Date: Fri, 21 Apr 2017 12:55:54 +0900
Message-ID: <20170421035558.2657-7-damien.lemoal@wdc.com>
References: <20170421035558.2657-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170421035558.2657-1-damien.lemoal@wdc.com>
Sender: linux-block-owner@vger.kernel.org
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>, Bart Van Assche <Bart.VanAssche@sandisk.com>, linux-block@vger.kernel.org, Damien Le Moal <damien.lemoal@wdc.com>
List-Id: dm-devel.ids

From: Damien Le Moal <damien.lemoal@wdc.com>

A target driver support zoned block devices and exposing it as such may
receive REQ_OP_ZONE_REPORT request for the user to determine the mapped
device zone configuration. To process properly such request, the target
driver may need to remap the zone descriptors provided in the report
reply. The helper function dm_remap_zone_report() does this generically
using only the target start offset and length and the start offset
within the target device.

dm_remap_zone_report() will remap the start sector of all zones
reported. If the report includes sequential zones, the write pointer
position of these zones will also be remapped.

Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/md/dm.c               | 80 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h | 10 ++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index cd44928..1f6558e 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -975,6 +975,86 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
 }
 EXPORT_SYMBOL_GPL(dm_accept_partial_bio);
 
+#ifdef CONFIG_BLK_DEV_ZONED
+/*
+ * The zone descriptors obtained with a zone report indicate
+ * zone positions within the target device. The zone descriptors
+ * must be remapped to match their position within the dm device.
+ * A target may call dm_remap_zone_report after completion of a
+ * REQ_OP_ZONE_REPORT bio to remap the zone descriptors obtained
+ * from the target device mapping to the dm device.
+ */
+void dm_remap_zone_report(struct dm_target *ti, struct bio *bio, sector_t start)
+{
+	struct dm_target_io *tio =
+		container_of(bio, struct dm_target_io, clone);
+	struct bio *report_bio = tio->io->bio;
+	struct blk_zone_report_hdr *hdr = NULL;
+	struct blk_zone *zone;
+	unsigned int nr_rep = 0;
+	unsigned int ofst;
+	struct bio_vec bvec;
+	struct bvec_iter iter;
+	void *addr;
+
+	if (bio->bi_error)
+		return;
+
+	/*
+	 * Remap the start sector of the reported zones. For sequential zones,
+	 * also remap the write pointer position.
+	 */
+	bio_for_each_segment(bvec, report_bio, iter) {
+
+		addr = kmap_atomic(bvec.bv_page);
+
+		/* Remember the report header in the first page */
+		if (!hdr) {
+			hdr = addr;
+			ofst = sizeof(struct blk_zone_report_hdr);
+		} else {
+			ofst = 0;
+		}
+
+		/* Set zones start sector */
+		while (hdr->nr_zones && ofst < bvec.bv_len) {
+			zone = addr + ofst;
+			if (zone->start >= start + ti->len) {
+				hdr->nr_zones = 0;
+				break;
+			}
+			zone->start = zone->start + ti->begin - start;
+			if (zone->type != BLK_ZONE_TYPE_CONVENTIONAL) {
+				if (zone->cond == BLK_ZONE_COND_FULL)
+					zone->wp = zone->start + zone->len;
+				else if (zone->cond == BLK_ZONE_COND_EMPTY)
+					zone->wp = zone->start;
+				else
+					zone->wp = zone->wp + ti->begin - start;
+			}
+			ofst += sizeof(struct blk_zone);
+			hdr->nr_zones--;
+			nr_rep++;
+		}
+
+		if (addr != hdr)
+			kunmap_atomic(addr);
+
+		if (!hdr->nr_zones)
+			break;
+
+	}
+
+	if (hdr) {
+		hdr->nr_zones = nr_rep;
+		kunmap_atomic(hdr);
+	}
+
+	bio_advance(report_bio, report_bio->bi_iter.bi_size);
+}
+EXPORT_SYMBOL_GPL(dm_remap_zone_report);
+#endif
+
 /*
  * Flush current->bio_list when the target map method blocks.
  * This fixes deadlocks in snapshot and possibly in other targets.
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index b3c2408..d21c761 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -433,6 +433,16 @@ struct gendisk *dm_disk(struct mapped_device *md);
 int dm_suspended(struct dm_target *ti);
 int dm_noflush_suspending(struct dm_target *ti);
 void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors);
+#ifdef CONFIG_BLK_DEV_ZONED
+void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
+			  sector_t start);
+#else
+static inline void dm_remap_zone_report(struct dm_target *ti, struct bio *bio,
+					sector_t start)
+{
+	bio->bi_error = -ENOTSUPP;
+}
+#endif
 union map_info *dm_get_rq_mapinfo(struct request *rq);
 
 struct queue_limits *dm_get_queue_limits(struct mapped_device *md);
-- 
2.9.3
