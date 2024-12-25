Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD0BB1BB6B3
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 11:19:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125602; cv=none; b=URL/yUtD/vam/bynibRScj8A0Xq+knbbvmhY8MEQAKzuY3/rqkjUy8zliVcD+AeUi1VWjJLZ4pUDciI4KORmCKMBN7u1kxo6Dgqoh+JnlkkCzCdxRmGBdGD2iOUqZyQ+vF5yYaJCnxooQzLSAicbPHz2KHZf3SCfizWYDgQRpp0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125602; c=relaxed/simple;
	bh=nfYhcN4VnYgejh0507vR1HLDHMpxqVVs9MZBZbBtOPk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=uNglm+eaRCXmvA1FftPC9GwB/f6LOvJdcfLBg8X4/WXY0g8bLHE9qLAGwwYMXxji5jHJ1Vp8YEYebETGo4ohUZS+wD6IA5eD++0uYzefz75TRbMVx/9uSvTi13XVCwe0HALkBw09+gGZrDnpNXvY3imaTR72GNbL6e8KOv+3Au8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4YJ8RW1rLmz4f3jsC
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id F183C1A0568
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:54 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S11;
	Wed, 25 Dec 2024 19:19:54 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com,
	agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	yukuai3@huawei.com
Cc: dm-devel@lists.linux.dev,
	linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.14 07/13] md/raid1: check bitmap before behind write
Date: Wed, 25 Dec 2024 19:15:40 +0800
Message-Id: <20241225111546.1833250-8-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
References: <20241225111546.1833250-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S11
X-Coremail-Antispam: 1UD129KBjvJXoWxJFWUuF17Xr47ZFWfGF1rJFb_yoWrJF1kpa
	yqqFn0krW5trW3XrnrAFykuFyrXw4ktF9rtrWfW34FgF12ywn0gF4FgFyrGrnxA3sxCF45
	Zw4Yyr1UWrWSqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUma14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkE
	bVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsG
	vfC2KfnxnUUI43ZEXa7VUbPC7UUUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

behind write rely on bitmap, because the number of IO are recoreded in
bitmap->behind_writes, and callers rely on bitmap_wait_behind_writes()
to wait for IO to be done.

Hence if behind write start without bitmap, readers will not wait for
the IO to be done because bitmap_wait_behind_writes() do nothing,
and old data can be read.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  6 ------
 drivers/md/raid1.c     | 45 ++++++++++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f87236225826..72cbbe0d3408 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2031,9 +2031,6 @@ static void bitmap_start_behind_write(struct mddev *mddev)
 	struct bitmap *bitmap = mddev->bitmap;
 	int bw;
 
-	if (!bitmap)
-		return;
-
 	atomic_inc(&bitmap->behind_writes);
 	bw = atomic_read(&bitmap->behind_writes);
 	if (bw > bitmap->behind_writes_used)
@@ -2047,9 +2044,6 @@ static void bitmap_end_behind_write(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
-	if (!bitmap)
-		return;
-
 	if (atomic_dec_and_test(&bitmap->behind_writes))
 		wake_up(&bitmap->behind_wait);
 	pr_debug("dec write-behind count %d/%lu\n",
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a931e52bdfe3..bb1cadfcf54b 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1369,7 +1369,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 				    (unsigned long long)r1_bio->sector,
 				    mirror->rdev->bdev);
 
-	if (test_bit(WriteMostly, &mirror->rdev->flags)) {
+	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
+	    md_bitmap_enabled(mddev)) {
 		/*
 		 * Reading from a write-mostly device must take care not to
 		 * over-take any writes that are 'behind'
@@ -1456,6 +1457,30 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
 	return true;
 }
 
+static void raid1_start_write_behind(struct mddev *mddev, struct r1bio *r1_bio,
+				     struct bio *bio)
+{
+	unsigned long max_write_behind = mddev->bitmap_info.max_write_behind;
+	struct md_bitmap_stats stats;
+	int err;
+
+	/* behind write rely on bitmap, see bitmap_operations */
+	if (!md_bitmap_enabled(mddev))
+		return;
+
+	err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
+	if (err)
+		return;
+
+	/* Don't do behind IO if reader is waiting, or there are too many. */
+	if (!stats.behind_wait && stats.behind_writes < max_write_behind)
+		alloc_behind_master_bio(r1_bio, bio);
+
+	if (test_bit(R1BIO_BehindIO, &r1_bio->state))
+		mddev->bitmap_ops->start_behind_write(mddev);
+
+}
+
 static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 				int max_write_sectors)
 {
@@ -1629,22 +1654,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
 			continue;
 
 		if (first_clone) {
-			unsigned long max_write_behind =
-				mddev->bitmap_info.max_write_behind;
-			struct md_bitmap_stats stats;
-			int err;
-
-			/* do behind I/O ?
-			 * Not if there are too many, or cannot
-			 * allocate memory, or a reader on WriteMostly
-			 * is waiting for behind writes to flush */
-			err = mddev->bitmap_ops->get_stats(mddev->bitmap, &stats);
-			if (!err && write_behind && !stats.behind_wait &&
-			    stats.behind_writes < max_write_behind)
-				alloc_behind_master_bio(r1_bio, bio);
-
-			if (test_bit(R1BIO_BehindIO, &r1_bio->state))
-				mddev->bitmap_ops->start_behind_write(mddev);
+			if (write_behind)
+				raid1_start_write_behind(mddev, r1_bio, bio);
 			first_clone = 0;
 		}
 
-- 
2.39.2

