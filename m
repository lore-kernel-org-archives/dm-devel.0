From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH v3 06/10] dm: Introduce dm_remap_zone_report()
Date: Mon, 8 May 2017 16:40:48 -0700
Message-ID: <20170508234052.32375-7-bart.vanassche@sandisk.com>
References: <20170508234052.32375-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20170508234052.32375-1-bart.vanassche@sandisk.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, Alasdair Kergon <agk@redhat.com>
Cc: Bart Van Assche <bart.vanassche@sandisk.com>, Damien Le Moal <damien.lemoal@wdc.com>, Christoph Hellwig <hch@lst.de>
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
Reviewed-by: Hannes Reinecke <hare@suse.com>
Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/md/dm.c               | 80 +++++++++++++++++++++++++++++++++++++++++++
 include/linux/device-mapper.h | 10 ++++++
 2 files changed, 90 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 023bbc0..df68142 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1009,6 +1009,86 @@ void dm_accept_partial_bio(struct bio *bio, unsigned n_sectors)
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
index afd25af..3a45254 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -450,6 +450,16 @@ struct gendisk *dm_disk(struct mapped_device *md);
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
