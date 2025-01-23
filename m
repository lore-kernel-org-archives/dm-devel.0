Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05B3F1C2BD
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 02:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737598403; cv=none; b=j68R8n/OKE51xwiuwmip7lDvZ6SSL6ZdtVejLdVYQjMUI7j/TMCrSdKwV3n97H0uRfyAdfJFMi6b48WLlwLoJAOg9PYGg+fPtn08taVGn/Y7iANfx5+IMW4BscuBMU0qCIXVKo0uM4T+RHDejJr5hYvbxAls4qqdcoWX+wD9moA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737598403; c=relaxed/simple;
	bh=3SFOrsjQF4HrzruxXJTlhZKA/xezoD9Lf4rRPOYVGyE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RMF/FB/VZZwc0NlELj1V0Naaa2jpH8zWwQG8+CGE7k5HjYLBcXm5d3cKivl+Q9LVZub2PE4b7bRa/bvGYOJ8vHnVNWdtqLEeTR0JdijxdSCYxwZoNICJ43+Am7D8zTy0GXvd8HhPV0XPdhqtApuwM3MG+btEGnAW9Mi0x+rYSUk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YdkxP0Lqlz4f3jLX
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:12:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id EFAB91A1873
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:18 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+7pZFno+znBg--.59488S8;
	Thu, 23 Jan 2025 10:13:18 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: song@kernel.org,
	yukuai3@huawei.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com
Cc: linux-raid@vger.kernel.org,
	dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v3 md-6.15 04/11] md/md-bitmap: handle the case bitmap is not enabled before start_sync()
Date: Thu, 23 Jan 2025 10:07:23 +0800
Message-Id: <20250123020730.2003602-5-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250123020730.2003602-1-yukuai1@huaweicloud.com>
References: <20250123020730.2003602-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgA3m1+7pZFno+znBg--.59488S8
X-Coremail-Antispam: 1UD129KBjvJXoW3Gr1UKF15uryrJw15uryrtFb_yoW7ArWrpw
	s7JFy3Kw45WFW5X3W7AFyDuFyFv3srtFZrtr1fW34fWFykGFykAF48WFyjqFyqgFyFyF98
	X3Z8AF45CFyaqFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This case can be handled without knowing internal implementation.

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  8 +-------
 drivers/md/md-bitmap.h | 12 ++++++++++++
 drivers/md/raid1.c     |  6 +++---
 drivers/md/raid10.c    | 15 ++++++---------
 drivers/md/raid5.c     |  7 ++-----
 5 files changed, 24 insertions(+), 24 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 8e14bbfbfc88..33f952c78397 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1769,15 +1769,9 @@ static bool __bitmap_start_sync(struct bitmap *bitmap, sector_t offset,
 				sector_t *blocks, bool degraded)
 {
 	bitmap_counter_t *bmc;
-	bool rv;
+	bool rv = false;
 
-	if (bitmap == NULL) {/* FIXME or bitmap set as 'failed' */
-		*blocks = 1024;
-		return true; /* always resync if no bitmap */
-	}
 	spin_lock_irq(&bitmap->counts.lock);
-
-	rv = false;
 	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
 	if (bmc) {
 		/* locked */
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 3b242ee10856..6a5806ebb11a 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -133,4 +133,16 @@ static inline bool md_bitmap_enabled(struct mddev *mddev)
 	return mddev->bitmap_ops->enabled(mddev->bitmap);
 }
 
+static inline bool md_bitmap_start_sync(struct mddev *mddev, sector_t offset,
+					sector_t *blocks, bool degraded)
+{
+	/* always resync if no bitmap */
+	if (!md_bitmap_enabled(mddev)) {
+		*blocks = 1024;
+		return true;
+	}
+
+	return mddev->bitmap_ops->start_sync(mddev, offset, blocks, degraded);
+}
+
 #endif
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 49960fbcffca..f6943849f34a 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2827,7 +2827,7 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 	/* before building a request, check if we can skip these blocks..
 	 * This call the bitmap_start_sync doesn't actually record anything
 	 */
-	if (!mddev->bitmap_ops->start_sync(mddev, sector_nr, &sync_blocks, true) &&
+	if (!md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, true) &&
 	    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
 		/* We can skip this block, and probably several more */
 		*skipped = 1;
@@ -3002,8 +3002,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		if (len == 0)
 			break;
 		if (sync_blocks == 0) {
-			if (!mddev->bitmap_ops->start_sync(mddev, sector_nr,
-						&sync_blocks, still_degraded) &&
+			if (!md_bitmap_start_sync(mddev, sector_nr,
+						  &sync_blocks, still_degraded) &&
 			    !conf->fullsync &&
 			    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
 				break;
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 8d4d19012f42..ca594d56f8d0 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3358,9 +3358,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			 * we only need to recover the block if it is set in
 			 * the bitmap
 			 */
-			must_sync = mddev->bitmap_ops->start_sync(mddev, sect,
-								  &sync_blocks,
-								  true);
+			must_sync = md_bitmap_start_sync(mddev, sect,
+							 &sync_blocks, true);
 			if (sync_blocks < max_sync)
 				max_sync = sync_blocks;
 			if (!must_sync &&
@@ -3403,9 +3402,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 				}
 			}
 
-			must_sync = mddev->bitmap_ops->start_sync(mddev, sect,
-						&sync_blocks, still_degraded);
-
+			md_bitmap_start_sync(mddev, sect, &sync_blocks,
+					     still_degraded);
 			any_working = 0;
 			for (j=0; j<conf->copies;j++) {
 				int k;
@@ -3581,9 +3579,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
-		if (!mddev->bitmap_ops->start_sync(mddev, sector_nr,
-						   &sync_blocks,
-						   mddev->degraded) &&
+		if (!md_bitmap_start_sync(mddev, sector_nr, &sync_blocks,
+					  mddev->degraded) &&
 		    !conf->fullsync && !test_bit(MD_RECOVERY_REQUESTED,
 						 &mddev->recovery)) {
 			/* We can skip this block */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8f33d2478d94..5b825c196b56 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6534,8 +6534,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 	}
 	if (!test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    !conf->fullsync &&
-	    !mddev->bitmap_ops->start_sync(mddev, sector_nr, &sync_blocks,
-					   true) &&
+	    !md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, true) &&
 	    sync_blocks >= RAID5_STRIPE_SECTORS(conf)) {
 		/* we can skip this block, and probably more */
 		do_div(sync_blocks, RAID5_STRIPE_SECTORS(conf));
@@ -6566,9 +6565,7 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 			still_degraded = true;
 	}
 
-	mddev->bitmap_ops->start_sync(mddev, sector_nr, &sync_blocks,
-				      still_degraded);
-
+	md_bitmap_start_sync(mddev, sector_nr, &sync_blocks, still_degraded);
 	set_bit(STRIPE_SYNC_REQUESTED, &sh->state);
 	set_bit(STRIPE_HANDLE, &sh->state);
 
-- 
2.39.2

