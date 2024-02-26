Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8D475812F;
	Mon, 26 Feb 2024 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943461; cv=none; b=TTRvGws5j5qMBKU6FFL620q7cXBBrQf++bziU+BGnEA3A/d949BJbfIwXAyoxiMnHDOkn3829PDHfZyyB9fxuEt7NSnfD18cNcPsrzxH7BNQYdvpx24jRgAJp6spgtk/LpapzZ1Rq5UpREuhpOhCdPjie2E/ZCtM32Nd2n7KJho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943461; c=relaxed/simple;
	bh=mB06Z2uA4DAsqce0csx+7RI8JFCGUu6qC8AcgHHHB8A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Wzx0DnoQaSnkp130OcueSmooVqKmz1I4+HuaF+RztvcDsfQnfnRwXVLX6YPNsukJY3+p1uev6gcMKR5O6YzHnMKKjCbkAOJ7qBavDvDQalQkHE132A6gzntBZtcS9g++p/QayT1Z3niDi29Hcu6wk8n8q8C8AKPhOrpj+E7y8Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UTW8N0GR; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UTW8N0GR"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=9RW0iy9EfWCoucmumjZAUDfk0pG1Ea5omDHUf2NvGls=; b=UTW8N0GRE7d/41D9krPkY70yTt
	X3vgXYoSl8fNWinul+O7DP4M/gz+SR1awZsPhpsg76gcKH7+i94ArAYRVI2+SZK/vCZ9A58y32La3
	Hku3267vFi7NdDPGH7rZNWNzLqM1e8eQGJack16TLVpHdXAWXb1Z0IIXiAkB+wadURKurh6xm64i+
	9XVCbBQ2U7Kw1t5axkTXjOam5y72GmDraS90mB4PKt45oOniguVolgIBjUv157A4PUK/TFLz/DXIa
	ob9mcDs3avRjGQx1yWkw3FLOJRX+dlNacUgmIs2VV6M29N+q5XtfSXy9VAKeFkMMjYLzYcDyG8pjU
	iTnuO9kw==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYG8-000000004qz-3ddE;
	Mon, 26 Feb 2024 10:30:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>,
	Philipp Reisner <philipp.reisner@linbit.com>,
	Lars Ellenberg <lars.ellenberg@linbit.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>
Cc: drbd-dev@lists.linbit.com,
	dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/16] md/raid5: use the atomic queue limit update APIs
Date: Mon, 26 Feb 2024 11:29:56 +0100
Message-Id: <20240226103004.281412-9-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240226103004.281412-1-hch@lst.de>
References: <20240226103004.281412-1-hch@lst.de>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

Build the queue limits outside the queue and apply them using
queue_limits_set.  Also remove the bogus ->gendisk and ->queue NULL
checks in the are while touching it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid5.c | 123 +++++++++++++++++++++------------------------
 1 file changed, 56 insertions(+), 67 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 14f2cf75abbd72..3dd7c05d3ba2ab 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7682,12 +7682,6 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
 	return 0;
 }
 
-static void raid5_set_io_opt(struct r5conf *conf)
-{
-	blk_queue_io_opt(conf->mddev->queue, (conf->chunk_sectors << 9) *
-			 (conf->raid_disks - conf->max_degraded));
-}
-
 static int raid5_run(struct mddev *mddev)
 {
 	struct r5conf *conf;
@@ -7695,9 +7689,12 @@ static int raid5_run(struct mddev *mddev)
 	struct md_rdev *rdev;
 	struct md_rdev *journal_dev = NULL;
 	sector_t reshape_offset = 0;
+	struct queue_limits lim;
 	int i;
 	long long min_offset_diff = 0;
 	int first = 1;
+	int data_disks, stripe;
+	int ret = -EIO;
 
 	if (mddev->recovery_cp != MaxSector)
 		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
@@ -7950,67 +7947,59 @@ static int raid5_run(struct mddev *mddev)
 			mdname(mddev));
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
-	if (mddev->queue) {
-		int chunk_size;
-		/* read-ahead size must cover two whole stripes, which
-		 * is 2 * (datadisks) * chunksize where 'n' is the
-		 * number of raid devices
-		 */
-		int data_disks = conf->previous_raid_disks - conf->max_degraded;
-		int stripe = data_disks *
-			((mddev->chunk_sectors << 9) / PAGE_SIZE);
-
-		chunk_size = mddev->chunk_sectors << 9;
-		blk_queue_io_min(mddev->queue, chunk_size);
-		raid5_set_io_opt(conf);
-		mddev->queue->limits.raid_partial_stripes_expensive = 1;
-		/*
-		 * We can only discard a whole stripe. It doesn't make sense to
-		 * discard data disk but write parity disk
-		 */
-		stripe = stripe * PAGE_SIZE;
-		stripe = roundup_pow_of_two(stripe);
-		mddev->queue->limits.discard_granularity = stripe;
-
-		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-
-		rdev_for_each(rdev, mddev) {
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->new_data_offset << 9);
-		}
+	/*
+	 * The read-ahead size must cover two whole stripes, which is
+	 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices.
+	 */
+	data_disks = conf->previous_raid_disks - conf->max_degraded;
+	/*
+	 * We can only discard a whole stripe. It doesn't make sense to
+	 * discard data disk but write parity disk
+	 */
+	stripe = roundup_pow_of_two(data_disks * (mddev->chunk_sectors << 9));
+
+	blk_set_stacking_limits(&lim);
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * (conf->raid_disks - conf->max_degraded);
+	lim.raid_partial_stripes_expensive = 1;
+	lim.discard_granularity = stripe;
+	lim.max_write_zeroes_sectors = 0;
+	mddev_stack_rdev_limits(mddev, &lim);
+	rdev_for_each(rdev, mddev) {
+		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
+	                         mddev->gendisk->disk_name);
+	}
 
-		/*
-		 * zeroing is required, otherwise data
-		 * could be lost. Consider a scenario: discard a stripe
-		 * (the stripe could be inconsistent if
-		 * discard_zeroes_data is 0); write one disk of the
-		 * stripe (the stripe could be inconsistent again
-		 * depending on which disks are used to calculate
-		 * parity); the disk is broken; The stripe data of this
-		 * disk is lost.
-		 *
-		 * We only allow DISCARD if the sysadmin has confirmed that
-		 * only safe devices are in use by setting a module parameter.
-		 * A better idea might be to turn DISCARD into WRITE_ZEROES
-		 * requests, as that is required to be safe.
-		 */
-		if (!devices_handle_discard_safely ||
-		    mddev->queue->limits.max_discard_sectors < (stripe >> 9) ||
-		    mddev->queue->limits.discard_granularity < stripe)
-			blk_queue_max_discard_sectors(mddev->queue, 0);
+	/*
+	 * Zeroing is required for discard, otherwise data could be lost.
+	 *
+	 * Consider a scenario: discard a stripe (the stripe could be
+	 * inconsistent if discard_zeroes_data is 0); write one disk of the
+	 * stripe (the stripe could be inconsistent again depending on which
+	 * disks are used to calculate parity); the disk is broken; The stripe
+	 * data of this disk is lost.
+	 *
+	 * We only allow DISCARD if the sysadmin has confirmed that only safe
+	 * devices are in use by setting a module parameter.  A better idea
+	 * might be to turn DISCARD into WRITE_ZEROES requests, as that is
+	 * required to be safe.
+	 */
+	if (!devices_handle_discard_safely ||
+	    lim.max_discard_sectors < (stripe >> 9) ||
+	    lim.discard_granularity < stripe)
+		lim.max_hw_discard_sectors = 0;
 
-		/*
-		 * Requests require having a bitmap for each stripe.
-		 * Limit the max sectors based on this.
-		 */
-		blk_queue_max_hw_sectors(mddev->queue,
-			RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf));
+	/*
+	 * Requests require having a bitmap for each stripe.
+	 * Limit the max sectors based on this.
+	 */
+	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
 
-		/* No restrictions on the number of segments in the request */
-		blk_queue_max_segments(mddev->queue, USHRT_MAX);
-	}
+	/* No restrictions on the number of segments in the request */
+	lim.max_segments = USHRT_MAX;
+	ret = queue_limits_set(mddev->queue, &lim);
+	if (ret)
+		goto abort;
 
 	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
 		goto abort;
@@ -8022,7 +8011,7 @@ static int raid5_run(struct mddev *mddev)
 	free_conf(conf);
 	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
-	return -EIO;
+	return ret;
 }
 
 static void raid5_free(struct mddev *mddev, void *priv)
@@ -8554,8 +8543,8 @@ static void end_reshape(struct r5conf *conf)
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 
-		if (conf->mddev->queue)
-			raid5_set_io_opt(conf);
+		mddev_update_io_opt(conf->mddev,
+			conf->raid_disks - conf->max_degraded);
 	}
 }
 
-- 
2.39.2

