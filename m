From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3] dm table: verify each table mapping is HW
	sector aligned
Date: Mon, 13 Apr 2009 12:07:21 -0400
Message-ID: <1239638841-5033-1-git-send-email-snitzer@redhat.com>
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
--
 drivers/md/dm-table.c |  111 +++++++++++++++++++++++++++++++++++++++++++------
 1 files changed, 98 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 429b50b..38b4af0 100644
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
+		       dm_device_name(ti->table->md), start, bdevname(bdev, b));
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
@@ -693,6 +717,63 @@ static void check_for_valid_limits(struct io_restrictions *rs)
 		rs->bounce_pfn = -1;
 }
 
+/*
+ * Verify a table's targets can collectively accommodate the table's
+ * hardsect_size aligned I/O in addition to their own hardsect_size
+ * alignment; paying attention to target boundaries in the table
+ * - incoming I/O is aligned to the table's hardsect_size
+ * - each targets' len is aligned to the target's hardsect_size
+ */
+static int check_for_valid_alignment(struct dm_table *table)
+{
+	int r = 0;
+	unsigned int i, num_targets;
+	struct dm_target *ti = NULL;
+	unsigned short remaining_sectors = 0;
+	unsigned short ti_hardsect_size_sectors = 0;
+	unsigned short table_hardsect_size_sectors =
+		table->limits.hardsect_size >> SECTOR_SHIFT;
+
+	num_targets = dm_table_get_num_targets(table);
+	for (i = 0; i < num_targets; i++) {
+		ti = dm_table_get_target(table, i);
+		ti_hardsect_size_sectors =
+			ti->limits.hardsect_size >> SECTOR_SHIFT;
+
+		/*
+		 * Check that the previous target's remaining_sectors
+		 * do not disturb this target's hardsect_size alignment
+		 * - if remaining_sectors is greater than this
+		 *   target's len: it is the next target's concern
+		 */
+		if ((remaining_sectors && remaining_sectors < ti->len) &&
+		    (remaining_sectors & (ti_hardsect_size_sectors - 1))) {
+			r = -EINVAL;
+			break;
+		}
+
+		/*
+		 * Determine how many sectors (if any) will remain
+		 * for the table's next target to handle
+		 */
+		remaining_sectors = (ti->begin + ti->len) &
+			(table_hardsect_size_sectors - 1);
+		if (unlikely(ti->len < table_hardsect_size_sectors)) {
+			remaining_sectors = table_hardsect_size_sectors -
+				remaining_sectors;
+		}
+	}
+
+	if (remaining_sectors) {
+		DMWARN("%s: mapping with begin=%lu len=%lu "
+		       "not table H/W sector aligned",
+		       dm_device_name(table->md), ti->begin, ti->len);
+		r = -EINVAL;
+	}
+
+	return r;
+}
+
 int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params)
 {
@@ -723,6 +804,10 @@ int dm_table_add_target(struct dm_table *t, const char *type,
 	tgt->len = len;
 	tgt->error = "Unknown error";
 
+	r = check_for_valid_alignment(t);
+	if (r)
+		return r;
+
 	/*
 	 * Does this target adjoin the previous one ?
 	 */
