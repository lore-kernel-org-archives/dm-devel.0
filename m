Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4906517CA01
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112202; cv=none; b=OCX/QjgxAYnymTwSTjTo5wmj2fD4lj7I2uzZzd41FmWh1hQROoN/xG32PTkqRl39hgfq5oiNI6iohnSZwg021iT0FIH3P4zE0SIOwjTNpoWsciv4ggINysi8GnY7PCC5HSOCxAzRi0bJ5OapUlUGeFxu/Y32pJ1sb/HlqZWCytQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112202; c=relaxed/simple;
	bh=rIS/FBqfyW2srSdzFUnL98cAITUsE1DDF18pv08IhBs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=maxweXgIgd5ZrKzdffAVLGkqFXvBckgHqIDr4wd7lL38khSrq+okog0PbQOlAEgRhOjnN/4ohI04gXqA5R4AeVEnhH0Cg2Ei0V36zKyFioWUWdAVSALjpoIfQRefRAN6UychhxWU0sPMzdFRhiSBKAo5AZgBShlt1l9tGEBfSuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W25zkYz4f3jjv
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 61E4B1A0ED2
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:17 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S7;
	Tue, 11 Jun 2024 21:23:17 +0800 (CST)
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
Subject: [PATCH v2 md-6.11 03/12] md: add new helpers for sync_action
Date: Tue, 11 Jun 2024 21:22:42 +0800
Message-Id: <20240611132251.1967786-4-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S7
X-Coremail-Antispam: 1UD129KBjvJXoWxAFW5Cr18Zw15CF13Aw1xuFg_yoWrGFyfpF
	WvyF98ZrWjvF43XrW3Ja4DAayruw1Iq3y7Gry3Gas3J3ZxKanYka1DJ3W7AF9YyFy3urya
	qas8GFW5uF4Yyr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWx
	JVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd8n5UUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

The new helpers will get current sync_action of the array, will be used
in later patches to make code cleaner.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 79 +++++++++++++++++++++++++++++++++++++++++++++++++
 drivers/md/md.h |  3 ++
 2 files changed, 82 insertions(+)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index b9b15aa79496..4ce8d164cde9 100644
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
@@ -4868,6 +4878,75 @@ metadata_store(struct mddev *mddev, const char *buf, size_t len)
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
index e5001d39c82d..88add162b08e 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -864,6 +864,9 @@ extern void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu **t
 extern void md_wakeup_thread(struct md_thread __rcu *thread);
 extern void md_check_recovery(struct mddev *mddev);
 extern void md_reap_sync_thread(struct mddev *mddev);
+extern enum sync_action md_sync_action(struct mddev *mddev);
+extern enum sync_action md_sync_action_by_name(const char *page);
+extern const char *md_sync_action_name(enum sync_action action);
 extern void md_write_start(struct mddev *mddev, struct bio *bi);
 extern void md_write_inc(struct mddev *mddev, struct bio *bi);
 extern void md_write_end(struct mddev *mddev);
-- 
2.39.2

