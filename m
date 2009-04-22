From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH v2] dm table: verify a DM device is H/W sector
	aligned
Date: Wed, 22 Apr 2009 14:25:43 +0100
Message-ID: <20090422132543.GA7778@agk.fab.redhat.com>
References: <1240327259-14412-1-git-send-email-snitzer@redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
In-Reply-To: <1240327259-14412-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <snitzer@redhat.com>
Cc: device-mapper development <dm-devel@redhat.com>
List-Id: dm-devel.ids

I've tried to make this easier to understand.
Please check I've not broken something in the process...


From: Mike Snitzer <snitzer@redhat.com>

Impose necessary and sufficient conditions on a devices's table such
that any incoming bio which respects its hardsect_size can be processed
successfully.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>

---
 drivers/md/dm-table.c |   68 ++++++++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 68 insertions(+)

Index: linux-2.6.30-rc2/drivers/md/dm-table.c
===================================================================
--- linux-2.6.30-rc2.orig/drivers/md/dm-table.c
+++ linux-2.6.30-rc2/drivers/md/dm-table.c
@@ -719,6 +719,70 @@ static void check_for_valid_limits(struc
 		rs->bounce_pfn = -1;
 }
 
+/*
+ * Impose necessary and sufficient conditions on a devices's table such
+ * that any incoming bio which respects its hardsect_size can be
+ * processed successfully.  If it falls across the boundary between
+ * two or more targets, the size of each piece it gets split into must
+ * be compatible with the hardsect_size of the target processing it.
+ */
+static int validate_hardsect_alignment(struct dm_table *table)
+{
+	/*
+	 * This function uses arithmetic modulo the hardsect_size
+	 * (in units of 512-byte sectors).
+	 */
+	unsigned short device_hardsect_size_sects =
+			    table->limits.hardsect_size >> SECTOR_SHIFT;
+
+	/*
+	 * Offset of the start of the next table entry, mod hardsect_size.
+	 */
+	unsigned short next_target_start = 0;
+
+	/*
+	 * Given an aligned bio that extends beyond the end of a
+	 * target, how many sectors must the next target handle?
+	 */
+	unsigned short remaining = 0;
+
+	struct dm_target *ti;
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
+		 * table entry are they compatible with its hardsect_size?
+		 */
+		if (remaining < ti->len &&
+		    remaining & (ti->limits.hardsect_size >> SECTOR_SHIFT) - 1)
+			break;	/* Error */
+
+		next_target_start =
+		    (unsigned short) ((next_target_start + ti->len) &
+				      (device_hardsect_size_sects - 1));
+		remaining = next_target_start ?
+		    device_hardsect_size_sects - next_target_start : 0;
+	}
+
+	if (remaining) {
+		DMWARN("%s: table line %u (start sect %llu len %llu) "
+		       "not aligned to hardware sector size %hu",
+		       dm_device_name(table->md), i,
+		       (unsigned long long) ti->begin,
+		       (unsigned long long) ti->len,
+		       table->limits.hardsect_size);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
 int dm_table_add_target(struct dm_table *t, const char *type,
 			sector_t start, sector_t len, char *params)
 {
@@ -818,6 +882,10 @@ int dm_table_complete(struct dm_table *t
 
 	check_for_valid_limits(&t->limits);
 
+	r = validate_hardsect_alignment(t);
+	if (r)
+		return r;
+
 	/* how many indexes will the btree have ? */
 	leaf_nodes = dm_div_up(t->num_targets, KEYS_PER_NODE);
 	t->depth = 1 + int_log(leaf_nodes, CHILDREN_PER_NODE);
