From: Kirill Tkhai <ktkhai@virtuozzo.com>
Subject: [PATCH v6 1/6] block: Add @flags argument to
 bdev_write_zeroes_sectors()
Date: Mon, 10 Feb 2020 12:33:37 +0300
Message-ID: <158132721695.239613.5220696772652540347.stgit@localhost.localdomain>
References: <158132703141.239613.3550455492676290009.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <158132703141.239613.3550455492676290009.stgit@localhost.localdomain>
Sender: linux-kernel-owner@vger.kernel.org
To: martin.petersen@oracle.com, bob.liu@oracle.com, axboe@kernel.dk
Cc: agk@redhat.com, snitzer@redhat.com, dm-devel@redhat.com, song@kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca, Chaitanya.Kulkarni@wdc.com, darrick.wong@oracle.com, ming.lei@redhat.com, osandov@fb.com, jthumshirn@suse.de, minwoo.im.dev@gmail.com, damien.lemoal@wdc.com, andrea.parri@amarulasolutions.com, hare@suse.com, tj@kernel.org, ajay.joshi@wdc.com, sagi@grimberg.me, dsterba@suse.com, chaitanya.kulkarni@wdc.com, bvanassche@acm.org, dhowells@redhat.com, asml.silence@gmail.com, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, ktkhai@virtuozzo.com
List-Id: dm-devel.ids

This is a preparation for next patch, which introduces
a new flag BLKDEV_ZERO_ALLOCATE for calls, which need
only allocation of blocks and don't need actual blocks
zeroing.

Signed-off-by: Kirill Tkhai <ktkhai@virtuozzo.com>
Reviewed-by: Bob Liu <bob.liu@oracle.com>
Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
---
 block/blk-lib.c                     |    6 +++---
 drivers/md/dm-kcopyd.c              |    2 +-
 drivers/target/target_core_iblock.c |    4 ++--
 include/linux/blkdev.h              |    3 ++-
 4 files changed, 8 insertions(+), 7 deletions(-)

diff --git a/block/blk-lib.c b/block/blk-lib.c
index 5f2c429d4378..3e38c93cfc53 100644
--- a/block/blk-lib.c
+++ b/block/blk-lib.c
@@ -224,7 +224,7 @@ static int __blkdev_issue_write_zeroes(struct block_device *bdev,
 		return -EPERM;
 
 	/* Ensure that max_write_zeroes_sectors doesn't overflow bi_size */
-	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bdev);
+	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bdev, 0);
 
 	if (max_write_zeroes_sectors == 0)
 		return -EOPNOTSUPP;
@@ -362,7 +362,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 	sector_t bs_mask;
 	struct bio *bio;
 	struct blk_plug plug;
-	bool try_write_zeroes = !!bdev_write_zeroes_sectors(bdev);
+	bool try_write_zeroes = !!bdev_write_zeroes_sectors(bdev, 0);
 
 	bs_mask = (bdev_logical_block_size(bdev) >> 9) - 1;
 	if ((sector | nr_sects) & bs_mask)
@@ -391,7 +391,7 @@ int blkdev_issue_zeroout(struct block_device *bdev, sector_t sector,
 			try_write_zeroes = false;
 			goto retry;
 		}
-		if (!bdev_write_zeroes_sectors(bdev)) {
+		if (!bdev_write_zeroes_sectors(bdev, 0)) {
 			/*
 			 * Zeroing offload support was indicated, but the
 			 * device reported ILLEGAL REQUEST (for some devices
diff --git a/drivers/md/dm-kcopyd.c b/drivers/md/dm-kcopyd.c
index 1bbe4a34ef4c..f1b8e7926dd4 100644
--- a/drivers/md/dm-kcopyd.c
+++ b/drivers/md/dm-kcopyd.c
@@ -831,7 +831,7 @@ void dm_kcopyd_copy(struct dm_kcopyd_client *kc, struct dm_io_region *from,
 		 */
 		job->rw = REQ_OP_WRITE_ZEROES;
 		for (i = 0; i < job->num_dests; i++)
-			if (!bdev_write_zeroes_sectors(job->dests[i].bdev)) {
+			if (!bdev_write_zeroes_sectors(job->dests[i].bdev, 0)) {
 				job->rw = WRITE;
 				break;
 			}
diff --git a/drivers/target/target_core_iblock.c b/drivers/target/target_core_iblock.c
index 51ffd5c002de..73a63e197bf5 100644
--- a/drivers/target/target_core_iblock.c
+++ b/drivers/target/target_core_iblock.c
@@ -117,7 +117,7 @@ static int iblock_configure_device(struct se_device *dev)
 	 * Enable write same emulation for IBLOCK and use 0xFFFF as
 	 * the smaller WRITE_SAME(10) only has a two-byte block count.
 	 */
-	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bd);
+	max_write_zeroes_sectors = bdev_write_zeroes_sectors(bd, 0);
 	if (max_write_zeroes_sectors)
 		dev->dev_attrib.max_write_same_len = max_write_zeroes_sectors;
 	else
@@ -468,7 +468,7 @@ iblock_execute_write_same(struct se_cmd *cmd)
 		return TCM_INVALID_CDB_FIELD;
 	}
 
-	if (bdev_write_zeroes_sectors(bdev)) {
+	if (bdev_write_zeroes_sectors(bdev, 0)) {
 		if (!iblock_execute_zero_out(bdev, cmd))
 			return 0;
 	}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 053ea4b51988..1e3c08854b09 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1417,7 +1417,8 @@ static inline unsigned int bdev_write_same(struct block_device *bdev)
 	return 0;
 }
 
-static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev)
+static inline unsigned int bdev_write_zeroes_sectors(struct block_device *bdev,
+						     unsigned int flags)
 {
 	struct request_queue *q = bdev_get_queue(bdev);
 
