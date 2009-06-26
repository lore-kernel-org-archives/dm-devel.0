From: Mike Snitzer <snitzer@gmail.com>
Subject: [RFC][PATCH 1/2] block: add blk_limits_io_min() and
	stack io_opt
Date: Fri, 26 Jun 2009 00:55:15 -0400
Message-ID: <1245992116-28947-1-git-send-email-snitzer@gmail.com>
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
Cc: martin.petersen@oracle.com
List-Id: dm-devel.ids

Introduce blk_limits_io_min() and make blk_queue_io_min() call it.

blk_stack_limits() doesn't stack io_opt and DM needs it to.
---
 block/blk-settings.c   |   32 +++++++++++++++++++++++++-------
 include/linux/blkdev.h |    1 +
 2 files changed, 26 insertions(+), 7 deletions(-)

Index: linux-2.6/block/blk-settings.c
===================================================================
--- linux-2.6.orig/block/blk-settings.c	2009-06-26 00:39:22.000000000 -0400
+++ linux-2.6/block/blk-settings.c	2009-06-26 00:40:35.000000000 -0400
@@ -377,6 +377,29 @@
 EXPORT_SYMBOL(blk_queue_alignment_offset);
 
 /**
+ * blk_limits_io_min - set minimum request size for a device
+ * @limits: the queue limits
+ * @min:  smallest I/O size in bytes
+ *
+ * Description:
+ *   Some devices have an internal block size bigger than the reported
+ *   hardware sector size.  This function can be used to signal the
+ *   smallest I/O the device can perform without incurring a performance
+ *   penalty.
+ */
+void blk_limits_io_min(struct queue_limits *limits, unsigned int min)
+{
+	limits->io_min = min;
+
+	if (limits->io_min < limits->logical_block_size)
+		limits->io_min = limits->logical_block_size;
+
+	if (limits->io_min < limits->physical_block_size)
+		limits->io_min = limits->physical_block_size;
+}
+EXPORT_SYMBOL(blk_limits_io_min);
+
+/**
  * blk_queue_io_min - set minimum request size for the queue
  * @q:	the request queue for the device
  * @min:  smallest I/O size in bytes
@@ -389,13 +412,7 @@
  */
 void blk_queue_io_min(struct request_queue *q, unsigned int min)
 {
-	q->limits.io_min = min;
-
-	if (q->limits.io_min < q->limits.logical_block_size)
-		q->limits.io_min = q->limits.logical_block_size;
-
-	if (q->limits.io_min < q->limits.physical_block_size)
-		q->limits.io_min = q->limits.physical_block_size;
+	blk_limits_io_min(&q->limits, min);
 }
 EXPORT_SYMBOL(blk_queue_io_min);
 
@@ -496,6 +513,7 @@
 				     b->physical_block_size);
 
 	t->io_min = max(t->io_min, b->io_min);
+	t->io_opt = min_not_zero(t->io_opt, b->io_opt);
 	t->no_cluster |= b->no_cluster;
 
 	/* Bottom device offset aligned? */
Index: linux-2.6/include/linux/blkdev.h
===================================================================
--- linux-2.6.orig/include/linux/blkdev.h	2009-06-26 00:39:22.000000000 -0400
+++ linux-2.6/include/linux/blkdev.h	2009-06-26 00:40:35.000000000 -0400
@@ -924,6 +924,7 @@
 extern void blk_queue_physical_block_size(struct request_queue *, unsigned short);
 extern void blk_queue_alignment_offset(struct request_queue *q,
 				       unsigned int alignment);
+extern void blk_limits_io_min(struct queue_limits *limits, unsigned int min);
 extern void blk_queue_io_min(struct request_queue *q, unsigned int min);
 extern void blk_queue_io_opt(struct request_queue *q, unsigned int opt);
 extern void blk_set_default_limits(struct queue_limits *lim);
