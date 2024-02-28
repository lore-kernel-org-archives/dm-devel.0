Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C67F7290F;
	Wed, 28 Feb 2024 22:57:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161026; cv=none; b=ZUA69PwBGQ3JnnDQmS3yV5WCjd6P7JxQqiXW3s6LrTyijScea0J0AB6iKz6EoJSB+yjI69jGASaAThNFczgeykGtWFLqQbrJk0PORwX022t4y3uqYnM5p8TUvy7J9o42Vhv5pRheyC2Fnhc1Ls0qff6rQMfdviIf2CNaLEVTeBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161026; c=relaxed/simple;
	bh=EyGievBHp61SYFzpefanBWL5PLO6CviK4dFYj7JFjew=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=G8liFkOLaUX49atoEmSNzyLoFNGWIgp2sCsm0RzDjW8S2Wkxo2m6bU4sT2bDDK7ZoisWY8R9HUi6TFg0wZ5m2MC49AuzDYjfqylR5Bq64HCEVHNndJfCH0ByXdGIsgTPJrj9tYlNcnKDxwvYtY78mRB4PgSE0H83C3WLsA1AZzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=gddZRF9h; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="gddZRF9h"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=5SZHUYDI1UghuHcUnZfni2d98+Jb3vhnDCVfYx1sFtc=; b=gddZRF9hPRyqi2GNlBytoV8Aym
	nOUs1eO57L5aY81UIHu/ab79DmgQj1tmBnm1yZ+n590J35jyT9dJ1luJ0CJkqSNLCPfNeZJvZIJAY
	Tf5P92VNWctOomMY6C8CRDCam0fn+x14h4RIpbRSjAAyqhrpdyjp3hZh97BGMZzYnmMcnk+QfUn+B
	8mUC1PVlZIeGcE2kn4LrQ5sZRRVzY2lNbNd8MGdSKO/dC6UOgcViPv+2SZkMsx39dol1TEiJi9EHI
	pzJQy90r7y+BY0dDgWJf5hAJYvae/LNviCz2Ut28oAcjYft/8DTouqKcNzRdUZetKtIN3VYFAOfAd
	aBwVp+ww==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrH-0000000BCPb-27ed;
	Wed, 28 Feb 2024 22:57:03 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 11/14] md/raid10: use the atomic queue limit update APIs
Date: Wed, 28 Feb 2024 14:56:50 -0800
Message-Id: <20240228225653.947152-12-hch@lst.de>
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

Build the queue limits outside the queue and apply them using
queue_limits_set.   To make the code more obvious also split the queue
limits handling into separate helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid10.c | 60 +++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 95fa9e728f95a9..692a3bd94100e2 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2124,10 +2124,9 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 			continue;
 		}
 
-		if (!mddev_is_dm(mddev))
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
-
+		err = mddev_stack_new_rdev(mddev, rdev);
+		if (err)
+			return err;
 		p->head_position = 0;
 		p->recovery_disabled = mddev->recovery_disabled - 1;
 		rdev->raid_disk = mirror;
@@ -2143,10 +2142,9 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
 		clear_bit(In_sync, &rdev->flags);
 		set_bit(Replacement, &rdev->flags);
 		rdev->raid_disk = repl_slot;
-		err = 0;
-		if (!mddev_is_dm(mddev))
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
+		err = mddev_stack_new_rdev(mddev, rdev);
+		if (err)
+			return err;
 		conf->fullsync = 1;
 		WRITE_ONCE(p->replacement, rdev);
 	}
@@ -3995,14 +3993,26 @@ static struct r10conf *setup_conf(struct mddev *mddev)
 	return ERR_PTR(err);
 }
 
-static void raid10_set_io_opt(struct r10conf *conf)
+static unsigned int raid10_nr_stripes(struct r10conf *conf)
 {
-	int raid_disks = conf->geo.raid_disks;
+	unsigned int raid_disks = conf->geo.raid_disks;
+
+	if (conf->geo.raid_disks % conf->geo.near_copies)
+		return raid_disks;
+	return raid_disks / conf->geo.near_copies;
+}
 
-	if (!(conf->geo.raid_disks % conf->geo.near_copies))
-		raid_disks /= conf->geo.near_copies;
-	blk_queue_io_opt(conf->mddev->queue, (conf->mddev->chunk_sectors << 9) *
-			 raid_disks);
+static int raid10_set_queue_limits(struct mddev *mddev)
+{
+	struct r10conf *conf = mddev->private;
+	struct queue_limits lim;
+
+	blk_set_stacking_limits(&lim);
+	lim.max_write_zeroes_sectors = 0;
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * raid10_nr_stripes(conf);
+	mddev_stack_rdev_limits(mddev, &lim);
+	return queue_limits_set(mddev->queue, &lim);
 }
 
 static int raid10_run(struct mddev *mddev)
@@ -4014,6 +4024,7 @@ static int raid10_run(struct mddev *mddev)
 	sector_t size;
 	sector_t min_offset_diff = 0;
 	int first = 1;
+	int ret = -EIO;
 
 	if (mddev->private == NULL) {
 		conf = setup_conf(mddev);
@@ -4040,12 +4051,6 @@ static int raid10_run(struct mddev *mddev)
 		}
 	}
 
-	if (!mddev_is_dm(conf->mddev)) {
-		blk_queue_max_write_zeroes_sectors(mddev->queue, 0);
-		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-		raid10_set_io_opt(conf);
-	}
-
 	rdev_for_each(rdev, mddev) {
 		long long diff;
 
@@ -4074,14 +4079,16 @@ static int raid10_run(struct mddev *mddev)
 		if (first || diff < min_offset_diff)
 			min_offset_diff = diff;
 
-		if (!mddev_is_dm(mddev))
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
-
 		disk->head_position = 0;
 		first = 0;
 	}
 
+	if (!mddev_is_dm(conf->mddev)) {
+		ret = raid10_set_queue_limits(mddev);
+		if (ret)
+			goto out_free_conf;
+	}
+
 	/* need to check that every block has at least one working mirror */
 	if (!enough(conf, -1)) {
 		pr_err("md/raid10:%s: not enough operational mirrors.\n",
@@ -4182,7 +4189,7 @@ static int raid10_run(struct mddev *mddev)
 	raid10_free_conf(conf);
 	mddev->private = NULL;
 out:
-	return -EIO;
+	return ret;
 }
 
 static void raid10_free(struct mddev *mddev, void *priv)
@@ -4959,8 +4966,7 @@ static void end_reshape(struct r10conf *conf)
 	conf->reshape_safe = MaxSector;
 	spin_unlock_irq(&conf->device_lock);
 
-	if (!mddev_is_dm(conf->mddev))
-		raid10_set_io_opt(conf);
+	mddev_update_io_opt(conf->mddev, raid10_nr_stripes(conf));
 	conf->fullsync = 0;
 }
 
-- 
2.39.2

