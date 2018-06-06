From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 1/3] dm-writecache: convert swait_queues to
	wait_queues
Date: Wed, 06 Jun 2018 17:31:43 +0200
Message-ID: <20180606153200.530119259@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-writecache-wait.patch
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
Cc: dm-devel@redhat.com, Mikulas Patocka <mpatocka@redhat.com>
List-Id: dm-devel.ids

Convert swait_queues to wait_queues, because there may be multiple
processes waiting on the queue and swait_queues are inefficient in that
case (and the code incorrectly uses swake_up where it intends to wake all
the waiters).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-04 21:45:35.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-06-04 22:10:35.000000000 +0200
@@ -129,10 +129,10 @@ struct dm_writecache {
 
 	unsigned long autocommit_jiffies;
 	struct timer_list autocommit_timer;
-	struct swait_queue_head freelist_wait;
+	struct wait_queue_head freelist_wait;
 
 	atomic_t bio_in_progress[2];
-	struct swait_queue_head bio_in_progress_wait[2];
+	struct wait_queue_head bio_in_progress_wait[2];
 
 	struct dm_target *ti;
 	struct dm_dev *dev;
@@ -408,7 +408,7 @@ static void write_original_sector_seq_co
 do {									\
 	if (!cmpxchg(&(wc)->error, 0, err))				\
 		DMERR(msg, ##arg);					\
-	swake_up(&(wc)->freelist_wait);					\
+	wake_up(&(wc)->freelist_wait);					\
 } while (0)
 
 #define writecache_has_error(wc)	(unlikely(READ_ONCE((wc)->error)))
@@ -526,7 +526,7 @@ static void writecache_disk_flush(struct
 
 static void writecache_wait_for_ios(struct dm_writecache *wc, int direction)
 {
-	swait_event(wc->bio_in_progress_wait[direction],
+	wait_event(wc->bio_in_progress_wait[direction],
 		   !atomic_read(&wc->bio_in_progress[direction]));
 }
 
@@ -658,18 +658,18 @@ static void writecache_free_entry(struct
 	writecache_add_to_freelist(wc, e);
 	clear_seq_count(wc, e);
 	writecache_flush_region(wc, memory_entry(wc, e), sizeof(struct wc_memory_entry));
-	if (unlikely(swait_active(&wc->freelist_wait)))
-		swake_up(&wc->freelist_wait);
+	if (unlikely(waitqueue_active(&wc->freelist_wait)))
+		wake_up(&wc->freelist_wait);
 }
 
 static void writecache_wait_on_freelist(struct dm_writecache *wc)
 {
-	DECLARE_SWAITQUEUE(wait);
+	DEFINE_WAIT(wait);
 
-	prepare_to_swait(&wc->freelist_wait, &wait, TASK_UNINTERRUPTIBLE);
+	prepare_to_wait(&wc->freelist_wait, &wait, TASK_UNINTERRUPTIBLE);
 	wc_unlock(wc);
 	io_schedule();
-	finish_swait(&wc->freelist_wait, &wait);
+	finish_wait(&wc->freelist_wait, &wait);
 	wc_lock(wc);
 }
 
@@ -1238,8 +1238,8 @@ static int writecache_end_io(struct dm_t
 	if (bio->bi_private != NULL) {
 		int dir = bio_data_dir(bio);
 		if (atomic_dec_and_test(&wc->bio_in_progress[dir]))
-			if (unlikely(swait_active(&wc->bio_in_progress_wait[dir])))
-				swake_up(&wc->bio_in_progress_wait[dir]);
+			if (unlikely(waitqueue_active(&wc->bio_in_progress_wait[dir])))
+				wake_up(&wc->bio_in_progress_wait[dir]);
 	}
 	return 0;
 }
@@ -1823,12 +1823,12 @@ static int writecache_ctr(struct dm_targ
 
 	mutex_init(&wc->lock);
 	writecache_poison_lists(wc);
-	init_swait_queue_head(&wc->freelist_wait);
+	init_waitqueue_head(&wc->freelist_wait);
 	timer_setup(&wc->autocommit_timer, writecache_autocommit_timer, 0);
 
 	for (i = 0; i < 2; i++) {
 		atomic_set(&wc->bio_in_progress[i], 0);
-		init_swait_queue_head(&wc->bio_in_progress_wait[i]);
+		init_waitqueue_head(&wc->bio_in_progress_wait[i]);
 	}
 
 	wc->dm_io = dm_io_client_create();
