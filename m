From: Mike Snitzer <snitzer@redhat.com>
Subject: [PATCH v3 7/7] dm: remove the pending IO accounting
Date: Wed,  5 Dec 2018 15:24:33 -0500
Message-ID: <20181205202433.95823-8-snitzer@redhat.com>
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

Remove the "pending" atomic counters, that duplicate block-core's
in_flight counters, and update md_in_flight() to look at percpu
in_flight counters.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Mike Snitzer <snitzer@redhat.com>
---
 drivers/md/dm-core.h |  2 --
 drivers/md/dm.c      | 34 +++++++++++++++-------------------
 2 files changed, 15 insertions(+), 21 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index 224d44503a06..6fe883fac471 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -65,7 +65,6 @@ struct mapped_device {
 	 */
 	struct work_struct work;
 	wait_queue_head_t wait;
-	atomic_t pending[2];
 	spinlock_t deferred_lock;
 	struct bio_list deferred;
 
@@ -119,7 +118,6 @@ struct mapped_device {
 	struct srcu_struct io_barrier;
 };
 
-int md_in_flight(struct mapped_device *md);
 void disable_write_same(struct mapped_device *md);
 void disable_write_zeroes(struct mapped_device *md);
 
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a8ae7931bce7..ff6e5a5902f2 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -646,25 +646,30 @@ static void free_tio(struct dm_target_io *tio)
 	bio_put(&tio->clone);
 }
 
-int md_in_flight(struct mapped_device *md)
+static bool md_in_flight(struct mapped_device *md)
 {
-	return atomic_read(&md->pending[READ]) +
-	       atomic_read(&md->pending[WRITE]);
+	int cpu;
+	struct hd_struct *part = &dm_disk(md)->part0;
+
+	for_each_possible_cpu(cpu) {
+		if (local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[0]) ||
+		    local_read(&per_cpu_ptr(part->dkstats, cpu)->in_flight[1]))
+			return true;
+	}
+
+	return false;
 }
 
 static void start_io_acct(struct dm_io *io)
 {
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
-	int rw = bio_data_dir(bio);
 
 	io->start_time = jiffies;
 
 	generic_start_io_acct(md->queue, bio_op(bio), bio_sectors(bio),
 			      &dm_disk(md)->part0);
 
-	atomic_inc(&md->pending[rw]);
-
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
@@ -676,8 +681,6 @@ static void end_io_acct(struct dm_io *io)
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 	unsigned long duration = jiffies - io->start_time;
-	int pending;
-	int rw = bio_data_dir(bio);
 
 	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
 			    io->start_time);
@@ -687,16 +690,11 @@ static void end_io_acct(struct dm_io *io)
 				    bio->bi_iter.bi_sector, bio_sectors(bio),
 				    true, duration, &io->stats_aux);
 
-	/*
-	 * After this is decremented the bio must not be touched if it is
-	 * a flush.
-	 */
-	pending = atomic_dec_return(&md->pending[rw]);
-	pending += atomic_read(&md->pending[rw^0x1]);
-
 	/* nudge anyone waiting on suspend queue */
-	if (!pending)
-		wake_up(&md->wait);
+	if (unlikely(waitqueue_active(&md->wait))) {
+		if (!md_in_flight(md))
+			wake_up(&md->wait);
+	}
 }
 
 /*
@@ -1904,8 +1902,6 @@ static struct mapped_device *alloc_dev(int minor)
 	if (!md->disk)
 		goto bad;
 
-	atomic_set(&md->pending[0], 0);
-	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
-- 
2.18.0
