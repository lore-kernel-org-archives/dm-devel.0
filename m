From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm table: verify a DM device is H/W sector
	aligned
Date: Wed, 15 Apr 2009 14:46:35 -0400
Message-ID: <1239821195-9012-1-git-send-email-snitzer@redhat.com>
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

Verify a table's targets can collectively accommodate the device's
hardsect_size aligned I/O in addition to their own hardsect_size
alignment; paying attention to target boundaries in the table.
- incoming I/O is aligned to the device's hardsect_size
- each target is aligned to the target's hardsect_size
- device's hardsect_size >= each targets' hardsect_size
- device and targets' hardsect_size are always powers of 2

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   65 +++++++++++++++++++++++++++++++++++++++++++++++++
 1 files changed, 65 insertions(+), 0 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index e8f8d11..6e74e9a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -717,6 +717,67 @@ static void check_for_valid_limits(struct io_restrictions *rs)
 		rs->bounce_pfn = -1;
 }
 
+/*
+ * Verify a table's targets can collectively accommodate the device's
+ * hardsect_size aligned I/O in addition to their own hardsect_size
+ * alignment; paying attention to target boundaries in the table
+ * - incoming I/O is aligned to the device's hardsect_size
+ * - each target is aligned to the target's hardsect_size
+ * - device's hardsect_size >= each targets' hardsect_size
+ * - device and targets' hardsect_size are always powers of 2
+ */
+static int check_for_valid_alignment(struct dm_table *table)
+{
+	int r = 0;
+	unsigned int i, num_targets;
+	struct dm_target *ti = NULL;
+	unsigned short partial_sectors, remaining_sectors = 0;
+	unsigned short ti_hardsect_size_sectors = 0;
+	unsigned short device_hardsect_size_sectors =
+		table->limits.hardsect_size >> SECTOR_SHIFT;
+
+	num_targets = dm_table_get_num_targets(table);
+	for (i = 0; i < num_targets; i++) {
+		ti = dm_table_get_target(table, i);
+		ti_hardsect_size_sectors =
+			ti->limits.hardsect_size >> SECTOR_SHIFT;
+
+		/*
+		 * Check that remaining_sectors from the previous target
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
+		 * Determine if device's hardsect_size aligned I/O crosses
+		 * target boundaries; any remaining_sectors must be handled
+		 * by the next target(s) -- otherwise the table is misaligned
+		 */
+		partial_sectors = (ti->begin + ti->len) &
+			(device_hardsect_size_sectors - 1);
+		if (partial_sectors) {
+			remaining_sectors = device_hardsect_size_sectors -
+				partial_sectors;
+		} else
+			remaining_sectors = 0;
+	}
+
+	if (remaining_sectors) {
+		DMWARN("%s: mapping with begin=%lu len=%lu "
+		       "not device H/W sector aligned",
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
@@ -816,6 +877,10 @@ int dm_table_complete(struct dm_table *t)
 
 	check_for_valid_limits(&t->limits);
 
+	r = check_for_valid_alignment(t);
+	if (r)
+		return r;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
-- 
1.6.0.6
