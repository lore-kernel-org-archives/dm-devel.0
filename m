From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: verify each target is H/W sector
	aligned
Date: Wed, 15 Apr 2009 14:46:10 -0400
Message-ID: <1239821170-8989-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Return-path: <dm-devel-bounces@redhat.com>
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
List-Id: dm-devel.ids

Establish device limits prior to verifying a target is H/W sector
aligned.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
dm_set_device_limits() is now are now established prior to the call check_device_area()
---
 drivers/md/dm-table.c |   50 ++++++++++++++++++++++++++++++++++++------------
 1 files changed, 37 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 429b50b..e8f8d11 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -384,15 +384,39 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
 /*
  * If possible, this checks an area of a destination device is valid.
  */
-static int check_device_area(struct dm_dev_internal *dd, sector_t start,
-			     sector_t len)
+static int check_device_area(struct dm_target *ti, struct block_device *bdev,
+			     sector_t start, sector_t len)
 {
-	sector_t dev_size = dd->dm_dev.bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	sector_t dev_size = bdev->bd_inode->i_size >> SECTOR_SHIFT;
+	unsigned short hardsect_size_sectors =
+		ti->limits.hardsect_size >> SECTOR_SHIFT;
+	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
 		return 1;
 
-	return ((start < dev_size) && (len <= (dev_size - start)));
+	if (!((start < dev_size) && (len <= (dev_size - start)))) {
+		DMWARN("%s: %s too small for target",
+		       dm_device_name(ti->table->md), bdevname(bdev, b));
+		return 0;
+	}
+
+	if (hardsect_size_sectors <= 1)
+		return 1;
+
+	if (start & (hardsect_size_sectors - 1)) {
+		DMWARN("%s: start=%lu in mapping of %s not H/W sector aligned",
+		       dm_device_name(ti->table->md), start, bdevname(bdev, b));
+		return 0;
+	}
+
+	if (len & (hardsect_size_sectors - 1)) {
+		DMWARN("%s: len=%lu in mapping of %s not H/W sector aligned",
+		       dm_device_name(ti->table->md), len, bdevname(bdev, b));
+		return 0;
+	}
+
+	return 1;
 }
 
 /*
@@ -478,14 +502,7 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
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
 
@@ -553,8 +570,15 @@ int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
 	int r = __table_get_device(ti->table, ti, path,
 				   start, len, mode, result);
 
-	if (!r)
-		dm_set_device_limits(ti, (*result)->bdev);
+	if (r)
+		return r;
+
+	dm_set_device_limits(ti, (*result)->bdev);
+
+	if (!check_device_area(ti, (*result)->bdev, start, len)) {
+		dm_put_device(ti, *result);
+		return -EINVAL;
+	}
 
 	return r;
 }
-- 
1.6.0.6
