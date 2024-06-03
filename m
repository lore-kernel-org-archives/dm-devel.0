Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA85E1E4A2
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 13:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419616; cv=none; b=DQi1Jb4+HpMWZXbZUid7YmjtCkIrsXbu7Xwi8mVy3jZvmR3V5GaJ2a05eLL7wQrgou4XGy1qaYCXEVYZ9b80ZwDoTSKOFdRY/KOBAWgcjXFr8TBNtqlFm7y8VQ4VBLgctzGTUFbgVIQL4wJ4kN7vT8wD8bLajaPpDGbM0iyLO8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419616; c=relaxed/simple;
	bh=4zakUcF0MFcOmck4ftv9hkRUFHgaYL5eZRBK1OfzTbI=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=az1O3uiUoYX+vaQw0aXOchhoNvN1ktxfbdMV8clrqSHQ5IHpGFKPmPNTqOpydriEChTlQHi6z2LQVbNYA08HIouRORU9wBKOISauVQbW+RDAyw/+aZw04Imofqn1/SYgJqn0IaA8dOxP2bzUCpyl8jeSuJ2aayCNt/PpuuRqAAQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VtDHk4bwHz1S8qP;
	Mon,  3 Jun 2024 20:56:18 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 9770814037B;
	Mon,  3 Jun 2024 20:59:57 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:17 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 09/12] md: replace last_sync_action with new enum type
Date: Mon, 3 Jun 2024 20:58:12 +0800
Message-ID: <20240603125815.2199072-10-yukuai3@huawei.com>
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

The only difference is that "none" is removed and initial
last_sync_action will be idle.

On the one hand, this value is introduced by commit c4a395514516
("MD: Remember the last sync operation that was performed"), and the
usage described in commit message is not affected. On the other hand,
last_sync_action is not used in mdadm or mdmon, and none of the tests
that I can find.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c | 2 +-
 drivers/md/md.c      | 7 ++++---
 drivers/md/md.h      | 9 ++++-----
 3 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index abe88d1e6735..052c00c1eb15 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3542,7 +3542,7 @@ static void raid_status(struct dm_target *ti, status_type_t type,
 		recovery = rs->md.recovery;
 		state = decipher_sync_action(mddev, recovery);
 		progress = rs_get_progress(rs, recovery, state, resync_max_sectors);
-		resync_mismatches = (mddev->last_sync_action && !strcasecmp(mddev->last_sync_action, "check")) ?
+		resync_mismatches = mddev->last_sync_action == ACTION_CHECK ?
 				    atomic64_read(&mddev->resync_mismatches) : 0;
 
 		/* HM FIXME: do we want another state char for raid0? It shows 'D'/'A'/'-' now */
diff --git a/drivers/md/md.c b/drivers/md/md.c
index e44016055b56..28977595b7ba 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -767,7 +767,7 @@ int mddev_init(struct mddev *mddev)
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
 	mddev->reshape_backwards = 0;
-	mddev->last_sync_action = "none";
+	mddev->last_sync_action = ACTION_IDLE;
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
@@ -5148,7 +5148,8 @@ __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
 static ssize_t
 last_sync_action_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%s\n", mddev->last_sync_action);
+	return sprintf(page, "%s\n",
+		       md_sync_action_name(mddev->last_sync_action));
 }
 
 static struct md_sysfs_entry md_last_scan_mode = __ATTR_RO(last_sync_action);
@@ -8968,7 +8969,7 @@ void md_do_sync(struct md_thread *thread)
 
 	action = md_sync_action(mddev);
 	desc = md_sync_action_name(action);
-	mddev->last_sync_action = desc;
+	mddev->last_sync_action = action;
 
 	/*
 	 * Before starting a resync we must have set curr_resync to
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 614011651f79..296a78568fc4 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -426,13 +426,12 @@ struct mddev {
 	struct md_thread __rcu		*thread;	/* management thread */
 	struct md_thread __rcu		*sync_thread;	/* doing resync or reconstruct */
 
-	/* 'last_sync_action' is initialized to "none".  It is set when a
-	 * sync operation (i.e "data-check", "requested-resync", "resync",
-	 * "recovery", or "reshape") is started.  It holds this value even
+	/*
+	 * Set when a sync operation is started. It holds this value even
 	 * when the sync thread is "frozen" (interrupted) or "idle" (stopped
-	 * or finished).  It is overwritten when a new sync operation is begun.
+	 * or finished). It is overwritten when a new sync operation is begun.
 	 */
-	const char			*last_sync_action;
+	enum sync_action		last_sync_action;
 	sector_t			curr_resync;	/* last block scheduled */
 	/* As resync requests can complete out of order, we cannot easily track
 	 * how much resync has been completed.  So we occasionally pause until
-- 
2.39.2

