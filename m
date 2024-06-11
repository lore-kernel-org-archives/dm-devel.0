Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F347217D340
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112205; cv=none; b=CLFHYSWGWNIaPrcr08pfXshcHckjNeooXz1FXljGYIrBGl6vWP9pkOxryj94t57xIWs+73eH4/Fw7AmrTLqIKJu+HO8JJ3GkfyPsg+vp3WIeCXEYKqSgXMax5jVw9hbQmDq2Kpl1VnXZXMtNdBBcxNCnMA6JyJeAWFrdv7y+l40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112205; c=relaxed/simple;
	bh=I8306fpRwsxgUr2q/hkh3ND4xyfvxTK2xeekp7AcPXE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XaPn74sAALJtT3E+PNmPsqRxk9re8bdEtWyWxWF4f2m0h3djFYs2JNR1EESIEU3XVcS1GXw2/c8fxTygVpVeQFWyVL9qxytox/QH14zrLQ6wm1YEFCEYn08zJ0SqwRTT1AP2+p+72Nl3OkO4cWhLduHfdEVpfgeudGh+26vUzd0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W12nnjz4f3jdv
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:09 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 6068B1A0EDF
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:19 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S11;
	Tue, 11 Jun 2024 21:23:19 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com,
	mariusz.tkaczyk@linux.intel.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH v2 md-6.11 07/12] md: don't fail action_store() if sync_thread is not registered
Date: Tue, 11 Jun 2024 21:22:46 +0800
Message-Id: <20240611132251.1967786-8-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
References: <20240611132251.1967786-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S11
X-Coremail-Antispam: 1UD129KBjvJXoW3Jw4fuFyUXrWxArWfAF45trb_yoW7Zrykpa
	yftF95Jr4UtrZ3Xry7t3WDuayY9w1IqFWDtrW7ua4xJ3Z2kr47KF1YvF17JFykta4rCr4U
	Xa1rJFW5ZFWj9F7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
	0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
	SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

MD_RECOVERY_RUNNING will always be set when trying to register a new
sync_thread, however, if md_start_sync() turns out to do nothing,
MD_RECOVERY_RUNNING will be cleared in this case. And during the race
window, action_store() will return -EBUSY, which will cause some
mdadm tests to fail. For example:

The test 07reshape5intr will add a new disk to array, then start
reshape:

mdadm /dev/md0 --add /dev/xxx
mdadm --grow /dev/md0 -n 3

And add_bound_rdev() from mdadm --add will set MD_RECOVERY_NEEDED,
then during the race windown, mdadm --grow will fail.

Fix the problem by waiting in action_store() during the race window,
fail only if sync_thread is registered.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 85 +++++++++++++++++++------------------------------
 drivers/md/md.h |  2 --
 2 files changed, 33 insertions(+), 54 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 44cb18ec1c52..86abd0fe0681 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -753,7 +753,6 @@ int mddev_init(struct mddev *mddev)
 
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
-	mutex_init(&mddev->sync_mutex);
 	mutex_init(&mddev->suspend_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
 	INIT_LIST_HEAD(&mddev->disks);
@@ -5021,34 +5020,6 @@ void md_unfrozen_sync_thread(struct mddev *mddev)
 }
 EXPORT_SYMBOL_GPL(md_unfrozen_sync_thread);
 
-static void idle_sync_thread(struct mddev *mddev)
-{
-	mutex_lock(&mddev->sync_mutex);
-	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-
-	if (mddev_lock(mddev)) {
-		mutex_unlock(&mddev->sync_mutex);
-		return;
-	}
-
-	stop_sync_thread(mddev, false);
-	mutex_unlock(&mddev->sync_mutex);
-}
-
-static void frozen_sync_thread(struct mddev *mddev)
-{
-	mutex_lock(&mddev->sync_mutex);
-	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-
-	if (mddev_lock(mddev)) {
-		mutex_unlock(&mddev->sync_mutex);
-		return;
-	}
-
-	stop_sync_thread(mddev, false);
-	mutex_unlock(&mddev->sync_mutex);
-}
-
 static int mddev_start_reshape(struct mddev *mddev)
 {
 	int ret;
@@ -5056,24 +5027,13 @@ static int mddev_start_reshape(struct mddev *mddev)
 	if (mddev->pers->start_reshape == NULL)
 		return -EINVAL;
 
-	ret = mddev_lock(mddev);
-	if (ret)
-		return ret;
-
-	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-		mddev_unlock(mddev);
-		return -EBUSY;
-	}
-
 	if (mddev->reshape_position == MaxSector ||
 	    mddev->pers->check_reshape == NULL ||
 	    mddev->pers->check_reshape(mddev)) {
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 		ret = mddev->pers->start_reshape(mddev);
-		if (ret) {
-			mddev_unlock(mddev);
+		if (ret)
 			return ret;
-		}
 	} else {
 		/*
 		 * If reshape is still in progress, and md_check_recovery() can
@@ -5083,7 +5043,6 @@ static int mddev_start_reshape(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	mddev_unlock(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 	return 0;
 }
@@ -5097,36 +5056,53 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+retry:
+	if (work_busy(&mddev->sync_work))
+		flush_work(&mddev->sync_work);
+
+	ret = mddev_lock(mddev);
+	if (ret)
+		return ret;
+
+	if (work_busy(&mddev->sync_work)) {
+		mddev_unlock(mddev);
+		goto retry;
+	}
+
 	action = md_sync_action_by_name(page);
 
 	/* TODO: mdadm rely on "idle" to start sync_thread. */
 	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		switch (action) {
 		case ACTION_FROZEN:
-			frozen_sync_thread(mddev);
-			return len;
+			md_frozen_sync_thread(mddev);
+			ret = len;
+			goto out;
 		case ACTION_IDLE:
-			idle_sync_thread(mddev);
+			md_idle_sync_thread(mddev);
 			break;
 		case ACTION_RESHAPE:
 		case ACTION_RECOVER:
 		case ACTION_CHECK:
 		case ACTION_REPAIR:
 		case ACTION_RESYNC:
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	} else {
 		switch (action) {
 		case ACTION_FROZEN:
 			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-			return len;
+			ret = len;
+			goto out;
 		case ACTION_RESHAPE:
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			ret = mddev_start_reshape(mddev);
 			if (ret)
-				return ret;
+				goto out;
 			break;
 		case ACTION_RECOVER:
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
@@ -5144,7 +5120,8 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			break;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -5152,14 +5129,18 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 		/* A write to sync_action is enough to justify
 		 * canceling read-auto mode
 		 */
-		flush_work(&mddev->sync_work);
 		mddev->ro = MD_RDWR;
 		md_wakeup_thread(mddev->sync_thread);
 	}
+
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
-	return len;
+	ret = len;
+
+out:
+	mddev_unlock(mddev);
+	return ret;
 }
 
 static struct md_sysfs_entry md_scan_mode =
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 88add162b08e..732053b905b2 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -595,8 +595,6 @@ struct mddev {
 	 */
 	struct list_head		deleting;
 
-	/* Used to synchronize idle and frozen for action_store() */
-	struct mutex			sync_mutex;
 	/* The sequence number for sync thread */
 	atomic_t sync_seq;
 
-- 
2.39.2

