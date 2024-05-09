Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B85651327EB
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218149; cv=none; b=UWA/sIlbrTlEuz20CcRQb3visnUEgTbyDNpjDxwmqK0Xn4w2lauxSEhdnBq2M5qc+fVVEsom5VVhlxPRtJLbcmyLi9SnTASoAH+yiIf23ISdtQ0s0TGfQlOOdeo91HgtN7WCSWip3pDyZ1+5yBXdTK5PvaRNampbIc3mFzmfnr8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218149; c=relaxed/simple;
	bh=qGYdxANQG8fi9Ws+cMkljJA+iEqhORjVzl9kgebQQj4=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=dLW3OOU1T04ceyAiLHyFopNKEk3a173gl4vUR/WX3mPZS5pALjsENIsj8PQQzPvQpW/gEXujVLBsYKpdNZsl/0AvymOB857VHM7AZrZCRF+Daqnl+xtmDUmU3CVqM/+kiJLBqsRhWemVCCuB8aJpFLpx8meCO77bcm8mip8qjaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.216])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZZD62KJzz4f3nK1
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:28:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id 33AF61A09FA
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:29:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDeJjxm5MuXMA--.59814S5;
	Thu, 09 May 2024 09:29:04 +0800 (CST)
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
Subject: [PATCH md-6.10 1/9] md: rearrange recovery_flage
Date: Thu,  9 May 2024 09:18:52 +0800
Message-Id: <20240509011900.2694291-2-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDeJjxm5MuXMA--.59814S5
X-Coremail-Antispam: 1UD129KBjvJXoWxuF4UWFW3Cw47urWfXFy7ZFb_yoW5WFyrpF
	W0k3Z3Xr4UAry7ZrZxKayDX395ArW0qFy3Ar9xWr98tasYka1fAF4UWa4UJFWkt347ta12
	qF1DJF13uF4jvw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
	x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUSYLPUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

Currently there are lots of flags and the names are confusing, since
there are two main types of flags, sync thread runnng status and sync
thread action, rearrange and update comment to improve code readability,
there are no functional changes.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 38 insertions(+), 14 deletions(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 029dd0491a36..2a1cb7b889e5 100644
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

