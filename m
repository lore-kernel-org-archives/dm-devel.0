From: Mike Snitzer <snitzer@redhat.com>
Subject: [dm-4.6 PATCH v2 07/15] dm: add 'blk_mq_nr_hw_queues'
	and 'blk_mq_queue_depth' module params
Date: Sun,  7 Feb 2016 10:53:29 -0500
Message-ID: <1454860417-3203-8-git-send-email-snitzer@redhat.com>
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

Allow user to change these values via module params or sysfs.

'blk_mq_nr_hw_queues' defaults to 1 (max 32).

'blk_mq_queue_depth' defaults to 2048 (up from 64, which proved far too
small under moderate sized workloads -- the dm-multipath device would
continuously block waiting for tags (requests) to become available).
The maximum is BLK_MQ_MAX_DEPTH (currently 10240).

Keep in mind the total number of pre-allocated requests per rq-based DM
blk-mq device is 'blk_mq_nr_hw_queues' * 'blk_mq_queue_depth' (currently
2048).

Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 3dfcb5a..ec505e5 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -233,6 +233,12 @@ static bool use_blk_mq = true;
 static bool use_blk_mq = false;
 #endif
 
+#define DM_MQ_NR_HW_QUEUES 1
+#define DM_MQ_QUEUE_DEPTH 2048
+
+static unsigned blk_mq_nr_hw_queues = DM_MQ_NR_HW_QUEUES;
+static unsigned blk_mq_queue_depth = DM_MQ_QUEUE_DEPTH;
+
 bool dm_use_blk_mq(struct mapped_device *md)
 {
 	return md->use_blk_mq;
@@ -303,6 +309,17 @@ unsigned dm_get_reserved_rq_based_ios(void)
 }
 EXPORT_SYMBOL_GPL(dm_get_reserved_rq_based_ios);
 
+unsigned dm_get_blk_mq_nr_hw_queues(void)
+{
+	return __dm_get_module_param(&blk_mq_nr_hw_queues, 1, 32);
+}
+
+unsigned dm_get_blk_mq_queue_depth(void)
+{
+	return __dm_get_module_param(&blk_mq_queue_depth,
+				     DM_MQ_QUEUE_DEPTH, BLK_MQ_MAX_DEPTH);
+}
+
 static int __init local_init(void)
 {
 	int r = -ENOMEM;
@@ -2693,10 +2710,10 @@ static int dm_init_request_based_blk_mq_queue(struct mapped_device *md)
 
 	memset(&md->tag_set, 0, sizeof(md->tag_set));
 	md->tag_set.ops = &dm_mq_ops;
-	md->tag_set.queue_depth = BLKDEV_MAX_RQ;
+	md->tag_set.queue_depth = dm_get_blk_mq_queue_depth();
 	md->tag_set.numa_node = NUMA_NO_NODE;
 	md->tag_set.flags = BLK_MQ_F_SHOULD_MERGE | BLK_MQ_F_SG_MERGE;
-	md->tag_set.nr_hw_queues = 1;
+	md->tag_set.nr_hw_queues = dm_get_blk_mq_nr_hw_queues();
 	if (md_type == DM_TYPE_REQUEST_BASED) {
 		/* make the memory for non-blk-mq clone part of the pdu */
 		md->tag_set.cmd_size = sizeof(struct dm_rq_target_io) + sizeof(struct request);
@@ -3672,6 +3689,12 @@ MODULE_PARM_DESC(reserved_rq_based_ios, "Reserved IOs in request-based mempools"
 module_param(use_blk_mq, bool, S_IRUGO | S_IWUSR);
 MODULE_PARM_DESC(use_blk_mq, "Use block multiqueue for request-based DM devices");
 
+module_param(blk_mq_nr_hw_queues, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(blk_mq_nr_hw_queues, "Number of hardware queues for blk-mq request-based DM devices");
+
+module_param(blk_mq_queue_depth, uint, S_IRUGO | S_IWUSR);
+MODULE_PARM_DESC(blk_mq_queue_depth, "Queue depth for blk-mq request-based DM devices");
+
 MODULE_DESCRIPTION(DM_NAME " driver");
 MODULE_AUTHOR("Joe Thornber <dm-devel@redhat.com>");
 MODULE_LICENSE("GPL");
-- 
2.5.4 (Apple Git-61)
