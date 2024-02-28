Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C986E7290B;
	Wed, 28 Feb 2024 22:56:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709161017; cv=none; b=a4Qf3RUqRx52AiB3VH19KOlJrBd7I2Yk+au9a28JgniK46JE016RcpjBdUWpphWVY23/qA7qsdy8KStM6dwb59y2gK3e9osp49GgdbKCs/418TBVsh2UqlEXU+irB/YKd66K2qzyMntd38vwZWuIV3KC3DDyzSNkSfNWgAhhJPo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709161017; c=relaxed/simple;
	bh=Tv5mg8OHXTqQlH1yt2ga15Ej1aysgGRUUX0AqSIj+jk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=h0T+B5s5htgncCVBf/j9cxTnY9w9M+2zsMQdPyehFNHmIjuYaGqX8H/pzBahNq3XGWQvJLbNUrhBSKC6UGMRia/z6FQcxVynmLPdAbJk/LbyNrnyjc01symYGhtqipaT2NnOTy/n1b0J9jy0UVbDqwH/tv6TS6fmjnj//QzKZVw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=wxqXIxMw; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="wxqXIxMw"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=alNyR++8q090hPNGb0IaHU3evv2TI7AvlERQygPpLlg=; b=wxqXIxMwNAF3l+D8gw8NQzEYFS
	2Ex62B5lHRVRk6LKinvaEzsOCo2MXOOpbjhwsDS+05GEzNyeVC+P+6H6HUnKgkYLiSGv5WT1vgqbB
	lvs81dJgovru/FYXVxwLGG6ts5y0kkpq1fN5jMB1X1dcKwPuWrAGtm8ASH1MMTPF5OqWWz06BNfmN
	mbEc64Wsa3X6iuo4mRFAKj6Z0bkkvcOxKDDB4gq5PLZaj0uzXENpAti3EYJuC88N3MejNV+0suySZ
	WW3styGYH+qREAWqpG+O8cSZyDzzC0tlrWSbDMMPLXA7TMPF9rmhqckgpAgOdH3IgT1VVQTFDFfs2
	cnyhodLg==;
Received: from [4.28.11.157] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfSr8-0000000BCNq-2XG3;
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
Subject: [PATCH 03/14] dm: use queue_limits_set
Date: Wed, 28 Feb 2024 14:56:42 -0800
Message-Id: <20240228225653.947152-4-hch@lst.de>
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

Use queue_limits_set which validates the limits and takes care of
updating the readahead settings instead of directly assigning them to
the queue.  For that make sure all limits are actually updated before
the assignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
Reviewed-by: Mike Snitzer <snitzer@kernel.org>
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

