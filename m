Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7605B5A0FC;
	Sun,  3 Mar 2024 14:02:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474548; cv=none; b=QB7ftM6JFCOcQyS7CF0uF+nKhTHzkumrpxxysN5/umqny2ywwzk6cVd4wswydgZsafjbQHDqLWiuIpjvXA6VKzZHSBoFA+y7NsBMRWM2hoRuAE1r4dZ4hz1JRwJm/T/CkVBBviaFBhPy2K+XYclnAQOMjV3WusBeeNSPaqrgH6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474548; c=relaxed/simple;
	bh=vE5B2s3pYzCwOf8ukdjCpBr5MTVS+V8rLxzmIFjANmU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BMTS/UjCy6tsm2+3nnAVyDs1ET7SlKO8m/jh88FL4b/tPF2Ci1NkCllTDxTxASWV2hlSrTzB+ZAeVrTo87Re+ndLGV/rMlQhPhb77fN+ArJRtYQ97JEEhh+u8uURhx80eKlGIcsMHBRAwcgLo9y8Qe51hp6/M5L9O5eGoZauVJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cm9D7kyT; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cm9D7kyT"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=INCkpSOFdWHvBHvn1C9B+ofio+TVaN9EpUC34P2iI2U=; b=cm9D7kyT1TAp3ZZDc0ZGEi8+Gz
	E9S6h7XZrEV/qm8CKHpqCMO0oFY2i3bZnusMJh7VegFAJ7N9em+ABb4RvcfWtdLjkwAargmE+jTYK
	i4TfZivof1K39NuG5VxWkKn2JY4bBl5jqUEqb39QGXb4FEySlSl7YFSYXB48rPlBghbhb/zO8I1I+
	CUsI+UtMMxcRX2HFGMhF0j1vNVcYMCoKcfSq33OGg5YTKy4caF6LmDqhHKTIFahR/VdqpAOMm0PSW
	rwvd/PKoFYXE/5uQMuLSSZ/wNBcLwToSURf/qyIk0yFnCJd26iyTzh5+1CIVpnlf6f2wwQ//qieVu
	bI7zuz9g==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmQ5-000000061ry-35CV;
	Sun, 03 Mar 2024 14:02:26 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/11] md/raid10: use the atomic queue limit update APIs
Date: Sun,  3 Mar 2024 07:01:47 -0700
Message-Id: <20240303140150.5435-9-hch@lst.de>
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
queue_limits_set.   To make the code more obvious also split the queue
limits handling into separate helpers.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
---
 drivers/md/raid10.c | 60 +++++++++++++++++++++++++--------------------
 1 file changed, 33 insertions(+), 27 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 4021cf06b3a616..e96fdf47319fd0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -2106,10 +2106,9 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -2125,10 +2124,9 @@ static int raid10_add_disk(struct mddev *mddev, struct md_rdev *rdev)
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
@@ -3969,14 +3967,26 @@ static struct r10conf *setup_conf(struct mddev *mddev)
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
@@ -3988,6 +3998,7 @@ static int raid10_run(struct mddev *mddev)
 	sector_t size;
 	sector_t min_offset_diff = 0;
 	int first = 1;
+	int ret = -EIO;
 
 	if (mddev->private == NULL) {
 		conf = setup_conf(mddev);
@@ -4014,12 +4025,6 @@ static int raid10_run(struct mddev *mddev)
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
 
@@ -4048,14 +4053,16 @@ static int raid10_run(struct mddev *mddev)
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
@@ -4156,7 +4163,7 @@ static int raid10_run(struct mddev *mddev)
 	raid10_free_conf(conf);
 	mddev->private = NULL;
 out:
-	return -EIO;
+	return ret;
 }
 
 static void raid10_free(struct mddev *mddev, void *priv)
@@ -4933,8 +4940,7 @@ static void end_reshape(struct r10conf *conf)
 	conf->reshape_safe = MaxSector;
 	spin_unlock_irq(&conf->device_lock);
 
-	if (!mddev_is_dm(conf->mddev))
-		raid10_set_io_opt(conf);
+	mddev_update_io_opt(conf->mddev, raid10_nr_stripes(conf));
 	conf->fullsync = 0;
 }
 
-- 
2.39.2

