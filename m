From: Alasdair G Kergon <agk@redhat.com>
Subject: [2.6.24 PATCH 05/06] dm: merge max_hw_sector
Date: Thu, 13 Dec 2007 14:43:52 +0000
Message-ID: <20071213144352.GX24157@agk.fab.redhat.com>
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
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: dm-devel@redhat.com, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

From: Neil Brown <neilb@suse.de>

Make sure dm honours max_hw_sectors of underlying devices

  We still have no firm testing evidence in support of this patch but
  believe it may help to resolve some bug reports.  - agk

Signed-off-by: Neil Brown <neilb@suse.de>
Signed-off-by: Alasdair G Kergon <agk@redhat.com>

---
 drivers/md/dm-table.c         |    9 +++++++++
 include/linux/device-mapper.h |    1 +
 2 files changed, 10 insertions(+)

Index: linux-2.6.24-rc5/drivers/md/dm-table.c
===================================================================
--- linux-2.6.24-rc5.orig/drivers/md/dm-table.c	2007-12-12 15:43:06.000000000 +0000
+++ linux-2.6.24-rc5/drivers/md/dm-table.c	2007-12-13 13:25:45.000000000 +0000
@@ -99,6 +99,9 @@ static void combine_restrictions_low(str
 	lhs->max_segment_size =
 		min_not_zero(lhs->max_segment_size, rhs->max_segment_size);
 
+	lhs->max_hw_sectors =
+		min_not_zero(lhs->max_hw_sectors, rhs->max_hw_sectors);
+
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
 
@@ -566,6 +569,9 @@ void dm_set_device_limits(struct dm_targ
 	rs->max_segment_size =
 		min_not_zero(rs->max_segment_size, q->max_segment_size);
 
+	rs->max_hw_sectors =
+		min_not_zero(rs->max_hw_sectors, q->max_hw_sectors);
+
 	rs->seg_boundary_mask =
 		min_not_zero(rs->seg_boundary_mask,
 			     q->seg_boundary_mask);
@@ -703,6 +709,8 @@ static void check_for_valid_limits(struc
 {
 	if (!rs->max_sectors)
 		rs->max_sectors = SAFE_MAX_SECTORS;
+	if (!rs->max_hw_sectors)
+		rs->max_hw_sectors = SAFE_MAX_SECTORS;
 	if (!rs->max_phys_segments)
 		rs->max_phys_segments = MAX_PHYS_SEGMENTS;
 	if (!rs->max_hw_segments)
@@ -901,6 +909,7 @@ void dm_table_set_restrictions(struct dm
 	q->max_hw_segments = t->limits.max_hw_segments;
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
+	q->max_hw_sectors = t->limits.max_hw_sectors;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
 	q->bounce_pfn = t->limits.bounce_pfn;
 	if (t->limits.no_cluster)
Index: linux-2.6.24-rc5/include/linux/device-mapper.h
===================================================================
--- linux-2.6.24-rc5.orig/include/linux/device-mapper.h	2007-12-12 15:40:33.000000000 +0000
+++ linux-2.6.24-rc5/include/linux/device-mapper.h	2007-12-13 13:25:44.000000000 +0000
@@ -115,6 +115,7 @@ struct io_restrictions {
 	unsigned short		max_hw_segments;
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
+	unsigned int		max_hw_sectors;
 	unsigned long		seg_boundary_mask;
 	unsigned long		bounce_pfn;
 	unsigned char		no_cluster; /* inverted so that 0 is default */
