From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH] dm-table: establish queue limits by copying
	table limits
Date: Wed, 10 Jun 2009 11:14:36 -0400
Message-ID: <1244646876-1690-1-git-send-email-snitzer@redhat.com>
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
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jens.axboe@oracle.com
List-Id: dm-devel.ids

Copy the table's queue_limits to the DM device's request_queue.  This
properly initializes the queue's topology limits and also avoids having
to track the evolution of 'struct queue_limits' in
dm_table_set_restrictions()

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-table.c |   12 ++----------
 1 files changed, 2 insertions(+), 10 deletions(-)

diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 7acf09a..17d09dc 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -958,17 +958,9 @@ no_integrity:
 void dm_table_set_restrictions(struct dm_table *t, struct request_queue *q)
 {
 	/*
-	 * Make sure we obey the optimistic sub devices
-	 * restrictions.
+	 * Copy table's limits to the DM device's request_queue
 	 */
-	blk_queue_max_sectors(q, t->limits.max_sectors);
-	blk_queue_max_phys_segments(q, t->limits.max_phys_segments);
-	blk_queue_max_hw_segments(q, t->limits.max_hw_segments);
-	blk_queue_logical_block_size(q, t->limits.logical_block_size);
-	blk_queue_max_segment_size(q, t->limits.max_segment_size);
-	blk_queue_max_hw_sectors(q, t->limits.max_hw_sectors);
-	blk_queue_segment_boundary(q, t->limits.seg_boundary_mask);
-	blk_queue_bounce_limit(q, t->limits.bounce_pfn);
+	q->limits = t->limits;
 
 	if (t->limits.no_cluster)
 		queue_flag_clear_unlocked(QUEUE_FLAG_CLUSTER, q);
