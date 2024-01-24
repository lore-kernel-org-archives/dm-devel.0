Received: from szxga07-in.huawei.com (szxga07-in.huawei.com [45.249.212.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3976017BC6
	for <dm-devel@lists.linux.dev>; Wed, 24 Jan 2024 09:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.35
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706087977; cv=none; b=TVa2dsxpzgWeTlejd7HVYGCrwDx4SXxsfbJZV0I3xxErQkZQHvteulG6Ty7GOD+l0+rGSej7wAiTK19x4W+ERnAXJb3wA8B4V2V33n7O8WaX3QTd8xWJDoABNlKLWSujYxhfwkhIxckwgN9CT91DvNq2DImzng/QwEhwprLWtBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706087977; c=relaxed/simple;
	bh=dbDQaIVHXUE8dmHiG0RZLAFNbkTEDZ50EE8O+5/2iRY=;
	h=From:To:CC:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JJKfw1AmVn19obL7U3OulLVU4mo/Y5c16COZ4m3TBizvNb6PJIAs7JG/qlFxLlyIO3ta/pJ4mIdj7OZh54Z61Vky98LVLs3foKtDeVyESsZgy7lkX3YoMri0/3y9Y5d6BH7z/R0Tc+uwswJ6P8lZgFP+i+Folrlsg6FZH3fgNIU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga07-in.huawei.com (SkyGuard) with ESMTP id 4TKdf36Hzwz1Q83V;
	Wed, 24 Jan 2024 17:17:47 +0800 (CST)
Received: from kwepemm600009.china.huawei.com (unknown [7.193.23.164])
	by mail.maildlp.com (Postfix) with ESMTPS id 6F0FE1A0176;
	Wed, 24 Jan 2024 17:19:17 +0800 (CST)
Received: from huawei.com (10.175.104.67) by kwepemm600009.china.huawei.com
 (7.193.23.164) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2507.35; Wed, 24 Jan
 2024 17:18:20 +0800
From: Yu Kuai <yukuai3@huawei.com>
To: <agk@redhat.com>, <snitzer@kernel.org>, <mpatocka@redhat.com>,
	<dm-devel@lists.linux.dev>, <xni@redhat.com>, <song@kernel.org>,
	<yukuai3@huawei.com>, <jbrassow@f14.redhat.com>, <neilb@suse.de>,
	<heinzm@redhat.com>, <shli@fb.com>, <akpm@osdl.org>
CC: <linux-kernel@vger.kernel.org>, <linux-raid@vger.kernel.org>,
	<yukuai1@huaweicloud.com>, <yi.zhang@huawei.com>, <yangerkun@huawei.com>
Subject: [PATCH v2 04/11] md: don't register sync_thread for reshape directly
Date: Wed, 24 Jan 2024 17:14:14 +0800
Message-ID: <20240124091421.1261579-5-yukuai3@huawei.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20240124091421.1261579-1-yukuai3@huawei.com>
References: <20240124091421.1261579-1-yukuai3@huawei.com>
Precedence: bulk
X-Mailing-List: dm-devel@lists.linux.dev
List-Id: <dm-devel.lists.linux.dev>
List-Subscribe: <mailto:dm-devel+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:dm-devel+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 kwepemm600009.china.huawei.com (7.193.23.164)

Currently, if reshape is interrupted, then reassemble the array will
register sync_thread directly from pers->run(), in this case
'MD_RECOVERY_RUNNING' is set directly, however, there is no guarantee
that md_do_sync() will be executed, hence stop_sync_thread() will hang
because 'MD_RECOVERY_RUNNING' can't be cleared.

Last patch make sure that md_do_sync() will set MD_RECOVERY_DONE,
however, following hang can still be triggered by dm-raid test
shell/lvconvert-raid-reshape.sh occasionally:

[root@fedora ~]# cat /proc/1982/stack
[<0>] stop_sync_thread+0x1ab/0x270 [md_mod]
[<0>] md_frozen_sync_thread+0x5c/0xa0 [md_mod]
[<0>] raid_presuspend+0x1e/0x70 [dm_raid]
[<0>] dm_table_presuspend_targets+0x40/0xb0 [dm_mod]
[<0>] __dm_destroy+0x2a5/0x310 [dm_mod]
[<0>] dm_destroy+0x16/0x30 [dm_mod]
[<0>] dev_remove+0x165/0x290 [dm_mod]
[<0>] ctl_ioctl+0x4bb/0x7b0 [dm_mod]
[<0>] dm_ctl_ioctl+0x11/0x20 [dm_mod]
[<0>] vfs_ioctl+0x21/0x60
[<0>] __x64_sys_ioctl+0xb9/0xe0
[<0>] do_syscall_64+0xc6/0x230
[<0>] entry_SYSCALL_64_after_hwframe+0x6c/0x74

Meanwhile mddev->recovery is:
MD_RECOVERY_RUNNING |
MD_RECOVERY_INTR |
MD_RECOVERY_RESHAPE |
MD_RECOVERY_FROZEN

Fix this problem by remove the code to register sync_thread directly
from raid10 and raid5. And let md_check_recovery() to register
sync_thread.

Fixes: f67055780caa ("[PATCH] md: Checkpoint and allow restart of raid5 reshape")
Fixes: f52f5c71f3d4 ("md: fix stopping sync thread")
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c     |  5 ++++-
 drivers/md/raid10.c | 16 ++--------------
 drivers/md/raid5.c  | 29 ++---------------------------
 3 files changed, 8 insertions(+), 42 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c65dfd156090..6c5d0a372927 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9372,6 +9372,7 @@ static void md_start_sync(struct work_struct *ws)
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 	int spares = 0;
 	bool suspend = false;
+	char *name;
 
 	if (md_spares_need_change(mddev))
 		suspend = true;
@@ -9404,8 +9405,10 @@ static void md_start_sync(struct work_struct *ws)
 	if (spares)
 		md_bitmap_write_all(mddev->bitmap);
 
+	name = test_bit(MD_RECOVERY_RESHAPE, &mddev->recovery) ?
+			"reshape" : "resync";
 	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, "resync"));
+			   md_register_thread(md_do_sync, mddev, name));
 	if (!mddev->sync_thread) {
 		pr_warn("%s: could not start resync thread...\n",
 			mdname(mddev));
diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index 7412066ea22c..a5f8419e2df1 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -4175,11 +4175,7 @@ static int raid10_run(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-		rcu_assign_pointer(mddev->sync_thread,
-			md_register_thread(md_do_sync, mddev, "reshape"));
-		if (!mddev->sync_thread)
-			goto out_free_conf;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 
 	return 0;
@@ -4573,16 +4569,8 @@ static int raid10_start_reshape(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-
-	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, "reshape"));
-	if (!mddev->sync_thread) {
-		ret = -EAGAIN;
-		goto abort;
-	}
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_wakeup_thread(mddev->sync_thread);
 	md_new_event();
 	return 0;
 
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 8497880135ee..6a7a32f7fb91 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -7936,11 +7936,7 @@ static int raid5_run(struct mddev *mddev)
 		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
 		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-		set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-		rcu_assign_pointer(mddev->sync_thread,
-			md_register_thread(md_do_sync, mddev, "reshape"));
-		if (!mddev->sync_thread)
-			goto abort;
+		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	}
 
 	/* Ok, everything is just fine now */
@@ -8506,29 +8502,8 @@ static int raid5_start_reshape(struct mddev *mddev)
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_DONE, &mddev->recovery);
 	set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
-	set_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-	rcu_assign_pointer(mddev->sync_thread,
-			   md_register_thread(md_do_sync, mddev, "reshape"));
-	if (!mddev->sync_thread) {
-		mddev->recovery = 0;
-		spin_lock_irq(&conf->device_lock);
-		write_seqcount_begin(&conf->gen_lock);
-		mddev->raid_disks = conf->raid_disks = conf->previous_raid_disks;
-		mddev->new_chunk_sectors =
-			conf->chunk_sectors = conf->prev_chunk_sectors;
-		mddev->new_layout = conf->algorithm = conf->prev_algo;
-		rdev_for_each(rdev, mddev)
-			rdev->new_data_offset = rdev->data_offset;
-		smp_wmb();
-		conf->generation --;
-		conf->reshape_progress = MaxSector;
-		mddev->reshape_position = MaxSector;
-		write_seqcount_end(&conf->gen_lock);
-		spin_unlock_irq(&conf->device_lock);
-		return -EAGAIN;
-	}
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	conf->reshape_checkpoint = jiffies;
-	md_wakeup_thread(mddev->sync_thread);
 	md_new_event();
 	return 0;
 }
-- 
2.39.2

