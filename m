Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DB1E13C66A
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218149; cv=none; b=aJ67+jOqdI26leLIQYUQSZHineE7Y3NdbuV/64eM5pi2tmXNI1A8zOJ94cPongm4o3WLXxmYsJ8J+9Hj7cbujqaLHCj02t/mMDW2Xci6Dt/JFjLfOKaWKQNpQ13YnCI7qmlZlUEF0kE5NXcJRzncHLdAzybfbkRWAgg+4nm1xoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218149; c=relaxed/simple;
	bh=fvVoQBkbmWDglRcQFnfv1KvoziCqS+4VwoQlM+ctkSI=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=aLyqvzulT4HjyCBBWqXIL34WzZ5G0csjz65D6Lom3FUvajM7dME1QGs/ZoFaW3m79N72XSsS6V/nQv74Uj1kezR7aZAydriL5ygmG0Ql4ZDNRw7Q4xEvfEwcECd5WTuaOfj9/zRXeWMyr4hVfkpGsQijZqWCDibGqG9p692y8bo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZZDC67SGz4f3kjd
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:28:59 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 342F01A016E
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:29:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDeJjxm5MuXMA--.59814S7;
	Thu, 09 May 2024 09:29:05 +0800 (CST)
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
Subject: [PATCH md-6.10 3/9] md: add new helpers for sync_action
Date: Thu,  9 May 2024 09:18:54 +0800
Message-Id: <20240509011900.2694291-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDeJjxm5MuXMA--.59814S7
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW5XrWxAFWfuw1kGryxGrg_yoW5tw48pF
	WIyF98ZrWjvF43XrnxJa4DAayrZw1xX3y7GryxGa4fJ3WaganYk3WDt3WUAF9YkFy3urWa
	qa4DGFy5uF40yr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPj14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Cr0_Gr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVWUJVW8Jw
	CI42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjfUFfHUDUUU
	U
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The new helpers will get current sync_action of the array, will be used
in later patches to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 64 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 +++
 2 files changed, 67 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 00bbafcd27bb..48ec35342d1b 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -69,6 +69,16 @@
 #include "md-bitmap.h"
 #include "md-cluster.h"
 
+static char *action_name[NR_SYNC_ACTIONS] = {
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
@@ -4867,6 +4877,60 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
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
+	 * idle means no sync_thread is running, and no new sync_thread is
+	 * requested.
+	 */
+	if (!test_bit(MD_RECOVERY_RUNNING, &recovery) &&
+	    (!md_is_rdwr(mddev) || !test_bit(MD_RECOVERY_NEEDED, &recovery)))
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
+		if (test_bit(MD_RECOVERY_CHECK, &recovery))
+			return ACTION_CHECK;
+		if (test_bit(MD_RECOVERY_REQUESTED, &recovery))
+			return ACTION_REPAIR;
+		return ACTION_RESYNC;
+	}
+
+	return ACTION_IDLE;
+}
+
+enum sync_action md_sync_action_by_name(char *page)
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
+char *md_sync_action_name(enum sync_action action)
+{
+	return action_name[action];
+}
+
 static ssize_t
 action_show(struct mddev *mddev, char *page)
 {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2edad966f90a..72ca7a796df5 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
 extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
+extern enum sync_action md_sync_action(struct mddev *mddev);
+extern enum sync_action md_sync_action_by_name(char *page);
+extern char *md_sync_action_name(enum sync_action action);
 extern bool md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
-- 
2.39.2

