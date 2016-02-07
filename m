From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 08/15] dm: allocate blk_mq_tag_set
	rather than embed in mapped_device
Date: Sun,  7 Feb 2016 10:53:30 -0500
Message-ID: <1454860417-3203-9-git-send-email-snitzer@redhat.com>
References: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <1454860417-3203-1-git-send-email-snitzer@redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Mike Snitzer <snitzer@redhat.com>, Sagi Grimberg <sagig@dev.mellanox.co.il>
List-Id: dm-devel.ids

The blk_mq_tag_set is only needed for dm-mq support.  There is point
wasting space in 'struct mapped_device' for non-dm-mq devices.

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 42 ++++++++++++++++++++++++------------------
 1 file changed, 24 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ec505e5..1fab790 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -223,7 +223,7 @@ struct mapped_device {
 	ktime_t last_rq_start_time;
 
 	/* for blk-mq request-based DM support */
-	struct blk_mq_tag_set tag_set;
+	struct blk_mq_tag_set *tag_set;
 	bool use_blk_mq;
 };
 
@@ -2386,8 +2386,10 @@ static void free_dev(struct mapped_device *md)
 	unlock_fs(md);
 
 	cleanup_mapped_device(md);
-	if (md->use_blk_mq)
-		blk_mq_free_tag_set(&md->tag_set);
+	if (md->tag_set) {
+		blk_mq_free_tag_set(md->tag_set);
+		kfree(md->tag_set);
+	}
 
 	free_table_devices(&md->table_devices);
 	dm_stats_cleanup(&md->stats);
@@ -2708,24 +2710,25 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 	struct request_queue *q;
 	int err;
 
-	memset(&md->tag_set, 0, sizeof(md->tag_set));
-	md->tag_set.ops = &dm_mq_ops;
-	md->tag_set.queue_depth = dm_get_blk_mq_queue_depth();
-	md->tag_set.numa_node = NUMA_NO_NODE;
-	md->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
-	md->tag_set.nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
+	md->tag_set = kzalloc(sizeof(struct blk_mq_tag_set), GFP_KERNEL);
+	md->tag_set->ops = &dm_mq_ops;
+	md->tag_set->queue_depth = dm_get_blk_mq_queue_depth();
+	md->tag_set->numa_node = NUMA_NO_NODE;
+	md->tag_set->flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
+	md->tag_set->nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
+	md->tag_set->driver_data = md;
+
+	md->tag_set->cmd_size = sizeof(struct dm_rq_target_io);
 	if (md_type == DM_TYPE_REQUEST_BASED) {
-		/* make the memory for non-blk-mq clone part of the pdu */
-		md->tag_set.cmd_size = sizeof(struct dm_rq_target_io) + sizeof(struct request);
-	} else
-		md->tag_set.cmd_size = sizeof(struct dm_rq_target_io);
-	md->tag_set.driver_data = md;
+		/* put the memory for non-blk-mq clone at the end of the pdu */
+		md->tag_set->cmd_size += sizeof(struct request);
+	}
 
-	err = blk_mq_alloc_tag_set(&md->tag_set);
+	err = blk_mq_alloc_tag_set(md->tag_set);
 	if (err)
-		return err;
+		goto out_kfree_tag_set;
 
-	q = blk_mq_init_allocated_queue(&md->tag_set, md->queue);
+	q = blk_mq_init_allocated_queue(md->tag_set, md->queue);
 	if (IS_ERR(q)) {
 		err = PTR_ERR(q);
 		goto out_tag_set;
@@ -2742,7 +2745,10 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 	return 0;
 
 out_tag_set:
-	blk_mq_free_tag_set(&md->tag_set);
+	blk_mq_free_tag_set(md->tag_set);
+out_kfree_tag_set:
+	kfree(md->tag_set);
+
 	return err;
 }
 
-- 
2.5.4 (Apple Git-61)
