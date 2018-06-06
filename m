From: Mikulas Patocka <mpatocka@redhat.com>
Subject: [patch 3/3] dm-writecache: rework writecache_flush_thread
Date: Wed, 06 Jun 2018 17:31:45 +0200
Message-ID: <20180606153202.896526512@debian.vm>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
Content-Disposition: inline; filename=dm-writecache-flush-offload.patch
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

In order to avoid deadlocks due to bio queuing, discard and flush bios
must be offloaded to a different thread.

writecache_flush_thread was not resistant to spurious wake-up, when it was
woken up, it was assumed that wc->flush_bio is set.

This patch reworks writecache_flush_thread so that it uses a list of bios
and thus it is resistant to spurious wake-up.

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>

---
 drivers/md/dm-writecache.c |   78 ++++++++++++++++++++++++++++-----------------
 1 file changed, 50 insertions(+), 28 deletions(-)

Index: linux-2.6/drivers/md/dm-writecache.c
===================================================================
--- linux-2.6.orig/drivers/md/dm-writecache.c	2018-06-06 00:32:05.000000000 +0200
+++ linux-2.6/drivers/md/dm-writecache.c	2018-06-06 01:16:15.000000000 +0200
@@ -172,8 +172,7 @@ struct dm_writecache {
 	struct task_struct *endio_thread;
 
 	struct task_struct *flush_thread;
-	struct completion flush_completion;
-	struct bio *flush_bio;
+	struct bio_list flush_list;
 
 	struct dm_kcopyd_client *dm_kcopyd;
 	unsigned long *dirty_bitmap;
@@ -1065,35 +1064,48 @@ static int writecache_flush_thread(void
 {
 	struct dm_writecache *wc = data;
 
-	while (!kthread_should_stop()) {
-		struct bio *bio = wc->flush_bio;
-
-		if (likely(bio)) {
-			if (bio_op(bio) == REQ_OP_DISCARD)
-				writecache_discard(wc, bio->bi_iter.bi_sector, bio_end_sector(bio));
-			else
-				writecache_flush(wc);
-		}
+	while (1) {
+		struct bio *bio;
 
+		wc_lock(wc);
+		bio = bio_list_pop(&wc->flush_list);
+		if (bio)
+			goto process_bio;
 		set_current_state(TASK_INTERRUPTIBLE);
-		/* for debugging - catch uninitialized use */
-		wc->flush_bio = (void *)0x600 + POISON_POINTER_DELTA;
-		complete(&wc->flush_completion);
+		wc_unlock(wc);
+
+		if (unlikely(kthread_should_stop())) {
+			set_current_state(TASK_RUNNING);
+			break;
+		}
 
 		schedule();
-	}
 
-	set_current_state(TASK_RUNNING);
+		continue;
+
+process_bio:
+		if (bio_op(bio) == REQ_OP_DISCARD) {
+			writecache_discard(wc, bio->bi_iter.bi_sector, bio_end_sector(bio));
+			wc_unlock(wc);
+			bio_set_dev(bio, wc->dev->bdev);
+			generic_make_request(bio);
+		} else {
+			writecache_flush(wc);
+			wc_unlock(wc);
+			if (writecache_has_error(wc))
+				bio->bi_status = BLK_STS_IOERR;
+			bio_endio(bio);
+		}
+	}
 
 	return 0;
 }
 
 static void writecache_offload_bio(struct dm_writecache *wc, struct bio *bio)
 {
-	wc->flush_bio = bio;
-	reinit_completion(&wc->flush_completion);
-	wake_up_process(wc->flush_thread);
-	wait_for_completion_io(&wc->flush_completion);
+	if (bio_list_empty(&wc->flush_list))
+		wake_up_process(wc->flush_thread);
+	bio_list_add(&wc->flush_list, bio);
 }
 
 static int writecache_map(struct dm_target *ti, struct bio *bio)
@@ -1108,11 +1120,15 @@ static int writecache_map(struct dm_targ
 	if (unlikely(bio->bi_opf & REQ_PREFLUSH)) {
 		if (writecache_has_error(wc))
 			goto unlock_error;
-		if (WC_MODE_PMEM(wc))
+		if (WC_MODE_PMEM(wc)) {
 			writecache_flush(wc);
-		else
+			if (writecache_has_error(wc))
+				goto unlock_error;
+			goto unlock_ok;
+		} else {
 			writecache_offload_bio(wc, bio);
-		goto unlock_ok;
+			goto unlock_return;
+		}
 	}
 
 	bio->bi_iter.bi_sector = dm_target_offset(ti, bio->bi_iter.bi_sector);
@@ -1128,11 +1144,13 @@ static int writecache_map(struct dm_targ
 	if (unlikely(bio_op(bio) == REQ_OP_DISCARD)) {
 		if (writecache_has_error(wc))
 			goto unlock_error;
-		if (WC_MODE_PMEM(wc))
+		if (WC_MODE_PMEM(wc)) {
 			writecache_discard(wc, bio->bi_iter.bi_sector, bio_end_sector(bio));
-		else
+			goto unlock_remap_origin;
+		} else {
 			writecache_offload_bio(wc, bio);
-		goto unlock_remap_origin;
+			goto unlock_return;
+		}
 	}
 
 	if (bio_data_dir(bio) == READ) {
@@ -1224,6 +1242,10 @@ unlock_ok:
 	bio_endio(bio);
 	return DM_MAPIO_SUBMITTED;
 
+unlock_return:
+	wc_unlock(wc);
+	return DM_MAPIO_SUBMITTED;
+
 unlock_error:
 	wc_unlock(wc);
 	bio_io_error(bio);
@@ -2017,7 +2039,7 @@ invalid_optional:
 		size_t n_blocks, n_metadata_blocks;
 		uint64_t n_bitmap_bits;
 
-		init_completion(&wc->flush_completion);
+		bio_list_init(&wc->flush_list);
 		wc->flush_thread = kthread_create(writecache_flush_thread, wc, "dm_writecache_flush");
 		if (IS_ERR(wc->flush_thread)) {
 			r = PTR_ERR(wc->flush_thread);
@@ -2025,7 +2047,7 @@ invalid_optional:
 			ti->error = "Couldn't spawn endio thread";
 			goto bad;
 		}
-		writecache_offload_bio(wc, NULL);
+		wake_up_process(wc->flush_thread);
 
 		r = calculate_memory_size(wc->memory_map_size, wc->block_size,
 					  &n_blocks, &n_metadata_blocks);
