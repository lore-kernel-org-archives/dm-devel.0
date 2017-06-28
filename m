From: Brian King <brking@linux.vnet.ibm.com>
Subject: [PATCH 1/1] block: Convert hd_struct in_flight from atomic to percpu
Date: Wed, 28 Jun 2017 16:12:39 -0500
Message-ID: <20170628211010.4C8C9124035@b01ledav002.gho.pok.ibm.com>
Return-path: <linux-block-owner@vger.kernel.org>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: axboe@kernel.dk, dm-devel@redhat.com, snitzer@redhat.com, agk@redhat.com, brking@linux.vnet.ibm.com
List-Id: dm-devel.ids


This patch converts the in_flight counter in struct hd_struct from a pair of
atomics to a pair of percpu counters. This eliminates a couple of atomics from
the hot path. When running this on a Power system, to a single null_blk device
with 80 submission queues, irq mode 0, with 80 fio jobs, I saw IOPs go from
1.5M IO/s to 11.4 IO/s.

Signed-off-by: Brian King <brking@linux.vnet.ibm.com>
---

 block/bio.c               |    4 ++--
 block/blk-core.c          |    4 ++--
 block/blk-merge.c         |    2 +-
 block/genhd.c             |    2 +-
 block/partition-generic.c |    6 +++---
 drivers/md/dm.c           |   10 ++++++----
 include/linux/genhd.h     |   18 +++++++++---------
 7 files changed, 24 insertions(+), 22 deletions(-)

diff -puN include/linux/genhd.h~blk_in_flight_atomic_remove include/linux/genhd.h
--- linux-block/include/linux/genhd.h~blk_in_flight_atomic_remove	2017-06-28 16:06:43.037948079 -0500
+++ linux-block-bjking1/include/linux/genhd.h	2017-06-28 16:06:43.064947978 -0500
@@ -87,6 +87,7 @@ struct disk_stats {
 	unsigned long ticks[2];
 	unsigned long io_ticks;
 	unsigned long time_in_queue;
+	unsigned long in_flight[2];
 };
 
 #define PARTITION_META_INFO_VOLNAMELTH	64
@@ -120,7 +121,6 @@ struct hd_struct {
 	int make_it_fail;
 #endif
 	unsigned long stamp;
-	atomic_t in_flight[2];
 #ifdef	CONFIG_SMP
 	struct disk_stats __percpu *dkstats;
 #else
@@ -362,23 +362,23 @@ static inline void free_part_stats(struc
 #define part_stat_sub(cpu, gendiskp, field, subnd)			\
 	part_stat_add(cpu, gendiskp, field, -subnd)
 
-static inline void part_inc_in_flight(struct hd_struct *part, int rw)
+static inline void part_inc_in_flight(int cpu, struct hd_struct *part, int rw)
 {
-	atomic_inc(&part->in_flight[rw]);
+	part_stat_inc(cpu, part, in_flight[rw]);
 	if (part->partno)
-		atomic_inc(&part_to_disk(part)->part0.in_flight[rw]);
+		part_stat_inc(cpu, &part_to_disk(part)->part0, in_flight[rw]);
 }
 
-static inline void part_dec_in_flight(struct hd_struct *part, int rw)
+static inline void part_dec_in_flight(int cpu, struct hd_struct *part, int rw)
 {
-	atomic_dec(&part->in_flight[rw]);
+	part_stat_dec(cpu, part, in_flight[rw]);
 	if (part->partno)
-		atomic_dec(&part_to_disk(part)->part0.in_flight[rw]);
+		part_stat_dec(cpu, &part_to_disk(part)->part0, in_flight[rw]);
 }
 
-static inline int part_in_flight(struct hd_struct *part)
+static inline unsigned long part_in_flight(struct hd_struct *part)
 {
-	return atomic_read(&part->in_flight[0]) + atomic_read(&part->in_flight[1]);
+	return part_stat_read(part, in_flight[0]) + part_stat_read(part, in_flight[1]);
 }
 
 static inline struct partition_meta_info *alloc_part_info(struct gendisk *disk)
diff -puN block/bio.c~blk_in_flight_atomic_remove block/bio.c
--- linux-block/block/bio.c~blk_in_flight_atomic_remove	2017-06-28 16:06:43.041948064 -0500
+++ linux-block-bjking1/block/bio.c	2017-06-28 16:06:43.065947974 -0500
@@ -1737,7 +1737,7 @@ void generic_start_io_acct(int rw, unsig
 	part_round_stats(cpu, part);
 	part_stat_inc(cpu, part, ios[rw]);
 	part_stat_add(cpu, part, sectors[rw], sectors);
-	part_inc_in_flight(part, rw);
+	part_inc_in_flight(cpu, part, rw);
 
 	part_stat_unlock();
 }
@@ -1751,7 +1751,7 @@ void generic_end_io_acct(int rw, struct
 
 	part_stat_add(cpu, part, ticks[rw], duration);
 	part_round_stats(cpu, part);
-	part_dec_in_flight(part, rw);
+	part_dec_in_flight(cpu, part, rw);
 
 	part_stat_unlock();
 }
diff -puN block/blk-core.c~blk_in_flight_atomic_remove block/blk-core.c
--- linux-block/block/blk-core.c~blk_in_flight_atomic_remove	2017-06-28 16:06:43.045948049 -0500
+++ linux-block-bjking1/block/blk-core.c	2017-06-28 16:06:43.066947970 -0500
@@ -2435,7 +2435,7 @@ void blk_account_io_done(struct request
 		part_stat_inc(cpu, part, ios[rw]);
 		part_stat_add(cpu, part, ticks[rw], duration);
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part, rw);
+		part_dec_in_flight(cpu, part, rw);
 
 		hd_struct_put(part);
 		part_stat_unlock();
@@ -2493,7 +2493,7 @@ void blk_account_io_start(struct request
 			hd_struct_get(part);
 		}
 		part_round_stats(cpu, part);
-		part_inc_in_flight(part, rw);
+		part_inc_in_flight(cpu, part, rw);
 		rq->part = part;
 	}
 
diff -puN block/blk-merge.c~blk_in_flight_atomic_remove block/blk-merge.c
--- linux-block/block/blk-merge.c~blk_in_flight_atomic_remove	2017-06-28 16:06:43.048948038 -0500
+++ linux-block-bjking1/block/blk-merge.c	2017-06-28 16:06:43.067947967 -0500
@@ -634,7 +634,7 @@ static void blk_account_io_merge(struct
 		part = req->part;
 
 		part_round_stats(cpu, part);
-		part_dec_in_flight(part, rq_data_dir(req));
+		part_dec_in_flight(cpu, part, rq_data_dir(req));
 
 		hd_struct_put(part);
 		part_stat_unlock();
diff -puN block/genhd.c~blk_in_flight_atomic_remove block/genhd.c
--- linux-block/block/genhd.c~blk_in_flight_atomic_remove	2017-06-28 16:06:43.052948023 -0500
+++ linux-block-bjking1/block/genhd.c	2017-06-28 16:06:43.068947963 -0500
@@ -1220,7 +1220,7 @@ static int diskstats_show(struct seq_fil
 		part_round_stats(cpu, hd);
 		part_stat_unlock();
 		seq_printf(seqf, "%4d %7d %s %lu %lu %lu "
-			   "%u %lu %lu %lu %u %u %u %u\n",
+			   "%u %lu %lu %lu %u %lu %u %u\n",
 			   MAJOR(part_devt(hd)), MINOR(part_devt(hd)),
 			   disk_name(gp, hd->partno, buf),
 			   part_stat_read(hd, ios[READ]),
diff -puN block/partition-generic.c~blk_in_flight_atomic_remove block/partition-generic.c
--- linux-block/block/partition-generic.c~blk_in_flight_atomic_remove	2017-06-28 16:06:43.055948012 -0500
+++ linux-block-bjking1/block/partition-generic.c	2017-06-28 16:06:43.069947959 -0500
@@ -120,7 +120,7 @@ ssize_t part_stat_show(struct device *de
 	return sprintf(buf,
 		"%8lu %8lu %8llu %8u "
 		"%8lu %8lu %8llu %8u "
-		"%8u %8u %8u"
+		"%8lu %8u %8u"
 		"\n",
 		part_stat_read(p, ios[READ]),
 		part_stat_read(p, merges[READ]),
@@ -140,8 +140,8 @@ ssize_t part_inflight_show(struct device
 {
 	struct hd_struct *p = dev_to_part(dev);
 
-	return sprintf(buf, "%8u %8u\n", atomic_read(&p->in_flight[0]),
-		atomic_read(&p->in_flight[1]));
+	return sprintf(buf, "%8lu %8lu\n", part_stat_read(p, in_flight[0]),
+		part_stat_read(p, in_flight[1]));
 }
 
 #ifdef CONFIG_FAIL_MAKE_REQUEST
diff -puN drivers/md/dm.c~blk_in_flight_atomic_remove drivers/md/dm.c
--- linux-block/drivers/md/dm.c~blk_in_flight_atomic_remove	2017-06-28 16:06:43.058948000 -0500
+++ linux-block-bjking1/drivers/md/dm.c	2017-06-28 16:06:43.070947955 -0500
@@ -517,9 +517,9 @@ static void start_io_acct(struct dm_io *
 
 	cpu = part_stat_lock();
 	part_round_stats(cpu, &dm_disk(md)->part0);
+	part_inc_in_flight(cpu, &dm_disk(md)->part0, rw);
+	atomic_inc(&md->pending[rw]);
 	part_stat_unlock();
-	atomic_set(&dm_disk(md)->part0.in_flight[rw],
-		atomic_inc_return(&md->pending[rw]));
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -532,7 +532,7 @@ static void end_io_acct(struct dm_io *io
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->bio;
 	unsigned long duration = jiffies - io->start_time;
-	int pending;
+	int pending, cpu;
 	int rw = bio_data_dir(bio);
 
 	generic_end_io_acct(rw, &dm_disk(md)->part0, io->start_time);
@@ -546,9 +546,11 @@ static void end_io_acct(struct dm_io *io
 	 * After this is decremented the bio must not be touched if it is
 	 * a flush.
 	 */
+	cpu = part_stat_lock();
 	pending = atomic_dec_return(&md->pending[rw]);
-	atomic_set(&dm_disk(md)->part0.in_flight[rw], pending);
+	part_dec_in_flight(cpu, &dm_disk(md)->part0, rw);
 	pending += atomic_read(&md->pending[rw^0x1]);
+	part_stat_unlock();
 
 	/* nudge anyone waiting on suspend queue */
 	if (!pending)
_
