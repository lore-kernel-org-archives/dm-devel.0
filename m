Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C336218EB7
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851970; cv=none; b=HcRDdA+0b7B3s2sypgggHmmlbDdLIwr93aK6f7Aq3dTptdU+xcEh4AyiXIT+f7xmUQjTb3CFX1oCCOD6Hy5usKF58egb09z1bHdm3VL6x94nzQCtL+0K4YNzJE5PEIPh3y4GFcSWWTe4KOqMXRynpm/l3+JYImxGGW9xVej5BmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851970; c=relaxed/simple;
	bh=QYCuzQj36mgdTHmyj2WgNXVXzSnqWjjKe4HZbeg0pVk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=n2JYcx39+yYxU/Gjpacm4oXYXyxaTdOsD0xJyCndLq35wGAdbxdNRobOQhteolEcfzy+6btv82eBv3PuXsTmh/OUdUnMqrUn5L3jjxH2eYnVVAeF97FedRfTfrDQQeTPXD3yfKqyv61JWrwdpbCniGtmwm55NSRjhFCtyDJQAHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dn6DvszKHMjp
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id 54C7C1A0FA6
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S9;
	Mon, 07 Jul 2025 09:32:40 +0800 (CST)
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
Subject: [PATCH v5 05/15] md/md-bitmap: add a new parameter 'flush' to bitmap_ops->enabled
Date: Mon,  7 Jul 2025 09:27:01 +0800
Message-Id: <20250707012711.376844-6-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S9
X-Coremail-Antispam: 1UD129KBjvJXoWxZw47XFyUJr43Kr17GrWrGrg_yoW5Wr17p3
	9rta4Fkw15JFWag3W7AFWkua45tw1kt39rKFyfC34ruFy3ZFZ8WF4rGay8ta4vva43CFsx
	Za1rKFWUCF18WrJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	42IY6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCw
	CI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnI
	WIevJa73UjIFyTuYvjfUOyIUUUUUU
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The method is only used from raid1/raid10 IO path, to check if write
bio should be pluged, the parameter is always set to true for now,
following patch will use this helper in other context like updating
superblock.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 19 +++++++++++++------
 drivers/md/md-bitmap.h |  2 +-
 drivers/md/raid1-10.c  |  2 +-
 3 files changed, 15 insertions(+), 8 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 0ba1da35aa84..3f52716ea6f5 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -232,20 +232,27 @@ static inline char *bmname(struct bitmap *bitmap)
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
 }
 
-static bool __bitmap_enabled(struct bitmap *bitmap)
+static bool __bitmap_enabled(struct bitmap *bitmap, bool flush)
 {
-	return bitmap->storage.filemap &&
-	       !test_bit(BITMAP_STALE, &bitmap->flags);
+	if (!flush)
+		return true;
+
+	/*
+	 * If caller want to flush bitmap pages to underlying disks, check if
+	 * there are cached pages in filemap.
+	 */
+	return !test_bit(BITMAP_STALE, &bitmap->flags) &&
+	       bitmap->storage.filemap != NULL;
 }
 
-static bool bitmap_enabled(struct mddev *mddev)
+static bool bitmap_enabled(struct mddev *mddev, bool flush)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap)
 		return false;
 
-	return __bitmap_enabled(bitmap);
+	return __bitmap_enabled(bitmap, flush);
 }
 
 /*
@@ -1244,7 +1251,7 @@ static void __bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int writing = 0;
 
-	if (!__bitmap_enabled(bitmap))
+	if (!__bitmap_enabled(bitmap, true))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 0ceb9e97d21f..63d91831655f 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -62,7 +62,7 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
-	bool (*enabled)(struct mddev *mddev);
+	bool (*enabled)(struct mddev *mddev, bool flush);
 	int (*create)(struct mddev *mddev);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
 
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index b8b3a9069701..4ad051d49cdc 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -140,7 +140,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 	 * If bitmap is not enabled, it's safe to submit the io directly, and
 	 * this can get optimal performance.
 	 */
-	if (!mddev->bitmap_ops->enabled(mddev)) {
+	if (!mddev->bitmap_ops->enabled(mddev, true)) {
 		raid1_submit_write(bio);
 		return true;
 	}
-- 
2.39.2

