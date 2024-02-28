Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 772ED72935;
	Wed, 28 Feb 2024 22:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161019; cv=none; b=UNwoHDsWcsysqeAcWeTJXaFDtyIdzCzBVnVuM0wJ+28AKl9D2GZYqlc79pCtY5+4VQUP0rImPfyjHWm+WDBREtE/4iPA9CucOqhQspC+nQcqe1vQseq6XB8vB/MWUFGKpk6Y8pg+jwmamRjPEpAy+MRTXGaA+OgNxUBZyP0sVTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161019; c=relaxed/simple;
	bh=tUBiXcOF8C3XXZXLESFVjzDk+EquolH2ZllyiYg8knc=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ru4JocI+1bN9T3VAvetXi0XKQc2Qv76AnGYY+paoVx/Nubf5M0GVeKUJ/Uzw78fzwaMNTyb9vt0Xu7lZHskfQvAJtS7HNSz2mcpIy5JwPhW44vXVqA9wJTJSViShBS9aWY4SSKjdQGjjVZCKFZFODnIE1wX5cGpGLT3mH4qWx3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=a+pbN6lU; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="a+pbN6lU"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3SnZQCAHO0uhrafQS77bL3xaFhHO2hFXUSSgv3ZmbdE=; b=a+pbN6lUQ69WeE//6AkpAVAFCV
	gYV1xsz+yBlKeHvO+FZVyjy2e7KtSnh4HCbG+dPV+SlyizWyPp8Vkop7YifU69KG+NKcavq2tyca4
	lQNNTPDulFA/scpMo7a4b1ei/SlSmGalCiByl4qwD+D+DU/lyLapI4I0Kw7pcc9BoqJNMgZhbKyyh
	WCBIJR9haNYad5rfS4WEY2e/uByD8Wm0wkNA03/MJk1PJ5l3Qk71g7eklSF/VnsvTLHSnPC4EFgwR
	lnyXYBPJJ523pN/u7LmjrPE38D+L5wAZB2443JaoRCeKMjngE4XdP1JVOYP3Lcoa9oOmNLsMoOQCP
	Dz8QOwqA==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrA-0000000BCOX-13YC;
	Wed, 28 Feb 2024 22:56:56 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 06/14] md: add a mddev_is_dm helper
Date: Wed, 28 Feb 2024 14:56:45 -0800
Message-Id: <20240228225653.947152-7-hch@lst.de>
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

Add a helper to check for a DM-mapped MD device instead of using
the obfuscated ->gendisk or ->queue NULL checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/md.c     | 15 +++++++--------
 drivers/md/md.h     | 12 ++++++++++--
 drivers/md/raid0.c  |  2 +-
 drivers/md/raid1.c  | 13 +++++--------
 drivers/md/raid10.c | 10 +++++-----
 drivers/md/raid5.c  | 21 ++++++++++-----------
 6 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 409e57242b27f6..01a219b2559bdb 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2401,7 +2401,7 @@ int md_integrity_register(struct mddev *mddev)
 
 	if (list_empty(&mddev->disks))
 		return 0; /* nothing to do */
-	if (!mddev->gendisk || blk_get_integrity(mddev->gendisk))
+	if (mddev_is_dm(mddev) || blk_get_integrity(mddev->gendisk))
 		return 0; /* shouldn't register, or already is */
 	rdev_for_each(rdev, mddev) {
 		/* skip spares and non-functional disks */
@@ -2454,7 +2454,7 @@ int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	struct blk_integrity *bi_mddev;
 
-	if (!mddev->gendisk)
+	if (mddev_is_dm(mddev))
 		return 0;
 
 	bi_mddev = blk_get_integrity(mddev->gendisk);
@@ -5923,7 +5923,7 @@ int md_run(struct mddev *mddev)
 		invalidate_bdev(rdev->bdev);
 		if (mddev->ro != MD_RDONLY && rdev_read_only(rdev)) {
 			mddev->ro = MD_RDONLY;
-			if (mddev->gendisk)
+			if (!mddev_is_dm(mddev))
 				set_disk_ro(mddev->gendisk, 1);
 		}
 
@@ -6082,7 +6082,7 @@ int md_run(struct mddev *mddev)
 		}
 	}
 
-	if (mddev->queue) {
+	if (!mddev_is_dm(mddev)) {
 		bool nonrot = true;
 
 		rdev_for_each(rdev, mddev) {
@@ -6338,7 +6338,7 @@ static void mddev_detach(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 0);
 	}
 	md_unregister_thread(mddev, &mddev->thread);
-	if (mddev->queue)
+	if (!mddev_is_dm(mddev))
 		blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 }
 
@@ -7304,10 +7304,9 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
 	if (!rv) {
 		if (mddev_is_clustered(mddev))
 			md_cluster_ops->update_size(mddev, old_dev_sectors);
-		else if (mddev->queue) {
+		else if (!mddev_is_dm(mddev))
 			set_capacity_and_notify(mddev->gendisk,
 						mddev->array_sectors);
-		}
 	}
 	return rv;
 }
@@ -9137,7 +9136,7 @@ void md_do_sync(struct md_thread *thread)
 			mddev->delta_disks > 0 &&
 			mddev->pers->finish_reshape &&
 			mddev->pers->size &&
-			mddev->queue) {
+			!mddev_is_dm(mddev)) {
 		mddev_lock_nointr(mddev);
 		md_set_array_sectors(mddev, mddev->pers->size(mddev, 0, 0));
 		mddev_unlock(mddev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 91ee8951fc8dcb..b08e655f8bec41 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -864,16 +864,24 @@ int do_md_run(struct mddev *mddev);
 
 extern const struct block_device_operations md_fops;
 
+/*
+ * MD devices can be used undeneath by DM, in which case ->gendisk is NULL.
+ */
+static inline bool mddev_is_dm(struct mddev *mddev)
+{
+	return !mddev->gendisk;
+}
+
 static inline void mddev_trace_remap(struct mddev *mddev, struct bio *bio,
 		sector_t sector)
 {
-	if (mddev->gendisk)
+	if (!mddev_is_dm(mddev))
 		trace_block_bio_remap(bio, disk_devt(mddev->gendisk), sector);
 }
 
 #define mddev_add_trace_msg(mddev, fmt, args...)			\
 do {									\
-	if ((mddev)->gendisk)						\
+	if (!mddev_is_dm(mddev))					\
 		blk_add_trace_msg((mddev)->queue, fmt, ##args);		\
 } while (0)
 
diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index aff094de974347..9f787ae77ede88 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -399,7 +399,7 @@ static int raid0_run(struct mddev *mddev)
 		mddev->private = conf;
 	}
 	conf = mddev->private;
-	if (mddev->queue) {
+	if (!mddev_is_dm(mddev)) {
 		struct md_rdev *rdev;
 
 		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 3f47fe828b21bb..3b1227f67a6d61 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1782,7 +1782,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			if (mddev->gendisk)
+			if (!mddev_is_dm(mddev))
 				disk_stack_limits(mddev->gendisk, rdev->bdev,
 						  rdev->data_offset << 9);
 
@@ -3109,14 +3109,11 @@ static int raid1_run(struct mddev *mddev)
 	if (IS_ERR(conf))
 		return PTR_ERR(conf);
 
-	if (mddev->queue)
+	if (!mddev_is_dm(mddev)) {
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-
-	rdev_for_each(rdev, mddev) {
-		if (!mddev->gendisk)
-			continue;
-		disk_stack_limits(mddev->gendisk, rdev->bdev,
-				  rdev->data_offset << 9);
+		rdev_for_each(rdev, mddev)
+			disk_stack_limits(mddev->gendisk, rdev->bdev,
+					  rdev->data_offset << 9);
 	}
 
 	mddev->degraded = 0;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index b6c5194c22308d..95fa9e728f95a9 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2124,7 +2124,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		}
 
-		if (mddev->gendisk)
+		if (!mddev_is_dm(mddev))
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -2144,7 +2144,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		set_bit(Replacement, &rdev->flags);
 		rdev->raid_disk = repl_slot;
 		err = 0;
-		if (mddev->gendisk)
+		if (!mddev_is_dm(mddev))
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 		conf->fullsync = 1;
@@ -4040,7 +4040,7 @@ static int raid10_run(struct mddev *mddev)
 		}
 	}
 
-	if (mddev->queue) {
+	if (!mddev_is_dm(conf->mddev)) {
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
@@ -4074,7 +4074,7 @@ static int raid10_run(struct mddev *mddev)
 		if (first || diff < min_offset_diff)
 			min_offset_diff = diff;
 
-		if (mddev->gendisk)
+		if (!mddev_is_dm(mddev))
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -4959,7 +4959,7 @@ static void end_reshape(struct r10conf *conf)
 	conf->reshape_safe = MaxSector;
 	spin_unlock_irq(&conf->device_lock);
 
-	if (conf->mddev->queue)
+	if (!mddev_is_dm(conf->mddev))
 		raid10_set_io_opt(conf);
 	conf->fullsync = 0;
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 969df5c584653e..287fc1540a8d32 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2416,12 +2416,12 @@ static int grow_stripes(struct r5conf *conf, int num)
 	size_t namelen = sizeof(conf->cache_name[0]);
 	int devs = max(conf->raid_disks, conf->previous_raid_disks);
 
-	if (conf->mddev->gendisk)
+	if (mddev_is_dm(conf->mddev))
 		snprintf(conf->cache_name[0], namelen,
-			"raid%d-%s", conf->level, mdname(conf->mddev));
+			"raid%d-%p", conf->level, conf->mddev);
 	else
 		snprintf(conf->cache_name[0], namelen,
-			"raid%d-%p", conf->level, conf->mddev);
+			"raid%d-%s", conf->level, mdname(conf->mddev));
 	snprintf(conf->cache_name[1], namelen, "%.27s-alt", conf->cache_name[0]);
 
 	conf->active_name = 0;
@@ -4278,11 +4278,10 @@ static int handle_stripe_dirtying(struct r5conf *conf,
 					set_bit(STRIPE_DELAYED, &sh->state);
 			}
 		}
-		if (rcw && conf->mddev->queue)
-			mddev_add_trace_msg(conf->mddev,
-				"raid5 rcw %llu %d %d %d",
-				sh->sector, rcw, qread,
-				test_bit(STRIPE_DELAYED, &sh->state));
+		if (rcw && !mddev_is_dm(conf->mddev))
+			blk_add_trace_msg(conf->mddev->queue, "raid5 rcw %llu %d %d %d",
+					  (unsigned long long)sh->sector,
+					  rcw, qread, test_bit(STRIPE_DELAYED, &sh->state));
 	}
 
 	if (rcw > disks && rmw > disks &&
@@ -5693,7 +5692,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 	}
 	release_inactive_stripe_list(conf, cb->temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
-	if (mddev->queue)
+	if (!mddev_is_dm(mddev))
 		trace_block_unplug(mddev->queue, cnt, !from_schedule);
 	kfree(cb);
 }
@@ -7942,7 +7941,7 @@ static int raid5_run(struct mddev *mddev)
 			mdname(mddev));
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
-	if (mddev->queue) {
+	if (!mddev_is_dm(mddev)) {
 		int chunk_size;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
@@ -8546,7 +8545,7 @@ static void end_reshape(struct r5conf *conf)
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 
-		if (conf->mddev->queue)
+		if (!mddev_is_dm(conf->mddev))
 			raid5_set_io_opt(conf);
 	}
 }
-- 
2.39.2

