From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 1/3] dm table: ensure targets are aligned to
	logical_block_size
Date: Wed, 27 May 2009 17:06:51 -0400
Message-ID: <1243458413-15854-2-git-send-email-snitzer@redhat.com>
References: <1243458413-15854-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1243458413-15854-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: martin.petersen@oracle.com, agk@redhat.com, jens.axboe@oracle.com
List-Id: dm-devel.ids

Ensure I/O is aligned to the logical_block_size of target devices.

Rename check_device_area() to device_area_is_valid() for clarity and
establish the device limits including the logical block size prior to
calling it.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-table.c |   57 ++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -385,15 +385,45 @@ static void close_dev(struct dm_dev_inte
 /*
  * If possible, this checks an area of a destination device is valid.
  */
-static int check_device_area(struct dm_dev_internal *dd, sector_t start,
-			     sector_t len)
+static int device_area_is_valid(struct dm_target *ti, struct block_device *bdev,
+			     sector_t start, sector_t len)
 {
-	sector_t dev_size = dd->dm_dev.bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	unsigned short logical_block_size_sectors =
+		ti->limits.logical_block_size >> SECTOR_SHIFT;
+	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
 		return 1;
 
-	return ((start < dev_size) && (len <= (dev_size - start)));
+	if ((start >= dev_size) || (start + len > dev_size)) {
+		DMWARN("%s: %s too small for target",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		return 0;
+	}
+
+	if (logical_block_size_sectors <= 1)
+		return 1;
+
+	if (start & (logical_block_size_sectors - 1)) {
+		DMWARN("%s: start=%llu not aligned to h/w "
+		       "logical_block_size %hu of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)start,
+		       ti->limits.logical_block_size, bdevname(bdev, b));
+		return 0;
+	}
+
+	if (len & (logical_block_size_sectors - 1)) {
+		DMWARN("%s: len=%llu not aligned to h/w "
+		       "logical_block_size %hu of %s",
+		       dm_device_name(ti->table->md),
+		       (unsigned long long)len,
+		       ti->limits.logical_block_size, bdevname(bdev, b));
+		return 0;
+	}
+
+	return 1;
 }
 
 /*
@@ -479,14 +509,7 @@ static int __table_get_device(struct dm_
 	}
 	atomic_inc(&dd->count);
 
-	if (!check_device_area(dd, start, len)) {
-		DMWARN("device %s too small for target", path);
-		dm_put_device(ti, &dd->dm_dev);
-		return -EINVAL;
-	}
-
 	*result = &dd->dm_dev;
-
 	return 0;
 }
 
@@ -555,8 +578,16 @@ int dm_get_device(struct dm_target *ti, 
 	int r = __table_get_device(ti->table, ti, path,
 				   start, len, mode, result);
 
-	if (!r)
-		dm_set_device_limits(ti, (*result)->bdev);
+	if (r)
+		return r;
+
+	dm_set_device_limits(ti, (*result)->bdev);
+
+	if (!device_area_is_valid(ti, (*result)->bdev, start, len)) {
+		dm_put_device(ti, *result);
+		*result = NULL;
+		return -EINVAL;
+	}
 
 	return r;
 }
