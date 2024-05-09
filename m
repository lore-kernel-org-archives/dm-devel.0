Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2425B13C838
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 01:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218152; cv=none; b=bIBh9vKGM0HjCQIXsGbfYTLKc0G2B3zBkUfieMR3dqs8mbOuU8a/EzOaSJQWLG86fctv11k7ilufJLISg4DeKKTfi/sHo79UjbF4YlddjtF4riSebiASOcOzJ8Wqbg2xA4UEWeF/+SM0wAk9MOHACxqdZo3NOmpdM1gbLAjy8IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218152; c=relaxed/simple;
	bh=goML364Rx+4Wdc8aHvMpxefUVTTWGVKwB0lZ3XCOus8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=eJjMvZamhZFRAC/+aS2DVk8KYizXoABz2oCtbXUChPKAZX3oC+SR6PAJ3nqCmWRZKd3qDNG3V3vgvDr/u0aLi2Um6YAS+w+NIVK6lJpjFA4f2YBVPvkypip17Km/ZunnuO7EUeIMuikXDyuoaH4UWskzXIdf5wWvjHK+Y7EluE8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZZD92KMGz4f3n6K
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:28:57 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 348CB1A016E
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:29:07 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDeJjxm5MuXMA--.59814S11;
	Thu, 09 May 2024 09:29:07 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	song@kernel.org,
	xni@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	yukuai3@huawei.com,
	yukuai1@huaweicloud.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com
Subject: [PATCH md-6.10 7/9] md: replace last_sync_action with new enum type
Date: Thu,  9 May 2024 09:18:58 +0800
Message-Id: <20240509011900.2694291-8-yukuai1@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:cCh0CgDHlxDeJjxm5MuXMA--.59814S11
X-Coremail-Antispam: 1UD129KBjvJXoWxCF4UWr1ftr1Dtw4fJF17Awb_yoW5uF13pa
	yrAa43Ar4UJrZ5Xw4kJrykuFyF9wn7GayrKrW7u3y8Aa1fKr1DKF13Wa1UZFyDZFyFyFWa
	qayDGFW5ZF40kr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
	3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
	IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
	M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
	kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr
	0_Gr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUA
	rcfUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The only difference is that "none" is removed and initial
last_sync_action will be idle.

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
index 0b609d79453a..2fc81175b46b 100644
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
@@ -5156,7 +5156,8 @@ __ATTR_PREALLOC(sync_action, S_IRUGO|S_IWUSR, action_show, action_store);
 static ssize_t
 last_sync_action_show(struct mddev *mddev, char *page)
 {
-	return sprintf(page, "%s\n", mddev->last_sync_action);
+	return sprintf(page, "%s\n",
+		       md_sync_action_name(mddev->last_sync_action));
 }
 
 static struct md_sysfs_entry md_last_scan_mode = __ATTR_RO(last_sync_action);
@@ -8977,7 +8978,7 @@ void md_do_sync(struct md_thread *thread)
 
 	action = md_sync_action(mddev);
 	desc = md_sync_action_name(action);
-	mddev->last_sync_action = desc;
+	mddev->last_sync_action = action;
 
 	/*
 	 * Before starting a resync we must have set curr_resync to
diff --git a/drivers/md/md.h b/drivers/md/md.h
index cf54870e89db..883b147a2c52 100644
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
-	char				*last_sync_action;
+	enum sync_action		last_sync_action;
 	sector_t			curr_resync;	/* last block scheduled */
 	/* As resync requests can complete out of order, we cannot easily track
 	 * how much resync has been completed.  So we occasionally pause until
-- 
2.39.2

