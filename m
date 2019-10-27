From: Damien Le Moal <damien.lemoal@wdc.com>
Subject: [PATCH 5/8] block: add zone open,
	close and finish ioctl support
Date: Sun, 27 Oct 2019 23:05:46 +0900
Message-ID: <20191027140549.26272-6-damien.lemoal@wdc.com>
References: <20191027140549.26272-1-damien.lemoal@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20191027140549.26272-1-damien.lemoal@wdc.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>, linux-scsi@vger.kernel.org, "Martin K . Petersen" <martin.petersen@oracle.com>, dm-devel@redhat.com, Mike Snitzer <snitzer@redhat.com>
Cc: Dmitry Fomichev <dmitry.fomichev@wdc.com>, Keith Busch <kbusch@kernel.org>, Hans Holmberg <Hans.Holmberg@wdc.com>, Ajay Joshi <ajay.joshi@wdc.com>, Matias Bjorling <matias.bjorling@wdc.com>
List-Id: dm-devel.ids

From: Ajay Joshi <ajay.joshi@wdc.com>

Introduce three new ioctl commands BLKOPENZONE, BLKCLOSEZONE and
BLKFINISHZONE to allow applications to control the condition of zones
on a zoned block device through the execution of the REQ_OP_ZONE_OPEN,
REQ_OP_ZONE_CLOSE and REQ_OP_ZONE_FINISH operations.

Contains contributions from Matias Bjorling, Hans Holmberg,
Dmitry Fomichev, Keith Busch, Damien Le Moal and Christoph Hellwig.

Signed-off-by: Ajay Joshi <ajay.joshi@wdc.com>
Signed-off-by: Matias Bjorling <matias.bjorling@wdc.com>
Signed-off-by: Hans Holmberg <hans.holmberg@wdc.com>
Signed-off-by: Dmitry Fomichev <dmitry.fomichev@wdc.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Damien Le Moal <damien.lemoal@wdc.com>
---
 block/blk-zoned.c             | 28 +++++++++++++++++++++++-----
 block/ioctl.c                 |  5 ++++-
 include/linux/blkdev.h        | 10 +++++-----
 include/uapi/linux/blkzoned.h | 17 ++++++++++++++---
 4 files changed, 46 insertions(+), 14 deletions(-)

diff --git a/block/blk-zoned.c b/block/blk-zoned.c
index dab34dc48fb6..481eaf7d04d4 100644
--- a/block/blk-zoned.c
+++ b/block/blk-zoned.c
@@ -357,15 +357,16 @@ int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 }
 
 /*
- * BLKRESETZONE ioctl processing.
+ * BLKRESETZONE, BLKOPENZONE, BLKCLOSEZONE and BLKFINISHZONE ioctl processing.
  * Called from blkdev_ioctl.
  */
-int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
-			     unsigned int cmd, unsigned long arg)
+int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
+			   unsigned int cmd, unsigned long arg)
 {
 	void __user *argp = (void __user *)arg;
 	struct request_queue *q;
 	struct blk_zone_range zrange;
+	enum req_opf op;
 
 	if (!argp)
 		return -EINVAL;
@@ -386,8 +387,25 @@ int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
 	if (copy_from_user(&zrange, argp, sizeof(struct blk_zone_range)))
 		return -EFAULT;
 
-	return blkdev_zone_mgmt(bdev, REQ_OP_ZONE_RESET,
-				zrange.sector, zrange.nr_sectors, GFP_KERNEL);
+	switch (cmd) {
+	case BLKRESETZONE:
+		op = REQ_OP_ZONE_RESET;
+		break;
+	case BLKOPENZONE:
+		op = REQ_OP_ZONE_OPEN;
+		break;
+	case BLKCLOSEZONE:
+		op = REQ_OP_ZONE_CLOSE;
+		break;
+	case BLKFINISHZONE:
+		op = REQ_OP_ZONE_FINISH;
+		break;
+	default:
+		return -ENOTTY;
+	}
+
+	return blkdev_zone_mgmt(bdev, op, zrange.sector, zrange.nr_sectors,
+				GFP_KERNEL);
 }
 
 static inline unsigned long *blk_alloc_zone_bitmap(int node,
diff --git a/block/ioctl.c b/block/ioctl.c
index 15a0eb80ada9..8756efb1419e 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -532,7 +532,10 @@ int blkdev_ioctl(struct block_device *bdev, fmode_t mode, unsigned cmd,
 	case BLKREPORTZONE:
 		return blkdev_report_zones_ioctl(bdev, mode, cmd, arg);
 	case BLKRESETZONE:
-		return blkdev_reset_zones_ioctl(bdev, mode, cmd, arg);
+	case BLKOPENZONE:
+	case BLKCLOSEZONE:
+	case BLKFINISHZONE:
+		return blkdev_zone_mgmt_ioctl(bdev, mode, cmd, arg);
 	case BLKGETZONESZ:
 		return put_uint(arg, bdev_zone_sectors(bdev));
 	case BLKGETNRZONES:
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index bf797a63388c..dbef541c2530 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -367,8 +367,8 @@ extern int blk_revalidate_disk_zones(struct gendisk *disk);
 
 extern int blkdev_report_zones_ioctl(struct block_device *bdev, fmode_t mode,
 				     unsigned int cmd, unsigned long arg);
-extern int blkdev_reset_zones_ioctl(struct block_device *bdev, fmode_t mode,
-				    unsigned int cmd, unsigned long arg);
+extern int blkdev_zone_mgmt_ioctl(struct block_device *bdev, fmode_t mode,
+				  unsigned int cmd, unsigned long arg);
 
 #else /* CONFIG_BLK_DEV_ZONED */
 
@@ -389,9 +389,9 @@ static inline int blkdev_report_zones_ioctl(struct block_device *bdev,
 	return -ENOTTY;
 }
 
-static inline int blkdev_reset_zones_ioctl(struct block_device *bdev,
-					   fmode_t mode, unsigned int cmd,
-					   unsigned long arg)
+static inline int blkdev_zone_mgmt_ioctl(struct block_device *bdev,
+					 fmode_t mode, unsigned int cmd,
+					 unsigned long arg)
 {
 	return -ENOTTY;
 }
diff --git a/include/uapi/linux/blkzoned.h b/include/uapi/linux/blkzoned.h
index 498eec813494..0cdef67135f0 100644
--- a/include/uapi/linux/blkzoned.h
+++ b/include/uapi/linux/blkzoned.h
@@ -120,9 +120,11 @@ struct blk_zone_report {
 };
 
 /**
- * struct blk_zone_range - BLKRESETZONE ioctl request
- * @sector: starting sector of the first zone to issue reset write pointer
- * @nr_sectors: Total number of sectors of 1 or more zones to reset
+ * struct blk_zone_range - BLKRESETZONE/BLKOPENZONE/
+ *                         BLKCLOSEZONE/BLKFINISHZONE ioctl
+ *                         requests
+ * @sector: Starting sector of the first zone to operate on.
+ * @nr_sectors: Total number of sectors of all zones to operate on.
  */
 struct blk_zone_range {
 	__u64		sector;
@@ -139,10 +141,19 @@ struct blk_zone_range {
  *                sector range. The sector range must be zone aligned.
  * @BLKGETZONESZ: Get the device zone size in number of 512 B sectors.
  * @BLKGETNRZONES: Get the total number of zones of the device.
+ * @BLKOPENZONE: Open the zones in the specified sector range.
+ *               The 512 B sector range must be zone aligned.
+ * @BLKCLOSEZONE: Close the zones in the specified sector range.
+ *                The 512 B sector range must be zone aligned.
+ * @BLKFINISHZONE: Mark the zones as full in the specified sector range.
+ *                 The 512 B sector range must be zone aligned.
  */
 #define BLKREPORTZONE	_IOWR(0x12, 130, struct blk_zone_report)
 #define BLKRESETZONE	_IOW(0x12, 131, struct blk_zone_range)
 #define BLKGETZONESZ	_IOR(0x12, 132, __u32)
 #define BLKGETNRZONES	_IOR(0x12, 133, __u32)
+#define BLKOPENZONE	_IOW(0x12, 134, struct blk_zone_range)
+#define BLKCLOSEZONE	_IOW(0x12, 135, struct blk_zone_range)
+#define BLKFINISHZONE	_IOW(0x12, 136, struct blk_zone_range)
 
 #endif /* _UAPI_BLKZONED_H */
-- 
2.21.0
