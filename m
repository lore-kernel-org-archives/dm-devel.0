Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A6B4C77B7E
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 13:26:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685366781;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=vckWAANHNBVFpc+nCYXBKyRVaixuxO3Zc8vsqbGYFvc=;
	b=BFQ9FjduYFPSyGVtddGeZH36k2SFwyDl31OwRItESST+nNFfNI69j6jo5uHFglvMg+G9/V
	Wc9fWDJC6rTumOZedN+Pefqr6gPdYS/5ir+q/v9weOlVxrXrb5LDp6Yea9YrkPABmqc6lm
	r9CaAZtdTVQeBMLLGuNgWDSnaO1Ux3E=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-258-pcicJvIlNYCFgyC37A6hxg-1; Mon, 29 May 2023 09:26:17 -0400
X-MC-Unique: pcicJvIlNYCFgyC37A6hxg-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0426A811E85;
	Mon, 29 May 2023 13:26:16 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id E758E492B0E;
	Mon, 29 May 2023 13:26:15 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A7BB519465A0;
	Mon, 29 May 2023 13:25:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com
 [10.11.54.9])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BC6D71946595
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 6F34B48205E; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 65B39492B00
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 19AD8185A78B
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:23 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-255-b1RjmEQEPFGLizRkgWdulA-1; Mon, 29 May 2023 09:24:19 -0400
X-MC-Unique: b1RjmEQEPFGLizRkgWdulA-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4QVGT91K4pz4f3sjx;
 Mon, 29 May 2023 21:24:13 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbB9p3RkWVPoKQ--.23397S5;
 Mon, 29 May 2023 21:24:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
Date: Mon, 29 May 2023 21:20:32 +0800
Message-Id: <20230529132037.2124527-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbB9p3RkWVPoKQ--.23397S5
X-Coremail-Antispam: 1UD129KBjvJXoWxWr1ftF18AF45XF15ZF18Krg_yoWrKr43p3
 yfJF9xJrWUArW3ZrWUJa4DXay5Zw1jq3yqyrWfW34fJw1fKr43G345uFyUZFyDJas5Zw4a
 qayrJFWrZFW09r7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPY14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
 x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
 A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
 0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
 IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
 Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
 xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
 6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
 Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUCVW8JwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
 Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr0_Cr
 1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUTHqxU
 UUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
Subject: [dm-devel] [PATCH -next v2 1/6] Revert "md: unlock mddev before
 reap sync_thread in action_store"
X-BeenThere: dm-devel@redhat.com
X-Mailman-Version: 2.1.29
Precedence: list
List-Id: device-mapper development <dm-devel.redhat.com>
List-Unsubscribe: <https://listman.redhat.com/mailman/options/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <http://listman.redhat.com/archives/dm-devel/>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://listman.redhat.com/mailman/listinfo/dm-devel>,
 <mailto:dm-devel-request@redhat.com?subject=subscribe>
Cc: yi.zhang@huawei.com, yangerkun@huawei.com, linux-kernel@vger.kernel.org,
 linux-raid@vger.kernel.org, yukuai1@huaweicloud.com, yukuai3@huawei.com
Errors-To: dm-devel-bounces@redhat.com
Sender: "dm-devel" <dm-devel-bounces@redhat.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

This reverts commit 9dfbdafda3b34e262e43e786077bab8e476a89d1.

Because it will introduce a defect that sync_thread can be running while
MD_RECOVERY_RUNNING is cleared, which will cause some unexpected problems,
for example:

list_add corruption. prev->next should be next (ffff0001ac1daba0), but was ffff0000ce1a02a0. (prev=ffff0000ce1a02a0).
Call trace:
 __list_add_valid+0xfc/0x140
 insert_work+0x78/0x1a0
 __queue_work+0x500/0xcf4
 queue_work_on+0xe8/0x12c
 md_check_recovery+0xa34/0xf30
 raid10d+0xb8/0x900 [raid10]
 md_thread+0x16c/0x2cc
 kthread+0x1a4/0x1ec
 ret_from_fork+0x10/0x18

This is because work is requeued while it's still inside workqueue:

t1:			t2:
action_store
 mddev_lock
  if (mddev->sync_thread)
   mddev_unlock
   md_unregister_thread
   // first sync_thread is done
			md_check_recovery
			 mddev_try_lock
			 /*
			  * once MD_RECOVERY_DONE is set, new sync_thread
			  * can start.
			  */
			 set_bit(MD_RECOVERY_RUNNING, &mddev->recovery)
			 INIT_WORK(&mddev->del_work, md_start_sync)
			 queue_work(md_misc_wq, &mddev->del_work)
			  test_and_set_bit(WORK_STRUCT_PENDING_BIT, ...)
			  // set pending bit
			  insert_work
			   list_add_tail
			 mddev_unlock
   mddev_lock_nointr
   md_reap_sync_thread
   // MD_RECOVERY_RUNNING is cleared
 mddev_unlock

t3:

// before queued work started from t2
md_check_recovery
 // MD_RECOVERY_RUNNING is not set, a new sync_thread can be started
 INIT_WORK(&mddev->del_work, md_start_sync)
  work->data = 0
  // work pending bit is cleared
 queue_work(md_misc_wq, &mddev->del_work)
  insert_work
   list_add_tail
   // list is corrupted

The above commit is reverted to fix the problem, the deadlock this
commit tries to fix will be fixed in following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c |  1 -
 drivers/md/md.c      | 19 ++-----------------
 2 files changed, 2 insertions(+), 18 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 8846bf510a35..1f22bef27841 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3725,7 +3725,6 @@ static int raid_message(struct dm_target *ti, unsigned int argc, char **argv,
 	if (!strcasecmp(argv[0], "idle") || !strcasecmp(argv[0], "frozen")) {
 		if (mddev->sync_thread) {
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_unregister_thread(&mddev->sync_thread);
 			md_reap_sync_thread(mddev);
 		}
 	} else if (decipher_sync_action(mddev, mddev->recovery) != st_idle)
diff --git a/drivers/md/md.c b/drivers/md/md.c
index a5a7af2f4e59..9b97731e1fe4 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -4772,19 +4772,6 @@ action_store(struct mddev *mddev, const char *page, size_t len)
 			if (work_pending(&mddev->del_work))
 				flush_workqueue(md_misc_wq);
 			if (mddev->sync_thread) {
-				sector_t save_rp = mddev->reshape_position;
-
-				mddev_unlock(mddev);
-				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-				md_unregister_thread(&mddev->sync_thread);
-				mddev_lock_nointr(mddev);
-				/*
-				 * set RECOVERY_INTR again and restore reshape
-				 * position in case others changed them after
-				 * got lock, eg, reshape_position_store and
-				 * md_check_recovery.
-				 */
-				mddev->reshape_position = save_rp;
 				set_bit(MD_RECOVERY_INTR, &mddev->recovery);
 				md_reap_sync_thread(mddev);
 			}
@@ -6184,7 +6171,6 @@ static void __md_stop_writes(struct mddev *mddev)
 		flush_workqueue(md_misc_wq);
 	if (mddev->sync_thread) {
 		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_unregister_thread(&mddev->sync_thread);
 		md_reap_sync_thread(mddev);
 	}
 
@@ -9336,7 +9322,6 @@ void md_check_recovery(struct mddev *mddev)
 			 * ->spare_active and clear saved_raid_disk
 			 */
 			set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-			md_unregister_thread(&mddev->sync_thread);
 			md_reap_sync_thread(mddev);
 			clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery);
 			clear_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
@@ -9372,7 +9357,6 @@ void md_check_recovery(struct mddev *mddev)
 			goto unlock;
 		}
 		if (mddev->sync_thread) {
-			md_unregister_thread(&mddev->sync_thread);
 			md_reap_sync_thread(mddev);
 			goto unlock;
 		}
@@ -9452,7 +9436,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 	sector_t old_dev_sectors = mddev->dev_sectors;
 	bool is_reshaped = false;
 
-	/* sync_thread should be unregistered, collect result */
+	/* resync has finished, collect result */
+	md_unregister_thread(&mddev->sync_thread);
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

