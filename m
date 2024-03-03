Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D16C5A102;
	Sun,  3 Mar 2024 14:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474529; cv=none; b=ccWzOw+S64Y9QvJ7NH5GG9vTheij5Ab/zexFhDGEZ0SXNnnLX5f68uDn/YW1EErtKmZXlGfEGRB9Qp2T650ccm+eyrnJ18DsFd0P1xe+vnTarlv0ESNe8KEZ8baclyZIOAww8crAgBBwfsE1uru27+1PdMxWKeExi9kGfAAXzg0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474529; c=relaxed/simple;
	bh=8MHP4Dl0v5AwsxO9CidAfFRFJ0Ra+nEY8ae353U5D3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZrE9MBNUgr69ccNxhUO6dkxaYDSgW46Iftt8zK3FT5H4atupkRThBOfguChNcrCGsxQBrhKXtW2AMl8iZ5D/pIgWTbycaMJcVbrbfqpOiIf9PV9MveWwBF2ojqhpiJl34SgAAE7PBMZEm61+WkNdGHFWo+Yx4SeZWA+5lCOszsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dJpsXMVT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dJpsXMVT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=YE5UbB+FLL9gNqYMqc7m5KQfT4NkelJlyQPONKCILoo=; b=dJpsXMVTKp2BWBYhWL/MEVLvxy
	BmRo4SmceD4amSgHoQ20WC1fY3Q/9GUcRqCQIFuoN33rtRi/ENjea/E/acsJs7YS598lyNRGZT9Tm
	k57F6Y6SMwjA62yprQ5E5hLSFYRzvu6af8qJow8GVIJAN0roPWXFuk4Sr9kcC5tlnqK54juaW5SWy
	Yg47xmdBmA7+F7fpJ2C6wUZY5QjjxOUIRzfxyLhx18sDaXm3hc33aezuVrfMyGCM5aXj9/DureVdW
	fwkhrsbXsinDlcrRmMZKDY8Io/EB26KbXXgmq2y2eDgkxs9jSVra2HALSpA8sK2Nww9VCvr2fSqVu
	uYOTLYpA==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPm-000000061kA-2MUB;
	Sun, 03 Mar 2024 14:02:07 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 03/11] md: add a mddev_is_dm helper
Date: Sun,  3 Mar 2024 07:01:42 -0700
Message-Id: <20240303140150.5435-4-hch@lst.de>
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

Add a helper to check for a DM-mapped MD device instead of using
the obfuscated ->gendisk or ->queue NULL checks.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/md.c     | 15 +++++++--------
 drivers/md/md.h     | 12 ++++++++++--
 drivers/md/raid0.c  |  2 +-
 drivers/md/raid1.c  | 13 +++++--------
 drivers/md/raid10.c | 10 +++++-----
 drivers/md/raid5.c  | 21 ++++++++++-----------
 6 files changed, 38 insertions(+), 35 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 6cfa6812697f51..9ce4b5f2324dab 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2419,7 +2419,7 @@ int md_integrity_register(struct mddev *mddev)
 
 	if (list_empty(&mddev->disks))
 		return 0; /* nothing to do */
-	if (!mddev->gendisk || blk_get_integrity(mddev->gendisk))
+	if (mddev_is_dm(mddev) || blk_get_integrity(mddev->gendisk))
 		return 0; /* shouldn't register, or already is */
 	rdev_for_each(rdev, mddev) {
 		/* skip spares and non-functional disks */
@@ -2472,7 +2472,7 @@ int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev)
 {
 	struct blk_integrity *bi_mddev;
 
-	if (!mddev->gendisk)
+	if (mddev_is_dm(mddev))
 		return 0;
 
 	bi_mddev = blk_get_integrity(mddev->gendisk);
@@ -5957,7 +5957,7 @@ int md_run(struct mddev *mddev)
 		invalidate_bdev(rdev->bdev);
 		if (mddev->ro != MD_RDONLY && rdev_read_only(rdev)) {
 			mddev->ro = MD_RDONLY;
-			if (mddev->gendisk)
+			if (!mddev_is_dm(mddev))
 				set_disk_ro(mddev->gendisk, 1);
 		}
 
@@ -6116,7 +6116,7 @@ int md_run(struct mddev *mddev)
 		}
 	}
 
-	if (mddev->queue) {
+	if (!mddev_is_dm(mddev)) {
 		bool nonrot = true;
 
 		rdev_for_each(rdev, mddev) {
@@ -6380,7 +6380,7 @@ static void mddev_detach(struct mddev *mddev)
 		mddev->pers->quiesce(mddev, 0);
 	}
 	md_unregister_thread(mddev, &mddev->thread);
-	if (mddev->queue)
+	if (!mddev_is_dm(mddev))
 		blk_sync_queue(mddev->queue); /* the unplug fn references 'conf'*/
 }
 
@@ -7336,10 +7336,9 @@ static int update_size(struct mddev *mddev, sector_t num_sectors)
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
@@ -9136,7 +9135,7 @@ void md_do_sync(struct md_thread *thread)
 			mddev->delta_disks > 0 &&
 			mddev->pers->finish_reshape &&
 			mddev->pers->size &&
-			mddev->queue) {
+			!mddev_is_dm(mddev)) {
 		mddev_lock_nointr(mddev);
 		md_set_array_sectors(mddev, mddev->pers->size(mddev, 0, 0));
 		mddev_unlock(mddev);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index b7c2ade8260391..786b0eebd1cad6 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -875,16 +875,24 @@ int do_md_run(struct mddev *mddev);
 
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
index 05870a4565fc71..dd1393d0f08461 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1926,7 +1926,7 @@ static int raid1_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 	for (mirror = first; mirror <= last; mirror++) {
 		p = conf->mirrors + mirror;
 		if (!p->rdev) {
-			if (mddev->gendisk)
+			if (!mddev_is_dm(mddev))
 				disk_stack_limits(mddev->gendisk, rdev->bdev,
 						  rdev->data_offset << 9);
 
@@ -3227,14 +3227,11 @@ static int raid1_run(struct mddev *mddev)
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
index 1447cb1e441455..4021cf06b3a616 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2106,7 +2106,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		}
 
-		if (mddev->gendisk)
+		if (!mddev_is_dm(mddev))
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -2126,7 +2126,7 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		set_bit(Replacement, &rdev->flags);
 		rdev->raid_disk = repl_slot;
 		err = 0;
-		if (mddev->gendisk)
+		if (!mddev_is_dm(mddev))
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 		conf->fullsync = 1;
@@ -4014,7 +4014,7 @@ static int raid10_run(struct mddev *mddev)
 		}
 	}
 
-	if (mddev->queue) {
+	if (!mddev_is_dm(conf->mddev)) {
 		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
 		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
 		raid10_set_io_opt(conf);
@@ -4048,7 +4048,7 @@ static int raid10_run(struct mddev *mddev)
 		if (first || diff < min_offset_diff)
 			min_offset_diff = diff;
 
-		if (mddev->gendisk)
+		if (!mddev_is_dm(mddev))
 			disk_stack_limits(mddev->gendisk, rdev->bdev,
 					  rdev->data_offset << 9);
 
@@ -4933,7 +4933,7 @@ static void end_reshape(struct r10conf *conf)
 	conf->reshape_safe = MaxSector;
 	spin_unlock_irq(&conf->device_lock);
 
-	if (conf->mddev->queue)
+	if (!mddev_is_dm(conf->mddev))
 		raid10_set_io_opt(conf);
 	conf->fullsync = 0;
 }
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 2000fc5d01ba54..a6350eb711fb36 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2414,12 +2414,12 @@ static int grow_stripes(struct r5conf *conf, int num)
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
@@ -4272,11 +4272,10 @@ static int handle_stripe_dirtying(struct r5conf *conf,
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
@@ -5684,7 +5683,7 @@ static void raid5_unplug(struct blk_plug_cb *blk_cb, bool from_schedule)
 	}
 	release_inactive_stripe_list(conf, cb->temp_inactive_list,
 				     NR_STRIPE_HASH_LOCKS);
-	if (mddev->queue)
+	if (!mddev_is_dm(mddev))
 		trace_block_unplug(mddev->queue, cnt, !from_schedule);
 	kfree(cb);
 }
@@ -7935,7 +7934,7 @@ static int raid5_run(struct mddev *mddev)
 			mdname(mddev));
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
-	if (mddev->queue) {
+	if (!mddev_is_dm(mddev)) {
 		int chunk_size;
 		/* read-ahead size must cover two whole stripes, which
 		 * is 2 * (datadisks) * chunksize where 'n' is the
@@ -8539,7 +8538,7 @@ static void end_reshape(struct r5conf *conf)
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 
-		if (conf->mddev->queue)
+		if (!mddev_is_dm(conf->mddev))
 			raid5_set_io_opt(conf);
 	}
 }
-- 
2.39.2

