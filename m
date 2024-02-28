Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 223E576F09;
	Wed, 28 Feb 2024 22:56:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161019; cv=none; b=l5MJwBTOFIqeXhvz4YZAVpFdFUuJlAhJA6RlcHyVG385PuG7qzvJ6OfClIt7onwdMdXcEXyTzDF8Pjqk78kmSi/bi42WZOvpNBdfKZivsEX2wngLIWHTxV/f88lpjp55OkNlotla3LwpB4Hncqmlq4ZoywOuTOXhA5qH13cGMbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161019; c=relaxed/simple;
	bh=phhP3JvljeW48Hk8U5w6qEwDabadtVvD3iHDOKHgsGk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=KXasd5PphHPUg2WJWEvccGjYd6UWDM1Hl5nVOBfe1dzUPUYqD4PpbRCAwWXRY0PHrycvMRKk/xCEmd8RdcBUE/3p/QGDpYHAKLMMcEbPS1/nzSrqDneNkdMyKAG9GVz4Bw2CSQjZHZ2jqNODHOsYQcFk8T9Fzv7jsAd5TJb/d5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=XFrribF2; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="XFrribF2"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=VpG4V5/kI/N9iSOd4zOsIZodQf9DOHZRCkTqv4MZ5m0=; b=XFrribF2C0XLnWjr0U1/b8f/k5
	EdC8zIiM/zaWY5SZwljjVEc1Rn1ZyuTQt0U/eVCQUpbTt+zGvoKH8xKVFhX7VOwcSPllRQorCXMwj
	64lGHM5NuZzrO10Nc6Ga4obg7aoCl9IkGjF+loJ+Xk4AOPxyufaGMcNGO6uv62G6falpUM/JOP7bT
	CttxeZaUd2ovjBGcLuW7/R2DxdGuOqbZDfQTpr3hKi/yDw0DZwIBu6QXRRZU0HHBPyoVtXpJAeT5S
	gCmAmfKjWJ5sTsdQJTBwnh+ItdVURWysjhKIjKQVbbIe5Gh+UYpm6z68p/FlDBlox81ILnHNu4pNL
	6fGV9MJw==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrB-0000000BCOq-0Gks;
	Wed, 28 Feb 2024 22:56:57 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 08/14] md/raid0: use the atomic queue limit update APIs
Date: Wed, 28 Feb 2024 14:56:47 -0800
Message-Id: <20240228225653.947152-9-hch@lst.de>
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
queue_limits_set.  To make the code more obvious also split the queue
limits handling into a separate helper function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/raid0.c | 35 ++++++++++++++++++++---------------
 1 file changed, 20 insertions(+), 15 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index 9f787ae77ede88..f65aa6ecec0482 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -379,6 +379,19 @@ static void raid0_free(struct mddev *mddev, void *priv)
 	free_conf(mddev, conf);
 }
 
+static int raid0_set_limits(struct mddev *mddev)
+{
+	struct queue_limits lim;
+
+	blk_set_stacking_limits(&lim);
+	lim.max_hw_sectors = mddev->chunk_sectors;
+	lim.max_write_zeroes_sectors = mddev->chunk_sectors;
+	lim.io_min = mddev->chunk_sectors << 9;
+	lim.io_opt = lim.io_min * mddev->raid_disks;
+	mddev_stack_rdev_limits(mddev, &lim);
+	return queue_limits_set(mddev->queue, &lim);
+}
+
 static int raid0_run(struct mddev *mddev)
 {
 	struct r0conf *conf;
@@ -400,19 +413,9 @@ static int raid0_run(struct mddev *mddev)
 	}
 	conf = mddev->private;
 	if (!mddev_is_dm(mddev)) {
-		struct md_rdev *rdev;
-
-		blk_queue_max_hw_sectors(mddev->queue, mddev->chunk_sectors);
-		blk_queue_max_write_zeroes_sectors(mddev->queue, mddev->chunk_sectors);
-
-		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-		blk_queue_io_opt(mddev->queue,
-				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
-
-		rdev_for_each(rdev, mddev) {
-			disk_stack_limits(mddev->gendisk, rdev->bdev,
-					  rdev->data_offset << 9);
-		}
+		ret = raid0_set_limits(mddev);
+		if (ret)
+			goto out_free_conf;
 	}
 
 	/* calculate array device size */
@@ -426,8 +429,10 @@ static int raid0_run(struct mddev *mddev)
 
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

