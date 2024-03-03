Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36AAE5A118;
	Sun,  3 Mar 2024 14:02:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709474536; cv=none; b=GPVr3VE/h/K494zsZbpk5Kr00FpU2fLBURpJQthEQRFJmiSNGoYFIJpTcVy/taSmJIltA3eO3kbrYHeCBxBsrb3cxQeNdmAu5D+krEfb2dtQb9/874cJwIiTIezZxCpadDelOf/G+3riILPVrh5n60HfoNUQRHF5uBnkXE7O44w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709474536; c=relaxed/simple;
	bh=ZzfpEOuvgeMSuMUZdhvRZQIN9XZ3gwVF9qBcyNd3nKM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iNZNWisc76vPUlvYjKKpgq7/FzLXJgWu7aKquSJXKi3RRh/13Sj/jWHSJ3FFdm9trbPOC9JpSV8yCkdxf1GPTqj4O58qnv7wDlkLfzPO+CWZ1s9phjdlOJrr2UbvwNFV+cXKtu6u6J5qm3/PNDjMx04ls6DyDpVjTaQfFrUJl24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=YCRV9FSX; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="YCRV9FSX"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=mNFEgTD6S5LPbjlCSvkTSmFiasWMd7udr81oR1lVtKE=; b=YCRV9FSXFYMSxrPjyFsKzmw1vD
	MO88qU/pM3e5OFAYDPCggB5NB9qEZxUF6nk4iekOK61eJrevn9snBzG1nHxB5YMrjTI8tlpToDof8
	add9C84BllFX8xwJ4NXwXcPGGIwxrJNreI1uwNdXikbGS6sM5U8E72gc+NuVv4eWaWds+7z1tPqM8
	Z/z7uL6rZ+8Y2rWd5yaqncpAkK39t2BJGLI/fyQZhhaCE0f2gp9QhTr99j/18s6m15mPbmBQdO09K
	jHsqQDAuJ/kjlOofGnr4L2ZnqG+p1bWMgHsC0XmGD3ljp9FgFajaIrNnoH8MVG3pXxQdimJQ0dS4Q
	8f2G7FCw==;
Received: from [206.0.71.27] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rgmPt-000000061mS-2roI;
	Sun, 03 Mar 2024 14:02:14 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 05/11] md/raid0: use the atomic queue limit update APIs
Date: Sun,  3 Mar 2024 07:01:44 -0700
Message-Id: <20240303140150.5435-6-hch@lst.de>
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
limits handling into a separate helper function.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed--by: Song Liu <song@kernel.org>
Tested-by: Song Liu <song@kernel.org>
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

