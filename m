From: "Jun'ichi Nomura" <j-nomura@ce.jp.nec.com>
Subject: [PATCH 2/3] block: Rename trace_block_remap to
	trace_block_bio_remap
Date: Sat, 19 Sep 2009 00:13:23 +0900
Message-ID: <4AB3A393.5000709@ce.jp.nec.com>
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
To: Jens Axboe <jens.axboe@oracle.com>, Alasdair G Kergon <agk@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Cc: j-nomura@ce.jp.nec.com, device-mapper development <dm-devel@redhat.com>, linux-kernel@vger.kernel.org
List-Id: dm-devel.ids

Rename "block_remap" tracepoint to "block_bio_remap" to clarify the event.
No functional change.

Signed-off-by: Kiyoshi Ueda <k-ueda@ct.jp.nec.com>
Signed-off-by: Jun'ichi Nomura <j-nomura@ce.jp.nec.com>
Cc: Jens Axboe <jens.axboe@oracle.com>
Cc: Alasdair G Kergon <agk@redhat.com>
Cc: Li Zefan <lizf@cn.fujitsu.com>
---
 block/blk-core.c             |   10 +++++-----
 drivers/md/dm.c              |    4 ++--
 include/trace/events/block.h |    2 +-
 kernel/trace/blktrace.c      |   10 +++++-----
 4 files changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6.31.work/include/trace/events/block.h
===================================================================
--- linux-2.6.31.work.orig/include/trace/events/block.h
+++ linux-2.6.31.work/include/trace/events/block.h
@@ -453,7 +453,7 @@ TRACE_EVENT(block_split,
 		  __entry->comm)
 );

-TRACE_EVENT(block_remap,
+TRACE_EVENT(block_bio_remap,

 	TP_PROTO(struct request_queue *q, struct bio *bio, dev_t dev,
 		 sector_t from),
Index: linux-2.6.31.work/block/blk-core.c
===================================================================
--- linux-2.6.31.work.orig/block/blk-core.c
+++ linux-2.6.31.work/block/blk-core.c
@@ -33,7 +33,7 @@

 #include "blk.h"

-EXPORT_TRACEPOINT_SYMBOL_GPL(block_remap);
+EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_rq_remap);
 EXPORT_TRACEPOINT_SYMBOL_GPL(block_bio_complete);

@@ -1285,9 +1285,9 @@ static inline void blk_partition_remap(s
 		bio->bi_sector += p->start_sect;
 		bio->bi_bdev = bdev->bd_contains;

-		trace_block_remap(bdev_get_queue(bio->bi_bdev), bio,
-				    bdev->bd_dev,
-				    bio->bi_sector - p->start_sect);
+		trace_block_bio_remap(bdev_get_queue(bio->bi_bdev), bio,
+				      bdev->bd_dev,
+				      bio->bi_sector - p->start_sect);
 	}
 }

@@ -1455,7 +1455,7 @@ static inline void __generic_make_reques
 			goto end_io;

 		if (old_sector != -1)
-			trace_block_remap(q, bio, old_dev, old_sector);
+			trace_block_bio_remap(q, bio, old_dev, old_sector);

 		trace_block_bio_queue(q, bio);

Index: linux-2.6.31.work/kernel/trace/blktrace.c
===================================================================
--- linux-2.6.31.work.orig/kernel/trace/blktrace.c
+++ linux-2.6.31.work/kernel/trace/blktrace.c
@@ -822,7 +822,7 @@ static void blk_add_trace_split(struct r
 }

 /**
- * blk_add_trace_remap - Add a trace for a remap operation
+ * blk_add_trace_bio_remap - Add a trace for a bio-remap operation
  * @q:		queue the io is for
  * @bio:	the source bio
  * @dev:	target device
@@ -833,8 +833,8 @@ static void blk_add_trace_split(struct r
  *     it spans a stripe (or similar). Add a trace for that action.
  *
  **/
-static void blk_add_trace_remap(struct request_queue *q, struct bio *bio,
-				       dev_t dev, sector_t from)
+static void blk_add_trace_bio_remap(struct request_queue *q, struct bio
*bio,
+				    dev_t dev, sector_t from)
 {
 	struct blk_trace *bt = q->blk_trace;
 	struct blk_io_trace_remap r;
@@ -947,7 +947,7 @@ static void blk_register_tracepoints(voi
 	WARN_ON(ret);
 	ret = register_trace_block_split(blk_add_trace_split);
 	WARN_ON(ret);
-	ret = register_trace_block_remap(blk_add_trace_remap);
+	ret = register_trace_block_bio_remap(blk_add_trace_bio_remap);
 	WARN_ON(ret);
 	ret = register_trace_block_rq_remap(blk_add_trace_rq_remap);
 	WARN_ON(ret);
@@ -956,7 +956,7 @@ static void blk_register_tracepoints(voi
 static void blk_unregister_tracepoints(void)
 {
 	unregister_trace_block_rq_remap(blk_add_trace_rq_remap);
-	unregister_trace_block_remap(blk_add_trace_remap);
+	unregister_trace_block_bio_remap(blk_add_trace_bio_remap);
 	unregister_trace_block_split(blk_add_trace_split);
 	unregister_trace_block_unplug_io(blk_add_trace_unplug_io);
 	unregister_trace_block_unplug_timer(blk_add_trace_unplug_timer);
Index: linux-2.6.31.work/drivers/md/dm.c
===================================================================
--- linux-2.6.31.work.orig/drivers/md/dm.c
+++ linux-2.6.31.work/drivers/md/dm.c
@@ -961,8 +961,8 @@ static void __map_bio(struct dm_target *
 	if (r == DM_MAPIO_REMAPPED) {
 		/* the bio has been remapped so dispatch it */

-		trace_block_remap(bdev_get_queue(clone->bi_bdev), clone,
-				    tio->io->bio->bi_bdev->bd_dev, sector);
+		trace_block_bio_remap(bdev_get_queue(clone->bi_bdev), clone,
+				      tio->io->bio->bi_bdev->bd_dev, sector);

 		generic_make_request(clone);
 	} else if (r < 0 || r == DM_MAPIO_REQUEUE) {
