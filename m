From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.22 PATCH 01/26] dm: merge max_hw_sector
Date: Tue, 8 May 2007 20:40:15 +0100
Message-ID: <20070508194015.GH24114@agk.fab.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids

From: Neil Brown <neilb@suse.de>

Make sure dm honours max_hw_sectors of underlying devices

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>
---

### Diffstat output
 drivers/md/dm-table.c         |    9 +++++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 10 insertions(+)

Index: linux-2.6.21/drivers/md/dm-table.c
===================================================================
--- linux-2.6.21.orig/drivers/md/dm-table.c	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/drivers/md/dm-table.c	2007-05-01 17:40:45.000000000 +0100
@@ -99,6 +99,9 @@ static void combine_restrictions_low(str
 	lhs->max_segment_size =
 		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
 
+	lhs->max_hw_sectors =
+		min_not_zero(lhs->max_hw_sectors, rhs->max_hw_sectors);
+
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
 
@@ -561,6 +564,9 @@ void dm_set_device_limits(struct dm_targ
 	rs->max_segment_size =
 		min_not_zero(rs->max_segment_size, q->max_segment_size);
 
+	rs->max_hw_sectors =
+		min_not_zero(rs->max_hw_sectors, q->max_hw_sectors);
+
 	rs->seg_boundary_mask =
 		min_not_zero(rs->seg_boundary_mask,
 			     q->seg_boundary_mask);
@@ -696,6 +702,8 @@ static void check_for_valid_limits(struc
 {
 	if (!rs->max_sectors)
 		rs->max_sectors = SAFE_MAX_SECTORS;
+	if (!rs->max_hw_sectors)
+		rs->max_hw_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
 	if (!rs->max_hw_segments)
@@ -889,6 +897,7 @@ void dm_table_set_restrictions(struct dm
 	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
+	q->max_hw_sectors = t->limits.max_hw_sectors;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
 	if (t->limits.no_cluster)
 		q->queue_flags &= ~(1 << QUEUE_FLAG_CLUSTER);
Index: linux-2.6.21/include/linux/device-mapper.h
===================================================================
--- linux-2.6.21.orig/include/linux/device-mapper.h	2007-05-01 17:38:32.000000000 +0100
+++ linux-2.6.21/include/linux/device-mapper.h	2007-05-01 17:40:45.000000000 +0100
@@ -115,6 +115,7 @@ struct io_restrictions {
 	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
+	unsigned int		max_hw_sectors;
 	unsigned long		seg_boundary_mask;
 	unsigned char		no_cluster; /* inverted so that 0 is default */
 };
