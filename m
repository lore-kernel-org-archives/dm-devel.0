Received: from mail-m49207.qiye.163.com (mail-m49207.qiye.163.com [45.254.49.207])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 063D6262808
	for <dm-devel@lists.linux.dev>; Sat, 20 Dec 2025 12:04:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.254.49.207
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766232270; cv=none; b=qV8x7EvK26v0Qe5SxPvzcl4jU4I0lUItE/37nlqIlzeOlUHgAdU1KogCbJ0SIOC0DOYfpQNZvUdyvn2OQL87I+EUOZorFUZNYxdSQewMFMxeiIe09YO/wQISseHnL8NkBAfhYGweB4KRnp0HxQw+TDL+dsVtVlaX5t5l/ZPk4Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766232270; c=relaxed/simple;
	bh=wa97D9YrxtxrOKaLK2XxwTEFhYlqQUdHTvlzwKwoiik=;
	h=From:To:Cc:Subject:Date:Message-Id; b=ltC9MNWEUUx1wRT5E0fyTrxdSQHSu3QkNV/9qGlh/95thW5Hp+tQbUK5yZLuzLUiEtcIRc6l0WRc2G/04ClSsSkrk6CLi2K222ZbnjGOn7jZlXAXUbEAiyrq/njtD1D+tKTsD9B4UC5q5UppQp4NF8EDoR8nkcZsioGiCRP95Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sangfor.com.cn; spf=pass smtp.mailfrom=sangfor.com.cn; arc=none smtp.client-ip=45.254.49.207
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=sangfor.com.cn
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sangfor.com.cn
Received: from localhost.localdomain (unknown [113.92.156.73])
	by smtp.qiye.163.com (Hmail) with ESMTP id 2df8d417d;
	Sat, 20 Dec 2025 20:04:14 +0800 (GMT+08:00)
From: Ding Hui <dinghui@sangfor.com.cn>
To: linux-kernel@vger.kernel.org,
	dm-devel@lists.linux.dev
Cc: bmarzins@redhat.com,
	mpatocka@redhat.com,
	snitzer@kernel.org,
	agk@redhat.com,
	hch@lst.de,
	Ding Hui <dinghui@sangfor.com.cn>
Subject: [PATCH] dm: remove fake timeout to avoid leak request
Date: Sat, 20 Dec 2025 20:03:50 +0800
Message-Id: <20251220120350.10750-1-dinghui@sangfor.com.cn>
X-Mailer: git-send-email 2.17.1
X-HM-Tid: 0a9b3ba568b209d9kunm015e7bae884f60
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFITzdXWS1ZQUlXWQ8JGhUIEh9ZQVkZT04eVktNThhLGRlNGkpLGlYVFAkWGhdVEwETFh
	oSFyQUDg9ZV1kYEgtZQVlKSkhVQklVSk5NVUxIWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>

Since commit 15f73f5b3e59 ("blk-mq: move failure injection out of
blk_mq_complete_request"), drivers are responsible for calling
blk_should_fake_timeout() at appropriate code paths and opportunities.

However, the dm driver does not implement its own timeout handler and
relies on the timeout handling of its slave devices.

If an io-timeout-fail error is injected to a dm device, the request
will be leaked and never completed, causing tasks to hang indefinitely.

Reproduce:
1. prepare dm which has iscsi slave device
2. inject io-timeout-fail to dm
   echo 1 >/sys/class/block/dm-0/io-timeout-fail
   echo 100 >/sys/kernel/debug/fail_io_timeout/probability
   echo 10 >/sys/kernel/debug/fail_io_timeout/times
3. read/write dm
4. iscsiadm -m node -u

Result: hang task like below
[  862.243768] INFO: task kworker/u514:2:151 blocked for more than 122 seconds.
[  862.244133]       Tainted: G            E       6.19.0-rc1+ #51
[  862.244337] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  862.244718] task:kworker/u514:2  state:D stack:0     pid:151   tgid:151   ppid:2      task_flags:0x4288060 flags:0x00080000
[  862.245024] Workqueue: iscsi_ctrl_3:1 __iscsi_unbind_session [scsi_transport_iscsi]
[  862.245264] Call Trace:
[  862.245587]  <TASK>
[  862.245814]  __schedule+0x810/0x15c0
[  862.246557]  schedule+0x69/0x180
[  862.246760]  blk_mq_freeze_queue_wait+0xde/0x120
[  862.247688]  elevator_change+0x16d/0x460
[  862.247893]  elevator_set_none+0x87/0xf0
[  862.248798]  blk_unregister_queue+0x12e/0x2a0
[  862.248995]  __del_gendisk+0x231/0x7e0
[  862.250143]  del_gendisk+0x12f/0x1d0
[  862.250339]  sd_remove+0x85/0x130 [sd_mod]
[  862.250650]  device_release_driver_internal+0x36d/0x530
[  862.250849]  bus_remove_device+0x1dd/0x3f0
[  862.251042]  device_del+0x38a/0x930
[  862.252095]  __scsi_remove_device+0x293/0x360
[  862.252291]  scsi_remove_target+0x486/0x760
[  862.252654]  __iscsi_unbind_session+0x18a/0x3e0 [scsi_transport_iscsi]
[  862.252886]  process_one_work+0x633/0xe50
[  862.253101]  worker_thread+0x6df/0xf10
[  862.253647]  kthread+0x36d/0x720
[  862.254533]  ret_from_fork+0x2a6/0x470
[  862.255852]  ret_from_fork_asm+0x1a/0x30
[  862.256037]  </TASK>

Remove the blk_should_fake_timeout() check from dm, as dm has no
native timeout handling and should not attempt to fake timeouts.

Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
---
 drivers/md/dm-rq.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/md/dm-rq.c b/drivers/md/dm-rq.c
index a6ca92049c10..5e0854669614 100644
--- a/drivers/md/dm-rq.c
+++ b/drivers/md/dm-rq.c
@@ -278,8 +278,7 @@ static void dm_complete_request(struct request *rq, blk_status_t error)
 	struct dm_rq_target_io *tio = tio_from_request(rq);
 
 	tio->error = error;
-	if (likely(!blk_should_fake_timeout(rq->q)))
-		blk_mq_complete_request(rq);
+	blk_mq_complete_request(rq);
 }
 
 /*
-- 
2.17.1

