Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED2D45A7A0;
	Sun,  3 Mar 2024 14:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474544; cv=none; b=noX/PkWAUosFeFDcQAcd3J/ZVhUlFuFnLn2w19XTRTudtazXjQ9LVg63pOg7MVL5l92F4aJ2YwPwYKtUzMBp9FYfAY9CirRmRZxLzL8zvSoRB6T3iMDCASM6KugvuJKAT/gCDitb+u4B50dN54F0QmL7PG4khZsoUzDydMDwMLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474544; c=relaxed/simple;
	bh=A9IMjYVSdvW9jBasTZVfOoJ/6Dsd8niPdUDp6DdAfcw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=sINK2QNCLHbyy/oafqtq+mPG+swiusICZqsu4uaicNTrnDbDhQ1ebDX9pFJoD3PRYJg4U64RdbaHGmNYwG4XAx1nnzTaXNi8fIBEeOeeMLlA9GrZs2Fkw4L8+kIGs47eziAReSuBh88kVQDuRvu2Nz8y5NOmVLvC68xu1/P8KDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=NKNiNoEq; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="NKNiNoEq"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=ZgQHbFU7C/QRg6uw4BrO/e1HS93i/3UQ/wGQ2/QcTGM=; b=NKNiNoEqsU+VnDcwUmTZzjglnj
	WjLX8c/m0XHR4Yl3vBPYQmOV3UZTVTbWmEfIcNc1L1u/LoUURp1w8Gq7Z0SYcbzJwJWJRIME/JnxF
	+/1ptrs+greV19tKouF6Acp943aTaKS8r+I/Vke/8Co1Pqdnjwqi8oTjtnM4AojNXlha1oQqdv73y
	HJhCKD/fZ1wPVyq0r/z8ZBHJPlmi9TunTFFEV4rJuUw+PQq8Vl5Ylxj39VD9nHGyuv3CbXtzY/yoM
	OruOFC1+ztKujXcQZ4qJpliXj/6E9gtBFdWyvdJePAU4LjS+dzG60Avc3o+ak8LjgHHxIvICLBwqJ
	7GEjK7xA==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmQ1-000000061ps-1MzJ;
	Sun, 03 Mar 2024 14:02:21 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 07/11] md/raid5: use the atomic queue limit update APIs
Date: Sun,  3 Mar 2024 07:01:46 -0700
Message-Id: <20240303140150.5435-8-hch@lst.de>
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

Build the queue limits outside the queue and apply them using
queue_limits_set.  To make the code more obvious also split the queue
limits handling into separate helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/raid5.c | 130 ++++++++++++++++++++++-----------------------
 1 file changed, 65 insertions(+), 65 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index a6350eb711fb36..0c10fdc0dfdcf1 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7666,10 +7666,65 @@ static int only_parity(int raid_disk, int algo, int raid_disks, int max_degraded
 	return 0;
 }
 
-static void raid5_set_io_opt(struct r5conf *conf)
+static int raid5_set_limits(struct mddev *mddev)
 {
-	blk_queue_io_opt(conf->mddev->queue, (conf->chunk_sectors << 9) *
-			 (conf->raid_disks - conf->max_degraded));
+	struct r5conf *conf = mddev->private;
+	struct queue_limits lim;
+	int data_disks, stripe;
+	struct md_rdev *rdev;
+
+	/*
+	 * The read-ahead size must cover two whole stripes, which is
+	 * 2 * (datadisks) * chunksize where 'n' is the number of raid devices.
+	 */
+	data_disks = conf->previous_raid_disks - conf->max_degraded;
+
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
+	rdev_for_each(rdev, mddev)
+		queue_limits_stack_bdev(&lim, rdev->bdev, rdev->new_data_offset,
+				mddev->gendisk->disk_name);
+
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
+
+	/*
+	 * Requests require having a bitmap for each stripe.
+	 * Limit the max sectors based on this.
+	 */
+	lim.max_hw_sectors = RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf);
+
+	/* No restrictions on the number of segments in the request */
+	lim.max_segments = USHRT_MAX;
+
+	return queue_limits_set(mddev->queue, &lim);
 }
 
 static int raid5_run(struct mddev *mddev)
@@ -7682,6 +7737,7 @@ static int raid5_run(struct mddev *mddev)
 	int i;
 	long long min_offset_diff = 0;
 	int first = 1;
+	int ret = -EIO;
 
 	if (mddev->recovery_cp != MaxSector)
 		pr_notice("md/raid:%s: not clean -- starting background reconstruction\n",
@@ -7935,65 +7991,9 @@ static int raid5_run(struct mddev *mddev)
 	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
 
 	if (!mddev_is_dm(mddev)) {
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
-
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
-
-		/*
-		 * Requests require having a bitmap for each stripe.
-		 * Limit the max sectors based on this.
-		 */
-		blk_queue_max_hw_sectors(mddev->queue,
-			RAID5_MAX_REQ_STRIPES << RAID5_STRIPE_SHIFT(conf));
-
-		/* No restrictions on the number of segments in the request */
-		blk_queue_max_segments(mddev->queue, USHRT_MAX);
+		ret = raid5_set_limits(mddev);
+		if (ret)
+			goto abort;
 	}
 
 	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
@@ -8006,7 +8006,7 @@ static int raid5_run(struct mddev *mddev)
 	free_conf(conf);
 	mddev->private = NULL;
 	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
-	return -EIO;
+	return ret;
 }
 
 static void raid5_free(struct mddev *mddev, void *priv)
@@ -8538,8 +8538,8 @@ static void end_reshape(struct r5conf *conf)
 		spin_unlock_irq(&conf->device_lock);
 		wake_up(&conf->wait_for_overlap);
 
-		if (!mddev_is_dm(conf->mddev))
-			raid5_set_io_opt(conf);
+		mddev_update_io_opt(conf->mddev,
+			conf->raid_disks - conf->max_degraded);
 	}
 }
 
-- 
2.39.2

