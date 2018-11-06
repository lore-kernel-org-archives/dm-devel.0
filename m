From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 4/5] dm: use percpu counters
Date: Tue, 06 Nov 2018 22:35:02 +0100
Message-ID: <20181106213857.112447880@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-percpu.patch
List-Unsubscribe: <https://www.redhat.com/mailman/options/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Mike Snitzer <msnitzer@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Use percpu inflight counters to avoid cache line bouncing and improve
performance.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h |    5 ++++
 drivers/md/dm-rq.c   |   10 +++++++--
 drivers/md/dm.c      |   52 +++++++++++++++++++++++++++++++++++----------------
 3 files changed, 49 insertions(+), 18 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2018-11-06 00:45:06.320000000 +0100
+++ linux-2.6/drivers/md/dm-core.h	2018-11-06 00:45:35.640000000 +0100
@@ -24,6 +24,10 @@ struct dm_kobject_holder {
 	struct completion completion;
 };
 
+struct dm_percpu {
+	unsigned inflight[2];
+};
+
 /*
  * DM core internal structure that used directly by dm.c and dm-rq.c
  * DM targets must _not_ deference a mapped_device to directly access its members!
@@ -63,6 +67,7 @@ struct mapped_device {
 	/*
 	 * A list of ios that arrived while we were suspended.
 	 */
+	struct dm_percpu __percpu *counters;
 	struct work_struct work;
 	wait_queue_head_t wait;
 	spinlock_t deferred_lock;
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2018-11-06 00:45:06.320000000 +0100
+++ linux-2.6/drivers/md/dm.c	2018-11-06 22:31:33.980000000 +0100
@@ -597,19 +597,33 @@ static void free_tio(struct dm_target_io
 
 int md_in_flight(struct mapped_device *md)
 {
-	return atomic_read(&dm_disk(md)->part0.in_flight[READ]) +
-	       atomic_read(&dm_disk(md)->part0.in_flight[WRITE]);
+	int cpu;
+	unsigned sum = 0;
+	for_each_possible_cpu(cpu) {
+		struct dm_percpu *p = per_cpu_ptr(md->counters, cpu);
+		sum += p->inflight[READ] + p->inflight[WRITE];
+	}
+	return (int)sum;
 }
 
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
+	struct hd_struct *part;
+	int sgrp, cpu;
 
 	io->start_time = jiffies;
 
-	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
-			      &dm_disk(md)->part0);
+	part = &dm_disk(md)->part0;
+	sgrp = op_stat_group(bio_op(bio));
+	cpu = part_stat_lock();
+	part_round_stats(md->queue, cpu, part);
+	part_stat_inc(cpu, part, ios[sgrp]);
+	part_stat_add(cpu, part, sectors[sgrp], bio_sectors(bio));
+	part_stat_unlock();
+
+	this_cpu_inc(md->counters->inflight[bio_data_dir(bio)]);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -622,25 +636,25 @@ static void end_io_acct(struct dm_io *io
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 	unsigned long duration = jiffies - io->start_time;
+	struct hd_struct *part;
+	int sgrp, cpu;
 
-	/*
-	 * make sure that atomic_dec in generic_end_io_acct is not reordered
-	 * with previous writes
-	 */
-	smp_mb__before_atomic();
-	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
-			    io->start_time);
-	/*
-	 * generic_end_io_acct does atomic_dec, this barrier makes sure that
-	 * atomic_dec is not reordered with waitqueue_active
-	 */
-	smp_mb__after_atomic();
+	part = &dm_disk(md)->part0;
+	sgrp = op_stat_group(bio_op(bio));
+	cpu = part_stat_lock();
+	part_stat_add(cpu, part, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_round_stats(md->queue, cpu, part);
+	part_stat_unlock();
+
+	smp_wmb();
+	this_cpu_dec(md->counters->inflight[bio_data_dir(bio)]);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, &io->stats_aux);
 
+	smp_mb();
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(waitqueue_active(&md->wait))) {
 		if (!md_in_flight(md))
@@ -1828,6 +1842,8 @@ static void cleanup_mapped_device(struct
 	if (md->queue)
 		blk_cleanup_queue(md->queue);
 
+	free_percpu(md->counters);
+
 	cleanup_srcu_struct(&md->io_barrier);
 
 	if (md->bdev) {
@@ -1899,6 +1915,10 @@ static struct mapped_device *alloc_dev(i
 	if (!md->disk)
 		goto bad;
 
+	md->counters = alloc_percpu(struct dm_percpu);
+	if (!md->counters)
+		goto bad;
+
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
Index: linux-2.6/drivers/md/dm-rq.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-rq.c	2018-10-30 15:09:45.770000000 +0100
+++ linux-2.6/drivers/md/dm-rq.c	2018-11-06 00:53:13.870000000 +0100
@@ -172,6 +172,12 @@ static void rq_end_stats(struct mapped_d
 	}
 }
 
+static unsigned rq_md_in_flight(struct mapped_device *md)
+{
+	return	atomic_read(&dm_disk(md)->part0.in_flight[READ]) +
+		atomic_read(&dm_disk(md)->part0.in_flight[WRITE]);
+}
+
 /*
  * Don't touch any member of the md after calling this function because
  * the md may be freed in dm_put() at the end of this function.
@@ -185,7 +191,7 @@ static void rq_completed(struct mapped_d
 	atomic_dec(&dm_disk(md)->part0.in_flight[rw]);
 
 	/* nudge anyone waiting on suspend queue */
-	if (!md_in_flight(md))
+	if (!rq_md_in_flight(md))
 		wake_up(&md->wait);
 
 	/*
@@ -674,7 +680,7 @@ static void dm_old_request_fn(struct req
 			pos = blk_rq_pos(rq);
 
 		if ((dm_old_request_peeked_before_merge_deadline(md) &&
-		     md_in_flight(md) && rq->bio && !bio_multiple_segments(rq->bio) &&
+		     rq_md_in_flight(md) && rq->bio && !bio_multiple_segments(rq->bio) &&
 		     md->last_rq_pos == pos && md->last_rq_rw == rq_data_dir(rq)) ||
 		    (ti->type->busy && ti->type->busy(ti))) {
 			blk_delay_queue(q, 10);
