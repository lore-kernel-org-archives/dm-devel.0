From: Neil Brown <neilb@suse.de>
Subject: [PATCH] Make sure QUEUE_FLAG_CLUSTER is set properly for
	dm.
Date: Wed, 7 Dec 2005 14:21:58 +1100
Message-ID: <17302.21846.792776.256696@cse.unsw.edu.au>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
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


Hi,
 the block layer has a flag - QUEUE_FLAG_CLUSTER - which can be set
 (well, can be cleared, it defaults to set) by device drivers to
 encourage clustering of blocks in a bio - the presence of the flag
 essentially allows bios to be made bigger.

 Currently this flag is not set for dm (or md) devices, so bios are
 not made a big as they could be in some cases.

 The following patch sets the flag in the dm device, if all of the
 underlying devices have it set.

NeilBrown



------------

This flag should be set for a virtual device iff it is set
for all underlying devices.

Signed-off-by: Neil Brown <neilb@suse.de>

### Diffstat output
 ./drivers/md/dm-table.c         |    9 +++++++++
 ./include/linux/device-mapper.h |    1 +
 2 files changed, 10 insertions(+)

diff ./drivers/md/dm-table.c~current~ ./drivers/md/dm-table.c
--- ./drivers/md/dm-table.c~current~	2005-12-07 14:07:56.000000000 +1100
+++ ./drivers/md/dm-table.c	2005-12-07 14:14:46.000000000 +1100
@@ -97,6 +97,8 @@ static void combine_restrictions_low(str
 
 	lhs->seg_boundary_mask =
 		min_not_zero(lhs->seg_boundary_mask, rhs->seg_boundary_mask);
+
+	lhs->no_cluster |= rhs->no_cluster;
 }
 
 /*
@@ -525,6 +527,8 @@ int dm_get_device(struct dm_target *ti, 
 		rs->seg_boundary_mask =
 			min_not_zero(rs->seg_boundary_mask,
 				     q->seg_boundary_mask);
+
+		rs->no_cluster |= !test_bit(QUEUE_FLAG_CLUSTER, &q->queue_flags);
 	}
 
 	return r;
@@ -834,6 +838,11 @@ void dm_table_set_restrictions(struct dm
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
--- ./include/linux/device-mapper.h~current~	2005-12-07 14:07:56.000000000 +1100
+++ ./include/linux/device-mapper.h	2005-12-07 14:14:46.000000000 +1100
@@ -97,6 +97,7 @@ struct io_restrictions {
 	unsigned short		hardsect_size;
 	unsigned int		max_segment_size;
 	unsigned long		seg_boundary_mask;
+	unsigned char		no_cluster; /* inverted so that 0 is default */
 };
 
 struct dm_target {
