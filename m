Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93F201C2335
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851964; cv=none; b=AcYW+nvrAwlWdUAE6VDpa9bX4w5Dfwy3R87HVifHNeb44S70+O+zHw8xgDd/ujYUvFZQYpCrsvnavcl7rjgsU+hIurICexYVAMQHik6tW776ISyboCwFuqEKSjFw9Z2pkQvzNARQibTTOPzsZECHX52MdmGsH7WVLq/QNVkHMus=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851964; c=relaxed/simple;
	bh=3aIcq7J0empgvfqFLuVssNirgPyNfNfrxb7fWSBP3gw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=e9bxAV+V7Hd2zWGKztZTeP+FxvEhdlT3/42KJDeKIdfb1Gg69zB7+UG6WtPjaAClQBl851j9i6SnBHxoglKBhjuAm/NMSwVHEKopD1G0VELGvoUWXE/dch4JAAZzD5KRkI2pzekWUwBFri/kzM9Wj7OX9qvHWjBnOhvUPuNFxCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dp08BczYQtwf
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:41 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id CE8E61A1B94
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:40 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S10;
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
Subject: [PATCH v5 06/15] md/md-bitmap: add md_bitmap_registered/enabled() helper
Date: Mon,  7 Jul 2025 09:27:02 +0800
Message-Id: <20250707012711.376844-7-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S10
X-Coremail-Antispam: 1UD129KBjvJXoWxur1UJF48KF47uFW5ur1ftFb_yoW5Zr17p3
	98Ja45Cr15JFWaga17AFyDua4Yqwn7tr9rtFyfC34ruFy3ZFs8GF4rGay0y3Z7X343AFsx
	Xr15Kr1UCrWUWr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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

There are no functional changes, prepare to handle the case that
mddev->bitmap_ops can be NULL, which is possible after introducing
CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 16 ++++------------
 drivers/md/md-bitmap.h | 19 ++++++++++++++++++-
 drivers/md/raid1-10.c  |  2 +-
 3 files changed, 23 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 3f52716ea6f5..da2dcb3d2122 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -232,8 +232,10 @@ static inline char *bmname(struct bitmap *bitmap)
 	return bitmap->mddev ? mdname(bitmap->mddev) : "mdX";
 }
 
-static bool __bitmap_enabled(struct bitmap *bitmap, bool flush)
+static bool bitmap_enabled(void *data, bool flush)
 {
+	struct bitmap *bitmap = data;
+
 	if (!flush)
 		return true;
 
@@ -245,16 +247,6 @@ static bool __bitmap_enabled(struct bitmap *bitmap, bool flush)
 	       bitmap->storage.filemap != NULL;
 }
 
-static bool bitmap_enabled(struct mddev *mddev, bool flush)
-{
-	struct bitmap *bitmap = mddev->bitmap;
-
-	if (!bitmap)
-		return false;
-
-	return __bitmap_enabled(bitmap, flush);
-}
-
 /*
  * check a page and, if necessary, allocate it (or hijack it if the alloc fails)
  *
@@ -1251,7 +1243,7 @@ static void __bitmap_unplug(struct bitmap *bitmap)
 	int dirty, need_write;
 	int writing = 0;
 
-	if (!__bitmap_enabled(bitmap, true))
+	if (!bitmap_enabled(bitmap, true))
 		return;
 
 	/* look at each page to see if there are any set bits that need to be
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 63d91831655f..a36ed32ec0d5 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -62,7 +62,7 @@ struct md_bitmap_stats {
 };
 
 struct bitmap_operations {
-	bool (*enabled)(struct mddev *mddev, bool flush);
+	bool (*enabled)(void *data, bool flush);
 	int (*create)(struct mddev *mddev);
 	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
 
@@ -107,4 +107,21 @@ struct bitmap_operations {
 /* the bitmap API */
 void mddev_set_bitmap_ops(struct mddev *mddev);
 
+static inline bool md_bitmap_registered(struct mddev *mddev)
+{
+	return mddev->bitmap_ops != NULL;
+}
+
+static inline bool md_bitmap_enabled(struct mddev *mddev, bool flush)
+{
+	/* bitmap_ops must be registered before creating bitmap. */
+	if (!md_bitmap_registered(mddev))
+		return false;
+
+	if (!mddev->bitmap)
+		return false;
+
+	return mddev->bitmap_ops->enabled(mddev->bitmap, flush);
+}
+
 #endif
diff --git a/drivers/md/raid1-10.c b/drivers/md/raid1-10.c
index 4ad051d49cdc..0ad8b28ab7c2 100644
--- a/drivers/md/raid1-10.c
+++ b/drivers/md/raid1-10.c
@@ -140,7 +140,7 @@ static inline bool raid1_add_bio_to_plug(struct mddev *mddev, struct bio *bio,
 	 * If bitmap is not enabled, it's safe to submit the io directly, and
 	 * this can get optimal performance.
 	 */
-	if (!mddev->bitmap_ops->enabled(mddev, true)) {
+	if (!md_bitmap_enabled(mddev, true)) {
 		raid1_submit_write(bio);
 		return true;
 	}
-- 
2.39.2

