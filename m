Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC1B17290B;
	Wed, 28 Feb 2024 22:57:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161027; cv=none; b=oko8Z5AlwreFdg7Ls+MRKfxXVTuF7zYjAGeVvy0AlMHZs9ZIWbeB3FCR6u9XM28aRIJQaddqjEKJHrTGP1vaplk8hxdyyyCwdOjHnYM9N8tIbson73fuMYkfH22y5Jakv6QVfljuNEZkuupEjB6kMcP9oCYbQKTEdQC7tmyjnPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161027; c=relaxed/simple;
	bh=rjrBsSeN4TvfsIeude8FJjx7Vee0SyykGlyHSUvPlkU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Hc/CRwQlTzORP5lXLe8nfS+XwzXAvVnFo8+07UFOkkm814Th99HSMo42Dn9BpGDZLnWKaTteg49NKqBaAWpsvGLZ5KkHBO0g+ZWVMJSdXz6dTHRYgQleXfMMKzBspZwXSnWtWcAkspM1Owwmlm43hcL/8h17W7QdEa9w48iJXig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=ObCMGTaY; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="ObCMGTaY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=s9Pu6ieiVUWU70yfnx7yKzpl91lyIUDqJOc53o+My9E=; b=ObCMGTaYmZ7eGaBIveicf6zCPg
	4ldJZK3Zo/x9AzzJN+CyLM4jJgIgwbFC5bApatXQGhx3iDMfEQL+2Rc8oDSIj3Bpo4bOOqTjY/VUx
	p9FHFxyBZ5XG1SLLPVDWVT+sSxR10tnFG8PmOSPxceqiRaUPC5Z7YCQ4oSDD13tZ6gqUOZKrLga33
	wBVeBIo6p6zAHp4M+FYPMTJuLcjjBzLhQItZOYd2BODrPdKRcEFGuzSnRTUY4RVwE3HDE8KVZe2oY
	GjPu5Fr/BVqq9v0i4JN4BYMvryraC5/39T6UIE+96kQ/e0vNpjxqnX9G//ASIDbgf/BPQXYR7mBVM
	52OC7idg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSrI-0000000BCQ7-3WqO;
	Wed, 28 Feb 2024 22:57:04 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 14/14] block: remove disk_stack_limits
Date: Wed, 28 Feb 2024 14:56:53 -0800
Message-Id: <20240228225653.947152-15-hch@lst.de>
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

disk_stack_limits is unused now, remove it.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 24 ------------------------
 include/linux/blkdev.h |  2 --
 2 files changed, 26 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 13865a9f89726c..3c7d8d638ab59d 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -916,30 +916,6 @@ void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
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

