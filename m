From: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
Subject: [PATCH RFC 3/3] dm: add support for REQ_NOWAIT and enable for target
 dm-linear
Date: Mon, 01 Jun 2020 15:37:16 +0300
Message-ID: <159101503621.180989.6036577504611218020.stgit@buzz>
References: <159101473169.180989.12175693728191972447.stgit@buzz>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <159101473169.180989.12175693728191972447.stgit@buzz>
Sender: linux-block-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>
List-Id: dm-devel.ids

Add dm target feature flag DM_TARGET_NOWAIT which tells that target
has no problem with REQ_NOWAIT.

Set limits.nowait_requests if all targets and backends handle REQ_NOWAIT.

Signed-off-by: Konstantin Khlebnikov <khlebnikov@yandex-team.ru>
---
 drivers/md/dm-linear.c        |    5 +++--
 drivers/md/dm-table.c         |    3 +++
 drivers/md/dm.c               |    4 +++-
 include/linux/device-mapper.h |    6 ++++++
 4 files changed, 15 insertions(+), 3 deletions(-)

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
index 0a2cc197f62b..f4610f79ebd6 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1500,12 +1500,15 @@ int dm_calculate_queue_limits(struct dm_table *table,
 	unsigned int zone_sectors = 0;
 
 	blk_set_stacking_limits(limits);
+	limits->nowait_requests = 1;
 
 	for (i = 0; i < dm_table_get_num_targets(table); i++) {
 		blk_set_stacking_limits(&ti_limits);
 
 		ti = dm_table_get_target(table, i);
 
+		ti_limits.nowait_requests = dm_target_supports_nowait(ti->type);
+
 		if (!ti->type->iterate_devices)
 			goto combine_limits;
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index db9e46114653..767cd4d70341 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -1794,7 +1794,9 @@ static blk_qc_t dm_make_request(struct request_queue *q, struct bio *bio)
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
index af48d9da3916..4d4af1eeeba4 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -252,6 +252,12 @@ struct target_type {
 #define DM_TARGET_ZONED_HM		0x00000040
 #define dm_target_supports_zoned_hm(type) ((type)->features & DM_TARGET_ZONED_HM)
 
+/*
+ * A target handles REQ_NOWAIT
+ */
+#define DM_TARGET_NOWAIT		0x00000080
+#define dm_target_supports_nowait(type) (!!((type)->features & DM_TARGET_NOWAIT))
+
 struct dm_target {
 	struct dm_table *table;
 	struct target_type *type;
