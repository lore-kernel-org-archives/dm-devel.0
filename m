From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 13/14] barriers
Date: Fri, 27 Mar 2009 02:09:33 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0903270209100.17063@hs20-bc2-1.build.redhat.com>
References: <Pine.LNX.4.64.0902231422390.23293@hs20-bc2-1.build.redhat.com>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <Pine.LNX.4.64.0902231422390.23293@hs20-bc2-1.build.redhat.com>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: dm-devel@redhat.com
Cc: Alasdair G Kergon <agk@redhat.com>
List-Id: dm-devel.ids

Rework helper thread.

IO may be submitted to a worker thread with queue_io().
queue_io() sets DMF_QUEUE_IO_FOR_THREAD so that all further IO is queued for
the thread. When the thread finishes its work, it clears DMF_QUEUE_IO_FOR_THREAD
and from this point on, requests are submitted from dm_request again.

Add new flag DMF_BLOCK_FOR_SUSPEND that is set when the IO needs to be blocked
because of an ongoing suspend (DMF_BLOCK_IO had this meaning before this patch).

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm.c |   92 +++++++++++++++++++++++++-------------------------------
 1 file changed, 42 insertions(+), 50 deletions(-)

Index: linux-2.6.29-rc8-devel/drivers/md/dm.c
===================================================================
--- linux-2.6.29-rc8-devel.orig/drivers/md/dm.c	2009-03-27 05:00:56.000000000 +0100
+++ linux-2.6.29-rc8-devel/drivers/md/dm.c	2009-03-27 05:09:58.000000000 +0100
@@ -89,12 +89,13 @@ union map_info *dm_get_mapinfo(struct bi
 /*
  * Bits for the md->flags field.
  */
-#define DMF_BLOCK_IO 0
-#define DMF_SUSPENDED 1
-#define DMF_FROZEN 2
-#define DMF_FREEING 3
-#define DMF_DELETING 4
-#define DMF_NOFLUSH_SUSPENDING 5
+#define DMF_QUEUE_IO_FOR_THREAD 0
+#define DMF_BLOCK_FOR_SUSPEND 1
+#define DMF_SUSPENDED 2
+#define DMF_FROZEN 3
+#define DMF_FREEING 4
+#define DMF_DELETING 5
+#define DMF_NOFLUSH_SUSPENDING 6
 
 /*
  * Work processed by per-device workqueue.
@@ -435,21 +436,15 @@ static void end_io_acct(struct dm_io *io
 /*
  * Add the bio to the list of deferred io.
  */
-static int queue_io(struct mapped_device *md, struct bio *bio)
+static void queue_io(struct mapped_device *md, struct bio *bio)
 {
 	down_write(&md->io_lock);
-
-	if (!test_bit(DMF_BLOCK_IO, &md->flags)) {
-		up_write(&md->io_lock);
-		return 1;
-	}
-
 	spin_lock_irq(&md->deferred_lock);
 	bio_list_add(&md->deferred, bio);
 	spin_unlock_irq(&md->deferred_lock);
-
+	if (!test_and_set_bit(DMF_QUEUE_IO_FOR_THREAD, &md->flags))
+		queue_work(md->wq, &md->work);
 	up_write(&md->io_lock);
-	return 0;		/* deferred successfully */
 }
 
 /*
@@ -908,7 +903,6 @@ out:
  */
 static int dm_request(struct request_queue *q, struct bio *bio)
 {
-	int r = -EIO;
 	int rw = bio_data_dir(bio);
 	struct mapped_device *md = q->queuedata;
 	int cpu;
@@ -930,34 +924,26 @@ static int dm_request(struct request_que
 	part_stat_unlock();
 
 	/*
-	 * If we're suspended we have to queue
-	 * this io for later.
+	 * If we're suspended or the thread is processing barriers
+	 * we have to queue this io for later.
 	 */
-	while (test_bit(DMF_BLOCK_IO, &md->flags)) {
+	if (unlikely(test_bit(DMF_QUEUE_IO_FOR_THREAD, &md->flags))) {
 		up_read(&md->io_lock);
 
-		if (bio_rw(bio) != READA)
-			r = queue_io(md, bio);
+		if (unlikely(test_bit(DMF_BLOCK_FOR_SUSPEND, &md->flags)) &&
+		    bio_rw(bio) == READA) {
+			bio_io_error(bio);
+			return 0;
+		}
 
-		if (r <= 0)
-			goto out_req;
+		queue_io(md, bio);
 
-		/*
-		 * We're in a while loop, because someone could suspend
-		 * before we get to the following read lock.
-		 */
-		down_read(&md->io_lock);
+		return 0;
 	}
 
 	__split_and_process_bio(md, bio);
 	up_read(&md->io_lock);
 	return 0;
-
-out_req:
-	if (r < 0)
-		bio_io_error(bio);
-
-	return 0;
 }
 
 static void dm_unplug_all(struct request_queue *q)
@@ -977,7 +963,7 @@ static int dm_any_congested(void *conges
 	struct mapped_device *md = congested_data;
 	struct dm_table *map;
 
-	if (!test_bit(DMF_BLOCK_IO, &md->flags)) {
+	if (!test_bit(DMF_BLOCK_FOR_SUSPEND, &md->flags)) {
 		map = dm_get_table(md);
 		if (map) {
 			r = dm_table_any_congested(map, bdi_bits);
@@ -1413,29 +1399,32 @@ static int dm_wait_for_completion(struct
 static void dm_wq_work(struct work_struct *work)
 {
 	struct mapped_device *md = container_of(work, struct mapped_device, work);
-	struct bio *c;
-
 	down_write(&md->io_lock);
 
-next_bio:
-	spin_lock_irq(&md->deferred_lock);
-	c = bio_list_pop(&md->deferred);
-	spin_unlock_irq(&md->deferred_lock);
+	while (!test_bit(DMF_BLOCK_FOR_SUSPEND, &md->flags)) {
+		struct bio *c;
 
-	if (c) {
-		__split_and_process_bio(md, c);
-		goto next_bio;
-	}
+		spin_lock_irq(&md->deferred_lock);
+		c = bio_list_pop(&md->deferred);
+		spin_unlock_irq(&md->deferred_lock);
 
-	clear_bit(DMF_BLOCK_IO, &md->flags);
+		up_write(&md->io_lock);
 
-	up_write(&md->io_lock);
+		if (!c) {
+			clear_bit(DMF_QUEUE_IO_FOR_THREAD, &md->flags);
+			break;
+		}
+
+		__split_and_process_bio(md, c);
+
+		down_write(&md->io_lock);
+	}
 }
 
 static void dm_queue_flush(struct mapped_device *md)
 {
+	clear_bit(DMF_BLOCK_FOR_SUSPEND, &md->flags);
 	queue_work(md->wq, &md->work);
-	flush_workqueue(md->wq);
 }
 
 /*
@@ -1541,16 +1530,19 @@ int dm_suspend(struct mapped_device *md,
 	}
 
 	/*
-	 * First we set the BLOCK_IO flag so no more ios will be mapped.
+	 * First we set the QUEUE_IO_FOR_THREAD flag so no more ios
+	 * will be mapped.
 	 */
 	down_write(&md->io_lock);
-	set_bit(DMF_BLOCK_IO, &md->flags);
+	set_bit(DMF_BLOCK_FOR_SUSPEND, &md->flags);
+	set_bit(DMF_QUEUE_IO_FOR_THREAD, &md->flags);
 
 	up_write(&md->io_lock);
 
 	/*
 	 * Wait for the already-mapped ios to complete.
 	 */
+	flush_workqueue(md->wq);
 	r = dm_wait_for_completion(md, TASK_INTERRUPTIBLE);
 
 	down_write(&md->io_lock);
