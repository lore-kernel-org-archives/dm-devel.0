Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CFB32206B2
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851973; cv=none; b=Ajo3lI/Z8ZEIOezVFfK5ZJhXKPV+sVx3OtDxBJbKUykrOnFeLHekjWJr8QLCQ2YDp811+m5b+ACvT7SZjOqVZOdKeavKSAgkPVSWv+wgCzN2wKvERuUo4amKiGjkX2XP274kQEiqz5IlfnY3c5OioDhnI3PCCF7VzP3itc+l6tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851973; c=relaxed/simple;
	bh=AAfTqENMwUfW8Sza0yAJ9bh9YlilEmpT1iIe7eKjvLM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=iXznfJKbwjXWjdaTN8SENMX4YUlUcxlantqOtOHvZay/I8yLaNtwk9/FXKyu1HqLTlDigeY+qIcz15cC2vm16dhT/eeKzwFVo+vfeJeRQT8sirC3mCiZVc/ov3a1GN7u9tQOuzsZaq0VjAY76UwxaR7hBdJQjrc8wJh4ehY7Nc8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dq31PFzKHMbt
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id D9FB61A0FA6
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:41 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S12;
	Mon, 07 Jul 2025 09:32:41 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	johnny.chenyi@huawei.com
Subject: [PATCH v5 08/15] md/md-bitmap: handle the case bitmap is not enabled before end_sync()
Date: Mon,  7 Jul 2025 09:27:04 +0800
Message-Id: <20250707012711.376844-9-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250707012711.376844-1-yukuai1@huaweicloud.com>
References: <20250707012711.376844-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S12
X-Coremail-Antispam: 1UD129KBjvJXoWxXryfuF1DXryxXryrCrW3ZFb_yoWrXr18p3
	9rJFW3uw17WFW5Xa1UZrykuFyFvwnrtF9FyFyxW3s3uFykXF9rJF4rGFyjqr1qka4SyFZ8
	Xa45CrW5CF1UWrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

This case can be handled without knowing internal implementation.

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  4 ----
 drivers/md/md-bitmap.h | 11 +++++++++++
 drivers/md/raid1.c     |  6 +++---
 drivers/md/raid10.c    |  8 +++-----
 drivers/md/raid5.c     |  4 ++--
 5 files changed, 19 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ee676d4670ea..a079cbe2e6f1 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1838,10 +1838,6 @@ static void __bitmap_end_sync(struct bitmap *bitmap, sector_t offset,
 	bitmap_counter_t *bmc;
 	unsigned long flags;
 
-	if (bitmap == NULL) {
-		*blocks = 1024;
-		return;
-	}
 	spin_lock_irqsave(&bitmap->counts.lock, flags);
 	bmc = md_bitmap_get_counter(&bitmap->counts, offset, blocks, 0);
 	if (bmc == NULL)
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 7a16de62ee35..61cfc650c69c 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -136,4 +136,15 @@ static inline bool md_bitmap_start_sync(struct mddev *mddev, sector_t offset,
 	return mddev->bitmap_ops->start_sync(mddev, offset, blocks, degraded);
 }
 
+static inline void md_bitmap_end_sync(struct mddev *mddev, sector_t offset,
+				      sector_t *blocks)
+{
+	if (!md_bitmap_enabled(mddev, false)) {
+		*blocks = 1024;
+		return;
+	}
+
+	mddev->bitmap_ops->end_sync(mddev, offset, blocks);
+}
+
 #endif
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index 1f3f2046afe0..a46ce996ea9c 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -2056,7 +2056,7 @@ static void abort_sync_write(struct mddev *mddev, struct r1bio *r1_bio)
 
 	/* make sure these bits don't get cleared. */
 	do {
-		mddev->bitmap_ops->end_sync(mddev, s, &sync_blocks);
+		md_bitmap_end_sync(mddev, s, &sync_blocks);
 		s += sync_blocks;
 		sectors_to_go -= sync_blocks;
 	} while (sectors_to_go > 0);
@@ -2803,8 +2803,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * We can find the current addess in mddev->curr_resync
 		 */
 		if (mddev->curr_resync < max_sector) /* aborted */
-			mddev->bitmap_ops->end_sync(mddev, mddev->curr_resync,
-						    &sync_blocks);
+			md_bitmap_end_sync(mddev, mddev->curr_resync,
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 764a8d99c45e..c0aa19935881 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3216,15 +3216,13 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 
 		if (mddev->curr_resync < max_sector) { /* aborted */
 			if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery))
-				mddev->bitmap_ops->end_sync(mddev,
-							    mddev->curr_resync,
-							    &sync_blocks);
+				md_bitmap_end_sync(mddev, mddev->curr_resync,
+						   &sync_blocks);
 			else for (i = 0; i < conf->geo.raid_disks; i++) {
 				sector_t sect =
 					raid10_find_virt(conf, mddev->curr_resync, i);
 
-				mddev->bitmap_ops->end_sync(mddev, sect,
-							    &sync_blocks);
+				md_bitmap_end_sync(mddev, sect, &sync_blocks);
 			}
 		} else {
 			/* completed sync */
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8168acf7d3e7..156504ed0dd4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6492,8 +6492,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		}
 
 		if (mddev->curr_resync < max_sector) /* aborted */
-			mddev->bitmap_ops->end_sync(mddev, mddev->curr_resync,
-						    &sync_blocks);
+			md_bitmap_end_sync(mddev, mddev->curr_resync,
+					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
 		mddev->bitmap_ops->close_sync(mddev);
-- 
2.39.2

