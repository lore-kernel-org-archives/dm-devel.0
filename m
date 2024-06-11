Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4DBEE17B4F1
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112201; cv=none; b=UeZQPhi/YYXu5X8tpFMDMtPgf4bHsvanNDPs/lW4MLnUW/EGZUTB8r6+ufy7GW+1JpWyafwvsOzdNp8N9MQnb6FaIWdaNalYYUVbUz+/ovZW+Ihms8QJ2WoycZNGj0wXMPBe659P7qFjVCeJOlnG6o3Y/JHwYDImct31exIbNOA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112201; c=relaxed/simple;
	bh=vsKrgmnrDLeocYpqRdMGPAk0APiyOOhsd/Uid/g8hgs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QUHCOYtpQpF6gNYRUzRtUCs8QBgT/anIcl3FROhITmtRRXbPy22uK6R3fS9n9z8VPgU6VfbqWfukwNdpMGgFIiKqVs3bvJd/nj72g+IQZBfOyLIbS8YLYXLY34ZEWGtnjnKc9EIV91V8s1dvr9ahxSo07px5xw+7zHDIYlP4UIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Vz8Vy2bqPz4f3jXt
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:06 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 5AE101A0C08
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S5;
	Tue, 11 Jun 2024 21:23:16 +0800 (CST)
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
Subject: [PATCH v2 md-6.11 01/12] md: rearrange recovery_flags
Date: Tue, 11 Jun 2024 21:22:40 +0800
Message-Id: <20240611132251.1967786-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S5
X-Coremail-Antispam: 1UD129KBjvJXoWxuF1kXw1DJr13Xr4fAw17trb_yoW5AF15pF
	W0kFn3XF4UAr17ZrW3tayDX395ArW0qFy3Cr9xWr98tFWFy3WfAr4UX3WUJFZ7t347ta12
	qF1DJF13uF4jvw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjFdgJUUUUU=
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently there are lots of flags with the same confusing prefix
"MD_REOCVERY_", and there are two main types of flags, sync thread runnng
status, I prefer prefix "SYNC_THREAD_", and sync thread action, I perfer
prefix "SYNC_ACTION_".

For now, rearrange and update comment to improve code readability,
there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 487582058f74..1ee129c6f98f 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -551,22 +551,46 @@ struct mddev {
 };
 
 enum recovery_flags {
+	/* flags for sync thread running status */
+
+	/*
+	 * set when one of sync action is set and new sync thread need to be
+	 * registered, or just add/remove spares from conf.
+	 */
+	MD_RECOVERY_NEEDED,
+	/* sync thread is running, or about to be started */
+	MD_RECOVERY_RUNNING,
+	/* sync thread needs to be aborted for some reason */
+	MD_RECOVERY_INTR,
+	/* sync thread is done and is waiting to be unregistered */
+	MD_RECOVERY_DONE,
+	/* running sync thread must abort immediately, and not restart */
+	MD_RECOVERY_FROZEN,
+	/* waiting for pers->start() to finish */
+	MD_RECOVERY_WAIT,
+	/* interrupted because io-error */
+	MD_RECOVERY_ERROR,
+
+	/* flags determines sync action */
+
+	/* if just this flag is set, action is resync. */
+	MD_RECOVERY_SYNC,
+	/*
+	 * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not set,
+	 * action is repair, means user requested resync.
+	 */
+	MD_RECOVERY_REQUESTED,
 	/*
-	 * If neither SYNC or RESHAPE are set, then it is a recovery.
+	 * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, action is
+	 * check.
 	 */
-	MD_RECOVERY_RUNNING,	/* a thread is running, or about to be started */
-	MD_RECOVERY_SYNC,	/* actually doing a resync, not a recovery */
-	MD_RECOVERY_RECOVER,	/* doing recovery, or need to try it. */
-	MD_RECOVERY_INTR,	/* resync needs to be aborted for some reason */
-	MD_RECOVERY_DONE,	/* thread is done and is waiting to be reaped */
-	MD_RECOVERY_NEEDED,	/* we might need to start a resync/recover */
-	MD_RECOVERY_REQUESTED,	/* user-space has requested a sync (used with SYNC) */
-	MD_RECOVERY_CHECK,	/* user-space request for check-only, no repair */
-	MD_RECOVERY_RESHAPE,	/* A reshape is happening */
-	MD_RECOVERY_FROZEN,	/* User request to abort, and not restart, any action */
-	MD_RECOVERY_ERROR,	/* sync-action interrupted because io-error */
-	MD_RECOVERY_WAIT,	/* waiting for pers->start() to finish */
-	MD_RESYNCING_REMOTE,	/* remote node is running resync thread */
+	MD_RECOVERY_CHECK,
+	/* recovery, or need to try it */
+	MD_RECOVERY_RECOVER,
+	/* reshape */
+	MD_RECOVERY_RESHAPE,
+	/* remote node is running resync thread */
+	MD_RESYNCING_REMOTE,
 };
 
 enum md_ro_state {
-- 
2.39.2

