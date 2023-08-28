Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F6D4C83F11
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188303;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=A+R5YL21dBSrPwJqYzO7MbbgDQqjrcCqKPN1Attgj+A=;
	b=ZscMPgT7Wxwk1PtMaV5mx2BGzHXlReuE8JXGPHEGfArKAa18FV/5Wa0P1n+pZP2zoZcdAN
	tZeVqjfSZMP3IsDkRmNTJZTq6z1oj7h3Q0laHnEbCUCOLjs1Vp/WTiokxweeD8CyUaR8HQ
	jeepsz1NRpwFAcS2AjCOkJDSxDhCFiQ=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-294-iOzMg-J0MziNxdFbQfaJPg-1; Sun, 27 Aug 2023 22:04:59 -0400
X-MC-Unique: iOzMg-J0MziNxdFbQfaJPg-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0885E1C05158;
	Mon, 28 Aug 2023 02:04:58 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 534406B5A1;
	Mon, 28 Aug 2023 02:04:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D792D19465BA;
	Mon, 28 Aug 2023 02:04:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 3D09319465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:04:55 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 2AA3C40C6F53; Mon, 28 Aug 2023 02:04:55 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 228F940C6F4E
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:55 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-2.mimecast.com [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 08FA2856DED
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:55 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-180-6Lh-D83uMfKbtmo4oeL_sA-1; Sun, 27 Aug 2023 22:04:50 -0400
X-MC-Unique: 6Lh-D83uMfKbtmo4oeL_sA-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv595yG8z4f3jJM;
 Mon, 28 Aug 2023 10:04:45 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S7;
 Mon, 28 Aug 2023 10:04:46 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 09:59:56 +0800
Message-Id: <20230828020021.2489641-4-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S7
X-Coremail-Antispam: 1UD129KBjvJXoWxKrykZr47Gryxtw43Gry5twb_yoW7ZF1Up3
 yIqFZ5tr4UJFZxZw47t3srWa45Xw1rKFWDtrZxWa13C3Wakr4rWr15Wr15Jr1vka4fCr4D
 Jw10qayUCry8WFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBE14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JrWl82xGYIkIc2
 x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F4UJw
 A2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS
 0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2
 IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4UM4x0
 Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2kIc2
 xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v2
 6r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIxkGc2
 Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_
 Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r4UMI
 IF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUd8n5UUUUU
 =
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH -next v2 03/28] md: add new helpers to
 suspend/resume array
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Advantages for new apis:
 - reconfig_mutex is not required;
 - the weird logical that suspend array hold 'reconfig_mutex' for
   mddev_check_recovery() to update superblock is not needed;
 - the specail handling, 'pers->prepare_suspend', for raid456 is not
   needed;
 - It's safe to be called at any time once mddev is allocated, and it's
   designed to be used from slow path where array configuration is changed;

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 85 +++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/md/md.h |  3 ++
 2 files changed, 86 insertions(+), 2 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 7fa311a14317..6236e2e395c1 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -443,12 +443,22 @@ void mddev_suspend(struct mddev *mddev)
 			lockdep_is_held(&mddev->reconfig_mutex));
 
 	WARN_ON_ONCE(thread && current == thread->tsk);
-	if (mddev->suspended++)
+
+	/* can't concurrent with __mddev_suspend() and __mddev_resume() */
+	mutex_lock(&mddev->suspend_mutex);
+	if (mddev->suspended++) {
+		mutex_unlock(&mddev->suspend_mutex);
 		return;
+	}
+
 	wake_up(&mddev->sb_wait);
 	set_bit(MD_ALLOW_SB_UPDATE, &mddev->flags);
 	percpu_ref_kill(&mddev->active_io);
 
+	/*
+	 * TODO: cleanup 'pers->prepare_suspend after all callers are replaced
+	 * by __mddev_suspend().
+	 */
 	if (mddev->pers && mddev->pers->prepare_suspend)
 		mddev->pers->prepare_suspend(mddev);
 
@@ -459,14 +469,21 @@ void mddev_suspend(struct mddev *mddev)
 	del_timer_sync(&mddev->safemode_timer);
 	/* restrict memory reclaim I/O during raid array is suspend */
 	mddev->noio_flag = memalloc_noio_save();
+
+	mutex_unlock(&mddev->suspend_mutex);
 }
 EXPORT_SYMBOL_GPL(mddev_suspend);
 
 void mddev_resume(struct mddev *mddev)
 {
 	lockdep_assert_held(&mddev->reconfig_mutex);
-	if (--mddev->suspended)
+
+	/* can't concurrent with __mddev_suspend() and __mddev_resume() */
+	mutex_lock(&mddev->suspend_mutex);
+	if (--mddev->suspended) {
+		mutex_unlock(&mddev->suspend_mutex);
 		return;
+	}
 
 	/* entred the memalloc scope from mddev_suspend() */
 	memalloc_noio_restore(mddev->noio_flag);
@@ -477,9 +494,72 @@ void mddev_resume(struct mddev *mddev)
 	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
 	md_wakeup_thread(mddev->thread);
 	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
+
+	mutex_unlock(&mddev->suspend_mutex);
 }
 EXPORT_SYMBOL_GPL(mddev_resume);
 
+void __mddev_suspend(struct mddev *mddev)
+{
+
+	/*
+	 * hold reconfig_mutex to wait for normal io will deadlock, because
+	 * other context can't update super_block, and normal io can rely on
+	 * updating super_block.
+	 */
+	lockdep_assert_not_held(&mddev->reconfig_mutex);
+
+	mutex_lock(&mddev->suspend_mutex);
+
+	if (mddev->suspended) {
+		WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
+		mutex_unlock(&mddev->suspend_mutex);
+		return;
+	}
+
+	percpu_ref_kill(&mddev->active_io);
+	wait_event(mddev->sb_wait, percpu_ref_is_zero(&mddev->active_io));
+
+	/*
+	 * For raid456, io might be waiting for reshape to make progress,
+	 * allow new reshape to start while waiting for io to be done to
+	 * prevent deadlock.
+	 */
+	WRITE_ONCE(mddev->suspended, mddev->suspended + 1);
+
+	del_timer_sync(&mddev->safemode_timer);
+	/* restrict memory reclaim I/O during raid array is suspend */
+	mddev->noio_flag = memalloc_noio_save();
+
+	mutex_unlock(&mddev->suspend_mutex);
+}
+EXPORT_SYMBOL_GPL(__mddev_suspend);
+
+void __mddev_resume(struct mddev *mddev)
+{
+	lockdep_assert_not_held(&mddev->reconfig_mutex);
+
+	mutex_lock(&mddev->suspend_mutex);
+	WRITE_ONCE(mddev->suspended, mddev->suspended - 1);
+	if (mddev->suspended) {
+		mutex_unlock(&mddev->suspend_mutex);
+		return;
+	}
+
+	/* entred the memalloc scope from __mddev_suspend() */
+	memalloc_noio_restore(mddev->noio_flag);
+
+	percpu_ref_resurrect(&mddev->active_io);
+	wake_up(&mddev->sb_wait);
+
+	set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
+	md_wakeup_thread(mddev->thread);
+	md_wakeup_thread(mddev->sync_thread); /* possibly kick off a reshape */
+
+	mutex_unlock(&mddev->suspend_mutex);
+}
+EXPORT_SYMBOL_GPL(__mddev_resume);
+
 /*
  * Generic flush handling for md
  */
@@ -667,6 +747,7 @@ int mddev_init(struct mddev *mddev)
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->sync_mutex);
+	mutex_init(&mddev->suspend_mutex);
 	mutex_init(&mddev->bitmap_info.mutex);
 	INIT_LIST_HEAD(&mddev->disks);
 	INIT_LIST_HEAD(&mddev->all_mddevs);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index fb3b123f16dd..1103e6b08ad9 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -316,6 +316,7 @@ struct mddev {
 	unsigned long			sb_flags;
 
 	int				suspended;
+	struct mutex			suspend_mutex;
 	struct percpu_ref		active_io;
 	int				ro;
 	int				sysfs_active; /* set when sysfs deletes
@@ -811,6 +812,8 @@ extern void md_rdev_clear(struct md_rdev *rdev);
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
 extern void mddev_suspend(struct mddev *mddev);
 extern void mddev_resume(struct mddev *mddev);
+extern void __mddev_suspend(struct mddev *mddev);
+extern void __mddev_resume(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

