Received: from dggsgout11.his.huawei.com (unknown [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA16A17C9F9
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 13:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718112201; cv=none; b=d6LWCEzr9k275aK339aJBdoV8F84Eerx4kfarSelxVumd1NNE3PbZSOmBCqcVODxkpQWHRcrdZQPE5SY2jne0u0ErlLhrmyk19azTq09dCutSy/4VcWqZRm+efRhYZd8FD9O8FAOpfjgFmzO8JaWRdrYgNpy8Lvy190LdNev27M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718112201; c=relaxed/simple;
	bh=Y71BHiOOnVRfHmnzmD7aEmu6FN/FsBGXqLMcD8ZaSUA=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=WiA4Yk6+WYKbfR2OHmGCeUA5jwnTBlzC+WJrIWsXOp6D9RnoT6HPV93fvkwDUK5UkHNAzhI2xpKKBgRZ2sR0KD4ehqO4QFmi5tQbRAgYltJlmQtu7gOM1JlBN5aZ8jN44smQifQoMFVBjWMkTzHWnlf/+igeAZR0wU/3avLT2F8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.235])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Vz8W22B4Dz4f3jkK
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:10 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.112])
	by mail.maildlp.com (Postfix) with ESMTP id D16DA1A06D6
	for <dm-devel@lists.linux.dev>; Tue, 11 Jun 2024 21:23:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP1 (Coremail) with SMTP id cCh0CgDHlxDBT2hmsVPEPA--.1557S6;
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
Subject: [PATCH v2 md-6.11 02/12] md: add a new enum type sync_action
Date: Tue, 11 Jun 2024 21:22:41 +0800
Message-Id: <20240611132251.1967786-3-yukuai1@huaweicloud.com>
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
X-CM-TRANSID:cCh0CgDHlxDBT2hmsVPEPA--.1557S6
X-Coremail-Antispam: 1UD129KBjvJXoWxAryUJr13WrW8XFyDAF47Arb_yoW5Xw4rpF
	s7Cas5Jr1DAF4xA39ava47J393Za10q3y3JrW3WryrAa4Yyas7AFnxJ347AayDKr15Ka4U
	uFZ0k3Z8uFWkZ3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUBK14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jryl82xGYIkIc2
	x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
	Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr0_Gr1UM2
	8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
	xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
	vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
	r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
	v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
	Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
	0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
	JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
	AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUbdOz7UUUUU=
	=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/

From: Yu Kuai <yukuai3@huawei.com>

In order to make code related to sync_thread cleaner in following
patches, also add detail comment about each sync action. And also
prepare to remove the related recovery_flags in the fulture.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 1ee129c6f98f..e5001d39c82d 100644
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

