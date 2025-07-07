Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE641FBEAC
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851966; cv=none; b=MY174GH5Zvi4QEYR2LZGQSzdz59RNPlhlw3C2xJWDAR+qcgs17ZupX8UWmuKuWTUxoofFhk4I5GJX/9ruAQvX9X6T4QrvMf1DcodItfz+EJfkw8R7ThrKgZ8IOSc8drg+27ZQPNLtmvNnZNfCykl55NCgPZsdJYrhwlhMEX1JCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851966; c=relaxed/simple;
	bh=MBu1mejQ++tU50EgLNX9tCdC8Z1xzYjVDlz1gKR4WM0=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ezEc2rATjj4JIp1o9bmUBfuAf4Pv9SoA6GzpkVhkoR5i7aIzn+FlV4lrTb1qwrCZPpmjoAi1ZCmfAFlyLJQ8Cg1+KSMp3Lwcz7NGVDv7h+4QYjD0oBdwg5QQwMKWnO4QSVB4aRoeA97bbsp70uLwKMs/X+QmkAEloNubZHvfzlk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dq47mQzYQtwf
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:43 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 66B9E1A166B
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:42 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S13;
	Mon, 07 Jul 2025 09:32:42 +0800 (CST)
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
Subject: [PATCH v5 09/15] md/raid1: check bitmap before behind write
Date: Mon,  7 Jul 2025 09:27:05 +0800
Message-Id: <20250707012711.376844-10-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S13
X-Coremail-Antispam: 1UD129KBjvJXoWxAry8tr47Cr4xtF17Kw45Jrb_yoWrGryrpa
	9FqFn0krW5trW3XrnrAFykuFyrXw4ktF9rtrWfW34FgF12yr90gF4FgFyrCrnxA3sxCF45
	Zr4Yyr1UW3ySqFUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

behind write rely on bitmap, because the number of IO are recorded in
bitmap->behind_writes, and callers rely on bitmap_wait_behind_writes()
to wait for IO to be done.

However, currently callers doesn't check if bitmap is enabeld before
calling into behind methods. Hence if behind write start without bitmap,
readers will not wait for slow write IO to be done and old data can be
read in some corner cases.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  6 ------
 drivers/md/raid1.c     | 45 ++++++++++++++++++++++++++----------------
 2 files changed, 28 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index a079cbe2e6f1..5bd75fa6ee1d 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2049,9 +2049,6 @@ static void bitmap_start_behind_write(struct mddev *mddev)
 	struct bitmap *bitmap = mddev->bitmap;
 	int bw;
 
-	if (!bitmap)
-		return;
-
 	atomic_inc(&bitmap->behind_writes);
 	bw = atomic_read(&bitmap->behind_writes);
 	if (bw > bitmap->behind_writes_used)
@@ -2065,9 +2062,6 @@ static void bitmap_end_behind_write(struct mddev *mddev)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
-	if (!bitmap)
-		return;
-
 	if (atomic_dec_and_test(&bitmap->behind_writes))
 		wake_up(&bitmap->behind_wait);
 	pr_debug("dec write-behind count %d/%lu\n",
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a46ce996ea9c..015eabb502ec 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -1366,7 +1366,8 @@ static void raid1_read_request(struct mddev *mddev, struct bio *bio,
 				    (unsigned long long)r1_bio->sector,
 				    mirror->rdev->bdev);
 
-	if (test_bit(WriteMostly, &mirror->rdev->flags)) {
+	if (test_bit(WriteMostly, &mirror->rdev->flags) &&
+	    md_bitmap_enabled(mddev, false)) {
 		/*
 		 * Reading from a write-mostly device must take care not to
 		 * over-take any writes that are 'behind'
@@ -1452,6 +1453,30 @@ static bool wait_blocked_rdev(struct mddev *mddev, struct bio *bio)
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
+	if (!md_bitmap_enabled(mddev, false))
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
@@ -1612,22 +1637,8 @@ static void raid1_write_request(struct mddev *mddev, struct bio *bio,
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

