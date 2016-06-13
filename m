From: Toshi Kani <toshi.kani@hpe.com>
Subject: [PATCH 2/6] block: Check GENHD_FL_DAX for DAX capability
Date: Mon, 13 Jun 2016 16:21:33 -0600
Message-ID: <1465856497-19698-3-git-send-email-toshi.kani@hpe.com>
References: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465856497-19698-1-git-send-email-toshi.kani@hpe.com>
Sender: linux-kernel-owner@vger.kernel.org
To: agk@redhat.com, snitzer@redhat.com, dan.j.williams@intel.com
Cc: ross.zwisler@linux.intel.com, viro@zeniv.linux.org.uk, axboe@kernel.dk, toshi.kani@hpe.com, linux-nvdimm@lists.01.org, dm-devel@redhat.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
List-Id: dm-devel.ids

Now that GENHD_FL_DAX is set to all drivers supporting DAX,
change bdev_direct_access() and __blkdev_get() to check this
GENHD_FL_DAX flag.

Signed-off-by: Toshi Kani <toshi.kani@hpe.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>
Cc: Ross Zwisler <ross.zwisler@linux.intel.com>
Cc: <linux-fsdevel@vger.kernel.org>
---
 fs/block_dev.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/fs/block_dev.c b/fs/block_dev.c
index 71ccab1..61935ee 100644
--- a/fs/block_dev.c
+++ b/fs/block_dev.c
@@ -493,7 +493,7 @@ long bdev_direct_access(struct block_device *bdev, struct blk_dax_ctl *dax)
 
 	if (size < 0)
 		return size;
-	if (!ops->direct_access)
+	if (!(bdev->bd_disk->flags & GENHD_FL_DAX) || !ops->direct_access)
 		return -EOPNOTSUPP;
 	if ((sector + DIV_ROUND_UP(size, 512)) >
 					part_nr_sects_read(bdev->bd_part))
@@ -1287,7 +1287,8 @@ static int __blkdev_get(struct block_device *bdev, fmode_t mode, int for_part)
 		bdev->bd_disk = disk;
 		bdev->bd_queue = disk->queue;
 		bdev->bd_contains = bdev;
-		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) && disk->fops->direct_access)
+		if (IS_ENABLED(CONFIG_BLK_DEV_DAX) &&
+		    disk->flags & GENHD_FL_DAX)
 			bdev->bd_inode->i_flags = S_DAX;
 		else
 			bdev->bd_inode->i_flags = 0;
