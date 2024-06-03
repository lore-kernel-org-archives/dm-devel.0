Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F3812C550
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:58:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419526; cv=none; b=r/hRzRWwhWJAkaSuO9iaiCUkmTkDO8vtGIFwPdTD6bqTO3deyKoHXewniD6Wv6xY//k/wG/wW9jSIAt4zLKgu/tNpL/OBsKmfNO5Ipof3c+IAMW380J8au+gqe6w7R/1wG/lhiFBTR+GFgPIwSuDnyNaSezbmzUe6nAR769/0DU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419526; c=relaxed/simple;
	bh=RYgIXlpfHFpa7fuAjbAWJANhvY0CxwerTgR7X6hLYaw=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PCMhzqrQstPKz84rAUYbnrTrxJdVjpB0CNGlKRV3AX/SACNI/yTfiuQT7psCJX8OpzPMwsNvxncZvSK2hFA8l7qg8F7zzmK+rIDxg5uUKdFGhw9LB0ZzTMK8zK7sKi2De5CMpSFHk97fGs0Q4nCelEgitn/qpi2GnNsvBYpiZ3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VtDFJ0BR1zmXZx;
	Mon,  3 Jun 2024 20:54:12 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 54347140123;
	Mon,  3 Jun 2024 20:58:27 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:12 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 03/12] md: add new helpers for sync_action
Date: Mon, 3 Jun 2024 20:58:06 +0800
Message-ID: <20240603125815.2199072-4-yukuai3@huawei.com>
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

The new helpers will get current sync_action of the array, will be used
in later patches to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 ++
 2 files changed, 82 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index aff9118ff697..e5487008f66e 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -69,6 +69,16 @@
 #include "md-bitmap.h"
 #include "md-cluster.h"
 
+static const char *action_name[NR_SYNC_ACTIONS] = {
+	[ACTION_RESYNC]		= "resync",
+	[ACTION_RECOVER]	= "recover",
+	[ACTION_CHECK]		= "check",
+	[ACTION_REPAIR]		= "repair",
+	[ACTION_RESHAPE]	= "reshape",
+	[ACTION_FROZEN]		= "frozen",
+	[ACTION_IDLE]		= "idle",
+};
+
 /* pers_list is a list of registered personalities protected by pers_lock. */
 static LIST_HEAD(pers_list);
 static DEFINE_SPINLOCK(pers_lock);
@@ -4867,6 +4877,75 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
 static struct md_sysfs_entry md_metadata =
 __ATTR_PREALLOC(metadata_version, S_IRUGO|S_IWUSR, metadata_show, metadata_store);
 
+enum sync_action md_sync_action(struct mddev *mddev)
+{
+	unsigned long recovery = mddev->recovery;
+
+	/*
+	 * frozen has the highest priority, means running sync_thread will be
+	 * stopped immediately, and no new sync_thread can start.
+	 */
+	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
+		return ACTION_FROZEN;
+
+	/*
+	 * read-only array can't register sync_thread, and it can only
+	 * add/remove spares.
+	 */
+	if (!md_is_rdwr(mddev))
+		return ACTION_IDLE;
+
+	/*
+	 * idle means no sync_thread is running, and no new sync_thread is
+	 * requested.
+	 */
+	if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
+	    !test_bit(MD_RECOVERY_NEEDED, &recovery))
+		return ACTION_IDLE;
+
+	if (test_bit(MD_RECOVERY_RESHAPE, &recovery) ||
+	    mddev->reshape_position != MaxSector)
+		return ACTION_RESHAPE;
+
+	if (test_bit(MD_RECOVERY_RECOVER, &recovery))
+		return ACTION_RECOVER;
+
+	if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
+		/*
+		 * MD_RECOVERY_CHECK must be paired with
+		 * MD_RECOVERY_REQUESTED.
+		 */
+		if (test_bit(MD_RECOVERY_CHECK, &recovery))
+			return ACTION_CHECK;
+		if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
+			return ACTION_REPAIR;
+		return ACTION_RESYNC;
+	}
+
+	/*
+	 * MD_RECOVERY_NEEDED or MD_RECOVERY_RUNNING is set, however, no
+	 * sync_action is specified.
+	 */
+	return ACTION_IDLE;
+}
+
+enum sync_action md_sync_action_by_name(const char *page)
+{
+	enum sync_action action;
+
+	for (action = 0; action < NR_SYNC_ACTIONS; ++action) {
+		if (cmd_match(page, action_name[action]))
+			return action;
+	}
+
+	return NR_SYNC_ACTIONS;
+}
+
+const char *md_sync_action_name(enum sync_action action)
+{
+	return action_name[action];
+}
+
 static ssize_t
 action_show(struct mddev *mddev, char *page)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 6b9d9246f260..018f3292a25c 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
 extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
+extern enum sync_action md_sync_action(struct mddev *mddev);
+extern enum sync_action md_sync_action_by_name(const char *page);
+extern const char *md_sync_action_name(enum sync_action action);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
-- 
2.39.2

