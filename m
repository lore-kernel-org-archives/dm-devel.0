Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E681385638;
	Fri, 23 Feb 2024 16:13:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704793; cv=none; b=jNakNND9K/HXs5jLdOzTJoJiwymS6Dn0a1P9OAvtb+fWcqtonQ1Kuag/IRHNZ+7ld4p8CFvvb7bRaD7AX+w+WA+ivslatL/VEs3GrXZNUKWrO2VrkLxQo8wW072kO8rzkH2BC5tXX6NNJIo34pjGuy/p/BHe/pcAf25UIHbUQ0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704793; c=relaxed/simple;
	bh=zCBk/PqWZLZGFEBjfM2iuYUXRJ2akvHWBPqC0vjBMw0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=GXf06uPjgxCUUnjoZFF+ucBHzlRv4pgLHgoacAjtcuHUXAY/S2BiEEGXzflgT32OcD2EuyVrHUp1y2w11VDTBZmUHNzc9HLH1Mf5XJDsAZgIsUHE69bWVyX1MxQiKwsprpkgiH7CkhWPsgPUK3wWQSi4Bh8f5FfzzBRXd99BDGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Z9gFGMjk; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Z9gFGMjk"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=sguSj+eaTMBTK7hMcvpX41ZMewjfbPx9/+19uC/WjPk=; b=Z9gFGMjkqNdTvip6KFBzKAIU2/
	nOBFS1DErdHLhyQY/MtYazmYuvwDaTmr/weBhfgjI+GAUGs548gTDK0p1AI/Pzh7g8UJjK9cfpPik
	gxeibVIY04sKgoun1Uv0r6meCxgCH5pruXcnjDL9KPi1CSTjZiFuiFSPw+nRqvqCGc8b1HQcV9pFU
	ERT9sQ65ghLNp1NLZzBLSVwBO+JFxpV3eN9S8h9ih1Y3jUoHX4XiV8PD5n7myENujdNNg7WqDlizS
	6kqJ86Sso9tvKcD3sOPGQ+C2d/+KZvCeEt6e+cVkmDaipwRqUDjaG9XG9KIMl9jPe60s/wElYF0Hj
	575EDYsw==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAg-0000000AAmE-2WzM;
	Fri, 23 Feb 2024 16:13:11 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 5/9] md/raid0: use the atomic queue limit update APIs
Date: Fri, 23 Feb 2024 17:12:43 +0100
Message-Id: <20240223161247.3998821-6-hch@lst.de>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240223161247.3998821-1-hch@lst.de>
References: <20240223161247.3998821-1-hch@lst.de>
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
 drivers/md/raid0.c | 35 ++++++++++++++++-------------------
 1 file changed, 16 insertions(+), 19 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c50a7abda744ad..f7d78ee5338bd3 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -381,6 +381,7 @@ static void raid0_free(struct mddev *mddev, void *priv)
 
 static int raid0_run(struct mddev *mddev)
 {
+	struct queue_limits lim;
 	struct r0conf *conf;
 	int ret;
 
@@ -391,29 +392,23 @@ static int raid0_run(struct mddev *mddev)
 	if (md_check_no_bitmap(mddev))
 		return -EINVAL;
 
-	/* if private is not null, we are here after takeover */
-	if (mddev->private == NULL) {
+	/* if conf is not null, we are here after takeover */
+	if (!conf) {
 		ret = create_strip_zones(mddev, &conf);
 		if (ret < 0)
 			return ret;
 		mddev->private = conf;
 	}
-	conf = mddev->private;
-	if (mddev->queue) {
-		struct md_rdev *rdev;
-
-		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
-
-		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-		blk_queue_io_opt(mddev->queue,
-				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
 
-		rdev_for_each(rdev, mddev) {
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
-		}
-	}
+	blk_set_stacking_limits(&lim);
+	lim.max_hw_sectors = mddev->chunk_sectors;
+	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * mddev->raid_disks;
+	mddev_stack_rdev_limits(mddev, &lim);
+	ret = queue_limits_set(mddev->queue, &lim);
+	if (ret)
+		goto out_free_conf;
 
 	/* calculate array device size */
 	md_set_array_sectors(mddev, raid0_size(mddev, 0, 0));
@@ -426,8 +421,10 @@ static int raid0_run(struct mddev *mddev)
 
 	ret = md_integrity_register(mddev);
 	if (ret)
-		free_conf(mddev, conf);
-
+		goto out_free_conf;
+	return 0;
+out_free_conf:
+	free_conf(mddev, conf);
 	return ret;
 }
 
-- 
2.39.2

