Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F9F5A0FC;
	Sun,  3 Mar 2024 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474555; cv=none; b=AiLNk+62lWQnm+VgvK3VM1oN71JDmHgGzvKeIRWlAybmVCObfEywUY3JK0vZDwqhO6mD48rym6nZgtdWOkI74Rjp9QebOAMiRjggRuDJ9qD19R30AxnItlQFogGE6xvUp9/LIdpQCu665ydr+6hTPtbD1B0FlV7Hnl74nulnOsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474555; c=relaxed/simple;
	bh=PYGqzMOyZxRPZx0/G18y700/zqlLHAbe9PQB2oMamu8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dWDrUecpMYj+xgQ3yuaP7soNNIa1UHNtIlRhune6wnpp28jvOUOzVUPt/GVzL/i8i2OuqhMtUly351VEzbBrxN29yWe8TqpQ9Vd78LTL7zDAcS20CPrR495jx4m9IS4y4wt7G13QR5Sxrv3xBLnwjrivJZcUNRvsmoI/D27WFGQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=VoylhsnL; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="VoylhsnL"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=8soMuUaLp0MawEwWPgYziwbw8cJRlhM5EXSBa8SKG48=; b=VoylhsnLrsGdkZXdjND/1GeHv0
	4mINPU961eLALy8tiDanZJsVCmRBmXYvSRrv0XQ4pbV4HnQiU2FAuO1kXzNXeD6EOLKg4Y6fX/lKS
	2gt7FQXbSCh2K0Kkjmh6ohomXmy4WFiuSb15w7aIRRr41XoS6onBymr8/5lFZc3z5AyWXqB/xNsVK
	oC/lLUz8zMb0oekOjlhxQf+zifOcKwEiuHEG3d02LdWUFx1RsjbmoxJOjjeThXx0ao081pXNXqRVc
	YyUfXByWZAerhtzo3sCksLVuSQPH49HY4W0Vi5LsP5PMuzdUf6wb/3i07ZQ+KgeADeMUAn3CtMXqy
	ptaPBBdQ==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmQC-000000061yC-221m;
	Sun, 03 Mar 2024 14:02:33 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 10/11] md: remove mddev->queue
Date: Sun,  3 Mar 2024 07:01:49 -0700
Message-Id: <20240303140150.5435-11-hch@lst.de>
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

Just use the request_queue from the gendisk pointer in the relatively
few places that sill need it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c        | 22 ++++++++++++----------
 drivers/md/md.h        |  5 ++---
 drivers/md/raid0.c     |  2 +-
 drivers/md/raid1.c     |  2 +-
 drivers/md/raid10.c    |  2 +-
 drivers/md/raid5-ppl.c |  3 ++-
 drivers/md/raid5.c     | 13 +++++++------
 7 files changed, 26 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index f564ad051a427d..8d963b887eecc7 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5750,10 +5750,10 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
 	if (mddev_is_dm(mddev))
 		return 0;
 
-	lim = queue_limits_start_update(mddev->queue);
+	lim = queue_limits_start_update(mddev->gendisk->queue);
 	queue_limits_stack_bdev(&lim, rdev->bdev, rdev->data_offset,
 				mddev->gendisk->disk_name);
-	return queue_limits_commit_update(mddev->queue, &lim);
+	return queue_limits_commit_update(mddev->gendisk->queue, &lim);
 }
 EXPORT_SYMBOL_GPL(mddev_stack_new_rdev);
 
@@ -5857,8 +5857,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 
-	mddev->queue = disk->queue;
-	blk_queue_write_cache(mddev->queue, true, true);
+	blk_queue_write_cache(disk->queue, true, true);
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
@@ -6160,6 +6159,7 @@ int md_run(struct mddev *mddev)
 	}
 
 	if (!mddev_is_dm(mddev)) {
+		struct request_queue *q = mddev->gendisk->queue;
 		bool nonrot = true;
 
 		rdev_for_each(rdev, mddev) {
@@ -6171,14 +6171,14 @@ int md_run(struct mddev *mddev)
 		if (mddev->degraded)
 			nonrot = false;
 		if (nonrot)
-			blk_queue_flag_set(QUEUE_FLAG_NONROT, mddev->queue);
+			blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 		else
-			blk_queue_flag_clear(QUEUE_FLAG_NONROT, mddev->queue);
-		blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue);
+			blk_queue_flag_clear(QUEUE_FLAG_NONROT, q);
+		blk_queue_flag_set(QUEUE_FLAG_IO_STAT, q);
 
 		/* Set the NOWAIT flags if all underlying devices support it */
 		if (nowait)
-			blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
+			blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
 	}
 	if (pers->sync_request) {
 		if (mddev->kobj.sd &&
@@ -6423,8 +6423,10 @@ static void mddev_detach(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 0);
 	}
 	md_unregister_thread(mddev, &mddev->thread);
+
+	/* the unplug fn references 'conf' */
 	if (!mddev_is_dm(mddev))
-		blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
+		blk_sync_queue(mddev->gendisk->queue);
 }
 
 static void __md_stop(struct mddev *mddev)
@@ -7142,7 +7144,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	if (!bdev_nowait(rdev->bdev)) {
 		pr_info("%s: Disabling nowait because %pg does not support nowait\n",
 			mdname(mddev), rdev->bdev);
-		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
+		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->gendisk->queue);
 	}
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 003db35b4b5926..b2299924f0766a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -480,7 +480,6 @@ struct mddev {
 	struct timer_list		safemode_timer;
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
-	struct request_queue		*queue;	/* for plugging ... */
 
 	struct bitmap			*bitmap; /* the bitmap for the device */
 	struct {
@@ -833,7 +832,7 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 {
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 	    !bio->bi_bdev->bd_disk->queue->limits.max_write_zeroes_sectors)
-		mddev->queue->limits.max_write_zeroes_sectors = 0;
+		mddev->gendisk->queue->limits.max_write_zeroes_sectors = 0;
 }
 
 static inline int mddev_suspend_and_lock(struct mddev *mddev)
@@ -896,7 +895,7 @@ static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 #define mddev_add_trace_msg(mddev, fmt, args...)			\
 do {									\
 	if (!mddev_is_dm(mddev))					\
-		blk_add_trace_msg((mddev)->queue, fmt, ##args);		\
+		blk_add_trace_msg((mddev)->gendisk->queue, fmt, ##args); \
 } while (0)
 
 #endif /* _MD_MD_H */
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index f65aa6ecec0482..c5d4aeb68404c9 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -389,7 +389,7 @@ static int raid0_set_limits(struct mddev *mddev)
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * mddev->raid_disks;
 	mddev_stack_rdev_limits(mddev, &lim);
-	return queue_limits_set(mddev->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
 static int raid0_run(struct mddev *mddev)
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index c3496837837720..be8ac24f50b6ad 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3201,7 +3201,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	blk_set_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	mddev_stack_rdev_limits(mddev, &lim);
-	return queue_limits_set(mddev->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
 static void raid1_free(struct mddev *mddev, void *priv);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e96fdf47319fd0..b0fd3005f5c18f 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3986,7 +3986,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
 	lim.io_min = mddev->chunk_sectors << 9;
 	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
 	mddev_stack_rdev_limits(mddev, &lim);
-	return queue_limits_set(mddev->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
 static int raid10_run(struct mddev *mddev)
diff --git a/drivers/md/raid5-ppl.c b/drivers/md/raid5-ppl.c
index da4ba736c4f0c9..a70cbec12ed017 100644
--- a/drivers/md/raid5-ppl.c
+++ b/drivers/md/raid5-ppl.c
@@ -1393,7 +1393,8 @@ int ppl_init_log(struct r5conf *conf)
 		ppl_conf->signature = ~crc32c_le(~0, mddev->uuid, sizeof(mddev->uuid));
 		ppl_conf->block_size = 512;
 	} else {
-		ppl_conf->block_size = queue_logical_block_size(mddev->queue);
+		ppl_conf->block_size =
+			queue_logical_block_size(mddev->gendisk->queue);
 	}
 
 	for (i = 0; i < ppl_conf->count; i++) {
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 0c10fdc0dfdcf1..b7515638fdcf80 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4273,9 +4273,10 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 			}
 		}
 		if (rcw && !mddev_is_dm(conf->mddev))
-			blk_add_trace_msg(conf->mddev->queue, "raid5 rcw %llu %d %d %d",
-					  (unsigned long long)sh->sector,
-					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
+			blk_add_trace_msg(conf->mddev->gendisk->queue,
+				"raid5 rcw %llu %d %d %d",
+				(unsigned long long)sh->sector, rcw, qread,
+				test_bit(STRIPE_DELAYED, &sh->state));
 	}
 
 	if (rcw > disks && rmw > disks &&
@@ -5684,7 +5685,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 	release_inactive_stripe_list(conf, cb->temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 	if (!mddev_is_dm(mddev))
-		trace_block_unplug(mddev->queue, cnt, !from_schedule);
+		trace_block_unplug(mddev->gendisk->queue, cnt, !from_schedule);
 	kfree(cb);
 }
 
@@ -7064,7 +7065,7 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 	if (!conf)
 		err = -ENODEV;
 	else if (new != conf->skip_copy) {
-		struct request_queue *q = mddev->queue;
+		struct request_queue *q = mddev->gendisk->queue;
 
 		conf->skip_copy = new;
 		if (new)
@@ -7724,7 +7725,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
 
-	return queue_limits_set(mddev->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
 static int raid5_run(struct mddev *mddev)
-- 
2.39.2

