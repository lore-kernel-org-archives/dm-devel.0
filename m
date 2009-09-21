From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH] Add a tracepoint for block request remapping
Date: Tue, 22 Sep 2009 01:25:18 +0900
Message-ID: <4AB7A8EE.9070607@ce.jp.nec.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
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
To: Jens Axboe <jens.axboe@oracle.com>
Cc: device-mapper development <dm-devel@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>, linux-kernel@vger.kernel.org, Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

# Re-sending just the core bit.

Since 2.6.31 now has request-based device-mapper, it's useful to have
a tracepoint for request-remapping as well as bio-remapping.
This patch adds a tracepoint for request-remapping, trace_block_rq_remap().

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-core.c             |    1 +
 include/trace/events/block.h |   33 +++++++++++++++++++++++++++++++++
 kernel/trace/blktrace.c      |   34 ++++++++++++++++++++++++++++++++++
 3 files changed, 68 insertions(+)

Index: linux-2.6.31.work/block/blk-core.c
===================================================================
--- linux-2.6.31.work.orig/block/blk-core.c
+++ linux-2.6.31.work/block/blk-core.c
@@ -34,6 +34,7 @@
 #include "blk.h"

 EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);

 static int __make_request(struct request_queue *q, struct bio *bio);
Index: linux-2.6.31.work/include/trace/events/block.h
===================================================================
--- linux-2.6.31.work.orig/include/trace/events/block.h
+++ linux-2.6.31.work/include/trace/events/block.h
@@ -486,6 +486,39 @@ TRACE_EVENT(block_remap,
 		  (unsigned long long)__entry->old_sector)
 );

+TRACE_EVENT(block_rq_remap,
+
+	TP_PROTO(struct request_queue *q, struct request *rq, dev_t dev,
+		 sector_t from),
+
+	TP_ARGS(q, rq, dev, from),
+
+	TP_STRUCT__entry(
+		__field( dev_t,		dev		)
+		__field( sector_t,	sector		)
+		__field( unsigned int,	nr_sector	)
+		__field( dev_t,		old_dev		)
+		__field( sector_t,	old_sector	)
+		__array( char,		rwbs,	6	)
+	),
+
+	TP_fast_assign(
+		__entry->dev		= disk_devt(rq->rq_disk);
+		__entry->sector		= blk_rq_pos(rq);
+		__entry->nr_sector	= blk_rq_sectors(rq);
+		__entry->old_dev	= dev;
+		__entry->old_sector	= from;
+		blk_fill_rwbs_rq(__entry->rwbs, rq);
+	),
+
+	TP_printk("%d,%d %s %llu + %u <- (%d,%d) %llu",
+		  MAJOR(__entry->dev), MINOR(__entry->dev), __entry->rwbs,
+		  (unsigned long long)__entry->sector,
+		  __entry->nr_sector,
+		  MAJOR(__entry->old_dev), MINOR(__entry->old_dev),
+		  (unsigned long long)__entry->old_sector)
+);
+
 #endif /* _TRACE_BLOCK_H */

 /* This part must be outside protection */
Index: linux-2.6.31.work/kernel/trace/blktrace.c
===================================================================
--- linux-2.6.31.work.orig/kernel/trace/blktrace.c
+++ linux-2.6.31.work/kernel/trace/blktrace.c
@@ -852,6 +852,37 @@ static void blk_add_trace_remap(struct r
 }

 /**
+ * blk_add_trace_rq_remap - Add a trace for a request-remap operation
+ * @q:		queue the io is for
+ * @rq:		the source request
+ * @dev:	target device
+ * @from:	source sector
+ *
+ * Description:
+ *     Device mapper remaps request to other devices.
+ *     Add a trace for that action.
+ *
+ **/
+static void blk_add_trace_rq_remap(struct request_queue *q,
+				   struct request *rq, dev_t dev,
+				   sector_t from)
+{
+	struct blk_trace *bt = q->blk_trace;
+	struct blk_io_trace_remap r;
+
+	if (likely(!bt))
+		return;
+
+	r.device_from = cpu_to_be32(dev);
+	r.device_to   = cpu_to_be32(disk_devt(rq->rq_disk));
+	r.sector_from = cpu_to_be64(from);
+
+	__blk_add_trace(bt, blk_rq_pos(rq), blk_rq_bytes(rq),
+			rq_data_dir(rq), BLK_TA_REMAP, !!rq->errors,
+			sizeof(r), &r);
+}
+
+/**
  * blk_add_driver_data - Add binary message with driver-specific data
  * @q:		queue the io is for
  * @rq:		io request
@@ -918,10 +949,13 @@ static void blk_register_tracepoints(voi
 	WARN_ON(ret);
 	ret = register_trace_block_remap(blk_add_trace_remap);
 	WARN_ON(ret);
+	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap);
+	WARN_ON(ret);
 }

 static void blk_unregister_tracepoints(void)
 {
+	unregister_trace_block_rq_remap(blk_add_trace_rq_remap);
 	unregister_trace_block_remap(blk_add_trace_remap);
 	unregister_trace_block_split(blk_add_trace_split);
 	unregister_trace_block_unplug_io(blk_add_trace_unplug_io);
