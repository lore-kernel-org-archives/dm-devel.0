Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAB912C7F8
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419600; cv=none; b=OQVtz9SAbSiGWpGAyIAfo1MsANhAJTI1/JKuFj0pe5kvWF4iDBa260+me5quXsd8dKoxNm95lzznLzCvW6Gp6q/ajqBYpsTf+3yhfU/hXcCM2w/6QSPyQ0STRzfSd8uHB3GYfDWWGXSut6zFIL3mXywNbWx0bZowBsNxlb+DoDM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419600; c=relaxed/simple;
	bh=ZnrRWs3Bwqrx78eVopoiKrlxIXxIzL+fgWaWm9uO0kE=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=jOS+DQ6wA2NbFn6MK8ookmHCo8yskHDvtW3spWhIIBj0+SUdOQZ3Ih1IdgFU9Ro6dI4hwDJ8EEoX0k5F7ZGW9RAxw9yEmgRPXaTd7alcYSUr1l/kz8OzOo11fY2Nx7c19Q6MpiNf3hrd+KTYxZ2lXmE2KNI2/m6yZhBJ969Zc1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VtDLL2Pn9zcl8Z;
	Mon,  3 Jun 2024 20:58:34 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 8C6E3140123;
	Mon,  3 Jun 2024 20:59:42 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:16 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 08/12] md: use new helers in md_do_sync()
Date: Mon, 3 Jun 2024 20:58:11 +0800
Message-ID: <20240603125815.2199072-9-yukuai3@huawei.com>
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

Make code cleaner. and also use the action_name directly in kernel log:
 - "check" instead of "data-check"
 - "repair" instead of "requested-resync"

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 21 +++++----------------
 drivers/md/md.h |  2 +-
 2 files changed, 6 insertions(+), 17 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 3890ae86449a..e44016055b56 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -8934,7 +8934,8 @@ void md_do_sync(struct md_thread *thread)
 	sector_t last_check;
 	int skipped = 0;
 	struct md_rdev *rdev;
-	char *desc, *action = NULL;
+	enum sync_action action;
+	const char *desc;
 	struct blk_plug plug;
 	int ret;
 
@@ -8965,21 +8966,9 @@ void md_do_sync(struct md_thread *thread)
 			goto skip;
 	}
 
-	if (test_bit(MD_RECOVERY_SYNC, &mddev->recovery)) {
-		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery)) {
-			desc = "data-check";
-			action = "check";
-		} else if (test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery)) {
-			desc = "requested-resync";
-			action = "repair";
-		} else
-			desc = "resync";
-	} else if (test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery))
-		desc = "reshape";
-	else
-		desc = "recovery";
-
-	mddev->last_sync_action = action ?: desc;
+	action = md_sync_action(mddev);
+	desc = md_sync_action_name(action);
+	mddev->last_sync_action = desc;
 
 	/*
 	 * Before starting a resync we must have set curr_resync to
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f7afc5a46031..614011651f79 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -432,7 +432,7 @@ struct mddev {
 	 * when the sync thread is "frozen" (interrupted) or "idle" (stopped
 	 * or finished).  It is overwritten when a new sync operation is begun.
 	 */
-	char				*last_sync_action;
+	const char			*last_sync_action;
 	sector_t			curr_resync;	/* last block scheduled */
 	/* As resync requests can complete out of order, we cannot easily track
 	 * how much resync has been completed.  So we occasionally pause until
-- 
2.39.2

