Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9FDC70055;
	Wed, 28 Feb 2024 22:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161027; cv=none; b=uieJpi0FVyOQkSkItl7KVK8KlmTeu505o2C1C1BV3gaxFEajhrcnR2mbxz79jmCqaRJxEt6LmQ5q3T2dgSu1NlElBMFOQL74gkaljDuDmol6A0k7+GapbFEVgTFJMnHduTLy0GjhQ7PvCJRLjhcTmZi6BsQr48DJ9w4siAoXFZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161027; c=relaxed/simple;
	bh=t0hwZwpfttp69/uGay6s716nZ8N7x7chnpzvYiDxo5s=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=agEWPZXvyHl4B4wYx81/T4zu4pCOpXA0CB2ImGvN0hD5lDuX68QXlA3NqNtv2FRf9Ga0QvFJvW7Rw9nXI0crCfOabIAGdR35zrhe2/dmHHduwbE36h9RCqFzVtpL2bEtEUCf/O/ejCzV8MMV687P1msE7rsCMNkW/EAIBRHm6kA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=JRRv1kkI; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="JRRv1kkI"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=J8BtlSqCftL8iclcmwg13p3hmHP0z6D21Rkm/rVP9ZM=; b=JRRv1kkI3KbMrspccO64WdGn5V
	V4oO4xue2FnQecEETp7QQPplb/ntkineJ7d3/OfewBAXYjHpINw4z0ufWJSMmBJ3raBhJNWRsczpT
	6g9FGzWo/bj8P58vIjutCKD110LuUYq6kCPHBga4Y0PsMbQe6aKDNgYNaI0L3fQecvvI0lz+xe14Q
	zTpOhzCeuaUYHY0fZStrgxvaiRqwNTb84XjbLzMZhbQCtmXk27Xg4r40D3zmEXM1jImJAP68dhUpV
	174gNESRxCvBHdhwY3alaJIAr4NPH9eaMwmmsQBlrIu2lufSlItkn+98Eb8PV0Yu/BU49iV8JDLu/
	GKkqUzhA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrI-0000000BCPs-2JP9;
	Wed, 28 Feb 2024 22:57:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 13/14] md: remove mddev->queue
Date: Wed, 28 Feb 2024 14:56:52 -0800
Message-Id: <20240228225653.947152-14-hch@lst.de>
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

Just use the request_queue from the gendisk pointer in the relatively
few places that sill need it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
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
index eab1b36c1d02ef..1cb4a33148aac9 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5716,10 +5716,10 @@ int mddev_stack_new_rdev(struct mddev *mddev, struct md_rdev *rdev)
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
 
@@ -5823,8 +5823,7 @@ struct mddev *md_alloc(dev_t dev, char *name)
 	disk->fops = &md_fops;
 	disk->private_data = mddev;
 
-	mddev->queue = disk->queue;
-	blk_queue_write_cache(mddev->queue, true, true);
+	blk_queue_write_cache(disk->queue, true, true);
 	disk->events |= DISK_EVENT_MEDIA_CHANGE;
 	mddev->gendisk = disk;
 	error = add_disk(disk);
@@ -6126,6 +6125,7 @@ int md_run(struct mddev *mddev)
 	}
 
 	if (!mddev_is_dm(mddev)) {
+		struct request_queue *q = mddev->gendisk->queue;
 		bool nonrot = true;
 
 		rdev_for_each(rdev, mddev) {
@@ -6137,14 +6137,14 @@ int md_run(struct mddev *mddev)
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
@@ -6381,8 +6381,10 @@ static void mddev_detach(struct mddev *mddev)
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
@@ -7110,7 +7112,7 @@ static int hot_add_disk(struct mddev *mddev, dev_t dev)
 	if (!bdev_nowait(rdev->bdev)) {
 		pr_info("%s: Disabling nowait because %pg does not support nowait\n",
 			mdname(mddev), rdev->bdev);
-		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->queue);
+		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, mddev->gendisk->queue);
 	}
 	/*
 	 * Kick recovery, maybe this spare has to be added to the
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5db58d076256d3..dc7d3dc1569934 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -469,7 +469,6 @@ struct mddev {
 	struct timer_list		safemode_timer;
 	struct percpu_ref		writes_pending;
 	int				sync_checkers;	/* # of threads checking writes_pending */
-	struct request_queue		*queue;	/* for plugging ... */
 
 	struct bitmap			*bitmap; /* the bitmap for the device */
 	struct {
@@ -822,7 +821,7 @@ static inline void mddev_check_write_zeroes(struct mddev *mddev, struct bio *bio
 {
 	if (bio_op(bio) == REQ_OP_WRITE_ZEROES &&
 	    !bio->bi_bdev->bd_disk->queue->limits.max_write_zeroes_sectors)
-		mddev->queue->limits.max_write_zeroes_sectors = 0;
+		mddev->gendisk->queue->limits.max_write_zeroes_sectors = 0;
 }
 
 static inline int mddev_suspend_and_lock(struct mddev *mddev)
@@ -885,7 +884,7 @@ static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
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
index 75329ab2dbd8de..445e3d3ff9ff7d 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3083,7 +3083,7 @@ static int raid1_set_limits(struct mddev *mddev)
 	blk_set_stacking_limits(&lim);
 	lim.max_write_zeroes_sectors = 0;
 	mddev_stack_rdev_limits(mddev, &lim);
-	return queue_limits_set(mddev->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
 static void raid1_free(struct mddev *mddev, void *priv);
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 692a3bd94100e2..fd960a5b29fe49 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4012,7 +4012,7 @@ static int raid10_set_queue_limits(struct mddev *mddev)
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
index 8d2e3f9419a7f3..651fc4d603dc59 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -4279,9 +4279,10 @@ static int handle_stripe_dirtying(struct r5conf *conf,
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
@@ -5693,7 +5694,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 	release_inactive_stripe_list(conf, cb->temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
 	if (!mddev_is_dm(mddev))
-		trace_block_unplug(mddev->queue, cnt, !from_schedule);
+		trace_block_unplug(mddev->gendisk->queue, cnt, !from_schedule);
 	kfree(cb);
 }
 
@@ -7073,7 +7074,7 @@ raid5_store_skip_copy(struct mddev *mddev, const char *page, size_t len)
 	if (!conf)
 		err = -ENODEV;
 	else if (new != conf->skip_copy) {
-		struct request_queue *q = mddev->queue;
+		struct request_queue *q = mddev->gendisk->queue;
 
 		conf->skip_copy = new;
 		if (new)
@@ -7731,7 +7732,7 @@ static int raid5_set_limits(struct mddev *mddev)
 	/* No restrictions on the number of segments in the request */
 	lim.max_segments = USHRT_MAX;
 
-	return queue_limits_set(mddev->queue, &lim);
+	return queue_limits_set(mddev->gendisk->queue, &lim);
 }
 
 static int raid5_run(struct mddev *mddev)
-- 
2.39.2

