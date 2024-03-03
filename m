Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077AC5A0F7;
	Sun,  3 Mar 2024 14:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474526; cv=none; b=C0RW3sfBozH2Cq3bdwrTiYxNGuXmCchwoRZyhLYl1qGS7DJVRrTIt7drJqcpGm6MIfWEDXAMPgio7L8u8O21j6X4nRQG7FC5F3Hvdas0N/RErZn+EI2VPnrHal1YXeqDyrFHzgo97a9Lak5pVxH2PtG4L/sW9Feye6YgrQcQMso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474526; c=relaxed/simple;
	bh=f79t/hc2+41/iXLSQ/Z5PV1waVcJx1+NImQJ9P8Le8c=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=TIEyiEKWiszs9wPBQjJrYr7cesMx+Y76mIYsYhDVJoG4MhrhEratjHTAu/3Tq227OplJeNf78riFkSgaUOYr8W/JqoPp/gqxdmKnSahjMZ87L4U0uGLBbySSEdThhlfPlaEQ5XeHH7btUY36vURa1AVgdmInV6IiQwFg7ZBRR1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=n1ZUyong; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="n1ZUyong"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=cvhN1/oRkTaRS0ZwZpQf56Xr08g6BU3kBimgDdDPet0=; b=n1ZUyong16OoWwp67GxBuEGfDj
	SkZR5dz5FoRWs3qTPgYRQoITZ3bvsmmj1pu4FC/I8s9jkIp+hVmx66qF/GUJE0rrTvTfqVhP3usks
	Z/7Rl8A+zneM2blopnypQHOu37TPYIFF4zNiXCsz/osxBWbxNkm+phCoSj0I+JuJv17N4T7x4zGW5
	cxHvD9RLsoVzxqbb86+rXAsP5FqYu6Svt7og1rc9R/xYy8XBqENXFvvpizk/k8o6itn0iGT44aFbE
	jEXkaYUWg8rIHgeNo0usANc4kwk/TUzUcQdq0RFw+Zx6yFvGzt9k4q3r9Ml4XIezBgBILw9kKcBbN
	G+Q/OyIg==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPh-000000061j4-42Tr;
	Sun, 03 Mar 2024 14:02:02 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 02/11] md: add a mddev_add_trace_msg helper
Date: Sun,  3 Mar 2024 07:01:41 -0700
Message-Id: <20240303140150.5435-3-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240303140150.5435-1-hch@lst.de>
References: <20240303140150.5435-1-hch@lst.de>
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
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/md-bitmap.c |  9 +++------
 drivers/md/md.c        |  3 +--
 drivers/md/md.h        |  6 ++++++
 drivers/md/raid1.c     | 10 ++++------
 drivers/md/raid10.c    | 15 +++++++--------
 drivers/md/raid5.c     | 14 +++++++-------
 6 files changed, 28 insertions(+), 29 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index a4976ceae8688a..059afc24c08bec 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1046,9 +1046,8 @@ void md_bitmap_unplug(struct bitmap *bitmap)
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
@@ -1319,9 +1318,7 @@ void md_bitmap_daemon_work(struct mddev *mddev)
 	}
 	bitmap->allclean = 1;
 
-	if (bitmap->mddev->queue)
-		blk_add_trace_msg(bitmap->mddev->queue,
-				  "md bitmap_daemon_work");
+	mddev_add_trace_msg(bitmap->mddev, "md bitmap_daemon_work");
 
 	/* Any file-page which is PENDING now needs to be written.
 	 * So set NEEDWRITE now, then after we make any last-minute changes
diff --git a/drivers/md/md.c b/drivers/md/md.c
index bbf84fdb879cd0..6cfa6812697f51 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2865,8 +2865,7 @@ void md_update_sb(struct mddev *mddev, int force_change)
 	pr_debug("md: updating %s RAID superblock on device (in sync %d)\n",
 		 mdname(mddev), mddev->in_sync);
 
-	if (mddev->queue)
-		blk_add_trace_msg(mddev->queue, "md md_update_sb");
+	mddev_add_trace_msg(mddev, "md md_update_sb");
 rewrite:
 	md_bitmap_update_sb(mddev->bitmap);
 	rdev_for_each(rdev, mddev) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 468bccbf206b71..b7c2ade8260391 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -882,4 +882,10 @@ static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
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
index 421154430f241c..05870a4565fc71 100644
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
 
@@ -1196,7 +1193,7 @@ static void freeze_array(struct r1conf *conf, int extra)
 	 */
 	spin_lock_irq(&conf->resync_lock);
 	conf->array_frozen = 1;
-	raid1_log(conf->mddev, "wait freeze");
+	mddev_add_trace_msg(conf->mddev, "raid1 wait freeze");
 	wait_event_lock_irq_cmd(
 		conf->wait_barrier,
 		get_unqueued_pending(conf) == extra,
@@ -1385,7 +1382,7 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 		 * Reading from a write-mostly device must take care not to
 		 * over-take any writes that are 'behind'
 		 */
-		raid1_log(mddev, "wait behind writes");
+		mddev_add_trace_msg(mddev, "raid1 wait behind writes");
 		wait_event(bitmap->behind_wait,
 			   atomic_read(&bitmap->behind_writes) == 0);
 	}
@@ -1568,7 +1565,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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
index 9335a1620e6c10..1447cb1e441455 100644
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
@@ -1019,7 +1016,7 @@ static bool wait_barrier(struct r10conf *conf, bool nowait)
 			ret = false;
 		} else {
 			conf->nr_waiting++;
-			raid10_log(conf->mddev, "wait barrier");
+			mddev_add_trace_msg(conf->mddev, "raid10 wait barrier");
 			wait_event_barrier(conf, stop_waiting_barrier(conf));
 			conf->nr_waiting--;
 		}
@@ -1138,7 +1135,7 @@ static bool regular_request_wait(struct mddev *mddev, struct r10conf *conf,
 			bio_wouldblock_error(bio);
 			return false;
 		}
-		raid10_log(conf->mddev, "wait reshape");
+		mddev_add_trace_msg(conf->mddev, "raid10 wait reshape");
 		wait_event(conf->wait_barrier,
 			   conf->reshape_progress <= bio->bi_iter.bi_sector ||
 			   conf->reshape_progress >= bio->bi_iter.bi_sector +
@@ -1336,8 +1333,9 @@ static void wait_blocked_dev(struct mddev *mddev, struct r10bio *r10_bio)
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
@@ -1392,7 +1390,8 @@ static void raid10_write_request(struct mddev *mddev, struct bio *bio,
 			bio_wouldblock_error(bio);
 			return;
 		}
-		raid10_log(conf->mddev, "wait reshape metadata");
+		mddev_add_trace_msg(conf->mddev,
+			"raid10 wait reshape metadata");
 		wait_event(mddev->sb_wait,
 			   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index db8fe9e92965be..2000fc5d01ba54 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4193,10 +4193,9 @@ static int handle_stripe_dirtying(struct r5conf *conf,
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
@@ -4274,9 +4273,10 @@ static int handle_stripe_dirtying(struct r5conf *conf,
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

