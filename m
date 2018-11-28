From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] block: return just one value from
	part_in_flight
Date: Wed, 28 Nov 2018 01:42:14 +0100
Message-ID: <20181128004251.504425345@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline;
	filename=block-avoid-second-value-from-part_in_flight.patch
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

The previous patches deleted all the code that needed the second value
returned from part_in_flight - now the kernel only uses the first value.

Consequently, part_in_flight (and blk_mq_in_flight) may be changed so that
it only returns one value.

This patch just refactors the code, there's no functional change.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-mq.c            |    6 ++++--
 block/blk-mq.h            |    3 +--
 block/genhd.c             |   32 +++++++++++---------------------
 block/partition-generic.c |    6 +++---
 include/linux/genhd.h     |    3 +--
 5 files changed, 20 insertions(+), 30 deletions(-)

Index: linux-block/block/blk-mq.c
===================================================================
--- linux-block.orig/block/blk-mq.c	2018-11-28 00:39:16.000000000 +0100
+++ linux-block/block/blk-mq.c	2018-11-28 00:39:16.000000000 +0100
@@ -113,13 +113,15 @@ static bool blk_mq_check_inflight(struct
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
Index: linux-block/block/blk-mq.h
===================================================================
--- linux-block.orig/block/blk-mq.h	2018-11-28 00:39:16.000000000 +0100
+++ linux-block/block/blk-mq.h	2018-11-28 00:39:16.000000000 +0100
@@ -184,8 +184,7 @@ static inline bool blk_mq_hw_queue_mappe
 	return hctx->nr_ctx && hctx->tags;
 }
 
-void blk_mq_in_flight(struct request_queue *q, struct hd_struct *part,
-		      unsigned int inflight[2]);
+unsigned int blk_mq_in_flight(struct request_queue *q, struct hd_struct *part);
 void blk_mq_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 			 unsigned int inflight[2]);
 
Index: linux-block/block/genhd.c
===================================================================
--- linux-block.orig/block/genhd.c	2018-11-28 00:39:16.000000000 +0100
+++ linux-block/block/genhd.c	2018-11-28 00:42:19.000000000 +0100
@@ -65,34 +65,24 @@ void part_dec_in_flight(struct request_q
 		local_dec(per_cpu_ptr(part_to_disk(part)->part0.dkstats, cpu)->in_flight);
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
@@ -1348,7 +1338,7 @@ static int diskstats_show(struct seq_fil
 	struct disk_part_iter piter;
 	struct hd_struct *hd;
 	char buf[BDEVNAME_SIZE];
-	unsigned int inflight[2];
+	unsigned int inflight;
 
 	/*
 	if (&disk_to_dev(gp)->kobj.entry == block_class.devices.next)
@@ -1360,7 +1350,7 @@ static int diskstats_show(struct seq_fil
 
 	disk_part_iter_init(&piter, gp, DISK_PITER_INCL_EMPTY_PART0);
 	while ((hd = disk_part_iter_next(&piter))) {
-		part_in_flight(gp->queue, hd, inflight);
+		inflight = part_in_flight(gp->queue, hd);
 		seq_printf(seqf, "%4d %7d %s "
 			   "%lu %lu %lu %u "
 			   "%lu %lu %lu %u "
@@ -1376,7 +1366,7 @@ static int diskstats_show(struct seq_fil
 			   part_stat_read(hd, merges[STAT_WRITE]),
 			   part_stat_read(hd, sectors[STAT_WRITE]),
 			   (unsigned int)part_stat_read_msecs(hd, STAT_WRITE),
-			   inflight[0],
+			   inflight,
 			   jiffies_to_msecs(part_stat_read(hd, io_ticks)),
 			   jiffies_to_msecs(part_stat_read(hd, time_in_queue)),
 			   part_stat_read(hd, ios[STAT_DISCARD]),
Index: linux-block/block/partition-generic.c
===================================================================
--- linux-block.orig/block/partition-generic.c	2018-11-28 00:39:16.000000000 +0100
+++ linux-block/block/partition-generic.c	2018-11-28 00:39:16.000000000 +0100
@@ -120,9 +120,9 @@ ssize_t part_stat_show(struct device *de
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
@@ -137,7 +137,7 @@ ssize_t part_stat_show(struct device *de
 		part_stat_read(p, merges[STAT_WRITE]),
 		(unsigned long long)part_stat_read(p, sectors[STAT_WRITE]),
 		(unsigned int)part_stat_read_msecs(p, STAT_WRITE),
-		inflight[0],
+		inflight,
 		jiffies_to_msecs(part_stat_read(p, io_ticks)),
 		jiffies_to_msecs(part_stat_read(p, time_in_queue)),
 		part_stat_read(p, ios[STAT_DISCARD]),
Index: linux-block/include/linux/genhd.h
===================================================================
--- linux-block.orig/include/linux/genhd.h	2018-11-28 00:39:16.000000000 +0100
+++ linux-block/include/linux/genhd.h	2018-11-28 00:39:16.000000000 +0100
@@ -377,8 +377,7 @@ static inline void free_part_stats(struc
 #define part_stat_sub(cpu, gendiskp, field, subnd)			\
 	part_stat_add(cpu, gendiskp, field, -subnd)
 
-void part_in_flight(struct request_queue *q, struct hd_struct *part,
-		    unsigned int inflight[2]);
+unsigned int part_in_flight(struct request_queue *q, struct hd_struct *part);
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2]);
 void part_dec_in_flight(struct request_queue *q, int cpu, struct hd_struct *part,
