Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E7374C83F1A
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188316;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=6LrafFeoKQKxIXQW74E+jjqq9bME2Ft96MmMHwth4+4=;
	b=DIWXu08bY20O069gX/QY8b/uGGa4oxnioCXpI3NqQ/yNbjw9EpBiVw7bcWu2YBJOfV1aGg
	WW0nMxTgQvVL+O3MjOjFMYCOVT1O6E2nznBeSL4Hb8PyGCn5dW9wIIUGrwuRz7d1oxhmrU
	Q6cC5mkE6HNTXA+HclaW6tMGzEgGuNM=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-266-_TtjHrKwNwqZ2d30qscDXw-1; Sun, 27 Aug 2023 22:05:13 -0400
X-MC-Unique: _TtjHrKwNwqZ2d30qscDXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com [10.11.54.2])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id E310B185A7AD;
	Mon, 28 Aug 2023 02:05:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id D167F40D283A;
	Mon, 28 Aug 2023 02:05:10 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id BC5D719465B6;
	Mon, 28 Aug 2023 02:05:10 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id CE16D19465B3
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:05:08 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B39F8140E962; Mon, 28 Aug 2023 02:05:08 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id ABE8F140E950
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:08 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-1.mimecast.com [207.211.31.81])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256
 bits)) (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8BBDE299E763
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:08 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-669-yBcNZbfINA2nd8CYUjJ4RQ-1; Sun, 27 Aug 2023 22:05:03 -0400
X-MC-Unique: yBcNZbfINA2nd8CYUjJ4RQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv5P01JHz4f3kp9;
 Mon, 28 Aug 2023 10:04:56 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S32;
 Mon, 28 Aug 2023 10:04:57 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 10:00:21 +0800
Message-Id: <20230828020021.2489641-29-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S32
X-Coremail-Antispam: 1UD129KBjvJXoWxKrW7KrWrCw4UZF15GF1UGFg_yoWxtr4rpr
 WxtayrZr48tFZaqryDAan7Ca45Jw1SkrZFyrW3X3s3Cas3t34fGF15ur4rJryvya4fXrn8
 Jw4Yva48Zr18GFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUP214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
 xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
 M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
 v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
 F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
 IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
 wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
 0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26ryj6F1UMIIF0xvE2Ix0cI8IcVCY1x0267AK
 xVW8Jr0_Cr1UMIIF0xvE42xK8VAvwI8IcIk0rVWUJVWUCwCI42IY6I8E87Iv67AKxVW8JV
 WxJwCI42IY6I8E87Iv6xkF7I0E14v26r4UJVWxJrUvcSsGvfC2KfnxnUUI43ZEXa7VUbmZ
 X7UUUUU==
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH -next v2 28/28] md: rename
 __mddev_suspend/resume() back to mddev_suspend/resume()
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

Now that the old apis are removed, __mddev_suspend/resume() can be
renamed to their original names.

This is done by:

sed -i "s/__mddev_suspend/mddev_suspend/g" *.[ch]
sed -i "s/__mddev_resume/mddev_resume/g" *.[ch]

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c     |  4 ++--
 drivers/md/md.c          | 30 +++++++++++++++---------------
 drivers/md/md.h          | 16 ++++++++--------
 drivers/md/raid5-cache.c |  4 ++--
 4 files changed, 27 insertions(+), 27 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 2ff33b5d9a1b..5114daead945 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3799,7 +3799,7 @@ static void raid_postsuspend(struct dm_target *ti)
 		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
 			md_stop_writes(&rs->md);
 
-		__mddev_suspend(&rs->md);
+		mddev_suspend(&rs->md);
 	}
 }
 
@@ -4011,7 +4011,7 @@ static int raid_preresume(struct dm_target *ti)
 	}
 
 	/* Check for any resize/reshape on @rs and adjust/initiate */
-	/* Be prepared for __mddev_resume() in raid_resume() */
+	/* Be prepared for mddev_resume() in raid_resume() */
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->recovery_cp && mddev->recovery_cp < MaxSector) {
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index bb67734eded6..3afaf960aa4a 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -422,7 +422,7 @@ static void md_submit_bio(struct bio *bio)
  * Make sure no new requests are submitted to the device, and any requests that
  * have been submitted are completely handled.
  */
-void __mddev_suspend(struct mddev *mddev)
+void mddev_suspend(struct mddev *mddev)
 {
 
 	/*
@@ -456,9 +456,9 @@ void __mddev_suspend(struct mddev *mddev)
 
 	mutex_unlock(&mddev->suspend_mutex);
 }
-EXPORT_SYMBOL_GPL(__mddev_suspend);
+EXPORT_SYMBOL_GPL(mddev_suspend);
 
-void __mddev_resume(struct mddev *mddev)
+void mddev_resume(struct mddev *mddev)
 {
 	lockdep_assert_not_held(&mddev->reconfig_mutex);
 
@@ -469,7 +469,7 @@ void __mddev_resume(struct mddev *mddev)
 		return;
 	}
 
-	/* entred the memalloc scope from __mddev_suspend() */
+	/* entred the memalloc scope from mddev_suspend() */
 	memalloc_noio_restore(mddev->noio_flag);
 
 	percpu_ref_resurrect(&mddev->active_io);
@@ -481,7 +481,7 @@ void __mddev_resume(struct mddev *mddev)
 
 	mutex_unlock(&mddev->suspend_mutex);
 }
-EXPORT_SYMBOL_GPL(__mddev_resume);
+EXPORT_SYMBOL_GPL(mddev_resume);
 
 /*
  * Generic flush handling for md
@@ -3609,7 +3609,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		if (cmd_match(page, "remove") || cmd_match(page, "re-add") ||
 		    cmd_match(page, "writemostly") ||
 		    cmd_match(page, "-writemostly")) {
-			__mddev_suspend(mddev);
+			mddev_suspend(mddev);
 			suspended = true;
 		}
 	}
@@ -3623,7 +3623,7 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 		mddev_unlock(mddev);
 
 		if (suspended)
-			__mddev_resume(mddev);
+			mddev_resume(mddev);
 	}
 
 	if (kn)
@@ -5197,9 +5197,9 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	__mddev_suspend(mddev);
+	mddev_suspend(mddev);
 	WRITE_ONCE(mddev->suspend_lo, new);
-	__mddev_resume(mddev);
+	mddev_resume(mddev);
 
 	return len;
 }
@@ -5225,9 +5225,9 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	__mddev_suspend(mddev);
+	mddev_suspend(mddev);
 	WRITE_ONCE(mddev->suspend_hi, new);
-	__mddev_resume(mddev);
+	mddev_resume(mddev);
 
 	return len;
 }
@@ -7789,7 +7789,7 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 
 	mddev_unlock(mddev);
 	if (md_ioctl_need_suspend(cmd))
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 
 out:
 	if(did_set_md_closing)
@@ -9383,7 +9383,7 @@ static void md_start_sync(struct work_struct *ws)
 	bool suspended = false;
 
 	if (md_spares_need_change(mddev)) {
-		__mddev_suspend(mddev);
+		mddev_suspend(mddev);
 		suspended = true;
 	}
 
@@ -9425,7 +9425,7 @@ static void md_start_sync(struct work_struct *ws)
 
 	mddev_unlock(mddev);
 	if (suspended)
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
@@ -9440,7 +9440,7 @@ static void md_start_sync(struct work_struct *ws)
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
 	mddev_unlock(mddev);
 	if (suspended)
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 
 	wake_up(&resync_wait);
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
diff --git a/drivers/md/md.h b/drivers/md/md.h
index f932d0cb9db0..fc64dea4f84d 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -804,8 +804,8 @@ extern int md_rdev_init(struct md_rdev *rdev);
 extern void md_rdev_clear(struct md_rdev *rdev);
 
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
-extern void __mddev_suspend(struct mddev *mddev);
-extern void __mddev_resume(struct mddev *mddev);
+extern void mddev_suspend(struct mddev *mddev);
+extern void mddev_resume(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
@@ -853,17 +853,17 @@ static inline int mddev_suspend_and_lock(struct mddev *mddev)
 {
 	int ret;
 
-	__mddev_suspend(mddev);
+	mddev_suspend(mddev);
 	ret = mddev_lock(mddev);
 	if (ret)
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 
 	return ret;
 }
 
 static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev)
 {
-	__mddev_suspend(mddev);
+	mddev_suspend(mddev);
 	mutex_lock(&mddev->reconfig_mutex);
 }
 
@@ -871,10 +871,10 @@ static inline int mddev_suspend_and_trylock(struct mddev *mddev)
 {
 	int ret;
 
-	__mddev_suspend(mddev);
+	mddev_suspend(mddev);
 	ret = mutex_trylock(&mddev->reconfig_mutex);
 	if (ret)
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 
 	return ret;
 }
@@ -882,7 +882,7 @@ static inline int mddev_suspend_and_trylock(struct mddev *mddev)
 static inline void mddev_unlock_and_resume(struct mddev *mddev)
 {
 	mddev_unlock(mddev);
-	__mddev_resume(mddev);
+	mddev_resume(mddev);
 }
 
 struct mdu_array_info_s;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 38d38f2e33bc..4dc69826a5d3 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -698,9 +698,9 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
 
 	if (READ_ONCE(conf->log)) {
-		__mddev_suspend(mddev);
+		mddev_suspend(mddev);
 		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 	}
 }
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

