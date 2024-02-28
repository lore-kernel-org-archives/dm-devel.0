Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C50997290E;
	Wed, 28 Feb 2024 22:56:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161020; cv=none; b=fcWm+KqNZ19efkXKeCESKYn9LeuTVB4FmeeL4Xa1vp6qHhwh7K83bfxY6FjEhg9VcxSrTmyj7fYi/sd/NgrHJv4ITa9Dt12sN6ToqM9X2ESg+XN+SwmKxGPcHeKbj7Bm+2piHC2gHaJO4DXpFObK3rydpdAaZscMxZETp8Ml4Ho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161020; c=relaxed/simple;
	bh=TjI7EHPbm0rtsFaJEe2vZG8NXZMT1AAx5wNDdJYY8JM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJQxluxKSVifu6r/NMgVoNoGCd7gw9QEZ7wVVURdmALSX/YHXWeCIAlsmaEo+KGGctBxBgHfHRP0wnXz7qjbBftgFbGWWeaBi3404PPJDNPTNptgqWOFtZlSpg723L4enGh5AfA9297mHxX/Xh7fAQStWP2KTPkuB0WcVaKIsNU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=rBUBUKgb; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="rBUBUKgb"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=Guj9TF+YSfgRpOC/M20J9OvG45zLGLW0zwrnlN78wZo=; b=rBUBUKgbQgeZFBQulNEQRPfwM0
	rVW/kwKftFs5W3xFFFZAhWMcu5QsH9auSFKiHrl3sInttF97R8VGTORNz2rxLb51YfpwMOouqnjZu
	o4Wsj4kC/aLt0TdGSQ5ObyHHMEswdWvF+vgSkY6opHzj8msQ6jSz81vMq7HyDHaEjon4dUbNYEOjD
	Qb73ZHMtMH1V6ks+bOvViUOOCNu3H2rIr0L7SUsbjgEaDg4n6HXu/1p3nC5jX3r93WfJrZ9/ySNPb
	u2N2UUpypY2BE5oiigG/h/iuZPCKqamDKuSEwr8LOvHokEKUsGCOG0YFxXuSwRXO3Lt35nPJJ6kTr
	qs6ljWwA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSr9-0000000BCOF-2hSE;
	Wed, 28 Feb 2024 22:56:55 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 05/14] md: add a mddev_add_trace_msg helper
Date: Wed, 28 Feb 2024 14:56:44 -0800
Message-Id: <20240228225653.947152-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240228225653.947152-1-hch@lst.de>
References: <20240228225653.947152-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Add a small wrapper around blk_add_trace_msg that hides some argument
dereferences and the check for a DM-mapped MD device.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md-bitmap.c |  9 +++------
 drivers/md/md.c        |  3 +--
 drivers/md/md.h        |  6 ++++++
 drivers/md/raid1.c     | 10 ++++------
 drivers/md/raid10.c    | 15 +++++++--------
 drivers/md/raid5.c     | 14 +++++++-------
 6 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 9672f75c30503c..a0935a3d66c2d7 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1043,9 +1043,8 @@ void md_bitmap_unplug(struct bitmap *bitmap)
 		if (dirty || need_write) {
 			if (!writing) {
 				md_bitmap_wait_writes(bitmap);
-				if (bitmap->mddev->queue)
-					blk_add_trace_msg(bitmap->mddev->queue,
-							  "md bitmap_unplug");
+				mddev_add_trace_msg(bitmap->mddev,
+					"md bitmap_unplug");
 			}
 			clear_page_attr(bitmap, i, BITMAP_PAGE_PENDING);
 			filemap_write_page(bitmap, i, false);
@@ -1316,9 +1315,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 	}
 	bitmap->allclean = 1;
 
-	if (bitmap->mddev->queue)
-		blk_add_trace_msg(bitmap->mddev->queue,
-				  "md bitmap_daemon_work");
+	mddev_add_trace_msg(bitmap->mddev, "md bitmap_daemon_work");
 
 	/* Any file-page which is PENDING now needs to be written.
 	 * So set NEEDWRITE now, then after we make any last-minute changes
diff --git a/drivers/md/md.c b/drivers/md/md.c
index ccbc66ce8c4d13..409e57242b27f6 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2847,8 +2847,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
 		 mdname(mddev), mddev->in_sync);
 
-	if (mddev->queue)
-		blk_add_trace_msg(mddev->queue, "md md_update_sb");
+	mddev_add_trace_msg(mddev, "md md_update_sb");
 rewrite:
 	md_bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6465411d3afd5d..91ee8951fc8dcb 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -871,4 +871,10 @@ static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		trace_block_bio_remap(bio, disk_devt(mddev->gendisk), sector);
 }
 
+#define mddev_add_trace_msg(mddev, fmt, args...)			\
+do {									\
+	if ((mddev)->gendisk)						\
+		blk_add_trace_msg((mddev)->queue, fmt, ##args);		\
+} while (0)
+
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index cb64477fa89feb..3f47fe828b21bb 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -46,9 +46,6 @@
 static void allow_barrier(struct r1conf *conf, sector_t sector_nr);
 static void lower_barrier(struct r1conf *conf, sector_t sector_nr);
 
-#define raid1_log(md, fmt, args...)				\
-	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid1 " fmt, ##args); } while (0)
-
 #define RAID_1_10_NAME "raid1"
 #include "raid1-10.c"
 
@@ -1098,7 +1095,7 @@ static void freeze_array(struct r1conf *conf, int extra)
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->array_frozen = 1;
-	raid1_log(conf->mddev, "wait freeze");
+	mddev_add_trace_msg(conf->mddev, "raid1 wait freeze");
 	wait_event_lock_irq_cmd(
 		conf->wait_barrier,
 		get_unqueued_pending(conf) == extra,
@@ -1287,7 +1284,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * Reading from a write-mostly device must take care not to
 		 * over-take any writes that are 'behind'
 		 */
-		raid1_log(mddev, "wait behind writes");
+		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
@@ -1470,7 +1467,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			bio_wouldblock_error(bio);
 			return;
 		}
-		raid1_log(mddev, "wait rdev %d blocked", blocked_rdev->raid_disk);
+		mddev_add_trace_msg(mddev, "raid1 wait rdev %d blocked",
+				blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
 		wait_barrier(conf, bio->bi_iter.bi_sector, false);
 		goto retry_write;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index ae90cca8335b50..b6c5194c22308d 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -76,9 +76,6 @@ static void reshape_request_write(struct mddev *mddev, struct r10bio *r10_bio);
 static void end_reshape_write(struct bio *bio);
 static void end_reshape(struct r10conf *conf);
 
-#define raid10_log(md, fmt, args...)				\
-	do { if ((md)->queue) blk_add_trace_msg((md)->queue, "raid10 " fmt, ##args); } while (0)
-
 #include "raid1-10.c"
 
 #define NULL_CMD
@@ -1033,7 +1030,7 @@ static bool wait_barrier(struct r10conf *conf, bool nowait)
 			ret = false;
 		} else {
 			conf->nr_waiting++;
-			raid10_log(conf->mddev, "wait barrier");
+			mddev_add_trace_msg(conf->mddev, "raid10 wait barrier");
 			wait_event_barrier(conf, stop_waiting_barrier(conf));
 			conf->nr_waiting--;
 		}
@@ -1152,7 +1149,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 			bio_wouldblock_error(bio);
 			return false;
 		}
-		raid10_log(conf->mddev, "wait reshape");
+		mddev_add_trace_msg(conf->mddev, "raid10 wait reshape");
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
@@ -1354,8 +1351,9 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
 	if (unlikely(blocked_rdev)) {
 		/* Have to wait for this device to get unblocked, then retry */
 		allow_barrier(conf);
-		raid10_log(conf->mddev, "%s wait rdev %d blocked",
-				__func__, blocked_rdev->raid_disk);
+		mddev_add_trace_msg(conf->mddev,
+			"raid10 %s wait rdev %d blocked",
+			__func__, blocked_rdev->raid_disk);
 		md_wait_for_blocked_rdev(blocked_rdev, mddev);
 		wait_barrier(conf, false);
 		goto retry_wait;
@@ -1410,7 +1408,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			bio_wouldblock_error(bio);
 			return;
 		}
-		raid10_log(conf->mddev, "wait reshape metadata");
+		mddev_add_trace_msg(conf->mddev,
+			"raid10 wait reshape metadata");
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index c7da69c6e7c50c..969df5c584653e 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4199,10 +4199,9 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 	set_bit(STRIPE_HANDLE, &sh->state);
 	if ((rmw < rcw || (rmw == rcw && conf->rmw_level == PARITY_PREFER_RMW)) && rmw > 0) {
 		/* prefer read-modify-write, but need to get some data */
-		if (conf->mddev->queue)
-			blk_add_trace_msg(conf->mddev->queue,
-					  "raid5 rmw %llu %d",
-					  (unsigned long long)sh->sector, rmw);
+		mddev_add_trace_msg(conf->mddev, "raid5 rmw %llu %d",
+				sh->sector, rmw);
+
 		for (i = disks; i--; ) {
 			struct r5dev *dev = &sh->dev[i];
 			if (test_bit(R5_InJournal, &dev->flags) &&
@@ -4280,9 +4279,10 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 			}
 		}
 		if (rcw && conf->mddev->queue)
-			blk_add_trace_msg(conf->mddev->queue, "raid5 rcw %llu %d %d %d",
-					  (unsigned long long)sh->sector,
-					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
+			mddev_add_trace_msg(conf->mddev,
+				"raid5 rcw %llu %d %d %d",
+				sh->sector, rcw, qread,
+				test_bit(STRIPE_DELAYED, &sh->state));
 	}
 
 	if (rcw > disks && rmw > disks &&
-- 
2.39.2

