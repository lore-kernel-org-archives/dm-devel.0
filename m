Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08AC312C484
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 12:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419511; cv=none; b=JIhAGR6LLa6cPNgnzvbcq33UmrV9rHcYC2fEeWiyUbcOMBk5nc3SSxMWcKe6c1gVLVpNwP5r6OH9u0EjTeyvrvVRRzbMIE7BaipXqZg+cCuHWOFm6RLb5/PAtC0CaPfxq/EkaqBqEpVOKdiKYr+fO4R5adpgJ2RSaa08OwnFmU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419511; c=relaxed/simple;
	bh=4FtcTTlzUqRsL2pap7+D6l9nOTLemGR0nLVEbnpHM8U=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WjLXY1mt3qMN+HmcpWOjKrU+7UC6YTSgnOw/LC5LnHmgDP/PPOWa8r7O9f+UHe2/Dbg2pb+r6qLsZv6pBTUGYaYGIYHSWQyUFapZ4gKCdUEjimtN2/2PiS2b1BMOzfaBsmOV/av9DTz3HSIjdmqyEv3uicFHtinD1ACTmw5Lwe4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VtDFj2M7Qz1S98c;
	Mon,  3 Jun 2024 20:54:33 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 4903E1403D2;
	Mon,  3 Jun 2024 20:58:12 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:11 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 02/12] md: add a new enum type sync_action
Date: Mon, 3 Jun 2024 20:58:05 +0800
Message-ID: <20240603125815.2199072-3-yukuai3@huawei.com>
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

In order to make code related to sync_thread cleaner in following
patches, also add detail comment about each sync action. And also
prepare to remove the related recovery_flags in the fulture.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.h | 57 ++++++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 56 insertions(+), 1 deletion(-)

diff --git a/drivers/md/md.h b/drivers/md/md.h
index 170412a65b63..6b9d9246f260 100644
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

