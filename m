From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: [PATCH 4/7] block: gendisk integrity wrapper
Date: Wed,  1 Oct 2008 03:38:40 -0400
Message-ID: <1222846723-18213-5-git-send-email-martin.petersen@oracle.com>
References: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1222846723-18213-1-git-send-email-martin.petersen@oracle.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: jens.axboe@oracle.com, neilb@suse.de, agk@sourceware.org
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: dm-devel.ids

This is a wrapper for accessing a gendisk's integrity bits.  It allows
the integrity support in MD to be compiled with BLK_DEV_INTEGRITY off.

Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 include/linux/blkdev.h |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index eec0842..ca08439 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1027,6 +1027,11 @@ static inline struct blk_integrity *bdev_get_integrity(struct block_device *bdev
 	return bdev->bd_disk->integrity;
 }
 
+static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
+{
+	return disk->integrity;
+}
+
 static inline unsigned int bdev_get_tag_size(struct block_device *bdev)
 {
 	struct blk_integrity *bi = bdev_get_integrity(bdev);
@@ -1069,6 +1074,7 @@ static inline int blk_integrity_rq(struct request *rq)
 #define blk_rq_count_integrity_sg(a)		(0)
 #define blk_rq_map_integrity_sg(a, b)		(0)
 #define bdev_get_integrity(a)			(0)
+#define blk_get_integrity(a)			(0)
 #define bdev_get_tag_size(a)			(0)
 #define blk_integrity_compare(a, b)		(0)
 #define blk_integrity_register(a, b)		(0)
-- 
1.6.0.2
