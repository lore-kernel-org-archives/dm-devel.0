From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH 2/3] dm table: validate device logical_block_size
Date: Wed, 27 May 2009 17:06:52 -0400
Message-ID: <1243458413-15854-3-git-send-email-snitzer@redhat.com>
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

Impose necessary and sufficient conditions on a devices's table such
that any incoming bio which respects its logical_block_size can be
processed successfully.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-table.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 69 insertions(+)

Index: linux-2.6/drivers/md/dm-table.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-table.c
+++ linux-2.6/drivers/md/dm-table.c
@@ -726,6 +726,71 @@ static void check_for_valid_limits(struc
 		rs->bounce_pfn = -1;
 }
 
+/*
+ * Impose necessary and sufficient conditions on a devices's table such
+ * that any incoming bio which respects its logical_block_size can be
+ * processed successfully.  If it falls across the boundary between
+ * two or more targets, the size of each piece it gets split into must
+ * be compatible with the logical_block_size of the target processing it.
+ */
+static int validate_hardware_logical_block_alignment(struct dm_table *table)
+{
+	/*
+	 * This function uses arithmetic modulo the logical_block_size
+	 * (in units of 512-byte sectors).
+	 */
+	unsigned short device_logical_block_size_sects =
+		table->limits.logical_block_size >> SECTOR_SHIFT;
+
+	/*
+	 * Offset of the start of the next table entry, mod logical_block_size.
+	 */
+	unsigned short next_target_start = 0;
+
+	/*
+	 * Given an aligned bio that extends beyond the end of a
+	 * target, how many sectors must the next target handle?
+	 */
+	unsigned short remaining = 0;
+
+	struct dm_target *uninitialized_var(ti);
+	unsigned i = 0;
+
+	/*
+	 * Check each entry in the table in turn.
+	 */
+	while (i < dm_table_get_num_targets(table)) {
+		ti = dm_table_get_target(table, i++);
+
+		/*
+		 * If the remaining sectors fall entirely within this
+		 * table entry are they compatible with its logical_block_size?
+		 */
+		if (remaining < ti->len &&
+		    remaining & ((ti->limits.logical_block_size >>
+				  SECTOR_SHIFT) - 1))
+			break;	/* Error */
+
+		next_target_start =
+		    (unsigned short) ((next_target_start + ti->len) &
+				      (device_logical_block_size_sects - 1));
+		remaining = next_target_start ?
+		    device_logical_block_size_sects - next_target_start : 0;
+	}
+
+	if (remaining) {
+		DMWARN("%s: table line %u (start sect %llu len %llu) "
+		       "not aligned to h/w logical_block_size %hu",
+		       dm_device_name(table->md), i,
+		       (unsigned long long) ti->begin,
+		       (unsigned long long) ti->len,
+		       table->limits.logical_block_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params)
 {
@@ -825,6 +890,10 @@ int dm_table_complete(struct dm_table *t
 
 	check_for_valid_limits(&t->limits);
 
+	r = validate_hardware_logical_block_alignment(t);
+	if (r)
+		return r;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
