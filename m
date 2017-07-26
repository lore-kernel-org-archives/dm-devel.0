From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 3/9] md: raid1 nowait support
Date: Wed, 26 Jul 2017 18:58:00 -0500
Message-ID: <20170726235806.12148-4-rgoldwyn@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170726235806.12148-1-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

The RAID1 driver would bail with EAGAIN in case of:
 + I/O has to wait for a barrier
 + array is frozen
 + Area is suspended
 + There are too many pending I/O that it will be queued.

To facilitate error for wait barriers, wait_barrier() is
returning bool. True in case if there was a wait (or is not
required). False in case a wait was required, but was not performed.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/raid1.c | 74 +++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 57 insertions(+), 17 deletions(-)

diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3febfc8391fb..66ca4288e3e8 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -903,8 +903,9 @@ static void lower_barrier(struct r1conf *conf, sector_t sector_nr)
 	wake_up(&conf->wait_barrier);
 }
 
-static void _wait_barrier(struct r1conf *conf, int idx)
+static bool _wait_barrier(struct r1conf *conf, int idx, bool nowait)
 {
+	bool ret = true;
 	/*
 	 * We need to increase conf->nr_pending[idx] very early here,
 	 * then raise_barrier() can be blocked when it waits for
@@ -935,7 +936,7 @@ static void _wait_barrier(struct r1conf *conf, int idx)
 	 */
 	if (!READ_ONCE(conf->array_frozen) &&
 	    !atomic_read(&conf->barrier[idx]))
-		return;
+		return ret;
 
 	/*
 	 * After holding conf->resync_lock, conf->nr_pending[idx]
@@ -953,18 +954,26 @@ static void _wait_barrier(struct r1conf *conf, int idx)
 	 */
 	wake_up(&conf->wait_barrier);
 	/* Wait for the barrier in same barrier unit bucket to drop. */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen &&
-			     !atomic_read(&conf->barrier[idx]),
-			    conf->resync_lock);
+	if (conf->array_frozen || atomic_read(&conf->barrier[idx])) {
+		if (nowait)
+			ret = false;
+		else
+			wait_event_lock_irq(conf->wait_barrier,
+					!conf->array_frozen &&
+					!atomic_read(&conf->barrier[idx]),
+					conf->resync_lock);
+	}
 	atomic_inc(&conf->nr_pending[idx]);
 	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
-static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
+static bool wait_read_barrier(struct r1conf *conf, sector_t sector_nr,
+		bool nowait)
 {
 	int idx = sector_to_idx(sector_nr);
+	bool ret = true;
 
 	/*
 	 * Very similar to _wait_barrier(). The difference is, for read
@@ -976,7 +985,7 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	atomic_inc(&conf->nr_pending[idx]);
 
 	if (!READ_ONCE(conf->array_frozen))
-		return;
+		return ret;
 
 	spin_lock_irq(&conf->resync_lock);
 	atomic_inc(&conf->nr_waiting[idx]);
@@ -987,19 +996,28 @@ static void wait_read_barrier(struct r1conf *conf, sector_t sector_nr)
 	 */
 	wake_up(&conf->wait_barrier);
 	/* Wait for array to be unfrozen */
-	wait_event_lock_irq(conf->wait_barrier,
-			    !conf->array_frozen,
-			    conf->resync_lock);
+	if (conf->array_frozen) {
+		/* If nowait flag is set, return false to
+		 * show we did not wait
+		 */
+		if (nowait)
+			ret = false;
+		else
+			wait_event_lock_irq(conf->wait_barrier,
+					!conf->array_frozen,
+					conf->resync_lock);
+	}
 	atomic_inc(&conf->nr_pending[idx]);
 	atomic_dec(&conf->nr_waiting[idx]);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
-static void wait_barrier(struct r1conf *conf, sector_t sector_nr)
+static bool wait_barrier(struct r1conf *conf, sector_t sector_nr, bool nowait)
 {
 	int idx = sector_to_idx(sector_nr);
 
-	_wait_barrier(conf, idx);
+	return _wait_barrier(conf, idx, nowait);
 }
 
 static void wait_all_barriers(struct r1conf *conf)
@@ -1007,7 +1025,7 @@ static void wait_all_barriers(struct r1conf *conf)
 	int idx;
 
 	for (idx = 0; idx < BARRIER_BUCKETS_NR; idx++)
-		_wait_barrier(conf, idx);
+		_wait_barrier(conf, idx, false);
 }
 
 static void _allow_barrier(struct r1conf *conf, int idx)
@@ -1223,7 +1241,11 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 	 * Still need barrier for READ in case that whole
 	 * array is frozen.
 	 */
-	wait_read_barrier(conf, bio->bi_iter.bi_sector);
+	if (!wait_read_barrier(conf, bio->bi_iter.bi_sector,
+				bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 
 	if (!r1_bio)
 		r1_bio = alloc_r1bio(mddev, bio);
@@ -1333,6 +1355,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		 * an interruptible wait.
 		 */
 		DEFINE_WAIT(w);
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
+
 		for (;;) {
 			sigset_t full, old;
 			prepare_to_wait(&conf->wait_barrier,
@@ -1351,7 +1378,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		}
 		finish_wait(&conf->wait_barrier, &w);
 	}
-	wait_barrier(conf, bio->bi_iter.bi_sector);
+	if (!wait_barrier(conf, bio->bi_iter.bi_sector,
+				bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 
 	r1_bio = alloc_r1bio(mddev, bio);
 	r1_bio->sectors = max_write_sectors;
@@ -1359,6 +1390,10 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		raid1_log(mddev, "wait queued");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		wait_event(conf->wait_barrier,
 			   conf->pending_count < max_queued_requests);
 	}
@@ -1442,6 +1477,11 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		/* Wait for this device to become unblocked */
 		int j;
 
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
+
 		for (j = 0; j < i; j++)
 			if (r1_bio->bios[j])
 				rdev_dec_pending(conf->mirrors[j].rdev, mddev);
@@ -1449,7 +1489,7 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 		allow_barrier(conf, bio->bi_iter.bi_sector);
 		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf, bio->bi_iter.bi_sector);
+		wait_barrier(conf, bio->bi_iter.bi_sector, false);
 		goto retry_write;
 	}
 
-- 
2.12.3
