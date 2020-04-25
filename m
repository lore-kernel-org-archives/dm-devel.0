From: Christoph Hellwig <hch@lst.de>
Subject: [PATCH 2/3] dm: remove the make_request_fn check in device_area_is_invalid
Date: Sat, 25 Apr 2020 09:53:35 +0200
Message-ID: <20200425075336.721021-3-hch@lst.de>
References: <20200425075336.721021-1-hch@lst.de>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20200425075336.721021-1-hch@lst.de>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>
Cc: dm-devel@redhat.com, linux-bcache@vger.kernel.org, linux-block@vger.kernel.org
List-Id: dm-devel.ids

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 0a2cc197f62b4..8277b959e00bd 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -279,7 +279,6 @@ static struct dm_dev_internal *find_device(struct list_head *l, dev_t dev)
 static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 				  sector_t start, sector_t len, void *data)
 {
-	struct request_queue *q;
 	struct queue_limits *limits = data;
 	struct block_device *bdev = dev->bdev;
 	sector_t dev_size =
@@ -288,22 +287,6 @@ static int device_area_is_invalid(struct dm_target *ti, struct dm_dev *dev,
 		limits->logical_block_size >> SECTOR_SHIFT;
 	char b[BDEVNAME_SIZE];
 
-	/*
-	 * Some devices exist without request functions,
-	 * such as loop devices not yet bound to backing files.
-	 * Forbid the use of such devices.
-	 */
-	q = bdev_get_queue(bdev);
-	if (!q || !q->make_request_fn) {
-		DMWARN("%s: %s is not yet initialised: "
-		       "start=%llu, len=%llu, dev_size=%llu",
-		       dm_device_name(ti->table->md), bdevname(bdev, b),
-		       (unsigned long long)start,
-		       (unsigned long long)len,
-		       (unsigned long long)dev_size);
-		return 1;
-	}
-
 	if (!dev_size)
 		return 0;
 
-- 
2.26.1
