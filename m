Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com [45.249.212.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B8127D770
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 07:50:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756194638; cv=none; b=figdTrL7gXL9EgRedXI1MlW6YE0JBRDHfNFBi6C0tZcDHnO08fFIOPXNXvnF4EhpqW5gZQ/xg9+J1JTnEZM0PozFKrWl02JUuCQO2tFGZ6XSqfVN7at0cZOmtqRVA+N31wXeRdmbA6Wa0FXeYI/81jY34qlb9HklKhLu748zSRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756194638; c=relaxed/simple;
	bh=kceaIyp+7/ZAzh1vrgBWSvlBf1/V10tz7Bt1vXDC+Lw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=XMCVfSbvWxVksnEvpq3CZUhzfe8+f94e5cJDFEnHyDSuRKFA22m9IqGWc5PX2Pd8noxVPDBOmMzhIara2aPduU9zwcCkhr8Fp5WRrd3y9AGsobDIHo8Y3XVZNk+F5H5QezcYz2/sEAmOjCb/R9ynitdkJGmI4WX0l1/eaYPNpAI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.93.142])
	by dggsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4cB0Fm3tYQzYQvVj
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 15:50:36 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 161F41A11EF
	for <dm-devel@lists.linux.dev>; Tue, 26 Aug 2025 15:50:35 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
	by APP4 (Coremail) with SMTP id gCh0CgDnMY5IZ61oTGJbAQ--.24858S5;
	Tue, 26 Aug 2025 15:50:34 +0800 (CST)
From: Zheng Qixing <zhengqixing@huaweicloud.com>
To: agk@redhat.com,
	snitzer@kernel.org,
	mpatocka@redhat.com,
	axboe@kernel.dk,
	ming.lei@redhat.com
Cc: dm-devel@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	yukuai3@huawei.com,
	yi.zhang@huawei.com,
	yangerkun@huawei.com,
	houtao1@huawei.com,
	zhengqixing@huawei.com
Subject: [PATCH-next 1/2] dm: fix queue start/stop imbalance under suspend/load/resume races
Date: Tue, 26 Aug 2025 15:42:03 +0800
Message-Id: <20250826074204.390111-2-zhengqixing@huaweicloud.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20250826074204.390111-1-zhengqixing@huaweicloud.com>
References: <20250826074204.390111-1-zhengqixing@huaweicloud.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgDnMY5IZ61oTGJbAQ--.24858S5
X-Coremail-Antispam: 1UD129KBjvJXoWxAFWxGr4DXrWfXw47tr4ktFb_yoW5XF4xpw
	4UXFWakw18Cr429w409rWxuFy3ta13t3y7CFyxC3sI9a90934rZF1UJFykXrWxAFs5AFW3
	JF1UZrWDua4Utr7anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUPYb4IE77IF4wAFF20E14v26rWj6s0DM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28IrcIa0xkI8VA2jI8067AKxVWUGw
	A2048vs2IY020Ec7CjxVAFwI0_Gr0_Xr1l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxS
	w2x7M28EF7xvwVC0I7IYx2IY67AKxVW7JVWDJwA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxV
	WxJVW8Jr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_
	GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx
	0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWU
	JVW8JwACjcxG0xvY0x0EwIxGrwACI402YVCY1x02628vn2kIc2xKxwCY1x0262kKe7AKxV
	WUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
	14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
	kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAF
	wI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
	4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x07jnpnQU
	UUUU=
X-CM-SenderInfo: x2kh0wptl0x03j6k3tpzhluzxrxghudrp/

From: Zheng Qixing <zhengqixing@huawei.com>

When suspend and load run concurrently, before q->mq_ops is set in
blk_mq_init_allocated_queue(), __dm_suspend() skip dm_stop_queue(). As a
result, the queue's quiesce depth is not incremented.

Later, once table load has finished and __dm_resume() runs, which triggers
q->quiesce_depth ==0 warning in blk_mq_unquiesce_queue():
Call Trace:
 <TASK>
 dm_start_queue+0x16/0x20 [dm_mod]
 __dm_resume+0xac/0xb0 [dm_mod]
 dm_resume+0x12d/0x150 [dm_mod]
 do_resume+0x2c2/0x420 [dm_mod]
 dev_suspend+0x30/0x130 [dm_mod]
 ctl_ioctl+0x402/0x570 [dm_mod]
 dm_ctl_ioctl+0x23/0x30 [dm_mod]

Fix this by explicitly tracking whether the request queue was
stopped in __dm_suspend() via a new DMF_QUEUE_STOPPED flag.
Only call dm_start_queue() in __dm_resume() if the queue was
actually stopped.

Fixes: e70feb8b3e68 ("blk-mq: support concurrent queue quiesce/unquiesce")
Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
---
 drivers/md/dm-core.h | 1 +
 drivers/md/dm.c      | 8 +++++---
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-core.h b/drivers/md/dm-core.h
index c889332e533b..0070e4462ee2 100644
--- a/drivers/md/dm-core.h
+++ b/drivers/md/dm-core.h
@@ -162,6 +162,7 @@ struct mapped_device {
 #define DMF_SUSPENDED_INTERNALLY 7
 #define DMF_POST_SUSPENDING 8
 #define DMF_EMULATE_ZONE_APPEND 9
+#define DMF_QUEUE_STOPPED 10
 
 static inline sector_t dm_get_size(struct mapped_device *md)
 {
diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index a44e8c2dccee..7222f20c1a83 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2960,8 +2960,10 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	 * Stop md->queue before flushing md->wq in case request-based
 	 * dm defers requests to md->wq from md->queue.
 	 */
-	if (dm_request_based(md))
+	if (dm_request_based(md)) {
 		dm_stop_queue(md->queue);
+		set_bit(DMF_QUEUE_STOPPED, &md->flags);
+	}
 
 	flush_workqueue(md->wq);
 
@@ -2983,7 +2985,7 @@ static int __dm_suspend(struct mapped_device *md, struct dm_table *map,
 	if (r < 0) {
 		dm_queue_flush(md);
 
-		if (dm_request_based(md))
+		if (test_and_clear_bit(DMF_QUEUE_STOPPED, &md->flags))
 			dm_start_queue(md->queue);
 
 		unlock_fs(md);
@@ -3067,7 +3069,7 @@ static int __dm_resume(struct mapped_device *md, struct dm_table *map)
 	 * so that mapping of targets can work correctly.
 	 * Request-based dm is queueing the deferred I/Os in its request_queue.
 	 */
-	if (dm_request_based(md))
+	if (test_and_clear_bit(DMF_QUEUE_STOPPED, &md->flags))
 		dm_start_queue(md->queue);
 
 	unlock_fs(md);
-- 
2.39.2

