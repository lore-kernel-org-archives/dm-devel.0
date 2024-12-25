Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B0121C4A2D
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 11:20:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735125603; cv=none; b=pzc5o8AukeN1jstVFh/lKCEptKKJWXmiVEPYfH7rNIE0ANqWN7OiMgLPaabMwxBtVtpCKfaOzq8hakY/YNn7WDOOwyrza5gXF4pnaFcQUvhroWp4/KYbrmcoVxlJfWjpdDyxITC51ELyvkyr34wXw6Dg0wHWqEH7VeOBLV5226A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735125603; c=relaxed/simple;
	bh=PX0h69U5hVqtfXuY7WmvgK/iaGUorVRnHMVO1++mCIg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=MegmjVr8/09+wQsXXcWdKHZRzt8VmnILR2D/53HMEfplYn/WoxjkbIp4u6sMVxDIpgCBf0Y7p3YoXSza2HWefDYoLS33UKCXG+4kuTUhRlBc2cZtyr0YVy5K8HkMwYDX0VPYDpvCEpKb2N6FafRi20JYl9qrk/FlKfLA98pHDKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4YJ8RW1fkBz4f3kvp
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:35 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 095761A0568
	for <dm-devel@lists.linux.dev>; Wed, 25 Dec 2024 19:19:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgAnT4NV6mtntXlgFg--.39006S13;
	Wed, 25 Dec 2024 19:19:55 +0800 (CST)
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
Subject: [PATCH md-6.14 09/13] md/raid10: check before deferencing mddev->bitmap_ops
Date: Wed, 25 Dec 2024 19:15:42 +0800
Message-Id: <20241225111546.1833250-10-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:gCh0CgAnT4NV6mtntXlgFg--.39006S13
X-Coremail-Antispam: 1UD129KBjvJXoWxJr43ZF48Gw47XFy8WFyxuFg_yoW5JF1fp3
	9rtFy3tryUArW3Wa15AFyku3WFv3s7tr9rtFyfWw1fGrn7KrnxJF4rWFyjqF1jva4rAF15
	X3yDtr45CF13WF7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0JUQFxUUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Prepare to support building bitmap as kernel module.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid10.c | 19 ++++++++++++-------
 1 file changed, 12 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 96d610116a25..ad81e9ca8d38 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -3270,7 +3270,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 			}
 			conf->fullsync = 0;
 		}
-		mddev->bitmap_ops->close_sync(mddev);
+		if (md_bitmap_enabled(mddev))
+			mddev->bitmap_ops->close_sync(mddev);
 		close_sync(conf);
 		*skipped = 1;
 		return sectors_skipped;
@@ -3589,7 +3590,8 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
 		 * safety reason, which ensures curr_resync_completed is
 		 * updated in bitmap_cond_end_sync.
 		 */
-		mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
+		if (md_bitmap_enabled(mddev))
+			mddev->bitmap_ops->cond_end_sync(mddev, sector_nr,
 					mddev_is_clustered(mddev) &&
 					(sector_nr + 2 * RESYNC_SECTORS > conf->cluster_sync_high));
 
@@ -4245,7 +4247,6 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	 */
 	struct r10conf *conf = mddev->private;
 	sector_t oldsize, size;
-	int ret;
 
 	if (mddev->reshape_position != MaxSector)
 		return -EBUSY;
@@ -4259,9 +4260,12 @@ static int raid10_resize(struct mddev *mddev, sector_t sectors)
 	    mddev->array_sectors > size)
 		return -EINVAL;
 
-	ret = mddev->bitmap_ops->resize(mddev, size, 0);
-	if (ret)
-		return ret;
+	if (md_bitmap_enabled(mddev)) {
+		int ret = mddev->bitmap_ops->resize(mddev, size, 0);
+
+		if (ret)
+			return ret;
+	}
 
 	md_set_array_sectors(mddev, size);
 	if (sectors > mddev->dev_sectors &&
@@ -4527,7 +4531,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 		oldsize = raid10_size(mddev, 0, 0);
 		newsize = raid10_size(mddev, 0, conf->geo.raid_disks);
 
-		if (!mddev_is_clustered(mddev)) {
+		if (!mddev_is_clustered(mddev) && md_bitmap_enabled(mddev)) {
 			ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 			if (ret)
 				goto abort;
@@ -4550,6 +4554,7 @@ static int raid10_start_reshape(struct mddev *mddev)
 			    MD_FEATURE_RESHAPE_ACTIVE)) || (oldsize == newsize))
 			goto out;
 
+		/* cluster can't be setup without bitmap */
 		ret = mddev->bitmap_ops->resize(mddev, newsize, 0);
 		if (ret)
 			goto abort;
-- 
2.39.2

