Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91FE35730B;
	Mon, 26 Feb 2024 10:30:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943445; cv=none; b=pwld/p2jVr5jt8gt97vJ8JcScSRvu7czE/bzQW/W1wDSpnVb0U03m26AdVs4U0oSTYJHPV1FMQZxa+73oaHqP1J0XcrfYHzqvl+uRkdZ+EIdw7twQmbo46N/Eyl5cC3HezsUdVPosdeJKhtyiGUfBqHYw4Lqxx3Jq4Ph9LWa5Wg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943445; c=relaxed/simple;
	bh=qkrvkJlyDXhDeLlNMru1+MYxZ4VRAl/ThVRgaiQjMh0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=rHoHib+h1x9HFAy9kPsrSb1nbsaMI9xGWmlMz0BklTBZjB16YEnLbb7SZfnX53D2SCG2kRMISDsgFXZU6IRy4RQwI1zObYKjT7bfQcPLBnuzLV83voj1lAQTaF2GFIYkaSgvvZ6d4iR7QRGvHplR9UILsRqwdFJUa1pIY8Gvu9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ViVd9ngd; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ViVd9ngd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=/W7QiFrwP9NDOeY0MMQGkpN8cv8t6hi9lmA8LIVLFK4=; b=ViVd9ngdKC+pbVTXEzzZVIeiIo
	uvWg2BFfZZmC4/wIR84Yn1UMLKp/TLOAa9H1J8WJakxb7d/stmiK37EL+g2XdyxQMaElOh0CASdaZ
	tjJpJHYYk+AsQxwCmY3Id8M5tSQq+CyxtJxZ9g7Fk30croBHKS6PGoGSjHg+XbfCrrIopnVNxnBHW
	67Hs075ipfe8eUW1lpfmmnaV/MiYv9EoVMUIeMa8LlWsWr19smweCYciwC+89kX+QzW1PPCdikaO+
	+LzEG3Xtbjf4R1Zl+jhpxLLatyNOaa5VnejTj0/Ijn2gbYMfWw4+VF+19RR6+QnyYIiG6WUpYLu3N
	TbDdcgpQ==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYFn-000000004ga-46GF;
	Mon, 26 Feb 2024 10:30:41 +0000
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
Subject: [PATCH 05/16] md/raid0: use the atomic queue limit update APIs
Date: Mon, 26 Feb 2024 11:29:53 +0100
Message-Id: <20240226103004.281412-6-hch@lst.de>
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
 drivers/md/raid0.c | 37 +++++++++++++++++--------------------
 1 file changed, 17 insertions(+), 20 deletions(-)

diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
index c50a7abda744ad..dd070e9b2d5643 100644
--- a/drivers/md/raid0.c
+++ b/drivers/md/raid0.c
@@ -381,7 +381,8 @@ static void raid0_free(struct mddev *mddev, void *priv)
 
 static int raid0_run(struct mddev *mddev)
 {
-	struct r0conf *conf;
+	struct r0conf *conf = mddev->private;
+	struct queue_limits lim;
 	int ret;
 
 	if (mddev->chunk_sectors == 0) {
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
 
-		blk_queue_io_min(mddev->queue, mddev->chunk_sectors << 9);
-		blk_queue_io_opt(mddev->queue,
-				 (mddev->chunk_sectors << 9) * mddev->raid_disks);
-
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

