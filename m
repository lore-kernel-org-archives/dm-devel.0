Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA7D31304A2
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 13:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419631; cv=none; b=mutiJH3yL4CSYzECU/jsk+uXNts0fc0KNZ2XEJekm6FjzVxMyq80yZGuz/tsScttDoWwwLZBuWF7KnLa0IHq6268piyCbH9OabYxuF/xJNfDr85gnOC3d3oP+AadtegVaCujZ4sgWxTY/ywlvKZk54D3LUKNMDWMJMRTyu/58eo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419631; c=relaxed/simple;
	bh=hDWUvzi0QkzJKv9d5XImEH4ogjhF2wiil2frdF3M+y0=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DfF5mb6/3/ui3fXRhdQW0hLBjZLVwcrVlgVigBve/S+1kwfp8wVntT448HE1Q+7zSS7VG7Z5X4FP73RGqcAm5w4nl3xLruouaXwPoear0pQl7ncnyiFsdcZKLIDaGIh2g+pZog/+/8sTqAym2fYnqi5CnJx/iTTwQoE159Us6cQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VtDJ13k7XzwRLp;
	Mon,  3 Jun 2024 20:56:33 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id A2640140382;
	Mon,  3 Jun 2024 21:00:12 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:18 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 10/12] md: factor out helpers for different sync_action in md_do_sync()
Date: Mon, 3 Jun 2024 20:58:13 +0800
Message-ID: <20240603125815.2199072-11-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240603125815.2199072-1-yukuai3@huawei.com>
References: <20240603125815.2199072-1-yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Make code cleaner by replacing if else if with switch, and it's more
obvious now what is doing for each sync_action. There are no
functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 123 ++++++++++++++++++++++++++++--------------------
 1 file changed, 73 insertions(+), 50 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 28977595b7ba..a1f9d9b69911 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8919,6 +8919,77 @@ void md_allow_write(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_allow_write);
 
+static sector_t md_sync_max_sectors(struct mddev *mddev,
+				    enum sync_action action)
+{
+	switch (action) {
+	case ACTION_RESYNC:
+	case ACTION_CHECK:
+	case ACTION_REPAIR:
+		atomic64_set(&mddev->resync_mismatches, 0);
+		fallthrough;
+	case ACTION_RESHAPE:
+		return mddev->resync_max_sectors;
+	case ACTION_RECOVER:
+		return mddev->dev_sectors;
+	default:
+		return 0;
+	}
+}
+
+static sector_t md_sync_position(struct mddev *mddev, enum sync_action action)
+{
+	sector_t start = 0;
+	struct md_rdev *rdev;
+
+	switch (action) {
+	case ACTION_CHECK:
+	case ACTION_REPAIR:
+		return mddev->resync_min;
+	case ACTION_RESYNC:
+		if (!mddev->bitmap)
+			return mddev->recovery_cp;
+		return 0;
+	case ACTION_RESHAPE:
+		/*
+		 * If the original node aborts reshaping then we continue the
+		 * reshaping, so set again to avoid restart reshape from the
+		 * first beginning
+		 */
+		if (mddev_is_clustered(mddev) &&
+		    mddev->reshape_position != MaxSector)
+			return mddev->reshape_position;
+		return 0;
+	case ACTION_RECOVER:
+		start = MaxSector;
+		rcu_read_lock();
+		rdev_for_each_rcu(rdev, mddev)
+			if (rdev->raid_disk >= 0 &&
+			    !test_bit(Journal, &rdev->flags) &&
+			    !test_bit(Faulty, &rdev->flags) &&
+			    !test_bit(In_sync, &rdev->flags) &&
+			    rdev->recovery_offset < start)
+				start = rdev->recovery_offset;
+		rcu_read_unlock();
+
+		/* If there is a bitmap, we need to make sure all
+		 * writes that started before we added a spare
+		 * complete before we start doing a recovery.
+		 * Otherwise the write might complete and (via
+		 * bitmap_endwrite) set a bit in the bitmap after the
+		 * recovery has checked that bit and skipped that
+		 * region.
+		 */
+		if (mddev->bitmap) {
+			mddev->pers->quiesce(mddev, 1);
+			mddev->pers->quiesce(mddev, 0);
+		}
+		return start;
+	default:
+		return MaxSector;
+	}
+}
+
 #define SYNC_MARKS	10
 #define	SYNC_MARK_STEP	(3*HZ)
 #define UPDATE_FREQUENCY (5*60*HZ)
@@ -9037,56 +9108,8 @@ void md_do_sync(struct md_thread *thread)
 		spin_unlock(&all_mddevs_lock);
 	} while (mddev->curr_resync < MD_RESYNC_DELAYED);
 
-	j = 0;
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		/* resync follows the size requested by the personality,
-		 * which defaults to physical size, but can be virtual size
-		 */
-		max_sectors = mddev->resync_max_sectors;
-		atomic64_set(&mddev->resync_mismatches, 0);
-		/* we don't use the checkpoint if there's a bitmap */
-		if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery))
-			j = mddev->resync_min;
-		else if (!mddev->bitmap)
-			j = mddev->recovery_cp;
-
-	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery)) {
-		max_sectors = mddev->resync_max_sectors;
-		/*
-		 * If the original node aborts reshaping then we continue the
-		 * reshaping, so set j again to avoid restart reshape from the
-		 * first beginning
-		 */
-		if (mddev_is_clustered(mddev) &&
-		    mddev->reshape_position != MaxSector)
-			j = mddev->reshape_position;
-	} else {
-		/* recovery follows the physical size of devices */
-		max_sectors = mddev->dev_sectors;
-		j = MaxSector;
-		rcu_read_lock();
-		rdev_for_each_rcu(rdev, mddev)
-			if (rdev->raid_disk >= 0 &&
-			    !test_bit(Journal, &rdev->flags) &&
-			    !test_bit(Faulty, &rdev->flags) &&
-			    !test_bit(In_sync, &rdev->flags) &&
-			    rdev->recovery_offset < j)
-				j = rdev->recovery_offset;
-		rcu_read_unlock();
-
-		/* If there is a bitmap, we need to make sure all
-		 * writes that started before we added a spare
-		 * complete before we start doing a recovery.
-		 * Otherwise the write might complete and (via
-		 * bitmap_endwrite) set a bit in the bitmap after the
-		 * recovery has checked that bit and skipped that
-		 * region.
-		 */
-		if (mddev->bitmap) {
-			mddev->pers->quiesce(mddev, 1);
-			mddev->pers->quiesce(mddev, 0);
-		}
-	}
+	max_sectors = md_sync_max_sectors(mddev, action);
+	j = md_sync_position(mddev, action);
 
 	pr_info("md: %s of RAID array %s\n", desc, mdname(mddev));
 	pr_debug("md: minimum _guaranteed_  speed: %d KB/sec/disk.\n", speed_min(mddev));
-- 
2.39.2

