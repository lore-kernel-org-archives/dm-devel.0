Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8335D82C60;
	Fri, 23 Feb 2024 16:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704807; cv=none; b=tf5HJ2RwFteiK4Q+DeBn6KxJowPhFZr5z3Iy7Z4Aooli42wrpQXPx5rUk5HJMYy1g0Yh7k32ttSa1QLy+FyJK4HlYQ+OIW8sv3I+8K1E2oXH3oE6PE/RtNtf/VW3EQ5EVI94BGEZOdp7R+SvbZ50YCQ05GQHv1jPBmbeMFL/+QA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704807; c=relaxed/simple;
	bh=l1ZzPCiEr335aH7EWESo2kG3Oa9lgrq7EV/mJlIuWJk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UHMtrIgN0Rs3qc7Fd0A8ZgConaCGu0DEb+1rPLSeVZDnL9VWf284DwBzdXq0tjA/vGhpbLkpT2SUz6h2kVbKmzUFswjNTxTSEwXt6OiNBZKD2uxStPYFSqehg/p7Mw5Aflx2gCDE1RWHOJp53owllexe3w2ewYGNENAjWtB//nQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=T6GZ6OQj; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="T6GZ6OQj"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=zXQ5eHK4YZoxrGzfweizYedOAgX1D7tLxQ3tD2OddIo=; b=T6GZ6OQjb1s06j9LDQJov016Gf
	QfvXiYADF6/lx4FBdPPlwglVahtmwpO6z8iMCsvES0DIgS5ZfRLtZ7qw5lNq38NleitlThkpBDNaI
	OaGyAua+eAoOjdaozr8EOBvrovCpI9+4pOIzqBFPu7bUC2wxI/m4APn/T73uY1qLVZr1D6Kc4b6oo
	hPSLQ4R0hj1FAUb54Ij60tFzShjdunjW1uD0mbB0RlmbZ0YYQ3OhmpoTDjK8HNtM/hpEVwvljYg0e
	4517G62nyzPhEBYNblBoYqet8kQZ5gI07SpvFVic0o+8cS+EKEilu1Fak94up1T48cYsjhocZKpXd
	1oy8wyLw==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAv-0000000AAqd-01cJ;
	Fri, 23 Feb 2024 16:13:25 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 9/9] block: remove disk_stack_limits
Date: Fri, 23 Feb 2024 17:12:47 +0100
Message-Id: <20240223161247.3998821-10-hch@lst.de>
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

disk_stack_limits is unused now, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 24 ------------------------
 include/linux/blkdev.h |  2 --
 2 files changed, 26 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index f14d3a18f9e2f0..299ecc399c0e6f 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -915,30 +915,6 @@ void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
 }
 EXPORT_SYMBOL_GPL(queue_limits_stack_bdev);
 
-/**
- * disk_stack_limits - adjust queue limits for stacked drivers
- * @disk:  MD/DM gendisk (top)
- * @bdev:  the underlying block device (bottom)
- * @offset:  offset to beginning of data within component device
- *
- * Description:
- *    Merges the limits for a top level gendisk and a bottom level
- *    block_device.
- */
-void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
-		       sector_t offset)
-{
-	struct request_queue *t = disk->queue;
-
-	if (blk_stack_limits(&t->limits, &bdev_get_queue(bdev)->limits,
-			get_start_sect(bdev) + (offset >> 9)) < 0)
-		pr_notice("%s: Warning: Device %pg is misaligned\n",
-			disk->disk_name, bdev);
-
-	disk_update_readahead(disk);
-}
-EXPORT_SYMBOL(disk_stack_limits);
-
 /**
  * blk_queue_update_dma_pad - update pad mask
  * @q:     the request queue for the device
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 285e82723d641f..75c909865a8b7b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -926,8 +926,6 @@ extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
 void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
 		sector_t offset, const char *pfx);
-extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
-			      sector_t offset);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
 extern void blk_queue_segment_boundary(struct request_queue *, unsigned long);
 extern void blk_queue_virt_boundary(struct request_queue *, unsigned long);
-- 
2.39.2

