Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB6E412C54A
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:59:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.189
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419587; cv=none; b=CNN8f8xCJ6nm2UKjEmtETv+l3b3eJx4nOfNe8kaVSpsKu0mV9wxPNWFU8YaD7rt899FWznyQml5xBjOTj+x5VfGgYpB/DWLUjxZ+MhOeCzAM7REVPPNmzHQlbliiwIVvkt+shdRJGZnFx4+u5fhnNnC3zm6pv+2mSB3AdoiikWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419587; c=relaxed/simple;
	bh=kNYjS8n3tbQbcI11AsmL/J3aa6ZedKgAcJ5KRt5TLwk=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WxIFYQEo6RHJ/PLiyD+WtEK1NVRuewggzwCURAHsgt6007upPbmZ3PzMec9SIUST7bcBzw8nwfDcMntya0M+mkXNkl68dj8pphtEbOW6vIWu+U9hHowSMKdRRUMkMmRnUavC2rT6PdkPqLFVDzweJew9RnKs/K00W+ZeBhNK/NI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.189
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4VtDHv1Q4rzPnpk;
	Mon,  3 Jun 2024 20:56:27 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 818DD140413;
	Mon,  3 Jun 2024 20:59:27 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:15 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 07/12] md: don't fail action_store() if sync_thread is not registered
Date: Mon, 3 Jun 2024 20:58:10 +0800
Message-ID: <20240603125815.2199072-8-yukuai3@huawei.com>
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
index 5e3c3c109412..3890ae86449a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -752,7 +752,6 @@ int mddev_init(struct mddev *mddev)
 
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
-	mutex_init(&mddev->sync_mutex);
 	mutex_init(&mddev->suspend_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
 	INIT_LIST_HEAD(&mddev->disks);
@@ -5020,34 +5019,6 @@ void md_unfrozen_sync_thread(struct mddev *mddev)
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
@@ -5055,24 +5026,13 @@ static int mddev_start_reshape(struct mddev *mddev)
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
@@ -5082,7 +5042,6 @@ static int mddev_start_reshape(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	mddev_unlock(mddev);
 	sysfs_notify_dirent_safe(mddev->sysfs_degraded);
 	return 0;
 }
@@ -5096,36 +5055,53 @@ action_store(struct mddev *mddev, const char *page, size_t len)
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
@@ -5143,7 +5119,8 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 			break;
 		default:
-			return -EINVAL;
+			ret = -EINVAL;
+			goto out;
 		}
 	}
 
@@ -5151,14 +5128,18 @@ action_store(struct mddev *mddev, const char *page, size_t len)
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
index 018f3292a25c..f7afc5a46031 100644
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

