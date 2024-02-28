Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DDD871EA1;
	Wed, 28 Feb 2024 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161017; cv=none; b=Exc9ZNLpK6IfjMlAGuJ3rjB2dnelLE1K3sFdfG3cy8jz/JS6/6G6yoQtJ4dPu3lrSd0BZOFIwh/x2QMNDZeUoH0kAbhlKrrkfByHzB6rDAr5xqqDovosLryCFH5hdO3fO6NSrHvHNVEFEl5xBD9ZHMjgbk5daILV+ayKGRyUHbk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161017; c=relaxed/simple;
	bh=c0iiMVqC1HcMKa6BgM8sFnbsAw2nZhdnOCQjy+MlK7Y=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Zx96AGFTkHV9T1lSWkDPNMinIhTlk2UVW/sEkPkx7F2j+yVIdG1m2Gv3DeBNi/aoG+lPDE2mMxoByD3aARGWOuWS6hSsY35fiY49EwqUSiAKqFN8QdyN+smzzJklUwbkNT4mxtqCl7iV9veuyhX3RI/yIsDX40J6C3cRIYoKQFU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Sg237stn; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Sg237stn"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=WCouwC0fhxTIxJn2BmBN/79OSqvHAzI8vVcSvmEQk0s=; b=Sg237stn4250N39bX0dwjYj6KA
	O2kUoh+SvgVP1VouSRndin6T7EWpOa7AXtGq1B66y/Ft5ABO6++6j2xvUVzfuXxlkRkEuuqYIKqDC
	uqa6LEewtrGSqTwwfw7qDZIK/v9Hnp2GIwG4sbUx06bNjNQ0woDxddgnVP+892OJ77QPWmihAvIuY
	kw8ve9t8gxcTu1PPkdCBinGCVGuYuIUdU+36RBuLSmybb7PQWb/CIiNorPHCv3xlGBp1fwKohq0Qz
	0of2/kA/JVbhGz4bG13DPo67b2egs5hqDvPKKKHXcQ2V/B4aoNElcWclGHHhu0wVHEqiBzWU94Odx
	my6WFG9g==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSr8-0000000BCNc-1M3x;
	Wed, 28 Feb 2024 22:56:54 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 02/14] block: add a queue_limits_stack_bdev helper
Date: Wed, 28 Feb 2024 14:56:41 -0800
Message-Id: <20240228225653.947152-3-hch@lst.de>
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

Add a small wrapper around blk_stack_limits that allows passing a bdev
for the bottom device and prints an error in case of misaligned
device. The name fits into the new queue limits API and the intent is
to eventually replace disk_stack_limits.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c   | 25 +++++++++++++++++++++++++
 include/linux/blkdev.h |  2 ++
 2 files changed, 27 insertions(+)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 1989a177be201b..865fe4ebbf9b83 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -891,6 +891,31 @@ int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 }
 EXPORT_SYMBOL(blk_stack_limits);
 
+/**
+ * queue_limits_stack_bdev - adjust queue_limits for stacked devices
+ * @t:	the stacking driver limits (top device)
+ * @bdev:  the underlying block device (bottom)
+ * @offset:  offset to beginning of data within component device
+ * @pfx: prefix to use for warnings logged
+ *
+ * Description:
+ *    This function is used by stacking drivers like MD and DM to ensure
+ *    that all component devices have compatible block sizes and
+ *    alignments.  The stacking driver must provide a queue_limits
+ *    struct (top) and then iteratively call the stacking function for
+ *    all component (bottom) devices.  The stacking function will
+ *    attempt to combine the values and ensure proper alignment.
+ */
+void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
+		sector_t offset, const char *pfx)
+{
+	if (blk_stack_limits(t, &bdev_get_queue(bdev)->limits,
+			get_start_sect(bdev) + offset))
+		pr_notice("%s: Warning: Device %pg is misaligned\n",
+			pfx, bdev);
+}
+EXPORT_SYMBOL_GPL(queue_limits_stack_bdev);
+
 /**
  * disk_stack_limits - adjust queue limits for stacked drivers
  * @disk:  MD/DM gendisk (top)
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index dd510ad7ce4b45..285e82723d641f 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -924,6 +924,8 @@ extern void blk_set_queue_depth(struct request_queue *q, unsigned int depth);
 extern void blk_set_stacking_limits(struct queue_limits *lim);
 extern int blk_stack_limits(struct queue_limits *t, struct queue_limits *b,
 			    sector_t offset);
+void queue_limits_stack_bdev(struct queue_limits *t, struct block_device *bdev,
+		sector_t offset, const char *pfx);
 extern void disk_stack_limits(struct gendisk *disk, struct block_device *bdev,
 			      sector_t offset);
 extern void blk_queue_update_dma_pad(struct request_queue *, unsigned int);
-- 
2.39.2

