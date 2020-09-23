From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/2] dm: add support for REQ_NOWAIT and enable it for linear target
Date: Wed, 23 Sep 2020 16:06:52 -0400
Message-ID: <20200923200652.11082-3-snitzer@redhat.com>
References: <20200923200652.11082-1-snitzer@redhat.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: Mike Snitzer <snitzer@gmail.com>
In-Reply-To: <20200923200652.11082-1-snitzer@redhat.com>
To: Jens Axboe <axboe@kernel.dk>
Cc: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>, hch@lst.de, dm-devel@redhat.com, linux-block@vger.kernel.org
List-Id: dm-devel.ids

From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>

Add DM target feature flag DM_TARGET_NOWAIT which advertises that
target works with REQ_NOWAIT bios.

Add dm_table_supports_nowait() and update dm_table_set_restrictions()
to set/clear QUEUE_FLAG_NOWAIT accordingly.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-linear.c        |  5 +++--
 drivers/md/dm-table.c         | 32 ++++++++++++++++++++++++++++++++
 drivers/md/dm.c               |  4 +++-
 include/linux/device-mapper.h |  6 ++++++
 4 files changed, 44 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index e1db43446327..00774b5d7668 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -228,10 +228,11 @@ static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 4, 0},
 #ifdef CONFIG_BLK_DEV_ZONED
-	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_ZONED_HM,
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
+		    DM_TARGET_ZONED_HM,
 	.report_zones = linear_report_zones,
 #else
-	.features = DM_TARGET_PASSES_INTEGRITY,
+	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT,
 #endif
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index acba92500c12..17fb9b96d18e 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1719,6 +1719,33 @@ static bool dm_table_supports_write_zeroes(struct dm_table *t)
 	return true;
 }
 
+static int device_not_nowait_capable(struct dm_target *ti, struct dm_dev *dev,
+				     sector_t start, sector_t len, void *data)
+{
+	struct request_queue *q = bdev_get_queue(dev->bdev);
+
+	return q && !blk_queue_nowait(q);
+}
+
+static bool dm_table_supports_nowait(struct dm_table *t)
+{
+	struct dm_target *ti;
+	unsigned i = 0;
+
+	while (i < dm_table_get_num_targets(t)) {
+		ti = dm_table_get_target(t, i++);
+
+		if (!dm_target_supports_nowait(ti->type))
+			return false;
+
+		if (!ti->type->iterate_devices ||
+		    ti->type->iterate_devices(ti, device_not_nowait_capable, NULL))
+			return false;
+	}
+
+	return true;
+}
+
 static int device_not_discard_capable(struct dm_target *ti, struct dm_dev *dev,
 				      sector_t start, sector_t len, void *data)
 {
@@ -1821,6 +1848,11 @@ void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	 */
 	q->limits = *limits;
 
+	if (dm_table_supports_nowait(t))
+		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
+	else
+		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
+
 	if (!dm_table_supports_discards(t)) {
 		blk_queue_flag_clear(QUEUE_FLAG_DISCARD, q);
 		/* Must also clear discard limits... */
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index b110b5eb99a5..3ad4a8da8b15 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1733,7 +1733,9 @@ static blk_qc_t dm_submit_bio(struct bio *bio)
 	if (unlikely(test_bit(DMF_BLOCK_IO_FOR_SUSPEND, &md->flags))) {
 		dm_put_live_table(md, srcu_idx);
 
-		if (!(bio->bi_opf & REQ_RAHEAD))
+		if (bio->bi_opf & REQ_NOWAIT)
+			bio_wouldblock_error(bio);
+		else if (!(bio->bi_opf & REQ_RAHEAD))
 			queue_io(md, bio);
 		else
 			bio_io_error(bio);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 57610fc3013e..ba3b0979e09f 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -252,6 +252,12 @@ struct target_type {
 #define DM_TARGET_ZONED_HM		0x00000040
 #define dm_target_supports_zoned_hm(type) ((type)->features & DM_TARGET_ZONED_HM)
 
+/*
+ * A target handles REQ_NOWAIT
+ */
+#define DM_TARGET_NOWAIT		0x00000080
+#define dm_target_supports_nowait(type) ((type)->features & DM_TARGET_NOWAIT)
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
-- 
2.15.0
