From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 3/5] dm: remove the pending variable
Date: Tue, 06 Nov 2018 22:35:01 +0100
Message-ID: <20181106213855.868640480@debian-a64.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-remove-pending.patch
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

Remove the "pending" variable and use dm_disk(md)->part0.in_flight.
These variables hold identical values.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-core.h |    1 -
 drivers/md/dm-rq.c   |    4 ++--
 drivers/md/dm.c      |   34 ++++++++++++++++------------------
 3 files changed, 18 insertions(+), 21 deletions(-)

Index: linux-2.6/drivers/md/dm-core.h
===================================================================
--- linux-2.6.orig/drivers/md/dm-core.h	2018-10-25 00:47:12.000000000 +0200
+++ linux-2.6/drivers/md/dm-core.h	2018-10-25 00:47:12.000000000 +0200
@@ -65,7 +65,6 @@ struct mapped_device {
 	 */
 	struct work_struct work;
 	wait_queue_head_t wait;
-	atomic_t pending[2];
 	spinlock_t deferred_lock;
 	struct bio_list deferred;
 
Index: linux-2.6/drivers/md/dm.c
===================================================================
--- linux-2.6.orig/drivers/md/dm.c	2018-10-25 00:47:12.000000000 +0200
+++ linux-2.6/drivers/md/dm.c	2018-10-25 00:47:28.000000000 +0200
@@ -597,23 +597,20 @@ static void free_tio(struct dm_target_io
 
 int md_in_flight(struct mapped_device *md)
 {
-	return atomic_read(&md->pending[READ]) +
-	       atomic_read(&md->pending[WRITE]);
+	return atomic_read(&dm_disk(md)->part0.in_flight[READ]) +
+	       atomic_read(&dm_disk(md)->part0.in_flight[WRITE]);
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
@@ -625,27 +622,30 @@ static void end_io_acct(struct dm_io *io
 	struct mapped_device *md = io->md;
 	struct bio *bio = io->orig_bio;
 	unsigned long duration = jiffies - io->start_time;
-	int pending;
-	int rw = bio_data_dir(bio);
 
+	/*
+	 * make sure that atomic_dec in generic_end_io_acct is not reordered
+	 * with previous writes
+	 */
+	smp_mb__before_atomic();
 	generic_end_io_acct(md->queue, bio_op(bio), &dm_disk(md)->part0,
 			    io->start_time);
+	/*
+	 * generic_end_io_acct does atomic_dec, this barrier makes sure that
+	 * atomic_dec is not reordered with waitqueue_active
+	 */
+	smp_mb__after_atomic();
 
 	if (unlikely(dm_stats_used(&md->stats)))
 		dm_stats_account_io(&md->stats, bio_data_dir(bio),
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
@@ -1899,8 +1899,6 @@ static struct mapped_device *alloc_dev(i
 	if (!md->disk)
 		goto bad;
 
-	atomic_set(&md->pending[0], 0);
-	atomic_set(&md->pending[1], 0);
 	init_waitqueue_head(&md->wait);
 	INIT_WORK(&md->work, dm_wq_work);
 	init_waitqueue_head(&md->eventq);
Index: linux-2.6/drivers/md/dm-rq.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-rq.c	2018-10-25 00:47:12.000000000 +0200
+++ linux-2.6/drivers/md/dm-rq.c	2018-10-25 00:47:12.000000000 +0200
@@ -182,7 +182,7 @@ static void rq_completed(struct mapped_d
 	struct request_queue *q = md->queue;
 	unsigned long flags;
 
-	atomic_dec(&md->pending[rw]);
+	atomic_dec(&dm_disk(md)->part0.in_flight[rw]);
 
 	/* nudge anyone waiting on suspend queue */
 	if (!md_in_flight(md))
@@ -536,7 +536,7 @@ static void dm_start_request(struct mapp
 		blk_start_request(orig);
 	else
 		blk_mq_start_request(orig);
-	atomic_inc(&md->pending[rq_data_dir(orig)]);
+	atomic_inc(&dm_disk(md)->part0.in_flight[rq_data_dir(orig)]);
 
 	if (md->seq_rq_merge_deadline_usecs) {
 		md->last_rq_pos = rq_end_sector(orig);
