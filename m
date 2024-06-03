Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E90912D76D
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:59:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419571; cv=none; b=s6ijgPavXNt4WpWlXB7h6wtShjyw4HvYXD6FGPHSkJj5Z4T9+TjnEIhyJN03HhWzSW9Lxig6nvw2V1nJ6RfAWHGbgKqjFetRojTbnfyeEGtmzod01KgsOc7Kl4EtU4O1jIoYovcAzqF3eitpI0c65Kp9eG62ii6RDVJrKsd6LRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419571; c=relaxed/simple;
	bh=oL4FzWeAQnqlaFb0oye4w6pZ4yq1rfOBVqzyzlNAc1Q=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nQKPgAof0i8imu3swa5aUYnFGs8iIrQAJHe57/DIzfiBkE+CgGPyM2wbYo3BshtUsgLR+1XBn0FUkZc8gDPY7ixwUuUmXWjbgndRER2o9Nyknn2RSwptw85J3nu2gmy93eI88Dk8xce0vGeDI8bKSwEAFQoWp/uQdbne9DpGmUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VtDGs2Z1kzwRMG;
	Mon,  3 Jun 2024 20:55:33 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 7586A140382;
	Mon,  3 Jun 2024 20:59:12 +0800 (CST)
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
Subject: [PATCH 06/12] md: remove parameter check_seq for stop_sync_thread()
Date: Mon, 3 Jun 2024 20:58:09 +0800
Message-ID: <20240603125815.2199072-7-yukuai3@huawei.com>
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

Caller will always set MD_RECOVERY_FROZEN if check_seq is true, and
always clear MD_RECOVERY_FROZEN if check_seq is false, hence replace
the parameter with test_bit() to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 26 +++++++++++---------------
 1 file changed, 11 insertions(+), 15 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 8a54b56e3463..5e3c3c109412 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4960,15 +4960,10 @@ action_show(struct mddev *mddev, char *page)
  * @locked:	if set, reconfig_mutex will still be held after this function
  *		return; if not set, reconfig_mutex will be released after this
  *		function return.
- * @check_seq:	if set, only wait for curent running sync_thread to stop, noted
- *		that new sync_thread can still start.
  */
-static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
+static void stop_sync_thread(struct mddev *mddev, bool locked)
 {
-	int sync_seq;
-
-	if (check_seq)
-		sync_seq = atomic_read(&mddev->sync_seq);
+	int sync_seq = atomic_read(&mddev->sync_seq);
 
 	if (!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
 		if (!locked)
@@ -4989,7 +4984,8 @@ static void stop_sync_thread(struct mddev *mddev, bool locked, bool check_seq)
 
 	wait_event(resync_wait,
 		   !test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
-		   (check_seq && sync_seq != atomic_read(&mddev->sync_seq)));
+		   (!test_bit(MD_RECOVERY_FROZEN, &mddev->recovery) &&
+		    sync_seq != atomic_read(&mddev->sync_seq)));
 
 	if (locked)
 		mddev_lock_nointr(mddev);
@@ -5000,7 +4996,7 @@ void md_idle_sync_thread(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, true);
+	stop_sync_thread(mddev, true);
 }
 EXPORT_SYMBOL_GPL(md_idle_sync_thread);
 
@@ -5009,7 +5005,7 @@ void md_frozen_sync_thread(struct mddev *mddev)
 	lockdep_assert_held(&mddev->reconfig_mutex);
 
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 }
 EXPORT_SYMBOL_GPL(md_frozen_sync_thread);
 
@@ -5034,7 +5030,7 @@ static void idle_sync_thread(struct mddev *mddev)
 		return;
 	}
 
-	stop_sync_thread(mddev, false, true);
+	stop_sync_thread(mddev, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -5048,7 +5044,7 @@ static void frozen_sync_thread(struct mddev *mddev)
 		return;
 	}
 
-	stop_sync_thread(mddev, false, false);
+	stop_sync_thread(mddev, false);
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -6543,7 +6539,7 @@ void md_stop_writes(struct mddev *mddev)
 {
 	mddev_lock_nointr(mddev);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 	__md_stop_writes(mddev);
 	mddev_unlock(mddev);
 }
@@ -6611,7 +6607,7 @@ static int md_set_readonly(struct mddev *mddev)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	stop_sync_thread(mddev, false, false);
+	stop_sync_thread(mddev, false);
 	wait_event(mddev->sb_wait,
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 	mddev_lock_nointr(mddev);
@@ -6657,7 +6653,7 @@ static int do_md_stop(struct mddev *mddev, int mode)
 		set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	}
 
-	stop_sync_thread(mddev, true, false);
+	stop_sync_thread(mddev, true);
 
 	if (mddev->sysfs_active ||
 	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
-- 
2.39.2

