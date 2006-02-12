From: NeilBrown <neilb@suse.de>
Subject: [PATCH] Make sure QUEUE_FLAG_CLUSTER is set properly for
	dm.
Date: Mon, 13 Feb 2006 09:20:27 +1100
Message-ID: <1060212222027.20486@suse.de>
References: <20060213091916.20461.patches@notabene>
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
To: Andrew Morton <akpm@osdl.org>
Cc: dm-devel@redhat.com
List-Id: dm-devel.ids


This flag should be set for a virtual device iff it is set
for all underlying devices.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-table.c         |    9 +++++++++
 ./include/linux/device-mapper.h |    1 +
 2 files changed, 10 insertions(+)

diff ./drivers/md/dm-table.c~current~ ./drivers/md/dm-table.c
--- ./drivers/md/dm-table.c~current~	2006-02-13 09:18:02.000000000 +1100
+++ ./drivers/md/dm-table.c	2006-02-13 09:18:02.000000000 +1100
@@ -98,6 +98,8 @@ static void combine_restrictions_low(str
 
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
+
+	lhs->no_cluster |= rhs->no_cluster;
 }
 
 /*
@@ -526,6 +528,8 @@ int dm_get_device(struct dm_target *ti, 
 		rs->seg_boundary_mask =
 			min_not_zero(rs->seg_boundary_mask,
 				     q->seg_boundary_mask);
+
+		rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	}
 
 	return r;
@@ -835,6 +839,11 @@ void dm_table_set_restrictions(struct dm
 	q->hardsect_size = t->limits.hardsect_size;
 	q->max_segment_size = t->limits.max_segment_size;
 	q->seg_boundary_mask = t->limits.seg_boundary_mask;
+	if (t->limits.no_cluster)
+		q->queue_flags &= ~(1 << QUEUE_FLAG_CLUSTER);
+	else
+		q->queue_flags |= (1 << QUEUE_FLAG_CLUSTER);
+
 }
 
 unsigned int dm_table_get_num_targets(struct dm_table *t)

diff ./include/linux/device-mapper.h~current~ ./include/linux/device-mapper.h
--- ./include/linux/device-mapper.h~current~	2006-02-13 09:18:02.000000000 +1100
+++ ./include/linux/device-mapper.h	2006-02-13 09:18:02.000000000 +1100
@@ -97,6 +97,7 @@ struct io_restrictions {
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
 	unsigned long		seg_boundary_mask;
+	unsigned char		no_cluster; /* inverted so that 0 is default */
 };
 
 struct dm_target {
