Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B114823C5;
	Fri, 23 Feb 2024 16:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708704788; cv=none; b=gBUI63iYgPVe7UzBpnCE2Gqi1SKPAO42Wjd8NwwZ4VqH9F8+P8PNWeBe43bQM91X7jr3mv/1YCa02aT1e/TvA+TgTB/OlbZ8tAjGoG2whxqmv9hkut8NyeIL6kf0ebHpzxGtPJUf013BzVS/QPBdUIZJNaVZZjiuSLU5DtKFm7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708704788; c=relaxed/simple;
	bh=CtypFnQPMSf6cTJp+3omQp0mUZrVL+FWefDyt1O5jo0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BC7/WvsR2IZFb5IbeC1GqSWXZRKG3beJ8hc5OeFZ5VuhlS38quO39OZeYljxUyp09CuG0Ziq+/M/c19D8i6Yo6ylbnOM71U5Ly4ZV6sJ/DcxjrjSs8Csw59H8jV8zxGpVTlq3IZCjHwEZ6FKEAu4TKrIWpZBMft0mwONGk+V6wE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Ztmztu1q; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Ztmztu1q"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender
	:Reply-To:Content-Type:Content-ID:Content-Description;
	bh=3IGcs6hbpkpzypLQ9cJmuxoia8QbDd1hniPlxwkl9Zc=; b=Ztmztu1qh5UdEsyQQBPgwnBb0Y
	f4vTMtHjfDEt2xlO6nR6Yrr7tn5wHGKDCCsT2kt6v2VHRT3g4SBsQsJFwtOKTSjkSB+4SM6FzTh3U
	3L09a3usY9FEdV+2sKeVJzIFfM0lBmWZBhfUp/IVUNk86ssa2zpEcyE0Rd05TANEhRLqv1QNkr+nG
	98A3wxvJhTJLZjWwIFy1ZS7HjkyiWMweGSei83QQpk8yY976ZHUDSlTWM43AzMFWn8jLr/YO1uzlb
	F45Epklh5HHoYALdXyTp7WQGB0npYk3gOeu70eYKpA5CE9WRxhdqpxSaXLYCgx1umzbdSB1uLZRry
	NPWe+84Q==;
Received: from [2001:4bb8:19a:62b2:c70:4a89:bc61:3] (helo=localhost)
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rdYAb-0000000AAi6-1Zkp;
	Fri, 23 Feb 2024 16:13:05 +0000
From: Christoph Hellwig <hch@lst.de>
To: Jens Axboe <axboe@kernel.dk>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai3@huawei.com>
Cc: dm-devel@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org
Subject: [PATCH 3/9] dm: use queue_limits_set
Date: Fri, 23 Feb 2024 17:12:41 +0100
Message-Id: <20240223161247.3998821-4-hch@lst.de>
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

Use queue_limits_set which validates the limits and takes care of
updating the readahead settings instead of directly assigning them to
the queue.  For that make sure all limits are actually updated before
the assignment.

Signed-off-by: Christoph Hellwig <hch@lst.de>
---
 drivers/md/dm-table.c | 27 ++++++++++++---------------
 1 file changed, 12 insertions(+), 15 deletions(-)

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

