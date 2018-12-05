From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 4/7] block: delete part_round_stats and switch
	to less precise counting
Date: Wed,  5 Dec 2018 15:24:30 -0500
Message-ID: <20181205202433.95823-5-snitzer@redhat.com>
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

From: Mikulas Patocka <mpatocka@redhat.com>

We want to convert to per-cpu in_flight counters.

The function part_round_stats needs the in_flight counter every jiffy, it
would be too costly to sum all the percpu variables every jiffy, so it
must be deleted. part_round_stats is used to calculate two counters -
time_in_queue and io_ticks.

time_in_queue can be calculated without part_round_stats, by adding the
duration of the I/O when the I/O ends (the value is almost as exact as the
previously calculated value, except that time for in-progress I/Os is not
counted).

io_ticks can be approximated by increasing the value when I/O is started
or ended and the jiffies value has changed. If the I/Os take less than a
jiffy, the value is as exact as the previously calculated value. If the
I/Os take more than a jiffy, io_ticks can drift behind the previously
calculated value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/bio.c               | 24 +++++++++++++--
 block/blk-core.c          | 62 +++------------------------------------
 block/blk-merge.c         |  1 -
 block/genhd.c             |  3 --
 block/partition-generic.c |  3 --
 include/linux/genhd.h     |  3 +-
 6 files changed, 26 insertions(+), 70 deletions(-)

diff --git a/block/bio.c b/block/bio.c
index 91e398ba57f1..0c2208a5446d 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1663,6 +1663,22 @@ void bio_check_pages_dirty(struct bio *bio)
 }
 EXPORT_SYMBOL_GPL(bio_check_pages_dirty);
 
+void update_io_ticks(struct hd_struct *part, unsigned long now)
+{
+	unsigned long stamp;
+again:
+	stamp = READ_ONCE(part->stamp);
+	if (unlikely(stamp != now)) {
+		if (likely(cmpxchg(&part->stamp, stamp, now) == stamp)) {
+			__part_stat_add(part, io_ticks, 1);
+		}
+	}
+	if (part->partno) {
+		part = &part_to_disk(part)->part0;
+		goto again;
+	}
+}
+
 void generic_start_io_acct(struct request_queue *q, int op,
 			   unsigned long sectors, struct hd_struct *part)
 {
@@ -1670,7 +1686,7 @@ void generic_start_io_acct(struct request_queue *q, int op,
 
 	part_stat_lock();
 
-	part_round_stats(q, part);
+	update_io_ticks(part, jiffies);
 	part_stat_inc(part, ios[sgrp]);
 	part_stat_add(part, sectors[sgrp], sectors);
 	part_inc_in_flight(q, part, op_is_write(op));
@@ -1682,13 +1698,15 @@ EXPORT_SYMBOL(generic_start_io_acct);
 void generic_end_io_acct(struct request_queue *q, int req_op,
 			 struct hd_struct *part, unsigned long start_time)
 {
-	unsigned long duration = jiffies - start_time;
+	unsigned long now = jiffies;
+	unsigned long duration = now - start_time;
 	const int sgrp = op_stat_group(req_op);
 
 	part_stat_lock();
 
+	update_io_ticks(part, now);
 	part_stat_add(part, nsecs[sgrp], jiffies_to_nsecs(duration));
-	part_round_stats(q, part);
+	part_stat_add(part, time_in_queue, duration);
 	part_dec_in_flight(q, part, op_is_write(req_op));
 
 	part_stat_unlock();
diff --git a/block/blk-core.c b/block/blk-core.c
index 734b768c9d9d..268d2b8e9843 100644
--- a/block/blk-core.c
+++ b/block/blk-core.c
@@ -584,62 +584,6 @@ struct request *blk_get_request(struct request_queue *q, unsigned int op,
 }
 EXPORT_SYMBOL(blk_get_request);
 
-static void part_round_stats_single(struct request_queue *q,
-				    struct hd_struct *part, unsigned long now,
-				    unsigned int inflight)
-{
-	if (inflight) {
-		__part_stat_add(part, time_in_queue,
-				inflight * (now - part->stamp));
-		__part_stat_add(part, io_ticks, (now - part->stamp));
-	}
-	part->stamp = now;
-}
-
-/**
- * part_round_stats() - Round off the performance stats on a struct disk_stats.
- * @q: target block queue
- * @part: target partition
- *
- * The average IO queue length and utilisation statistics are maintained
- * by observing the current state of the queue length and the amount of
- * time it has been in this state for.
- *
- * Normally, that accounting is done on IO completion, but that can result
- * in more than a second's worth of IO being accounted for within any one
- * second, leading to >100% utilisation.  To deal with that, we call this
- * function to do a round-off before returning the results when reading
- * /proc/diskstats.  This accounts immediately for all queue usage up to
- * the current jiffies and restarts the counters again.
- */
-void part_round_stats(struct request_queue *q, struct hd_struct *part)
-{
-	struct hd_struct *part2 = NULL;
-	unsigned long now = jiffies;
-	unsigned int inflight[2];
-	int stats = 0;
-
-	if (part->stamp != now)
-		stats |= 1;
-
-	if (part->partno) {
-		part2 = &part_to_disk(part)->part0;
-		if (part2->stamp != now)
-			stats |= 2;
-	}
-
-	if (!stats)
-		return;
-
-	part_in_flight(q, part, inflight);
-
-	if (stats & 2)
-		part_round_stats_single(q, part2, now, inflight[1]);
-	if (stats & 1)
-		part_round_stats_single(q, part, now, inflight[0]);
-}
-EXPORT_SYMBOL_GPL(part_round_stats);
-
 void blk_put_request(struct request *req)
 {
 	blk_mq_free_request(req);
@@ -1383,9 +1327,10 @@ void blk_account_io_done(struct request *req, u64 now)
 		part_stat_lock();
 		part = req->part;
 
+		update_io_ticks(part, jiffies);
 		part_stat_inc(part, ios[sgrp]);
 		part_stat_add(part, nsecs[sgrp], now - req->start_time_ns);
-		part_round_stats(req->q, part);
+		part_stat_add(part, time_in_queue, nsecs_to_jiffies64(now - req->start_time_ns));
 		part_dec_in_flight(req->q, part, rq_data_dir(req));
 
 		hd_struct_put(part);
@@ -1420,11 +1365,12 @@ void blk_account_io_start(struct request *rq, bool new_io)
 			part = &rq->rq_disk->part0;
 			hd_struct_get(part);
 		}
-		part_round_stats(rq->q, part);
 		part_inc_in_flight(rq->q, part, rw);
 		rq->part = part;
 	}
 
+	update_io_ticks(part, jiffies);
+
 	part_stat_unlock();
 }
 
diff --git a/block/blk-merge.c b/block/blk-merge.c
index a120d59b9705..9da5629d0887 100644
--- a/block/blk-merge.c
+++ b/block/blk-merge.c
@@ -689,7 +689,6 @@ static void blk_account_io_merge(struct request *req)
 		part_stat_lock();
 		part = req->part;
 
-		part_round_stats(req->q, part);
 		part_dec_in_flight(req->q, part, rq_data_dir(req));
 
 		hd_struct_put(part);
diff --git a/block/genhd.c b/block/genhd.c
index 2fe00cf32b93..cdf174d7d329 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -1337,9 +1337,6 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		part_stat_lock();
-		part_round_stats(gp->queue, hd);
-		part_stat_unlock();
 		part_in_flight(gp->queue, hd, inflight);
 		seq_printf(seqf, "%4d %7d %s "
 			   "%lu %lu %lu %u "
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 7e663cfb1487..42d6138ac876 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -122,9 +122,6 @@ ssize_t part_stat_show(struct device *dev,
 	struct request_queue *q = part_to_disk(p)->queue;
 	unsigned int inflight[2];
 
-	part_stat_lock();
-	part_round_stats(q, p);
-	part_stat_unlock();
 	part_in_flight(q, p, inflight);
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 1677cd2a4c4e..838c2a7a40c5 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -398,8 +398,7 @@ static inline void free_part_info(struct hd_struct *part)
 	kfree(part->info);
 }
 
-/* block/blk-core.c */
-extern void part_round_stats(struct request_queue *q, struct hd_struct *part);
+void update_io_ticks(struct hd_struct *part, unsigned long now);
 
 /* block/genhd.c */
 extern void device_add_disk(struct device *parent, struct gendisk *disk,
-- 
2.18.0
