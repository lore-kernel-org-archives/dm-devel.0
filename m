From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 6/7] block: return just one value from
	part_in_flight
Date: Wed,  5 Dec 2018 15:24:32 -0500
Message-ID: <20181205202433.95823-7-snitzer@redhat.com>
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

The previous patches deleted all the code that needed the second value
returned from part_in_flight - now the kernel only uses the first value.

Consequently, part_in_flight (and blk_mq_in_flight) may be changed so that
it only returns one value.

This patch just refactors the code, there's no functional change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 block/blk-mq.c            | 12 +++++-------
 block/blk-mq.h            |  3 +--
 block/genhd.c             | 32 +++++++++++---------------------
 block/partition-generic.c |  6 +++---
 include/linux/genhd.h     |  3 +--
 5 files changed, 21 insertions(+), 35 deletions(-)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index 900550594651..c6d3101352f4 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -100,25 +100,23 @@ static bool blk_mq_check_inflight(struct blk_mq_hw_ctx *hctx,
 	struct mq_inflight *mi = priv;
 
 	/*
-	 * index[0] counts the specific partition that was asked for. index[1]
-	 * counts the ones that are active on the whole device, so increment
-	 * that if mi->part is indeed a partition, and not a whole device.
+	 * index[0] counts the specific partition that was asked for.
 	 */
 	if (rq->part == mi->part)
 		mi->inflight[0]++;
-	if (mi->part->partno)
-		mi->inflight[1]++;
 
 	return true;
 }
 
-void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
-		      unsigned int inflight[2])
+unsigned int blk_mq_in_flight(struct request_queue *q, struct hd_struct *part)
 {
+	unsigned inflight[2];
 	struct mq_inflight mi = { .part = part, .inflight = inflight, };
 
 	inflight[0] = inflight[1] = 0;
 	blk_mq_queue_tag_busy_iter(q, blk_mq_check_inflight, &mi);
+
+	return inflight[0];
 }
 
 static bool blk_mq_check_inflight_rw(struct blk_mq_hw_ctx *hctx,
diff --git a/block/blk-mq.h b/block/blk-mq.h
index a664ea44ffd4..0c9c9ea2fefe 100644
--- a/block/blk-mq.h
+++ b/block/blk-mq.h
@@ -187,8 +187,7 @@ static inline bool blk_mq_hw_queue_mapped(struct blk_mq_hw_ctx *hctx)
 	return hctx->nr_ctx && hctx->tags;
 }
 
-void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
-		      unsigned int inflight[2]);
+unsigned int blk_mq_in_flight(struct request_queue *q, struct hd_struct *part);
 void blk_mq_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 			 unsigned int inflight[2]);
 
diff --git a/block/genhd.c b/block/genhd.c
index ffb9d416db64..dd84922192b6 100644
--- a/block/genhd.c
+++ b/block/genhd.c
@@ -71,34 +71,24 @@ void part_dec_in_flight(struct request_queue *q, struct hd_struct *part, int rw)
 		local_dec(&per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight[rw]);
 }
 
-void part_in_flight(struct request_queue *q, struct hd_struct *part,
-		    unsigned int inflight[2])
+unsigned int part_in_flight(struct request_queue *q, struct hd_struct *part)
 {
 	int cpu;
+	int inflight;
 
 	if (queue_is_mq(q)) {
-		blk_mq_in_flight(q, part, inflight);
-		return;
+		return blk_mq_in_flight(q, part);
 	}
 
-	inflight[0] = 0;
+	inflight = 0;
 	for_each_possible_cpu(cpu) {
-		inflight[0] +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
+		inflight +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
 				local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
 	}
-	if ((int)inflight[0] < 0)
-		inflight[0] = 0;
+	if (inflight < 0)
+		inflight = 0;
 
-	if (part->partno) {
-		part = &part_to_disk(part)->part0;
-		inflight[1] = 0;
-		for_each_possible_cpu(cpu) {
-			inflight[1] +=	local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) +
-					local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]);
-		}
-		if ((int)inflight[1] < 0)
-			inflight[1] = 0;
-	}
+	return (unsigned int)inflight;
 }
 
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
@@ -1354,7 +1344,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 	struct disk_part_iter piter;
 	struct hd_struct *hd;
 	char buf[BDEVNAME_SIZE];
-	unsigned int inflight[2];
+	unsigned int inflight;
 
 	/*
 	if (&disk_to_dev(gp)->kobj.entry == block_class.devices.next)
@@ -1366,7 +1356,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		part_in_flight(gp->queue, hd, inflight);
+		inflight = part_in_flight(gp->queue, hd);
 		seq_printf(seqf, "%4d %7d %s "
 			   "%lu %lu %lu %u "
 			   "%lu %lu %lu %u "
@@ -1382,7 +1372,7 @@ static int diskstats_show(struct seq_file *seqf, void *v)
 			   part_stat_read(hd, merges[STAT_WRITE]),
 			   part_stat_read(hd, sectors[STAT_WRITE]),
 			   (unsigned int)part_stat_read_msecs(hd, STAT_WRITE),
-			   inflight[0],
+			   inflight,
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue)),
 			   part_stat_read(hd, ios[STAT_DISCARD]),
diff --git a/block/partition-generic.c b/block/partition-generic.c
index 42d6138ac876..8e596a8dff32 100644
--- a/block/partition-generic.c
+++ b/block/partition-generic.c
@@ -120,9 +120,9 @@ ssize_t part_stat_show(struct device *dev,
 {
 	struct hd_struct *p = dev_to_part(dev);
 	struct request_queue *q = part_to_disk(p)->queue;
-	unsigned int inflight[2];
+	unsigned int inflight;
 
-	part_in_flight(q, p, inflight);
+	inflight = part_in_flight(q, p);
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
@@ -137,7 +137,7 @@ ssize_t part_stat_show(struct device *dev,
 		part_stat_read(p, merges[STAT_WRITE]),
 		(unsigned long long)part_stat_read(p, sectors[STAT_WRITE]),
 		(unsigned int)part_stat_read_msecs(p, STAT_WRITE),
-		inflight[0],
+		inflight,
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)),
 		part_stat_read(p, ios[STAT_DISCARD]),
diff --git a/include/linux/genhd.h b/include/linux/genhd.h
index 9489dcb7cc27..669b7fe400d7 100644
--- a/include/linux/genhd.h
+++ b/include/linux/genhd.h
@@ -377,8 +377,7 @@ static inline void free_part_stats(struct hd_struct *part)
 #define part_stat_sub(gendiskp, field, subnd)				\
 	part_stat_add(gendiskp, field, -subnd)
 
-void part_in_flight(struct request_queue *q, struct hd_struct *part,
-		    unsigned int inflight[2]);
+unsigned int part_in_flight(struct request_queue *q, struct hd_struct *part);
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2]);
 void part_dec_in_flight(struct request_queue *q, struct hd_struct *part,
-- 
2.18.0
