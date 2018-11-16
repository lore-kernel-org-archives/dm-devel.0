From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 3/3] block: use a driver-specific handler for the
	"inflight" value
Date: Fri, 16 Nov 2018 01:04:19 +0100
Message-ID: <20181116000508.980108938@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-inflight.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Device mapper was converted to percpu inflight counters. In order to
display the correct values in the "inflight" sysfs file and in
/proc/diskstats, we need a custom callback that sums the percpu counters.

The function part_round_stats calculates the number of in-flight I/Os
every jiffy and uses this to calculate the counters time_in_queue and
io_ticks. In order to avoid excessive memory traffic on systems with high
number of CPUs, this functionality is disabled when percpu inflight values
are used and the values time_in_queue and io_ticks are calculated
differently - the result is less precise.

We add the duration of an I/O to time_in_queue when the I/O finishes (the
value is almost the same as previously, except for the time of in-flight
I/Os).

If an I/O starts or finishes and the "jiffies" value has changed, we add
one to io_ticks. If the I/Os take less than a jiffy, the value is as exact
as the previous value. If the I/Os take more than a jiffy, the value may
lag behind the previous value.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 block/blk-core.c       |    7 ++++++-
 block/blk-settings.c   |    6 ++++++
 block/genhd.c          |   12 ++++++++++++
 drivers/md/dm.c        |   37 +++++++++++++++++++++++++++++++++++--
 include/linux/blkdev.h |    3 +++
 5 files changed, 62 insertions(+), 3 deletions(-)

Index: linux-dm/block/genhd.c
===================================================================
--- linux-dm.orig/block/genhd.c	2018-11-15 22:11:51.000000000 +0100
+++ linux-dm/block/genhd.c	2018-11-15 22:11:51.000000000 +0100
@@ -68,6 +68,13 @@ void part_dec_in_flight(struct request_q
 void part_in_flight(struct request_queue *q, struct hd_struct *part,
 		    unsigned int inflight[2])
 {
+	if (q->get_inflight_fn) {
+		q->get_inflight_fn(q, inflight);
+		inflight[0] += inflight[1];
+		inflight[1] = 0;
+		return;
+	}
+
 	if (q->mq_ops) {
 		blk_mq_in_flight(q, part, inflight);
 		return;
@@ -85,6 +92,11 @@ void part_in_flight(struct request_queue
 void part_in_flight_rw(struct request_queue *q, struct hd_struct *part,
 		       unsigned int inflight[2])
 {
+	if (q->get_inflight_fn) {
+		q->get_inflight_fn(q, inflight);
+		return;
+	}
+
 	if (q->mq_ops) {
 		blk_mq_in_flight_rw(q, part, inflight);
 		return;
Index: linux-dm/include/linux/blkdev.h
===================================================================
--- linux-dm.orig/include/linux/blkdev.h	2018-11-15 22:11:51.000000000 +0100
+++ linux-dm/include/linux/blkdev.h	2018-11-15 22:11:51.000000000 +0100
@@ -286,6 +286,7 @@ struct blk_queue_ctx;
 
 typedef blk_qc_t (make_request_fn) (struct request_queue *q, struct bio *bio);
 typedef bool (poll_q_fn) (struct request_queue *q, blk_qc_t);
+typedef void (get_inflight_fn)(struct request_queue *, unsigned int [2]);
 
 struct bio_vec;
 typedef int (dma_drain_needed_fn)(struct request *);
@@ -405,6 +406,7 @@ struct request_queue {
 	make_request_fn		*make_request_fn;
 	poll_q_fn		*poll_fn;
 	dma_drain_needed_fn	*dma_drain_needed;
+	get_inflight_fn		*get_inflight_fn;
 
 	const struct blk_mq_ops	*mq_ops;
 
@@ -1099,6 +1101,7 @@ extern void blk_queue_update_dma_alignme
 extern void blk_queue_rq_timeout(struct request_queue *, unsigned int);
 extern void blk_queue_flush_queueable(struct request_queue *q, bool queueable);
 extern void blk_queue_write_cache(struct request_queue *q, bool enabled, bool fua);
+extern void blk_queue_get_inflight(struct request_queue *, get_inflight_fn *);
 
 /*
  * Number of physical segments as sent to the device.
Index: linux-dm/block/blk-settings.c
===================================================================
--- linux-dm.orig/block/blk-settings.c	2018-11-15 22:11:51.000000000 +0100
+++ linux-dm/block/blk-settings.c	2018-11-15 22:11:51.000000000 +0100
@@ -849,6 +849,12 @@ void blk_queue_write_cache(struct reques
 }
 EXPORT_SYMBOL_GPL(blk_queue_write_cache);
 
+void blk_queue_get_inflight(struct request_queue *q, get_inflight_fn *fn)
+{
+	q->get_inflight_fn = fn;
+}
+EXPORT_SYMBOL_GPL(blk_queue_get_inflight);
+
 static int __init blk_settings_init(void)
 {
 	blk_max_low_pfn = max_low_pfn - 1;
Index: linux-dm/drivers/md/dm.c
===================================================================
--- linux-dm.orig/drivers/md/dm.c	2018-11-15 22:11:51.000000000 +0100
+++ linux-dm/drivers/md/dm.c	2018-11-15 22:18:44.000000000 +0100
@@ -657,18 +657,30 @@ int md_in_flight(struct mapped_device *m
 	return (int)sum;
 }
 
+static void test_io_ticks(int cpu, struct hd_struct *part, unsigned long now)
+{
+	unsigned long stamp = READ_ONCE(part->stamp);
+	if (unlikely(stamp != now)) {
+		if (likely(cmpxchg(&part->stamp, stamp, now) == stamp)) {
+			__part_stat_add(cpu, part, io_ticks, 1);
+		}
+	}
+}
+
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
+	unsigned long now = jiffies;
 	struct hd_struct *part;
 	int sgrp, cpu;
 
-	io->start_time = jiffies;
+	io->start_time = now;
 
 	part = &dm_disk(md)->part0;
 	sgrp = op_stat_group(bio_op(bio));
 	cpu = part_stat_lock();
+	test_io_ticks(cpu, part, now);
 	__part_stat_add(cpu, part, ios[sgrp], 1);
 	__part_stat_add(cpu, part, sectors[sgrp], bio_sectors(bio));
 	part_stat_unlock();
@@ -685,7 +697,8 @@ static void end_io_acct(struct dm_io *io
 {
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
-	unsigned long duration = jiffies - io->start_time;
+	unsigned long now = jiffies;
+	unsigned long duration = now - io->start_time;
 	struct hd_struct *part;
 	int sgrp, cpu;
 
@@ -697,7 +710,9 @@ static void end_io_acct(struct dm_io *io
 	part = &dm_disk(md)->part0;
 	sgrp = op_stat_group(bio_op(bio));
 	cpu = part_stat_lock();
+	test_io_ticks(cpu, part, now);
 	__part_stat_add(cpu, part, nsecs[sgrp], jiffies_to_nsecs(duration));
+	__part_stat_add(cpu, part, time_in_queue, duration);
 	part_stat_unlock();
 
 	smp_wmb();
@@ -711,6 +726,23 @@ static void end_io_acct(struct dm_io *io
 	}
 }
 
+static void dm_get_inflight(struct request_queue *q, unsigned int inflight[2])
+{
+	struct mapped_device *md = q->queuedata;
+	int cpu;
+
+	inflight[READ] = inflight[WRITE] = 0;
+	for_each_possible_cpu(cpu) {
+		struct dm_percpu *p = per_cpu_ptr(md->counters, cpu);
+		inflight[READ] += p->inflight[READ];
+		inflight[WRITE] += p->inflight[WRITE];
+	}
+	if ((int)inflight[READ] < 0)
+		inflight[READ] = 0;
+	if ((int)inflight[WRITE] < 0)
+		inflight[WRITE] = 0;
+}
+
 /*
  * Add the bio to the list of deferred io.
  */
@@ -2224,6 +2256,7 @@ int dm_setup_md_queue(struct mapped_devi
 	case DM_TYPE_NVME_BIO_BASED:
 		dm_init_normal_md_queue(md);
 		blk_queue_make_request(md->queue, dm_make_request);
+		blk_queue_get_inflight(md->queue, dm_get_inflight);
 		break;
 	case DM_TYPE_NONE:
 		WARN_ON_ONCE(true);
Index: linux-dm/block/blk-core.c
===================================================================
--- linux-dm.orig/block/blk-core.c	2018-11-15 22:11:51.000000000 +0100
+++ linux-dm/block/blk-core.c	2018-11-15 22:11:51.000000000 +0100
@@ -695,10 +695,15 @@ static void part_round_stats_single(stru
 void part_round_stats(struct request_queue *q, int cpu, struct hd_struct *part)
 {
 	struct hd_struct *part2 = NULL;
-	unsigned long now = jiffies;
+	unsigned long now;
 	unsigned int inflight[2];
 	int stats = 0;
 
+	if (q->get_inflight_fn)
+		return;
+
+	now = jiffies;
+
 	if (part->stamp != now)
 		stats |= 1;
 
