Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEAB822157B
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 01:32:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751851974; cv=none; b=PMTCwPufYr+p86Qmp7E0wtlIkoiuGmlIV0icXaCSZsUgmfzaq1SZFgLMGzcjIzovij6q8YK63tL+FAdtPzpsyceM2TW9D7OOJon+mpjLY810p2I3NHU4Gy45Tw/h94OODyEO2ZvWIZCmx7sJ/nifYKdU6SQcWVIjfHBJHluYO8c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751851974; c=relaxed/simple;
	bh=0a7/WG3mgzgY0l//4NfvK4sbSzedfN6RQRRxNPXW+7E=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=YOwo2JwRH8VIZ1WDwE6+c3q/kvkIQKw42kCqM7LwahQ1+8AMKPg4+xDguE3dAMDB0X2po2vFSUGu3If1dhkpZzOTJixaPxzbYMClsJatgYKReKmuSxScOFNv7wD4dhCCxK7lcOv7CU9sSo4UgrnFk34cvMfmiPwdi8MYA2PHhmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4bb6Dt1WtqzKHMjF
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:46 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.252])
	by mail.maildlp.com (Postfix) with ESMTP id A5CD51A0CEC
	for <dm-devel@lists.linux.dev>; Mon,  7 Jul 2025 09:32:44 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP3 (Coremail) with SMTP id _Ch0CgDnSCazI2to_nSRAw--.35890S17;
	Mon, 07 Jul 2025 09:32:44 +0800 (CST)
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
Subject: [PATCH v5 13/15] md/dm-raid: check before referencing mddev->bitmap_ops
Date: Mon,  7 Jul 2025 09:27:09 +0800
Message-Id: <20250707012711.376844-14-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:_Ch0CgDnSCazI2to_nSRAw--.35890S17
X-Coremail-Antispam: 1UD129KBjvJXoWxJr4fJF15Ar1xJr47KFyrXrb_yoW8Xr47pw
	sxGFWayry3Jr45Xw43XFyv9a40qwn5trZ0yryxJa43XF97XrnxWFyrGFWYq3W0kFyrAFsx
	Aa1DJr4jkF1jgaUanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	AF67kF1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI
	42IY6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to introduce CONFIG_MD_BITMAP.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 9757c32ea1f5..f11b4e1d9b75 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3950,9 +3950,11 @@ static int __load_dirty_region_bitmap(struct raid_set *rs)
 	    !test_and_set_bit(RT_FLAG_RS_BITMAP_LOADED, &rs->runtime_flags)) {
 		struct mddev *mddev = &rs->md;
 
-		r = mddev->bitmap_ops->load(mddev);
-		if (r)
-			DMERR("Failed to load bitmap");
+		if (md_bitmap_enabled(mddev, false)) {
+			r = mddev->bitmap_ops->load(mddev);
+			if (r)
+				DMERR("Failed to load bitmap");
+		}
 	}
 
 	return r;
@@ -4067,10 +4069,12 @@ static int raid_preresume(struct dm_target *ti)
 	       mddev->bitmap_info.chunksize != to_bytes(rs->requested_bitmap_chunk_sectors)))) {
 		int chunksize = to_bytes(rs->requested_bitmap_chunk_sectors) ?: mddev->bitmap_info.chunksize;
 
-		r = mddev->bitmap_ops->resize(mddev, mddev->dev_sectors,
-					      chunksize);
-		if (r)
-			DMERR("Failed to resize bitmap");
+		if (md_bitmap_enabled(mddev, false)) {
+			r = mddev->bitmap_ops->resize(mddev, mddev->dev_sectors,
+						      chunksize);
+			if (r)
+				DMERR("Failed to resize bitmap");
+		}
 	}
 
 	/* Check for any resize/reshape on @rs and adjust/initiate */
-- 
2.39.2

