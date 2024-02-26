Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D211DFD1;
	Mon, 26 Feb 2024 10:31:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943482; cv=none; b=c5itlDWBbZpSy2LZwkt5vVxJrXCyPu6wfAA8oU1Pov3MnXrr6z7LA7LNAwtWdWpiFQbcR1CiZ6DGvVzHsik3ZEa1CKtMQiupAj8uofVW4B0aIW0MJP5qnyrNqbx6Wxz7caExa/mk8ol7htOGIiPt9JoH8YIpiDe8eTk/rLjU7FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943482; c=relaxed/simple;
	bh=AsrYHsG7r6XadTI3QCTSg4hezSD4FYHHHuLdbXXQ+TA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dyYqgoI50gGxpt4GYt1mdyvW7/aqkp06+4OzdZZLa3okwAIEFlMKSqxz9VgcuCaDTWR5BWapZ4SH9EO66e4w3TQVscDjIFm1rV/GZUPYnWHmIf0boqGpEmuy+eECHgPj4cpp7aYy4uBV1n0Vii9gIHHMxkNQ0GlM3MznO5YpR6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=RKmXtcsx; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="RKmXtcsx"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=0KKDb4GuesD/jXOw/b5195T9S3k6Ul/k1CdB+JFeMjg=; b=RKmXtcsxAXaY0O7ggdOg000ZYN
	Nj7jdQhz8JZVwptX0zykKjDfqajQPE/rqkwz6mq+Tn19FkOnppynEbq0Wg3GWboeqqT+mnI/htPGB
	fYuAv9qRLcBKfEypQ1QgFukEJCgbMfDMa742lXE5cj1FNRi+VXGJY8HBlrUz/d0o14X8sZxVdNvVF
	uSyB8rPNwG9VbOh7G0N6VvcFRO16KtZ0J175dbeB6CHHGNYa6b62JhYg/xfr2HlYMFWv7VE5nZEX8
	E17hNQ2juwG/swiN4ntsGK6qa4h5SgTz6h53/V9QLwwp8eTmBx581m7gIAv/E3pvq4zoJ8oOaIsy+
	ZUU+mnlw==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYGU-000000004zq-3IoV;
	Mon, 26 Feb 2024 10:31:20 +0000
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
Subject: [PATCH 12/16] drbd: refactor the backing dev max_segments calculation
Date: Mon, 26 Feb 2024 11:30:00 +0100
Message-Id: <20240226103004.281412-13-hch@lst.de>
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

Factor out a drbd_backing_dev_max_segments helper that checks the
backing device limitation.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/block/drbd/drbd_nl.c | 25 +++++++++++++++++--------
 1 file changed, 17 insertions(+), 8 deletions(-)

diff --git a/drivers/block/drbd/drbd_nl.c b/drivers/block/drbd/drbd_nl.c
index 9135001a8e572d..0326b7322ceb48 100644
--- a/drivers/block/drbd/drbd_nl.c
+++ b/drivers/block/drbd/drbd_nl.c
@@ -1295,30 +1295,39 @@ static void fixup_discard_support(struct drbd_device *device, struct request_que
 	}
 }
 
+/* This is the workaround for "bio would need to, but cannot, be split" */
+static unsigned int drbd_backing_dev_max_segments(struct drbd_device *device)
+{
+	unsigned int max_segments;
+
+	rcu_read_lock();
+	max_segments = rcu_dereference(device->ldev->disk_conf)->max_bio_bvecs;
+	rcu_read_unlock();
+
+	if (!max_segments)
+		return BLK_MAX_SEGMENTS;
+	return max_segments;
+}
+
 static void drbd_setup_queue_param(struct drbd_device *device, struct drbd_backing_dev *bdev,
 				   unsigned int max_bio_size, struct o_qlim *o)
 {
 	struct request_queue * const q = device->rq_queue;
 	unsigned int max_hw_sectors = max_bio_size >> 9;
-	unsigned int max_segments = 0;
+	unsigned int max_segments = BLK_MAX_SEGMENTS;
 	struct request_queue *b = NULL;
-	struct disk_conf *dc;
 
 	if (bdev) {
 		b = bdev->backing_bdev->bd_disk->queue;
 
 		max_hw_sectors = min(queue_max_hw_sectors(b), max_bio_size >> 9);
-		rcu_read_lock();
-		dc = rcu_dereference(device->ldev->disk_conf);
-		max_segments = dc->max_bio_bvecs;
-		rcu_read_unlock();
+		max_segments = drbd_backing_dev_max_segments(device);
 
 		blk_set_stacking_limits(&q->limits);
 	}
 
 	blk_queue_max_hw_sectors(q, max_hw_sectors);
-	/* This is the workaround for "bio would need to, but cannot, be split" */
-	blk_queue_max_segments(q, max_segments ? max_segments : BLK_MAX_SEGMENTS);
+	blk_queue_max_segments(q, max_segments);
 	blk_queue_segment_boundary(q, PAGE_SIZE-1);
 	decide_on_discard_support(device, bdev);
 
-- 
2.39.2

