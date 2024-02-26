Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EAC455C0E;
	Mon, 26 Feb 2024 10:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708943428; cv=none; b=uxTPOa6dwEhwl1V5941dQRZLf05VtZ2hbZdGA7u9LOgedHWoAGrRAgYnvXEMy/bGSHHOSGmNleBuTStmDO8JMn3yPh8vhDB/10LxImFNsxNRH3xsgIvMngS43Bxc0bOrX/rlIU54LyNG3p6JUMfmaAx0nGQJGDj7ESx1F5Zq3wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708943428; c=relaxed/simple;
	bh=sAQZjB2FrdR9yWdUZ57amA8cIo4bw5qf5i4kh29tRno=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ZG5xVUzenh3AjeQQeDX5q55wzutj0OLDCCUwg8mYRhRAsLC090lMajVNo15Hl4bgEMm8giC9mURmrQUcO1eIqISBmRUgq+nFr7gvCh57LKVzQv6cFwZGBFchrFzjrqjsHWC88UtMhVczhJMc/1+jS/aZXxfvF1V5hlgN1FF9LWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=N+7rBBMm; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="N+7rBBMm"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=r3ThMUbXihPrvcBcOHkCf9OCUiYRxiuGjTc7JZwm/9g=; b=N+7rBBMmM5a0PB2joJRIyFlX16
	JLg0/hMBVcEeQIp1b8+8JSZJPrGhqQNl/WErFu++TfYhCclPTbIr//9rSAcv7WUVk4cMn5mDwK32P
	qgTgfB9DTwa1dJtMey/jDERvHts9GHuuqKDeqYXeiImK782b6WhrrCXE4kv9Ua/J8RsQxpaLxU8nI
	o1B84kgjrTQ46vcs3OjxyKupMMsb3UdQE9zjlmLl+KSzkFRy0XOsvpaMDd1BZD2gHcj0DUhA94VdC
	ApCba11ze/JV6QjUvZlRA80hBP1KX8pu040scRn2QhoGj14YB4qGPh62XBA6+2r7p8pScq5X4xluq
	r0ctmohQ==;
Received: from 213-147-167-65.nat.highway.webapn.at ([213.147.167.65] helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1reYFc-000000004bp-27l0;
	Mon, 26 Feb 2024 10:30:25 +0000
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
Subject: [PATCH 03/16] dm: use queue_limits_set
Date: Mon, 26 Feb 2024 11:29:51 +0100
Message-Id: <20240226103004.281412-4-hch@lst.de>
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

Use queue_limits_set which validates the limits and takes care of
updating the readahead settings instead of directly assigning them to
the queue.  For that make sure all limits are actually updated before
the assignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 block/blk-settings.c  |  2 +-
 drivers/md/dm-table.c | 27 ++++++++++++---------------
 2 files changed, 13 insertions(+), 16 deletions(-)

diff --git a/block/blk-settings.c b/block/blk-settings.c
index 865fe4ebbf9b83..13865a9f89726c 100644
--- a/block/blk-settings.c
+++ b/block/blk-settings.c
@@ -267,7 +267,7 @@ int queue_limits_commit_update(struct request_queue *q,
 EXPORT_SYMBOL_GPL(queue_limits_commit_update);
 
 /**
- * queue_limits_commit_set - apply queue limits to queue
+ * queue_limits_set - apply queue limits to queue
  * @q:		queue to update
  * @lim:	limits to apply
  *
diff --git a/drivers/md/dm-table.c b/drivers/md/dm-table.c
index 41f1d731ae5ac2..88114719fe187a 100644
--- a/drivers/md/dm-table.c
+++ b/drivers/md/dm-table.c
@@ -1963,26 +1963,27 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	bool wc = false, fua = false;
 	int r;
 
-	/*
-	 * Copy table's limits to the DM device's request_queue
-	 */
-	q->limits = *limits;
-
 	if (dm_table_supports_nowait(t))
 		blk_queue_flag_set(QUEUE_FLAG_NOWAIT, q);
 	else
 		blk_queue_flag_clear(QUEUE_FLAG_NOWAIT, q);
 
 	if (!dm_table_supports_discards(t)) {
-		q->limits.max_discard_sectors = 0;
-		q->limits.max_hw_discard_sectors = 0;
-		q->limits.discard_granularity = 0;
-		q->limits.discard_alignment = 0;
-		q->limits.discard_misaligned = 0;
+		limits->max_hw_discard_sectors = 0;
+		limits->discard_granularity = 0;
+		limits->discard_alignment = 0;
+		limits->discard_misaligned = 0;
 	}
 
+	if (!dm_table_supports_write_zeroes(t))
+		limits->max_write_zeroes_sectors = 0;
+
 	if (!dm_table_supports_secure_erase(t))
-		q->limits.max_secure_erase_sectors = 0;
+		limits->max_secure_erase_sectors = 0;
+
+	r = queue_limits_set(q, limits);
+	if (r)
+		return r;
 
 	if (dm_table_supports_flush(t, (1UL << QUEUE_FLAG_WC))) {
 		wc = true;
@@ -2007,9 +2008,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	else
 		blk_queue_flag_set(QUEUE_FLAG_NONROT, q);
 
-	if (!dm_table_supports_write_zeroes(t))
-		q->limits.max_write_zeroes_sectors = 0;
-
 	dm_table_verify_integrity(t);
 
 	/*
@@ -2047,7 +2045,6 @@ int dm_table_set_restrictions(struct dm_table *t, struct request_queue *q,
 	}
 
 	dm_update_crypto_profile(q, t);
-	disk_update_readahead(t->md->disk);
 
 	/*
 	 * Check for request-based device is left to
-- 
2.39.2

