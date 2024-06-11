Received: from dggsgout12.his.huawei.com (unknown [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3843617CA04
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112205; cv=none; b=GvAFlofv2pQh7buETv976inlQs4o6RbZDYSvjtISJVkk/YaZTcxy1u5YsUb55evKhUSOyHQmZov2yDeMGScmCVEMqXrnn+MNunZW3oe09+8CxN9EgMcs/rodDNN+5ZgntWbAULRmOSE1LMaFR92m4tDAc7Lw6Umddq6FUGmdgLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112205; c=relaxed/simple;
	bh=VGH19sLz/SZXAd/C1LzuUaE5aQdUkBDO3ZJ5CtF0JQ8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Pk4QF1nPCLFI0tSDZQpaYSJiKjJgZ7pg3jOARZvjha/++tD6lmr3QTVfFTyJ19vUeYhldceU449GihixAr31+F8LsrM7G+3+5T8epLpxVIpvUsfwutTQfEF3Yd8bDdD7oct1SrzIW01NOjbFYbya0TKIn5xnyZ2lXmmv1Zlns8s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W22rHJz4f3jsq
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 624F71A0FDB
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:20 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S13;
	Tue, 11 Jun 2024 21:23:20 +0800 (CST)
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
Subject: [PATCH v2 md-6.11 09/12] md: replace last_sync_action with new enum type
Date: Tue, 11 Jun 2024 21:22:48 +0800
Message-Id: <20240611132251.1967786-10-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S13
X-Coremail-Antispam: 1UD129KBjvJXoWxCF4UWr1ftr1Dtw4fJF17Awb_yoW5Kw48pa
	yrAa43Zr4UJr4rXa1kXrykCFWF9wn7J3yrKrW7u3y8Aa13Kr1DKF13Ga1UuFyDZFyFyFWa
	qayDWFW5AF40kr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
index 5fa7b5f4bc6d..ab492e885867 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -768,7 +768,7 @@ int mddev_init(struct mddev *mddev)
 	init_waitqueue_head(&mddev->recovery_wait);
 	mddev->reshape_position = MaxSector;
 	mddev->reshape_backwards = 0;
-	mddev->last_sync_action = "none";
+	mddev->last_sync_action = ACTION_IDLE;
 	mddev->resync_min = 0;
 	mddev->resync_max = MaxSector;
 	mddev->level = LEVEL_NONE;
@@ -5149,7 +5149,8 @@ __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
 static ssize_t
 last_sync_action_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%s\n", mddev->last_sync_action);
+	return sprintf(page, "%s\n",
+		       md_sync_action_name(mddev->last_sync_action));
 }
 
 static struct md_sysfs_entry md_last_scan_mode = __ATTR_RO(last_sync_action);
@@ -8963,7 +8964,7 @@ void md_do_sync(struct md_thread *thread)
 
 	action = md_sync_action(mddev);
 	desc = md_sync_action_name(action);
-	mddev->last_sync_action = desc;
+	mddev->last_sync_action = action;
 
 	/*
 	 * Before starting a resync we must have set curr_resync to
diff --git a/drivers/md/md.h b/drivers/md/md.h
index ee06cb076f8c..41781e41d8ff 100644
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

