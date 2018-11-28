From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] block: switch to per-cpu in-flight counters
Date: Wed, 28 Nov 2018 01:42:13 +0100
Message-ID: <20181128004250.325095242@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=block-percpu-inflight.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Jens Axboe <axboe@kernel.dk>
Cc: Christoph Hellwig <hch@infradead.org>, Mike Snitzer <msnitzer@redhat.com>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Now when part_round_stats is gone, we can switch to per-cpu in-flight
counters.

We use the local-atomic type local_t, so that if part_inc_in_flight or
part_dec_in_flight is reentrantly called from an interrupt, the value will
be correct.

The other counters could be corrupted due to reentrant interrupt, but the
corruption only results in slight counter skew - the in_flight counter
must be exact, so it needs local_t.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/bio.c           |    4 ++--
 block/blk-core.c      |    4 ++--
 block/blk-merge.c     |    2 +-
 block/genhd.c         |   47 +++++++++++++++++++++++++++++++++++------------
 drivers/md/dm.c       |    4 +---
 include/linux/genhd.h |    7 ++++---
 6 files changed, 45 insertions(+), 23 deletions(-)

Index: linux-block/block/genhd.c
===================================================================
--- linux-block.orig/block/genhd.c	2018-11-28 00:09:59.000000000 +0100
+++ linux-block/block/genhd.c	2018-11-28 00:09:59.000000000 +0100
@@ -45,53 +45,76 @@ static void disk_add_events(struct gendi
 static void disk_del_events(struct gendisk *disk);
 static void disk_release_events(struct gendisk *disk);
 
-void part_inc_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
+void part_inc_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
 {
 	if (queue_is_mq(q))
 		return;
 
-	atomic_inc(&part->in_flight[rw]);
+	local_inc(per_cpu_ptr(part->dkstats, cpu)->in_flight);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		local_inc(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
 }
 
-void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
+void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part, int rw)
 {
 	if (queue_is_mq(q))
 		return;
 
-	atomic_dec(&part->in_flight[rw]);
+	local_dec(per_cpu_ptr(part->dkstats, cpu)->in_flight);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		local_dec(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
 }
 
 void part_in_flight(struct request_queue *q, struct hd_struct *part,
 		    unsigned int inflight[2])
 {
+	int cpu;
+
 	if (queue_is_mq(q)) {
 		blk_mq_in_flight(q, part, inflight);
 		return;
 	}
 
-	inflight[0] = atomic_read(&part->in_flight[0]) +
-			atomic_read(&part->in_flight[1]);
+	inflight[0] = 0;
+	for_each_possible_cpu(cpu) {
+		inflight[0] +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
+				local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
+	}
+	if ((int)inflight[0] < 0)
+		inflight[0] = 0;
+
 	if (part->partno) {
 		part = &part_to_disk(part)->part0;
-		inflight[1] = atomic_read(&part->in_flight[0]) +
-				atomic_read(&part->in_flight[1]);
+		inflight[1] = 0;
+		for_each_possible_cpu(cpu) {
+			inflight[1] +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
+					local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
+		}
+		if ((int)inflight[1] < 0)
+			inflight[1] = 0;
 	}
 }
 
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2])
 {
+	int cpu;
+
 	if (queue_is_mq(q)) {
 		blk_mq_in_flight_rw(q, part, inflight);
 		return;
 	}
 
-	inflight[0] = atomic_read(&part->in_flight[0]);
-	inflight[1] = atomic_read(&part->in_flight[1]);
+	inflight[0] = 0;
+	inflight[1] = 0;
+	for_each_possible_cpu(cpu) {
+		inflight[0] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]);
+		inflight[1] += local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
+	}
+	if ((int)inflight[0] < 0)
+		inflight[0] = 0;
+	if ((int)inflight[1] < 0)
+		inflight[1] = 0;
 }
 
 struct hd_struct *__disk_get_part(struct gendisk *disk, int partno)
Index: linux-block/include/linux/genhd.h
===================================================================
--- linux-block.orig/include/linux/genhd.h	2018-11-28 00:09:59.000000000 +0100
+++ linux-block/include/linux/genhd.h	2018-11-28 00:09:59.000000000 +0100
@@ -17,6 +17,7 @@
 #include <linux/percpu-refcount.h>
 #include <linux/uuid.h>
 #include <linux/blk_types.h>
+#include <asm/local.h>
 
 #ifdef CONFIG_BLOCK
 
@@ -89,6 +90,7 @@ struct disk_stats {
 	unsigned long merges[NR_STAT_GROUPS];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+	local_t in_flight[2];
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -122,7 +124,6 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -380,9 +381,9 @@ void part_in_flight(struct request_queue
 		    unsigned int inflight[2]);
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2]);
-void part_dec_in_flight(struct request_queue *q, struct hd_struct *part,
+void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part,
 			int rw);
-void part_inc_in_flight(struct request_queue *q, struct hd_struct *part,
+void part_inc_in_flight(struct request_queue *q, int cpu, struct hd_struct *part,
 			int rw);
 
 static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)
Index: linux-block/block/bio.c
===================================================================
--- linux-block.orig/block/bio.c	2018-11-28 00:09:59.000000000 +0100
+++ linux-block/block/bio.c	2018-11-28 00:09:59.000000000 +0100
@@ -1688,7 +1688,7 @@ void generic_start_io_acct(struct reques
 	update_io_ticks(cpu, part, jiffies);
 	part_stat_inc(cpu, part, ios[sgrp]);
 	part_stat_add(cpu, part, sectors[sgrp], sectors);
-	part_inc_in_flight(q, part, op_is_write(op));
+	part_inc_in_flight(q, cpu, part, op_is_write(op));
 
 	part_stat_unlock();
 }
@@ -1707,7 +1707,7 @@ void generic_end_io_acct(struct request_
 	part_stat_add(cpu, part, time_in_queue, duration);
 	if (part->partno)
 		part_stat_add(cpu, &part_to_disk(part)->part0, time_in_queue, duration);
-	part_dec_in_flight(q, part, op_is_write(req_op));
+	part_dec_in_flight(q, cpu, part, op_is_write(req_op));
 
 	part_stat_unlock();
 }
Index: linux-block/block/blk-merge.c
===================================================================
--- linux-block.orig/block/blk-merge.c	2018-11-28 00:09:59.000000000 +0100
+++ linux-block/block/blk-merge.c	2018-11-28 00:09:59.000000000 +0100
@@ -690,7 +690,7 @@ static void blk_account_io_merge(struct
 		cpu = part_stat_lock();
 		part = req->part;
 
-		part_dec_in_flight(req->q, part, rq_data_dir(req));
+		part_dec_in_flight(req->q, cpu, part, rq_data_dir(req));
 
 		hd_struct_put(part);
 		part_stat_unlock();
Index: linux-block/block/blk-core.c
===================================================================
--- linux-block.orig/block/blk-core.c	2018-11-28 00:09:59.000000000 +0100
+++ linux-block/block/blk-core.c	2018-11-28 00:09:59.000000000 +0100
@@ -1356,7 +1356,7 @@ void blk_account_io_done(struct request
 		part_stat_add(cpu, part, nsecs[sgrp], now - req->start_time_ns);
 		part_stat_add(cpu, part, time_in_queue, nsecs_to_jiffies64(now - req->start_time_ns));
 			part_stat_add(cpu, &part_to_disk(part)->part0, time_in_queue, nsecs_to_jiffies64(now - req->start_time_ns));
-		part_dec_in_flight(req->q, part, rq_data_dir(req));
+		part_dec_in_flight(req->q, cpu, part, rq_data_dir(req));
 
 		hd_struct_put(part);
 		part_stat_unlock();
@@ -1391,7 +1391,7 @@ void blk_account_io_start(struct request
 			part = &rq->rq_disk->part0;
 			hd_struct_get(part);
 		}
-		part_inc_in_flight(rq->q, part, rw);
+		part_inc_in_flight(rq->q, cpu, part, rw);
 		rq->part = part;
 	}
 
Index: linux-block/drivers/md/dm.c
===================================================================
--- linux-block.orig/drivers/md/dm.c	2018-11-28 00:09:59.000000000 +0100
+++ linux-block/drivers/md/dm.c	2018-11-28 00:09:59.000000000 +0100
@@ -663,8 +663,7 @@ static void start_io_acct(struct dm_io *
 	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
 			      &dm_disk(md)->part0);
 
-	atomic_set(&dm_disk(md)->part0.in_flight[rw],
-		   atomic_inc_return(&md->pending[rw]));
+	atomic_inc(&md->pending[rw]);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -693,7 +692,6 @@ static void end_io_acct(struct dm_io *io
 	 * a flush.
 	 */
 	pending = atomic_dec_return(&md->pending[rw]);
-	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
 	pending += atomic_read(&md->pending[rw^0x1]);
 
 	/* nudge anyone waiting on suspend queue */
