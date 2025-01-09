Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BAEC2AD31
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 02:02:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736388126; cv=none; b=IQQkrsCRhpXnZdhfOmClHL4ua6KSRjUhb+P33tv3Gg3roGcY4mt50MMtngtVvVmHT7fpKHbsrIwYXqHaSM5ZngrNHJt24nhbFOP7kggg4KMLKW6MiIHYVYeQkCHr0s82hnKVY2kGDHQKm2drBKPP0B2/urK8WdOrQEt54hJJWkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736388126; c=relaxed/simple;
	bh=uA5Mh5+XGUpvq5ARmPHPE95LrGPANLL4nGUm1OryI3Q=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJ94bOAoHeKQgEez7lGyXQoukxccozgG69TzFlCYxa+rp2ugt2gzO3kUOhuH1p7Cx05dWXuWqRHyVA7MOnzpToUrryb8K2+XMUhbPIOCoYSOTZntlG49hcqD6993BdejbWd0VKV5SZM1h0QdKPLBBOfETqEKaR4CXtJedTWJBsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YT7Ls2m38z4f3kFN
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 10:01:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 923CC1A14C5
	for <dm-devel@lists.linux.dev>; Thu,  9 Jan 2025 10:02:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgCnCl8XLn9nqDrAAQ--.985S7;
	Thu, 09 Jan 2025 10:02:01 +0800 (CST)
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
Subject: [PATCH v2 md-6.14 03/12] md/md-bitmap: add md_bitmap_registered/enabled() helper
Date: Thu,  9 Jan 2025 09:56:55 +0800
Message-Id: <20250109015704.216128-4-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250109015704.216128-1-yukuai1@huaweicloud.com>
References: <20250109015704.216128-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgCnCl8XLn9nqDrAAQ--.985S7
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF48KF47trW3Aw1xGrg_yoW5AFW3p3
	yDta43Cr45JFWag3W7AFWkuFyYqwn7tr9rKryfC34ruFy5ZFs8GF4rWayUt3Z7t343AFsx
	Zw45tr4UCr1UWF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42
	IY6I8E87Iv67AKxVW8JVWxJwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIev
	Ja73UjIFyTuYvjfUF3kuDUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

There are no functional changes, prepare to handle the case that
mddev->bitmap_ops can be NULL, which is possible after support to
build md-bitmap as kernel module.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 16 ++++------------
 drivers/md/md-bitmap.h | 19 ++++++++++++++++++-
 drivers/md/raid1-10.c  |  2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index bf6de7ad3b6a..4450edd9774f 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -220,22 +220,14 @@ static inline char *bmname(struct bitmap *bitmap)
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
 }
 
-static bool __bitmap_enabled(struct bitmap *bitmap)
+static bool bitmap_enabled(void *data)
 {
+	struct bitmap *bitmap = data;
+
 	return bitmap->storage.filemap &&
 	       !test_bit(BITMAP_STALE, &bitmap->flags);
 }
 
-static bool bitmap_enabled(struct mddev *mddev)
-{
-	struct bitmap *bitmap = mddev->bitmap;
-
-	if (!bitmap)
-		return false;
-
-	return __bitmap_enabled(bitmap);
-}
-
 /*
  * check a page and, if necessary, allocate it (or hijack it if the alloc fails)
  *
@@ -1232,7 +1224,7 @@ static void __bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int writing = 0;
 
-	if (!__bitmap_enabled(bitmap))
+	if (!bitmap_enabled(bitmap))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 5a2aa1324df0..3b242ee10856 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -71,7 +71,7 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
-	bool (*enabled)(struct mddev *mddev);
+	bool (*enabled)(void *data);
 	int (*create)(struct mddev *mddev, int slot);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
 
@@ -116,4 +116,21 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
+static inline bool md_bitmap_registered(struct mddev *mddev)
+{
+	return mddev->bitmap_ops != NULL;
+}
+
+static inline bool md_bitmap_enabled(struct mddev *mddev)
+{
+	/* bitmap_ops must be registered before creating bitmap. */
+	if (!md_bitmap_registered(mddev))
+		return false;
+
+	if (!mddev->bitmap)
+		return false;
+
+	return mddev->bitmap_ops->enabled(mddev->bitmap);
+}
+
 #endif
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 4378d3250bd7..6b8b7b7f1678 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -140,7 +140,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 	 * If bitmap is not enabled, it's safe to submit the io directly, and
 	 * this can get optimal performance.
 	 */
-	if (!mddev->bitmap_ops->enabled(mddev)) {
+	if (!md_bitmap_enabled(mddev)) {
 		raid1_submit_write(bio);
 		return true;
 	}
-- 
2.39.2

