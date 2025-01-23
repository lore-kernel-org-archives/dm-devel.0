Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B0C212CDAE
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 02:13:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737598407; cv=none; b=Du0IrfBhJtPiwnbwxglwdMaldH4E0FU6Kd4C/oV56hTvzM5IStGIxAc09YdHM+7nT4VG9D5f76ZRJGfYaow48zfTQrwqGUJ2H1ZJ+n9573COu0Q9m1HG5etAo+ft+9XlMKZheZZ1KEsQRMrqYYLbfEQ9f99QWDP7ZKOXgUwMW5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737598407; c=relaxed/simple;
	bh=NwirNklYFRpfOH+wfI7YFrT824/URRxjFu0Q6EZSZ7U=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=SUe5ehexWoMj2OIVM8S16HFupZTMMH2wP1X6SC9UBgUjnYeSNyvMekY8ER59a7FfQPHcE7yyf75pMrtW7j7wMszM6PQolW+mb6FFYQps93MpbyKIiVuQhhd+QB2SHbrm+OG2plhLWVZWGd+XyofvxZdrw4CI98YO9+W2wRxVkm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YdkxY6Yh5z4f3jkc
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:05 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 633151A165E
	for <dm-devel@lists.linux.dev>; Thu, 23 Jan 2025 10:13:21 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgA3m1+7pZFno+znBg--.59488S13;
	Thu, 23 Jan 2025 10:13:21 +0800 (CST)
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
Subject: [PATCH v3 md-6.15 09/11] md/raid5: check before deferencing mddev->bitmap_ops
Date: Thu, 23 Jan 2025 10:07:28 +0800
Message-Id: <20250123020730.2003602-10-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgA3m1+7pZFno+znBg--.59488S13
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4DJF15urW3KF4DJrWrKrg_yoW8tF47p3
	9rtFyaqry5ZrW3Ww4DJFykuF1Fva97tr9rtryfWw1xWwn7Gr9xWF4rWFyjqF1jya4rAFWr
	J3y5AF45Cr13Wr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
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
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 9098762ccfa6..f81600a6cd14 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6505,7 +6505,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 					   &sync_blocks);
 		else /* completed sync */
 			conf->fullsync = 0;
-		mddev->bitmap_ops->close_sync(mddev);
+		if (md_bitmap_enabled(mddev))
+			mddev->bitmap_ops->close_sync(mddev);
 
 		return 0;
 	}
@@ -6543,7 +6544,8 @@ static inline sector_t raid5_sync_request(struct mddev *mddev, sector_t sector_n
 		return sync_blocks * RAID5_STRIPE_SECTORS(conf);
 	}
 
-	mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
+	if (md_bitmap_enabled(mddev))
+		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr, false);
 
 	sh = raid5_get_active_stripe(conf, NULL, sector_nr,
 				     R5_GAS_NOBLOCK);
@@ -6769,7 +6771,8 @@ static void raid5d(struct md_thread *thread)
 			/* Now is a good time to flush some bitmap updates */
 			conf->seq_flush++;
 			spin_unlock_irq(&conf->device_lock);
-			mddev->bitmap_ops->unplug(mddev, true);
+			if (md_bitmap_enabled(mddev))
+				mddev->bitmap_ops->unplug(mddev, true);
 			spin_lock_irq(&conf->device_lock);
 			conf->seq_write = conf->seq_flush;
 			activate_bit_delay(conf, conf->temp_inactive_list);
@@ -8318,7 +8321,6 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	 */
 	sector_t newsize;
 	struct r5conf *conf = mddev->private;
-	int ret;
 
 	if (raid5_has_log(conf) || raid5_has_ppl(conf))
 		return -EINVAL;
@@ -8328,9 +8330,12 @@ static int raid5_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > newsize)
 		return -EINVAL;
 
-	ret = mddev->bitmap_ops->resize(mddev, sectors, 0);
-	if (ret)
-		return ret;
+	if (md_bitmap_enabled(mddev)) {
+		int ret = mddev->bitmap_ops->resize(mddev, sectors, 0);
+
+		if (ret)
+			return ret;
+	}
 
 	md_set_array_sectors(mddev, newsize);
 	if (sectors > mddev->dev_sectors &&
-- 
2.39.2

