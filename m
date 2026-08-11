Received: from mail-m49197.qiye.163.com (mail-m49197.qiye.163.com [45.254.49.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAB0738AC64
	for <dm-devel@lists.linux.dev>; Tue, 11 Aug 2026 03:14:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786418081; cv=none; b=R2yXuw7nOY8KD8XH5LbKw134dfZ6eUxWPo+kNfstFMNYB2fhYbpgGHFH1M8I/GS15KPsx3KwkZqT+WaBJSQzXONVmALe57aAQQ/1InFC3vfkU0SlicQQpVyBed0WlAR3Um6w4S05TGS2oC35ouG5P/Wdq7gOFkhiyHT7SZZL2M8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786418081; c=relaxed/simple;
	bh=B7Fh/q+gK5/q26mqh5exJkJWAAkIDHpDaVSVcwzy6Tg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=BiVnHvl5cM2Qrc50HPLfaUT6QGAMQY9X+sQ2/rLzFNNQrVMIHHeFetk8L8Sq2cTiB2C0KxiI0A7wFHq3HKKF6xKzlyB+NB7l9cRxkDPFHsjbJ2oir3WZ0Ebt+DL575QE0Vb13vxQSGrcv1LrKD0Vluw8WDqkgsT1/X3RZ4IM/VA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn; spf=pass smtp.mailfrom=seu.edu.cn; dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b=DQKNBov5; arc=none smtp.client-ip=45.254.49.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=seu.edu.cn
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=seu.edu.cn header.i=@seu.edu.cn header.b="DQKNBov5"
Received: from PC-202605011814.localdomain (unknown [223.112.146.162])
	by smtp.qiye.163.com (Hmail) with ESMTP id 49800b390;
	Tue, 11 Aug 2026 11:14:28 +0800 (GMT+08:00)
From: Runyu Xiao <runyu.xiao@seu.edu.cn>
To: Alasdair Kergon <agk@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Cc: Bart Van Assche <bvanassche@acm.org>,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jianhao Xu <jianhao.xu@seu.edu.cn>
Subject: [PATCH v2] dm-crypt: refactor buffer allocation retry handling
Date: Tue, 11 Aug 2026 11:14:21 +0800
Message-Id: <20260811031421.319489-1-runyu.xiao@seu.edu.cn>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <cc5ed697-e769-4f40-aa9c-19c90b79fa7b@acm.org>
References: <cc5ed697-e769-4f40-aa9c-19c90b79fa7b@acm.org>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9feed07c2a03a1kunm58a3c517cd1c3
X-HM-MType: 10
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWRgWCB1ZQUpXWS1ZQUlXWQ8JGhUIEh9ZQVkaGUsZVkNPSx0ZTR9DGBlNQ1YeHw
	5VEwETFhoSFyQUDg9ZV1kYEgtZQVlJSUhVSkpJVUpPTVVKTUlZV1kWGg8SFR0UWUFZT0tIVUJCSU
	5LVUpLS1VKQktCWQY+
DKIM-Signature: a=rsa-sha256;
	b=DQKNBov5KFutFP/LGAgzY8rUFtmPIjX0pToJt8fYLlU6osM0NUrEnaU99mOjPCvgl3Z5E7PPpOk/Mg5fhiPMub9ouIFm5E9i+AfUWiuhkCVzyFaoXTbAugkvfz2P396hibz6Jx0J0CDftEFOwJc/MaXUO/Lspg3JpezZ06a2gig=; s=default; c=relaxed/relaxed; d=seu.edu.cn; v=1;
	bh=OyBGjozRF8NAlVCDeJEHW6X2zJvyesn7HFxJp7P3adg=;
	h=date:mime-version:subject:message-id:from;

crypt_alloc_buffer() conditionally acquires bio_alloc_lock around the
allocation path and also contains the retry logic for the reclaim
fallback.

Move one allocation attempt into crypt_alloc_buffer_try() so that
bio_alloc_lock is always acquired and released in crypt_alloc_buffer(),
and the retry decision is made only after the mutex has been dropped.

This keeps the retry path outside the locked region and makes the
locking context easier to analyze.

Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>

---
Changes in v2:
- Move one allocation attempt into crypt_alloc_buffer_try(), as suggested
  by Bart Van Assche.
- Keep bio_alloc_lock acquisition and release in crypt_alloc_buffer(), and
  make the retry decision only after releasing the lock.
- Preserve the distinction between a page-pool retry and a final integrity
  allocation failure.

v1: https://lore.kernel.org/r/20260809051839.3504080-1-runyu.xiao@seu.edu.cn

diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 608b617fb817..7c68fad12960 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -1627,18 +1627,16 @@ static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone);
  * In order to reduce allocation overhead, we try to allocate compound pages in
  * the first pass. If they are not available, we fall back to the mempool.
  */
-static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
+static struct bio *crypt_alloc_buffer_try(struct dm_crypt_io *io,
+					  unsigned int size, gfp_t gfp_mask,
+					  unsigned int order, bool *retry)
 {
 	struct crypt_config *cc = io->cc;
 	struct bio *clone;
 	unsigned int nr_iovecs = (size + PAGE_SIZE - 1) >> PAGE_SHIFT;
-	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
 	unsigned int remaining_size;
-	unsigned int order = MAX_PAGE_ORDER;
 
-retry:
-	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
-		mutex_lock(&cc->bio_alloc_lock);
+	*retry = false;
 
 	clone = bio_alloc_bioset(cc->dev->bdev, nr_iovecs, io->base_bio->bi_opf,
 				 GFP_NOIO, &cc->bs);
@@ -1674,9 +1672,8 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 		if (!pages) {
 			crypt_free_buffer_pages(cc, clone);
 			bio_put(clone);
-			gfp_mask |= __GFP_DIRECT_RECLAIM;
-			order = 0;
-			goto retry;
+			*retry = true;
+			return NULL;
 		}
 
 have_pages:
@@ -1692,12 +1689,34 @@ static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
 		clone = NULL;
 	}
 
-	if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
-		mutex_unlock(&cc->bio_alloc_lock);
-
 	return clone;
 }
 
+static struct bio *crypt_alloc_buffer(struct dm_crypt_io *io, unsigned int size)
+{
+	struct crypt_config *cc = io->cc;
+	struct bio *clone;
+	gfp_t gfp_mask = GFP_NOWAIT | __GFP_HIGHMEM;
+	unsigned int order = MAX_PAGE_ORDER;
+	bool retry;
+
+	for (;;) {
+		if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
+			mutex_lock(&cc->bio_alloc_lock);
+
+		clone = crypt_alloc_buffer_try(io, size, gfp_mask, order, &retry);
+
+		if (unlikely(gfp_mask & __GFP_DIRECT_RECLAIM))
+			mutex_unlock(&cc->bio_alloc_lock);
+
+		if (!retry)
+			return clone;
+
+		gfp_mask |= __GFP_DIRECT_RECLAIM;
+		order = 0;
+	}
+}
+
 static void crypt_free_buffer_pages(struct crypt_config *cc, struct bio *clone)
 {
 	struct folio_iter fi;
-- 
2.34.1
