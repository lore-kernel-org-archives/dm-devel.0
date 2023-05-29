Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38088C77B7E
	for <dm-devel@archiver.kernel.org>; Mon, 29 May 2023 13:26:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1685366776;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=aPgRS6gpSZKrHGWH4IEaFZW1KQQCDggoqHJiEiZo7XM=;
	b=NOeeFm6kIdimF3IFYztWsLw+YwAlrUDhKvfTcCW2/0h+A9xxtBhGwfWqvkMa24jwNodsFL
	KxbvPKmaM2uDcygxOG2wT+b7Z/9t8mAh4/8z1RtyzyAauCbOZl6y7hXMbgEFKekBme5XU+
	c6GNbKtsp7/h7VCUmWkqz+dNrrs/hxw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-204-_Hi_P8GMPx-gTjvCu1wEgg-1; Mon, 29 May 2023 09:26:12 -0400
X-MC-Unique: _Hi_P8GMPx-gTjvCu1wEgg-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E2BAF811E86;
	Mon, 29 May 2023 13:26:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (unknown [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D1A56140E954;
	Mon, 29 May 2023 13:26:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 1793319452C7;
	Mon, 29 May 2023 13:25:20 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com
 [10.11.54.5])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF73719465A0
 for <dm-devel@listman.corp.redhat.com>; Mon, 29 May 2023 13:24:26 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id F248A420A9; Mon, 29 May 2023 13:24:25 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id EA0E5420A8
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:25 +0000 (UTC)
Received: from us-smtp-inbound-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id CBB78185A78F
 for <dm-devel@redhat.com>; Mon, 29 May 2023 13:24:25 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-96-V-3qNHOcMv27cb5JbO8Gcw-1; Mon, 29 May 2023 09:24:23 -0400
X-MC-Unique: V-3qNHOcMv27cb5JbO8Gcw-1
Received: from mail02.huawei.com (unknown [172.30.67.153])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4QVGTD1Mtrz4f455H;
 Mon, 29 May 2023 21:24:16 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAHvbB9p3RkWVPoKQ--.23397S8;
 Mon, 29 May 2023 21:24:16 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: guoqing.jiang@linux.dev, agk@redhat.com, snitzer@kernel.org,
 dm-devel@redhat.com, song@kernel.org
Date: Mon, 29 May 2023 21:20:35 +0800
Message-Id: <20230529132037.2124527-5-yukuai1@huaweicloud.com>
In-Reply-To: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
References: <20230529132037.2124527-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAHvbB9p3RkWVPoKQ--.23397S8
X-Coremail-Antispam: 1UD129KBjvJXoWxZr4xKr4xWF4DXF1kCF4kJFb_yoW7Jw4fp3
 yxtFn8Ar4UArW3ZrsrJ3Zrua4rZw109a9rtrW3ua4xAr1Sgr43tFn5uFy8ZFykAa9ayr4U
 Xw4rXayfuFWUWr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUGVWUXwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
 0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUA
 rcfUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Subject: [dm-devel] [PATCH -next v2 4/6] md: refactor
 idle/frozen_sync_thread() to fix deadlock
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Our test found a following deadlock in raid10:

1) Issue a normal write, and such write failed:

  raid10_end_write_request
   set_bit(R10BIO_WriteError, &r10_bio->state)
   one_write_done
    reschedule_retry

  // later from md thread
  raid10d
   handle_write_completed
    list_add(&r10_bio->retry_list, &conf->bio_end_io_list)

  // later from md thread
  raid10d
   if (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags))
    list_move(conf->bio_end_io_list.prev, &tmp)
    r10_bio = list_first_entry(&tmp, struct r10bio, retry_list)
    raid_end_bio_io(r10_bio)

Dependency chain 1: normal io is waiting for updating superblock

2) Trigger a recovery:

  raid10_sync_request
   raise_barrier

Dependency chain 2: sync thread is waiting for normal io

3) echo idle/frozen to sync_action:

  action_store
   mddev_lock
    md_unregister_thread
     kthread_stop

Dependency chain 3: drop 'reconfig_mutex' is waiting for sync thread

4) md thread can't update superblock:

  raid10d
   md_check_recovery
    if (mddev_trylock(mddev))
     md_update_sb

Dependency chain 4: update superblock is waiting for 'reconfig_mutex'

Hence cyclic dependency exist, in order to fix the problem, we must
break one of them. Dependency 1 and 2 can't be broken because they are
foundation design. Dependency 4 may be possible if it can be guaranteed
that no io can be inflight, however, this requires a new mechanism which
seems complex. Dependency 3 is a good choice, because idle/frozen only
requires sync thread to finish, which can be done asynchronously that is
already implemented, and 'reconfig_mutex' is not needed anymore.

This patch switch 'idle' and 'frozen' to wait sync thread to be done
asynchronously, and this patch also add a sequence counter to record how
many times sync thread is done, so that 'idle' won't keep waiting on new
started sync thread.

Noted that raid456 has similiar deadlock([1]), and it's verified[2] this
deadlock can be fixed by this patch as well.

[1] https://lore.kernel.org/linux-raid/5ed54ffc-ce82-bf66-4eff-390cb23bc1ac@molgen.mpg.de/T/#t
[2] https://lore.kernel.org/linux-raid/e9067438-d713-f5f3-0d3d-9e6b0e9efa0e@huaweicloud.com/
Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 23 +++++++++++++++++++----
 drivers/md/md.h |  2 ++
 2 files changed, 21 insertions(+), 4 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 63a993b52cd7..7912de0e4d12 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -652,6 +652,7 @@ void mddev_init(struct mddev *mddev)
 	timer_setup(&mddev->safemode_timer, md_safemode_timeout, 0);
 	atomic_set(&mddev->active, 1);
 	atomic_set(&mddev->openers, 0);
+	atomic_set(&mddev->sync_seq, 0);
 	spin_lock_init(&mddev->lock);
 	atomic_set(&mddev->flush_pending, 0);
 	init_waitqueue_head(&mddev->sb_wait);
@@ -4776,19 +4777,27 @@ static void stop_sync_thread(struct mddev *mddev)
 	if (work_pending(&mddev->del_work))
 		flush_workqueue(md_misc_wq);
 
-	if (mddev->sync_thread) {
-		set_bit(MD_RECOVERY_INTR, &mddev->recovery);
-		md_reap_sync_thread(mddev);
-	}
+	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
+	/*
+	 * Thread might be blocked waiting for metadata update which will now
+	 * never happen
+	 */
+	md_wakeup_thread_directly(mddev->sync_thread);
 
 	mddev_unlock(mddev);
 }
 
 static void idle_sync_thread(struct mddev *mddev)
 {
+	int sync_seq = atomic_read(&mddev->sync_seq);
+
 	mutex_lock(&mddev->sync_mutex);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	stop_sync_thread(mddev);
+
+	wait_event(resync_wait, sync_seq != atomic_read(&mddev->sync_seq) ||
+			!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -4797,6 +4806,10 @@ static void frozen_sync_thread(struct mddev *mddev)
 	mutex_init(&mddev->delete_mutex);
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	stop_sync_thread(mddev);
+
+	wait_event(resync_wait, mddev->sync_thread == NULL &&
+			!test_bit(MD_RECOVERY_RUNNING, &mddev->recovery));
+
 	mutex_unlock(&mddev->sync_mutex);
 }
 
@@ -9472,6 +9485,8 @@ void md_reap_sync_thread(struct mddev *mddev)
 
 	/* resync has finished, collect result */
 	md_unregister_thread(&mddev->sync_thread);
+	atomic_inc(&mddev->sync_seq);
+
 	if (!test_bit(MD_RECOVERY_INTR, &mddev->recovery) &&
 	    !test_bit(MD_RECOVERY_REQUESTED, &mddev->recovery) &&
 	    mddev->degraded != mddev->raid_disks) {
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 2fa903de5bd0..7cab9c7c45b8 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -539,6 +539,8 @@ struct mddev {
 
 	/* Used to synchronize idle and frozen for action_store() */
 	struct mutex			sync_mutex;
+	/* The sequence number for sync thread */
+	atomic_t sync_seq;
 
 	bool	has_superblocks:1;
 	bool	fail_last_dev:1;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

