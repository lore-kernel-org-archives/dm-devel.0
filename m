Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CC4912C54B
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419556; cv=none; b=Z0cyuaxisRmjPDMybOZ942AwCNsto9HpJbVCHzUMgj5ToJebAu4lqCibpi6+fxpRyOchlBcpPrAg3dzsvcEbFB2PHf5wlHJ2HlN44jQ7xz8H+BUCxM9kTf7gkHY+vL4ViVQDV4h6fAcj+2chYkTNcyYhYF9bDzZZT2mvYGvuhhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419556; c=relaxed/simple;
	bh=25a+xXQ1heY5RNKMbD3/mNhgR1Z1gljogRR9UUG+yTE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=QI2TqLnPMHAY4PrTaTWzwsPm6sTiBOileO8Qsx8rql4alWxvlbcXXaI4lWVLdKqqxd4eKqSOjLc+1tfY7YwTOvPWgrSFbWmqNVEi44JHU5mno05qNLQPgvzLNM0lTLr1/osg/XyVJ3xNHCuJyNlb2j/sMTQvGX1O3AWleb3vKgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VtDFt0q8WzmW8y;
	Mon,  3 Jun 2024 20:54:42 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 6A6AD140413;
	Mon,  3 Jun 2024 20:58:57 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:14 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 05/12] md: replace sysfs api sync_action with new helpers
Date: Mon, 3 Jun 2024 20:58:08 +0800
Message-ID: <20240603125815.2199072-6-yukuai3@huawei.com>
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

To get rid of extrem long if else if usage, and make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 94 +++++++++++++++++++++++++++----------------------
 1 file changed, 52 insertions(+), 42 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 28f50a106566..8a54b56e3463 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4949,27 +4949,9 @@ const char *md_sync_action_name(enum sync_action action)
 static ssize_t
 action_show(struct mddev *mddev, char *page)
 {
-	char *type = "idle";
-	unsigned long recovery = mddev->recovery;
-	if (test_bit(MD_RECOVERY_FROZEN, &recovery))
-		type = "frozen";
-	else if (test_bit(MD_RECOVERY_RUNNING, &recovery) ||
-	    (md_is_rdwr(mddev) && test_bit(MD_RECOVERY_NEEDED, &recovery))) {
-		if (test_bit(MD_RECOVERY_RESHAPE, &recovery))
-			type = "reshape";
-		else if (test_bit(MD_RECOVERY_SYNC, &recovery)) {
-			if (!test_bit(MD_RECOVERY_REQUESTED, &recovery))
-				type = "resync";
-			else if (test_bit(MD_RECOVERY_CHECK, &recovery))
-				type = "check";
-			else
-				type = "repair";
-		} else if (test_bit(MD_RECOVERY_RECOVER, &recovery))
-			type = "recover";
-		else if (mddev->reshape_position != MaxSector)
-			type = "reshape";
-	}
-	return sprintf(page, "%s\n", type);
+	enum sync_action action = md_sync_action(mddev);
+
+	return sprintf(page, "%s\n", md_sync_action_name(action));
 }
 
 /**
@@ -5112,35 +5094,63 @@ static int mddev_start_reshape(struct mddev *mddev)
 static ssize_t
 action_store(struct mddev *mddev, const char *page, size_t len)
 {
+	int ret;
+	enum sync_action action;
+
 	if (!mddev->pers || !mddev->pers->sync_request)
 		return -EINVAL;
 
+	action = md_sync_action_by_name(page);
 
-	if (cmd_match(page, "idle"))
-		idle_sync_thread(mddev);
-	else if (cmd_match(page, "frozen"))
-		frozen_sync_thread(mddev);
-	else if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery))
-		return -EBUSY;
-	else if (cmd_match(page, "resync"))
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-	else if (cmd_match(page, "recover")) {
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
-	} else if (cmd_match(page, "reshape")) {
-		int err = mddev_start_reshape(mddev);
-
-		if (err)
-			return err;
+	/* TODO: mdadm rely on "idle" to start sync_thread. */
+	if (test_bit(MD_RECOVERY_RUNNING, &mddev->recovery)) {
+		switch (action) {
+		case ACTION_FROZEN:
+			frozen_sync_thread(mddev);
+			return len;
+		case ACTION_IDLE:
+			idle_sync_thread(mddev);
+			break;
+		case ACTION_RESHAPE:
+		case ACTION_RECOVER:
+		case ACTION_CHECK:
+		case ACTION_REPAIR:
+		case ACTION_RESYNC:
+			return -EBUSY;
+		default:
+			return -EINVAL;
+		}
 	} else {
-		if (cmd_match(page, "check"))
+		switch (action) {
+		case ACTION_FROZEN:
+			set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			return len;
+		case ACTION_RESHAPE:
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			ret = mddev_start_reshape(mddev);
+			if (ret)
+				return ret;
+			break;
+		case ACTION_RECOVER:
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			set_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
+			break;
+		case ACTION_CHECK:
 			set_bit(MD_RECOVERY_CHECK, &mddev->recovery);
-		else if (!cmd_match(page, "repair"))
+			fallthrough;
+		case ACTION_REPAIR:
+			set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
+			set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+			fallthrough;
+		case ACTION_RESYNC:
+		case ACTION_IDLE:
+			clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
+			break;
+		default:
 			return -EINVAL;
-		clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
-		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
-		set_bit(MD_RECOVERY_SYNC, &mddev->recovery);
+		}
 	}
+
 	if (mddev->ro == MD_AUTO_READ) {
 		/* A write to sync_action is enough to justify
 		 * canceling read-auto mode
-- 
2.39.2

