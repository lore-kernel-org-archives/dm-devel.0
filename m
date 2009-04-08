From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: verify each table mapping is HW sector
	aligned
Date: Tue,  7 Apr 2009 22:35:11 -0400
Message-ID: <1239158111-3976-1-git-send-email-snitzer@redhat.com>
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

Each mapping in a DM table must be properly aligned on HW sector
boundaries.  This is particularly important when a DM table is composed
of mappings for devices with different HW sector sizes.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   43 +++++++++++++++++++++++++++++++------------
 1 files changed, 31 insertions(+), 12 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e8361b1..0ff8b27 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -387,15 +387,34 @@ static void close_dev(struct dm_dev_internal *d, struct mapped_device *md)
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
+	struct io_restrictions *rs = &ti->limits;
+	sector_t dev_hardsectors = rs->hardsect_size >> SECTOR_SHIFT;
+	char b[BDEVNAME_SIZE];
 
 	if (!dev_size)
 		return 1;
 
-	return ((start < dev_size) && (len <= (dev_size - start)));
+	if (!((start < dev_size) && (len <= (dev_size - start)))) {
+		DMWARN("device %s too small for target", bdevname(bdev, b));
+		return 0;
+	}
+
+	if (dev_hardsectors > 1) {
+		if ((ti->begin % dev_hardsectors) ||
+		    (start % dev_hardsectors) ||
+		    (len % dev_hardsectors)) {
+			DMWARN("device %s mapping (%lu %lu ... %lu) "
+			       "is not HW sector aligned",
+			       bdevname(bdev, b), ti->begin, len, start);
+			return 0;
+		}
+	}
+
+	return 1;
 }
 
 /*
@@ -481,14 +500,7 @@ static int __table_get_device(struct dm_table *t, struct dm_target *ti,
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
 
@@ -556,9 +568,16 @@ int dm_get_device(struct dm_target *ti, const char *path, sector_t start,
 	int r = __table_get_device(ti->table, ti, path,
 				   start, len, mode, result);
 
-	if (!r)
+	if (!r) {
 		dm_set_device_limits(ti, (*result)->bdev);
 
+		if (!check_device_area(ti, (*result)->bdev,
+				       start, len)) {
+			dm_put_device(ti, *result);
+			return -EINVAL;
+		}
+	}
+
 	return r;
 }
 
