Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82AEC168DA
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 02:13:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737598404; cv=none; b=I5yXS3YFgVTmbhkGCbD1OjNsKX/urv6QT7Sc/EmKp7FfdyWUU8rH3n8JUkblRoghHHUFmP0e3qOTxYCPsUWNSaPLN4VHiT03zTWDQeiqQnIuiXTPxrEJ4W3Us5Zjrx5HmRkXVbYRZLWSV85AWSu1gl0g/uw55PMe7il2i3q/ESg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737598404; c=relaxed/simple;
	bh=pm5Slt+znNC5SPnFqwk7Wf51U1EHBt58KIWvpUjsnZk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SiMFGIQt8ErKOlHgJeCM2LDHmDDyn+REZSe8tWolFNiZxS8/ItlPlxUFNv0Afv6yP8lZYBUSXMioFlDcMTlolLBXfHQsm/Sh3eaTreayUgbQeL5ETcsQcmeybnjQ+LwQGmpOYaCVjyFJtHoK0VaoKsiy1Pye5bm3vGdp5rnguqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YdkxV0Q23z4f3jqx
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:02 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 82C971A108A
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+7pZFno+znBg--.59488S5;
	Thu, 23 Jan 2025 10:13:17 +0800 (CST)
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
Subject: [PATCH v3 md-6.15 01/11] md/md-bitmap: remove the parameter 'init' for bitmap_ops->resize()
Date: Thu, 23 Jan 2025 10:07:20 +0800
Message-Id: <20250123020730.2003602-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgA3m1+7pZFno+znBg--.59488S5
X-Coremail-Antispam: 1UD129KBjvJXoWxJFyxAr15tr1xWw13XF4fKrg_yoWrKw1Dpa
	17tFy3A345KrW5Wa1UXFykuFyFq34ktr9rKryxC34fWF9rXrZrXF4rWFWqqF1Dta45XFZI
	qan8trWUCF1xXFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUm014x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWU
	JVW8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67
	kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY
	6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0x
	vEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVj
	vjDU0xZFpf9x0JU2dgAUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

It's set to 'false' for all callers, hence it's useless and can be
removed.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c    | 2 +-
 drivers/md/md-bitmap.c  | 5 ++---
 drivers/md/md-bitmap.h  | 3 +--
 drivers/md/md-cluster.c | 2 +-
 drivers/md/raid1.c      | 2 +-
 drivers/md/raid10.c     | 8 ++++----
 drivers/md/raid5.c      | 2 +-
 7 files changed, 11 insertions(+), 13 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1e0d3b9b75d6..0ca73b571c7d 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -4069,7 +4069,7 @@ static int raid_preresume(struct dm_target *ti)
 		int chunksize = to_bytes(rs->requested_bitmap_chunk_sectors) ?: mddev->bitmap_info.chunksize;
 
 		r = mddev->bitmap_ops->resize(mddev, mddev->dev_sectors,
-					      chunksize, false);
+					      chunksize);
 		if (r)
 			DMERR("Failed to resize bitmap");
 	}
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index ec4ecd96e6b1..b745eb6ad0e4 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2581,15 +2581,14 @@ static int __bitmap_resize(struct bitmap *bitmap, sector_t blocks,
 	return ret;
 }
 
-static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize,
-			 bool init)
+static int bitmap_resize(struct mddev *mddev, sector_t blocks, int chunksize)
 {
 	struct bitmap *bitmap = mddev->bitmap;
 
 	if (!bitmap)
 		return 0;
 
-	return __bitmap_resize(bitmap, blocks, chunksize, init);
+	return __bitmap_resize(bitmap, blocks, chunksize, false);
 }
 
 static ssize_t
diff --git a/drivers/md/md-bitmap.h b/drivers/md/md-bitmap.h
index 31c93019c76b..6d1ab949ed95 100644
--- a/drivers/md/md-bitmap.h
+++ b/drivers/md/md-bitmap.h
@@ -73,8 +73,7 @@ struct md_bitmap_stats {
 struct bitmap_operations {
 	bool (*enabled)(struct mddev *mddev);
 	int (*create)(struct mddev *mddev, int slot);
-	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize,
-		      bool init);
+	int (*resize)(struct mddev *mddev, sector_t blocks, int chunksize);
 
 	int (*load)(struct mddev *mddev);
 	void (*destroy)(struct mddev *mddev);
diff --git a/drivers/md/md-cluster.c b/drivers/md/md-cluster.c
index 6595f89becdb..67898a02bd3a 100644
--- a/drivers/md/md-cluster.c
+++ b/drivers/md/md-cluster.c
@@ -630,7 +630,7 @@ static int process_recvd_msg(struct mddev *mddev, struct cluster_msg *msg)
 		if (le64_to_cpu(msg->high) != mddev->pers->size(mddev, 0, 0))
 			ret = mddev->bitmap_ops->resize(mddev,
 							le64_to_cpu(msg->high),
-							0, false);
+							0);
 		break;
 	default:
 		ret = -1;
diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
index a5cd6522fc2d..49960fbcffca 100644
--- a/drivers/md/raid1.c
+++ b/drivers/md/raid1.c
@@ -3334,7 +3334,7 @@ static int raid1_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-	ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 	if (ret)
 		return ret;
 
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index e1e6cd7fb125..8d4d19012f42 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4248,7 +4248,7 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > size)
 		return -EINVAL;
 
-	ret = mddev->bitmap_ops->resize(mddev, size, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, size, 0);
 	if (ret)
 		return ret;
 
@@ -4517,7 +4517,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
 
 		if (!mddev_is_clustered(mddev)) {
-			ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
+			ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 			if (ret)
 				goto abort;
 			else
@@ -4539,13 +4539,13 @@ static int raid10_start_reshape(struct mddev *mddev)
 			    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
 			goto out;
 
-		ret = mddev->bitmap_ops->resize(mddev, newsize, 0, false);
+		ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 		if (ret)
 			goto abort;
 
 		ret = md_cluster_ops->resize_bitmaps(mddev, newsize, oldsize);
 		if (ret) {
-			mddev->bitmap_ops->resize(mddev, oldsize, 0, false);
+			mddev->bitmap_ops->resize(mddev, oldsize, 0);
 			goto abort;
 		}
 	}
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 5c79429acc64..8f33d2478d94 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -8331,7 +8331,7 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-	ret = mddev->bitmap_ops->resize(mddev, sectors, 0, false);
+	ret = mddev->bitmap_ops->resize(mddev, sectors, 0);
 	if (ret)
 		return ret;
 
-- 
2.39.2

