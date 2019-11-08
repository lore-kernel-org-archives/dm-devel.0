From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 6/9] null_blk: clean up report zones
Date: Fri,  8 Nov 2019 10:56:59 +0900
Message-ID: <20191108015702.233102-7-damien.lemoal@wdc.com>
References: <20191108015702.233102-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-f2fs-devel-bounces@lists.sourceforge.net>
In-Reply-To: <20191108015702.233102-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://lists.sourceforge.net/lists/options/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-f2fs-devel>
List-Post: <mailto:linux-f2fs-devel@lists.sourceforge.net>
List-Help: <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel>,
 <mailto:linux-f2fs-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-f2fs-devel-bounces@lists.sourceforge.net
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>, linux-f2fs-devel@lists.sourceforge.net, Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>
List-Id: dm-devel.ids

From: Christoph Hellwig <hch@lst.de>

Make the instance name match the method name and define the name to NULL
instead of providing an inline stub, which is rather pointless for a
method call.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 drivers/block/null_blk.h       | 11 +++--------
 drivers/block/null_blk_main.c  |  2 +-
 drivers/block/null_blk_zoned.c |  4 ++--
 3 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/block/null_blk.h b/drivers/block/null_blk.h
index 93c2a3d403da..9bf56fbab091 100644
--- a/drivers/block/null_blk.h
+++ b/drivers/block/null_blk.h
@@ -91,8 +91,8 @@ struct nullb {
 #ifdef CONFIG_BLK_DEV_ZONED
 int null_zone_init(struct nullb_device *dev);
 void null_zone_exit(struct nullb_device *dev);
-int null_zone_report(struct gendisk *disk, sector_t sector,
-		     struct blk_zone *zones, unsigned int *nr_zones);
+int null_report_zones(struct gendisk *disk, sector_t sector,
+		      struct blk_zone *zones, unsigned int *nr_zones);
 blk_status_t null_handle_zoned(struct nullb_cmd *cmd,
 				enum req_opf op, sector_t sector,
 				sector_t nr_sectors);
@@ -105,12 +105,6 @@ static inline int null_zone_init(struct nullb_device *dev)
 	return -EINVAL;
 }
 static inline void null_zone_exit(struct nullb_device *dev) {}
-static inline int null_zone_report(struct gendisk *disk, sector_t sector,
-				   struct blk_zone *zones,
-				   unsigned int *nr_zones)
-{
-	return -EOPNOTSUPP;
-}
 static inline blk_status_t null_handle_zoned(struct nullb_cmd *cmd,
 					     enum req_opf op, sector_t sector,
 					     sector_t nr_sectors)
@@ -123,5 +117,6 @@ static inline size_t null_zone_valid_read_len(struct nullb *nullb,
 {
 	return len;
 }
+#define null_report_zones	NULL
 #endif /* CONFIG_BLK_DEV_ZONED */
 #endif /* __NULL_BLK_H */
diff --git a/drivers/block/null_blk_main.c b/drivers/block/null_blk_main.c
index 89d385bab45b..2687eb36441c 100644
--- a/drivers/block/null_blk_main.c
+++ b/drivers/block/null_blk_main.c
@@ -1444,7 +1444,7 @@ static void null_config_discard(struct nullb *nullb)
 
 static const struct block_device_operations null_ops = {
 	.owner		= THIS_MODULE,
-	.report_zones	= null_zone_report,
+	.report_zones	= null_report_zones,
 };
 
 static void null_init_queue(struct nullb *nullb, struct nullb_queue *nq)
diff --git a/drivers/block/null_blk_zoned.c b/drivers/block/null_blk_zoned.c
index 02f41a3bc4cb..00696f16664b 100644
--- a/drivers/block/null_blk_zoned.c
+++ b/drivers/block/null_blk_zoned.c
@@ -66,8 +66,8 @@ void null_zone_exit(struct nullb_device *dev)
 	kvfree(dev->zones);
 }
 
-int null_zone_report(struct gendisk *disk, sector_t sector,
-		     struct blk_zone *zones, unsigned int *nr_zones)
+int null_report_zones(struct gendisk *disk, sector_t sector,
+		      struct blk_zone *zones, unsigned int *nr_zones)
 {
 	struct nullb *nullb = disk->private_data;
 	struct nullb_device *dev = nullb->dev;
-- 
2.23.0
