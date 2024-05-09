Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B83F32BB12
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 01:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715218149; cv=none; b=Rq8G9gjbyalECJc/mLL69oFYFYj06OMymVTD3M126dAGqXumsf/ngd1u9CZ3pcrVsRtCVliX3bsCrlz/4mos02MQzjwJhHS5hZhn1mnGoK1qhEu7kEnC+r9V2csLlDsiRMbZYUIb067d0gODSDtBvHEQgVVOfFDm7cR1dsQ4eIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715218149; c=relaxed/simple;
	bh=tcI8Rq4r8Y8X0VfPoe9tsANZa22K9p//uTz8bH7EMlU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=Io3mJYTHEa6dTCMETJQKYJ05E+IGCKfCSP3SB55LMUz4np1pg1GLyK/b+M+uCOtEo0u1vae6iT+DMSaOtDCIO7l6uACAjY8HLvqMLMj6JiFrhnBS6v9u42zy3M0I0mkajilEIzlcF600DqbhFM7Alo1p5UZEitYKVgyJFBJ3nvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4VZZD65vcJz4f3nKT
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:28:54 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id AED7F1A016E
	for <dm-devel@lists.linux.dev>; Thu,  9 May 2024 09:29:04 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDeJjxm5MuXMA--.59814S6;
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
Subject: [PATCH md-6.10 2/9] md: add a new enum type sync_action
Date: Thu,  9 May 2024 09:18:53 +0800
Message-Id: <20240509011900.2694291-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDeJjxm5MuXMA--.59814S6
X-Coremail-Antispam: 1UD129KBjvJXoWxAryUJr18GFWxtw47CF4Durg_yoW5XrW7pF
	4kCas5Xr1DAF4xA3ySva47W393ZF4Fq3y3JryagryrAa4Yyas7AFnxJ3srAaykKr15Ga4U
	uFZ0k3Z8uFykZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
	A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
	0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
	IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
	Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
	xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
	6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
	Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
	Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
	IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUAGYLUUUUU
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

In order to make code related to sync_thread cleaner in following
patches, also add detail comment about each sync action.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2a1cb7b889e5..2edad966f90a 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -34,6 +34,61 @@
  */
 #define	MD_FAILFAST	(REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT)
 
+/* Status of sync thread. */
+enum sync_action {
+	/*
+	 * Represent by MD_RECOVERY_SYNC, start when:
+	 * 1) after assemble, sync data from first rdev to other copies, this
+	 * must be done first before other sync actions and will only execute
+	 * once;
+	 * 2) resize the array(notice that this is not reshape), sync data for
+	 * the new range;
+	 */
+	ACTION_RESYNC,
+	/*
+	 * Represent by MD_RECOVERY_RECOVER, start when:
+	 * 1) for new replacement, sync data based on the replace rdev or
+	 * available copies from other rdev;
+	 * 2) for new member disk while the array is degraded, sync data from
+	 * other rdev;
+	 * 3) reassemble after power failure or re-add a hot removed rdev, sync
+	 * data from first rdev to other copies based on bitmap;
+	 */
+	ACTION_RECOVER,
+	/*
+	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED |
+	 * MD_RECOVERY_CHECK, start when user echo "check" to sysfs api
+	 * sync_action, used to check if data copies from differenct rdev are
+	 * the same. The number of mismatch sectors will be exported to user
+	 * by sysfs api mismatch_cnt;
+	 */
+	ACTION_CHECK,
+	/*
+	 * Represent by MD_RECOVERY_SYNC | MD_RECOVERY_REQUESTED, start when
+	 * user echo "repair" to sysfs api sync_action, usually paired with
+	 * ACTION_CHECK, used to force syncing data once user found that there
+	 * are inconsistent data,
+	 */
+	ACTION_REPAIR,
+	/*
+	 * Represent by MD_RECOVERY_RESHAPE, start when new member disk is added
+	 * to the conf, notice that this is different from spares or
+	 * replacement;
+	 */
+	ACTION_RESHAPE,
+	/*
+	 * Represent by MD_RECOVERY_FROZEN, can be set by sysfs api sync_action
+	 * or internal usage like setting the array read-only, will forbid above
+	 * actions.
+	 */
+	ACTION_FROZEN,
+	/*
+	 * All above actions don't match.
+	 */
+	ACTION_IDLE,
+	NR_SYNC_ACTIONS,
+};
+
 /*
  * The struct embedded in rdev is used to serialize IO.
  */
@@ -571,7 +626,7 @@ enum recovery_flags {
 	/* interrupted because io-error */
 	MD_RECOVERY_ERROR,
 
-	/* flags determines sync action */
+	/* flags determines sync action, see details in enum sync_action */
 
 	/* if just this flag is set, action is resync. */
 	MD_RECOVERY_SYNC,
-- 
2.39.2

