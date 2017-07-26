From: Goldwyn Rodrigues <rgoldwyn@suse.de>
Subject: [PATCH 5/9] md: raid10 nowait support
Date: Wed, 26 Jul 2017 18:58:02 -0500
Message-ID: <20170726235806.12148-6-rgoldwyn@suse.de>
References: <20170726235806.12148-1-rgoldwyn@suse.de>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20170726235806.12148-1-rgoldwyn@suse.de>
Sender: linux-block-owner@vger.kernel.org
To: linux-block@vger.kernel.org
Cc: hch@infradead.org, jack@suse.cz, linux-raid@vger.kernel.org, dm-devel@redhat.com, Goldwyn Rodrigues <rgoldwyn@suse.com>
List-Id: dm-devel.ids

From: Goldwyn Rodrigues <rgoldwyn@suse.com>

Bail and status to EAGAIN if raid10 is going to wait for:
 + barriers
 + reshape operation
 + Too many queued requests

Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
---
 drivers/md/raid10.c | 62 ++++++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 47 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 5026e7ad51d3..6d80438c5040 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -978,8 +978,9 @@ static void lower_barrier(struct r10conf *conf)
 	wake_up(&conf->wait_barrier);
 }
 
-static void wait_barrier(struct r10conf *conf)
+static bool wait_barrier(struct r10conf *conf, bool nowait)
 {
+	bool ret = true;
 	spin_lock_irq(&conf->resync_lock);
 	if (conf->barrier) {
 		conf->nr_waiting++;
@@ -993,19 +994,23 @@ static void wait_barrier(struct r10conf *conf)
 		 * count down.
 		 */
 		raid10_log(conf->mddev, "wait barrier");
-		wait_event_lock_irq(conf->wait_barrier,
-				    !conf->barrier ||
-				    (atomic_read(&conf->nr_pending) &&
-				     current->bio_list &&
-				     (!bio_list_empty(&current->bio_list[0]) ||
-				      !bio_list_empty(&current->bio_list[1]))),
-				    conf->resync_lock);
+		if (!nowait)
+			wait_event_lock_irq(conf->wait_barrier,
+					    !conf->barrier ||
+				            (atomic_read(&conf->nr_pending) &&
+				             current->bio_list &&
+				             (!bio_list_empty(&current->bio_list[0]) ||
+				              !bio_list_empty(&current->bio_list[1]))),
+					    conf->resync_lock);
+		else
+			ret = false;
 		conf->nr_waiting--;
 		if (!conf->nr_waiting)
 			wake_up(&conf->wait_barrier);
 	}
 	atomic_inc(&conf->nr_pending);
 	spin_unlock_irq(&conf->resync_lock);
+	return ret;
 }
 
 static void allow_barrier(struct r10conf *conf)
@@ -1158,7 +1163,10 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	wait_barrier(conf);
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 
 	sectors = r10_bio->sectors;
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1169,12 +1177,16 @@ static void raid10_read_request(struct mddev *mddev, struct bio *bio,
 		 * pass
 		 */
 		raid10_log(conf->mddev, "wait reshape");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		allow_barrier(conf);
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 
 	rdev = read_balance(conf, r10_bio, &max_sectors);
@@ -1308,7 +1320,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	 * thread has put up a bar for new requests.
 	 * Continue immediately if no resync is active currently.
 	 */
-	wait_barrier(conf);
+	if (!wait_barrier(conf, bio->bi_opf & REQ_NOWAIT)) {
+		bio_wouldblock_error(bio);
+		return;
+	}
 
 	sectors = r10_bio->sectors;
 	while (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1319,12 +1334,16 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		 * pass
 		 */
 		raid10_log(conf->mddev, "wait reshape");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		allow_barrier(conf);
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
 			   sectors);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 	}
 
 	if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) &&
@@ -1339,6 +1358,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
 		md_wakeup_thread(mddev->thread);
 		raid10_log(conf->mddev, "wait reshape metadata");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
@@ -1348,6 +1371,10 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 	if (conf->pending_count >= max_queued_requests) {
 		md_wakeup_thread(mddev->thread);
 		raid10_log(mddev, "wait queued");
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
 		wait_event(conf->wait_barrier,
 			   conf->pending_count < max_queued_requests);
 	}
@@ -1454,6 +1481,11 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		int j;
 		int d;
 
+		if (bio->bi_opf & REQ_NOWAIT) {
+			bio_wouldblock_error(bio);
+			return;
+		}
+
 		for (j = 0; j < i; j++) {
 			if (r10_bio->devs[j].bio) {
 				d = r10_bio->devs[j].devnum;
@@ -1474,7 +1506,7 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 		allow_barrier(conf);
 		raid10_log(conf->mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		goto retry_write;
 	}
 
@@ -1703,7 +1735,7 @@ static void print_conf(struct r10conf *conf)
 
 static void close_sync(struct r10conf *conf)
 {
-	wait_barrier(conf);
+	wait_barrier(conf, false);
 	allow_barrier(conf);
 
 	mempool_destroy(conf->r10buf_pool);
@@ -4347,7 +4379,7 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr,
 	if (need_flush ||
 	    time_after(jiffies, conf->reshape_checkpoint + 10*HZ)) {
 		/* Need to update reshape_position in metadata */
-		wait_barrier(conf);
+		wait_barrier(conf, false);
 		mddev->reshape_position = conf->reshape_progress;
 		if (mddev->reshape_backwards)
 			mddev->curr_resync_completed = raid10_size(mddev, 0, 0)
-- 
2.12.3
