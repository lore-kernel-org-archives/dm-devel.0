Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C921B12C550
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:58:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419495; cv=none; b=he07o5OL3u6pTQ+8Tl1h5U3l2iNeFhcWKHWVQt9UP+lL1VtbM96m85HuIE9P9a0ZpztzAPC4+elTu1Zd0TDeNRuqoPywk76j5PIifKxR1FB+vRUwL9RclAPWpTSaZSAhXHoNunyh1kZtganF/BSLRc8NYdKVXE4brvpvJmYp8b8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419495; c=relaxed/simple;
	bh=gdmUcErX0vsOeRarPKhA1OeJyebQSfVxmZsfIBoqpRg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UawcPIwJbGPldj6vVCpk+JGxy5ftvHyF3XU4484h/i5gIGMARAURiiu9lT0FbqnH/qgUxY0tXxlQyT/TOlUReC6ohAV9oFH3eTbfjISTDXR4Q1BJqijW5MCGXYjMDk9auYuqY8bmc2IaGsgLoLrowSM2H2U0EDOttw6riFZUR6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VtDFP1lqYzwRLd;
	Mon,  3 Jun 2024 20:54:17 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 5B033140417;
	Mon,  3 Jun 2024 20:58:11 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:10 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 01/12] md: rearrange recovery_flags
Date: Mon, 3 Jun 2024 20:58:04 +0800
Message-ID: <20240603125815.2199072-2-yukuai3@huawei.com>
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
index ca085ecad504..170412a65b63 100644
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

