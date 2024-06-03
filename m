Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C790D12C7FD
	for <dm-devel@lists.linux.dev>; Mon,  3 Jun 2024 13:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.255
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717419661; cv=none; b=PKhPk2MjAvdVKBnvOt67k/35/vIcH7EKkjhUnQjw4XGGNv9afCsnBdvGNUqhlU/I2lHoNCSCIwmmt2Aaes+xhfO/XHFhSRSgktVliRS53dYxmSsjrYEFOmtgoeaymdDoxPjTQGtE1qet3MszNc5D54BV+FbeUmNLpUuIN44vhoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717419661; c=relaxed/simple;
	bh=DbKL2DpCNxLJE7j01bpvEj8WJhxVsUr+mlsQyFYMnDg=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=nv7jiOoHCopu76v+9bgF5eWK6LAkyXsEdOtRG78MHPCSkcm2nCYiJMXMJ1VgTa9f/1vSpU6RPjjkpYzmgI6qNhVuDsUuC4iLQw+cTJptOzyGspzX2x2tr6Fh/QRB7W+SiOqh8DM3HmZcDIN1CUmf2b0CwXRrslsf9Fsf6G6VX2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.255
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4VtDJb5Yjwz1S98n;
	Mon,  3 Jun 2024 20:57:03 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id B8A9E140413;
	Mon,  3 Jun 2024 21:00:42 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Mon, 3 Jun
 2024 20:58:20 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<song@kernel.org>, <xni@redhat.com>, <mariusz.tkaczyk@linux.intel.com>,
	<l@damenly.org>
CC: <dm-devel@lists.linux.dev>, <linux-kernel@vger.kernel.org>,
	<linux-raid@vger.kernel.org>, <yukuai3@huawei.com>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH 12/12] md/raid5: avoid BUG_ON() while continue reshape after reassembling
Date: Mon, 3 Jun 2024 20:58:15 +0800
Message-ID: <20240603125815.2199072-13-yukuai3@huawei.com>
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

Currently, mdadm support --revert-reshape to abort the reshape while
reassembling, as the test 07revert-grow. However, following BUG_ON()
can be triggerred by the test:

kernel BUG at drivers/md/raid5.c:6278!
invalid opcode: 0000 [#1] PREEMPT SMP PTI
irq event stamp: 158985
CPU: 6 PID: 891 Comm: md0_reshape Not tainted 6.9.0-03335-g7592a0b0049a #94
RIP: 0010:reshape_request+0x3f1/0xe60
Call Trace:
 <TASK>
 raid5_sync_request+0x43d/0x550
 md_do_sync+0xb7a/0x2110
 md_thread+0x294/0x2b0
 kthread+0x147/0x1c0
 ret_from_fork+0x59/0x70
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Root cause is that --revert-reshape update the raid_disks from 5 to 4,
while reshape position is still set, and after reassembling the array,
reshape position will be read from super block, then during reshape the
checking of 'writepos' that is caculated by old reshape position will
fail.

Fix this panic the easy way first, by converting the BUG_ON() to
WARN_ON(), and stop the reshape if checkings fail.

Noted that mdadm must fix --revert-shape as well, and probably md/raid
should enhance metadata validation as well, however this means
reassemble will fail and there must be user tools to fix the wrong
metadata.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 20 +++++++++++++-------
 1 file changed, 13 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 69a083ca41a3..d4c30a94e4e4 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6255,7 +6255,9 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	safepos = conf->reshape_safe;
 	sector_div(safepos, data_disks);
 	if (mddev->reshape_backwards) {
-		BUG_ON(writepos < reshape_sectors);
+		if (WARN_ON(writepos < reshape_sectors))
+			return MaxSector;
+
 		writepos -= reshape_sectors;
 		readpos += reshape_sectors;
 		safepos += reshape_sectors;
@@ -6273,14 +6275,18 @@ static sector_t reshape_request(struct mddev *mddev, sector_t sector_nr, int *sk
 	 * to set 'stripe_addr' which is where we will write to.
 	 */
 	if (mddev->reshape_backwards) {
-		BUG_ON(conf->reshape_progress == 0);
+		if (WARN_ON(conf->reshape_progress == 0))
+			return MaxSector;
+
 		stripe_addr = writepos;
-		BUG_ON((mddev->dev_sectors &
-			~((sector_t)reshape_sectors - 1))
-		       - reshape_sectors - stripe_addr
-		       != sector_nr);
+		if (WARN_ON((mddev->dev_sectors &
+		    ~((sector_t)reshape_sectors - 1)) -
+		    reshape_sectors - stripe_addr != sector_nr))
+			return MaxSector;
 	} else {
-		BUG_ON(writepos != sector_nr + reshape_sectors);
+		if (WARN_ON(writepos != sector_nr + reshape_sectors))
+			return MaxSector;
+
 		stripe_addr = sector_nr;
 	}
 
-- 
2.39.2

