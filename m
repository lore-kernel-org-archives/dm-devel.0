From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 2/3] dm: use percpu counters
Date: Fri, 16 Nov 2018 01:04:18 +0100
Message-ID: <20181116000507.773533534@debian.vm>
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
To: Mike Snitzer <msnitzer@redhat.com>
Cc: Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, linux-block@vger.kernel.org, dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>, "Alasdair G. Kergon" <agk@redhat.com>
List-Id: dm-devel.ids

Use percpu inflight counters to avoid cache line bouncing and improve
performance.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h |    5 +++++
 drivers/md/dm.c      |   50 ++++++++++++++++++++++++++++++++++----------------
 2 files changed, 39 insertions(+), 16 deletions(-)

Index: linux-dm/drivers/md/dm-core.h
===================================================================
--- linux-dm.orig/drivers/md/dm-core.h	2018-11-15 22:06:37.000000000 +0100
+++ linux-dm/drivers/md/dm-core.h	2018-11-15 22:06:37.000000000 +0100
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
Index: linux-dm/drivers/md/dm.c
===================================================================
--- linux-dm.orig/drivers/md/dm.c	2018-11-15 22:06:37.000000000 +0100
+++ linux-dm/drivers/md/dm.c	2018-11-15 22:09:31.000000000 +0100
@@ -648,19 +648,32 @@ static void free_tio(struct dm_target_io
 
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
+	__part_stat_add(cpu, part, ios[sgrp], 1);
+	__part_stat_add(cpu, part, sectors[sgrp], bio_sectors(bio));
+	part_stat_unlock();
+
+	this_cpu_inc(md->counters->inflight[bio_data_dir(bio)]);
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
@@ -673,25 +686,24 @@ static void end_io_acct(struct dm_io *io
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 	unsigned long duration = jiffies - io->start_time;
+	struct hd_struct *part;
+	int sgrp, cpu;
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, &io->stats_aux);
 
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
+	__part_stat_add(cpu, part, nsecs[sgrp], jiffies_to_nsecs(duration));
+	part_stat_unlock();
+
+	smp_wmb();
+	this_cpu_dec(md->counters->inflight[bio_data_dir(bio)]);
 
+	smp_mb();
 	/* nudge anyone waiting on suspend queue */
 	if (unlikely(waitqueue_active(&md->wait))) {
 		if (!md_in_flight(md))
@@ -1822,6 +1834,8 @@ static void cleanup_mapped_device(struct
 	if (md->queue)
 		blk_cleanup_queue(md->queue);
 
+	free_percpu(md->counters);
+
 	cleanup_srcu_struct(&md->io_barrier);
 
 	if (md->bdev) {
@@ -1892,6 +1906,10 @@ static struct mapped_device *alloc_dev(i
 	if (!md->disk)
 		goto bad;
 
+	md->counters = alloc_percpu(struct dm_percpu);
+	if (!md->counters)
+		goto bad;
+
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
