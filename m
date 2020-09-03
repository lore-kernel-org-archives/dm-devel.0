From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 8/9] block: use bd_partno in bdevname
Date: Thu,  3 Sep 2020 07:41:03 +0200
Message-ID: <20200903054104.228829-9-hch@lst.de>
References: <20200903054104.228829-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20200903054104.228829-1-hch@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, drbd-dev@lists.linbit.com, linux-ide@vger.kernel.org, linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org, linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
List-Id: dm-devel.ids

No need to go through the hd_struct to find the partition number.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/genhd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/genhd.c b/block/genhd.c
index 081f1039d9367f..771aa56b1a8c3d 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -85,7 +85,7 @@ char *disk_name(struct gendisk *hd, int partno, char *buf)
 
 const char *bdevname(struct block_device *bdev, char *buf)
 {
-	return disk_name(bdev->bd_disk, bdev->bd_part->partno, buf);
+	return disk_name(bdev->bd_disk, bdev->bd_partno, buf);
 }
 EXPORT_SYMBOL(bdevname);
 
-- 
2.28.0
