From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 3/7] block: stop passing 'cpu' to all percpu
	stats methods
Date: Wed,  5 Dec 2018 15:24:29 -0500
Message-ID: <20181205202433.95823-4-snitzer@redhat.com>
References: <20181205202433.95823-1-snitzer@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20181205202433.95823-1-snitzer@redhat.com>
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
Cc: linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

All of part_stat_* and related methods are used with preempt disabled,
so there is no need to pass cpu around to allow of them.  Just call
smp_processor_id() as needed.

Suggested-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/bio.c               | 16 +++++++++-------
 block/blk-core.c          | 34 +++++++++++++++-------------------
 block/blk-merge.c         |  5 ++---
 block/genhd.c             |  5 ++---
 block/partition-generic.c |  5 ++---
 drivers/md/md.c           |  7 +++----
 include/linux/genhd.h     | 26 +++++++++++++-------------
 7 files changed, 46 insertions(+), 52 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 03895cc0d74a..91e398ba57f1 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1667,11 +1667,12 @@ void generic_start_io_acct(struct request_queue *q, int op,
 			   unsigned long sectors, struct hd_struct *part)
 {
 	const int sgrp = op_stat_group(op);
-	int cpu = part_stat_lock();
 
-	part_round_stats(q, cpu, part);
-	part_stat_inc(cpu, part, ios[sgrp]);
-	part_stat_add(cpu, part, sectors[sgrp], sectors);
+	part_stat_lock();
+
+	part_round_stats(q, part);
+	part_stat_inc(part, ios[sgrp]);
+	part_stat_add(part, sectors[sgrp], sectors);
 	part_inc_in_flight(q, part, op_is_write(op));
 
 	part_stat_unlock();
@@ -1683,10 +1684,11 @@ void generic_end_io_acct(struct request_queue *q, int req_op,
 {
 	unsigned long duration = jiffies - start_time;
 	const int sgrp = op_stat_group(req_op);
-	int cpu = part_stat_lock();
 
-	part_stat_add(cpu, part, nsecs[sgrp], jiffies_to_nsecs(duration));
-	part_round_stats(q, cpu, part);
+	part_stat_lock();
+
+	part_stat_add(part, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_round_stats(q, part);
 	part_dec_in_flight(q, part, op_is_write(req_op));
 
 	part_stat_unlock();
diff --git a/block/blk-core.c b/block/blk-core.c
index ad59102ee30a..734b768c9d9d 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -584,14 +584,14 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 }
 EXPORT_SYMBOL(blk_get_request);
 
-static void part_round_stats_single(struct request_queue *q, int cpu,
+static void part_round_stats_single(struct request_queue *q,
 				    struct hd_struct *part, unsigned long now,
 				    unsigned int inflight)
 {
 	if (inflight) {
-		__part_stat_add(cpu, part, time_in_queue,
+		__part_stat_add(part, time_in_queue,
 				inflight * (now - part->stamp));
-		__part_stat_add(cpu, part, io_ticks, (now - part->stamp));
+		__part_stat_add(part, io_ticks, (now - part->stamp));
 	}
 	part->stamp = now;
 }
@@ -599,7 +599,6 @@ static void part_round_stats_single(struct request_queue *q, int cpu,
 /**
  * part_round_stats() - Round off the performance stats on a struct disk_stats.
  * @q: target block queue
- * @cpu: cpu number for stats access
  * @part: target partition
  *
  * The average IO queue length and utilisation statistics are maintained
@@ -613,7 +612,7 @@ static void part_round_stats_single(struct request_queue *q, int cpu,
  * /proc/diskstats.  This accounts immediately for all queue usage up to
  * the current jiffies and restarts the counters again.
  */
-void part_round_stats(struct request_queue *q, int cpu, struct hd_struct *part)
+void part_round_stats(struct request_queue *q, struct hd_struct *part)
 {
 	struct hd_struct *part2 = NULL;
 	unsigned long now = jiffies;
@@ -635,9 +634,9 @@ void part_round_stats(struct request_queue *q, int cpu, struct hd_struct *part)
 	part_in_flight(q, part, inflight);
 
 	if (stats & 2)
-		part_round_stats_single(q, cpu, part2, now, inflight[1]);
+		part_round_stats_single(q, part2, now, inflight[1]);
 	if (stats & 1)
-		part_round_stats_single(q, cpu, part, now, inflight[0]);
+		part_round_stats_single(q, part, now, inflight[0]);
 }
 EXPORT_SYMBOL_GPL(part_round_stats);
 
@@ -1362,11 +1361,10 @@ void blk_account_io_completion(struct request *req, unsigned int bytes)
 	if (blk_do_io_stat(req)) {
 		const int sgrp = op_stat_group(req_op(req));
 		struct hd_struct *part;
-		int cpu;
 
-		cpu = part_stat_lock();
+		part_stat_lock();
 		part = req->part;
-		part_stat_add(cpu, part, sectors[sgrp], bytes >> 9);
+		part_stat_add(part, sectors[sgrp], bytes >> 9);
 		part_stat_unlock();
 	}
 }
@@ -1381,14 +1379,13 @@ void blk_account_io_done(struct request *req, u64 now)
 	if (blk_do_io_stat(req) && !(req->rq_flags & RQF_FLUSH_SEQ)) {
 		const int sgrp = op_stat_group(req_op(req));
 		struct hd_struct *part;
-		int cpu;
 
-		cpu = part_stat_lock();
+		part_stat_lock();
 		part = req->part;
 
-		part_stat_inc(cpu, part, ios[sgrp]);
-		part_stat_add(cpu, part, nsecs[sgrp], now - req->start_time_ns);
-		part_round_stats(req->q, cpu, part);
+		part_stat_inc(part, ios[sgrp]);
+		part_stat_add(part, nsecs[sgrp], now - req->start_time_ns);
+		part_round_stats(req->q, part);
 		part_dec_in_flight(req->q, part, rq_data_dir(req));
 
 		hd_struct_put(part);
@@ -1400,16 +1397,15 @@ void blk_account_io_start(struct request *rq, bool new_io)
 {
 	struct hd_struct *part;
 	int rw = rq_data_dir(rq);
-	int cpu;
 
 	if (!blk_do_io_stat(rq))
 		return;
 
-	cpu = part_stat_lock();
+	part_stat_lock();
 
 	if (!new_io) {
 		part = rq->part;
-		part_stat_inc(cpu, part, merges[rw]);
+		part_stat_inc(part, merges[rw]);
 	} else {
 		part = disk_map_sector_rcu(rq->rq_disk, blk_rq_pos(rq));
 		if (!hd_struct_try_get(part)) {
@@ -1424,7 +1420,7 @@ void blk_account_io_start(struct request *rq, bool new_io)
 			part = &rq->rq_disk->part0;
 			hd_struct_get(part);
 		}
-		part_round_stats(rq->q, cpu, part);
+		part_round_stats(rq->q, part);
 		part_inc_in_flight(rq->q, part, rw);
 		rq->part = part;
 	}
diff --git a/block/blk-merge.c b/block/blk-merge.c
index 4431da69a5cf..a120d59b9705 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -685,12 +685,11 @@ static void blk_account_io_merge(struct request *req)
 {
 	if (blk_do_io_stat(req)) {
 		struct hd_struct *part;
-		int cpu;
 
-		cpu = part_stat_lock();
+		part_stat_lock();
 		part = req->part;
 
-		part_round_stats(req->q, cpu, part);
+		part_round_stats(req->q, part);
 		part_dec_in_flight(req->q, part, rq_data_dir(req));
 
 		hd_struct_put(part);
diff --git a/block/genhd.c b/block/genhd.c
index 0145bcb0cc76..2fe00cf32b93 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1326,7 +1326,6 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	struct hd_struct *hd;
 	char buf[BDEVNAME_SIZE];
 	unsigned int inflight[2];
-	int cpu;
 
 	/*
 	if (&disk_to_dev(gp)->kobj.entry == block_class.devices.next)
@@ -1338,8 +1337,8 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		cpu = part_stat_lock();
-		part_round_stats(gp->queue, cpu, hd);
+		part_stat_lock();
+		part_round_stats(gp->queue, hd);
 		part_stat_unlock();
 		part_in_flight(gp->queue, hd, inflight);
 		seq_printf(seqf, "%4d %7d %s "
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 5f8db5c5140f..7e663cfb1487 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -121,10 +121,9 @@ ssize_t part_stat_show(struct device *dev,
 	struct hd_struct *p = dev_to_part(dev);
 	struct request_queue *q = part_to_disk(p)->queue;
 	unsigned int inflight[2];
-	int cpu;
 
-	cpu = part_stat_lock();
-	part_round_stats(q, cpu, p);
+	part_stat_lock();
+	part_round_stats(q, p);
 	part_stat_unlock();
 	part_in_flight(q, p, inflight);
 	return sprintf(buf,
diff --git a/drivers/md/md.c b/drivers/md/md.c
index fc488cb30a94..9a0a1e0934d5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -334,7 +334,6 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 	const int sgrp = op_stat_group(bio_op(bio));
 	struct mddev *mddev = q->queuedata;
 	unsigned int sectors;
-	int cpu;
 
 	blk_queue_split(q, &bio);
 
@@ -359,9 +358,9 @@ static blk_qc_t md_make_request(struct request_queue *q, struct bio *bio)
 
 	md_handle_request(mddev, bio);
 
-	cpu = part_stat_lock();
-	part_stat_inc(cpu, &mddev->gendisk->part0, ios[sgrp]);
-	part_stat_add(cpu, &mddev->gendisk->part0, sectors[sgrp], sectors);
+	part_stat_lock();
+	part_stat_inc(&mddev->gendisk->part0, ios[sgrp]);
+	part_stat_add(&mddev->gendisk->part0, sectors[sgrp], sectors);
 	part_stat_unlock();
 
 	return BLK_QC_T_NONE;
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 0c5ee17b4d88..1677cd2a4c4e 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -295,8 +295,8 @@ extern struct hd_struct *disk_map_sector_rcu(struct gendisk *disk,
 #define part_stat_lock()	({ rcu_read_lock(); get_cpu(); })
 #define part_stat_unlock()	do { put_cpu(); rcu_read_unlock(); } while (0)
 
-#define __part_stat_add(cpu, part, field, addnd)			\
-	(per_cpu_ptr((part)->dkstats, (cpu))->field += (addnd))
+#define __part_stat_add(part, field, addnd)				\
+	(per_cpu_ptr((part)->dkstats, smp_processor_id())->field += (addnd))
 
 #define part_stat_read(part, field)					\
 ({									\
@@ -333,7 +333,7 @@ static inline void free_part_stats(struct hd_struct *part)
 #define part_stat_lock()	({ rcu_read_lock(); 0; })
 #define part_stat_unlock()	rcu_read_unlock()
 
-#define __part_stat_add(cpu, part, field, addnd)				\
+#define __part_stat_add(part, field, addnd)				\
 	((part)->dkstats.field += addnd)
 
 #define part_stat_read(part, field)	((part)->dkstats.field)
@@ -362,19 +362,19 @@ static inline void free_part_stats(struct hd_struct *part)
 	 part_stat_read(part, field[STAT_WRITE]) +			\
 	 part_stat_read(part, field[STAT_DISCARD]))
 
-#define part_stat_add(cpu, part, field, addnd)	do {			\
-	__part_stat_add((cpu), (part), field, addnd);			\
+#define part_stat_add(part, field, addnd)	do {			\
+	__part_stat_add((part), field, addnd);				\
 	if ((part)->partno)						\
-		__part_stat_add((cpu), &part_to_disk((part))->part0,	\
+		__part_stat_add(&part_to_disk((part))->part0,		\
 				field, addnd);				\
 } while (0)
 
-#define part_stat_dec(cpu, gendiskp, field)				\
-	part_stat_add(cpu, gendiskp, field, -1)
-#define part_stat_inc(cpu, gendiskp, field)				\
-	part_stat_add(cpu, gendiskp, field, 1)
-#define part_stat_sub(cpu, gendiskp, field, subnd)			\
-	part_stat_add(cpu, gendiskp, field, -subnd)
+#define part_stat_dec(gendiskp, field)					\
+	part_stat_add(gendiskp, field, -1)
+#define part_stat_inc(gendiskp, field)					\
+	part_stat_add(gendiskp, field, 1)
+#define part_stat_sub(gendiskp, field, subnd)				\
+	part_stat_add(gendiskp, field, -subnd)
 
 void part_in_flight(struct request_queue *q, struct hd_struct *part,
 		    unsigned int inflight[2]);
@@ -399,7 +399,7 @@ static inline void free_part_info(struct hd_struct *part)
 }
 
 /* block/blk-core.c */
-extern void part_round_stats(struct request_queue *q, int cpu, struct hd_struct *part);
+extern void part_round_stats(struct request_queue *q, struct hd_struct *part);
 
 /* block/genhd.c */
 extern void device_add_disk(struct device *parent, struct gendisk *disk,
-- 
2.18.0
