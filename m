Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1EDF6CE7B01
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695883500;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=X3GxKBl7MXAQZFbt0GxslK6h/TmDLe9oiDOL4V3TMwI=;
	b=KIC8M/c3glDpmXwdiCcGMR3DIFKgn1Gn1oa55WzsaE/ugYaQSuKrpwTKI9KdEjsQZEr+wb
	qQK7fxQchoortoQIySiYIT8fpitUEqRj2LTvTKr7u3ieSMEAJeedZXHJJRdIZxUrVo6J9b
	H3MQx7Jk4khkKwoSwn3xwhKE9VN9HNw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-523-pq5DGVhpOOCmRLPE1gmxOw-1; Thu, 28 Sep 2023 02:44:57 -0400
X-MC-Unique: pq5DGVhpOOCmRLPE1gmxOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63EA9811761;
	Thu, 28 Sep 2023 06:44:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5033710EE402;
	Thu, 28 Sep 2023 06:44:56 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 7DA6119465B2;
	Thu, 28 Sep 2023 06:44:55 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id C3B551946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:18 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id B573A1054FC1; Thu, 28 Sep 2023 06:22:18 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast01.extmail.prod.ext.rdu2.redhat.com [10.11.55.17])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id AC8281004145
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:18 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 90B2A85A5BE
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:18 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-554-WbWfSPp5Mb6DqyRZtMvc4w-1; Thu, 28 Sep 2023 02:22:14 -0400
X-MC-Unique: WbWfSPp5Mb6DqyRZtMvc4w-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kn3K1Kz4f3n5p;
 Thu, 28 Sep 2023 14:22:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S29;
 Thu, 28 Sep 2023 14:22:07 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:43 +0800
Message-Id: <20230928061543.1845742-26-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S29
X-Coremail-Antispam: 1UD129KBjvJXoWxKrW7KrWrCw4UZFyUJr1DKFg_yoW7Ar4Upw
 42qFWrZw48ZF95XryDJa1kCa45tw4rKrZFyrW7Z3s3GasIgwn5GF15WF45Xryqka4fXF1D
 Ja1j9a48ZryxGrUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUP214x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH -next v3 25/25] md: rename
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
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
 drivers/md/md.c          | 18 +++++++++---------
 drivers/md/md.h          | 12 ++++++------
 drivers/md/raid5-cache.c |  4 ++--
 4 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 05dd6ccf6f48..a4692f8f98ee 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -3797,7 +3797,7 @@ static void raid_postsuspend(struct dm_target *ti)
 		if (!test_bit(MD_RECOVERY_FROZEN, &rs->md.recovery))
 			md_stop_writes(&rs->md);
 
-		__mddev_suspend(&rs->md, false);
+		mddev_suspend(&rs->md, false);
 	}
 }
 
@@ -4009,7 +4009,7 @@ static int raid_preresume(struct dm_target *ti)
 	}
 
 	/* Check for any resize/reshape on @rs and adjust/initiate */
-	/* Be prepared for __mddev_resume() in raid_resume() */
+	/* Be prepared for mddev_resume() in raid_resume() */
 	set_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 	if (mddev->recovery_cp && mddev->recovery_cp < MaxSector) {
 		set_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 271d3f336026..b711eaf53e41 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -422,7 +422,7 @@ static void md_submit_bio(struct bio *bio)
  * Make sure no new requests are submitted to the device, and any requests that
  * have been submitted are completely handled.
  */
-int __mddev_suspend(struct mddev *mddev, bool interruptible)
+int mddev_suspend(struct mddev *mddev, bool interruptible)
 {
 	int err = 0;
 
@@ -473,9 +473,9 @@ int __mddev_suspend(struct mddev *mddev, bool interruptible)
 	mutex_unlock(&mddev->suspend_mutex);
 	return 0;
 }
-EXPORT_SYMBOL_GPL(__mddev_suspend);
+EXPORT_SYMBOL_GPL(mddev_suspend);
 
-void __mddev_resume(struct mddev *mddev)
+void mddev_resume(struct mddev *mddev)
 {
 	lockdep_assert_not_held(&mddev->reconfig_mutex);
 
@@ -486,7 +486,7 @@ void __mddev_resume(struct mddev *mddev)
 		return;
 	}
 
-	/* entred the memalloc scope from __mddev_suspend() */
+	/* entred the memalloc scope from mddev_suspend() */
 	memalloc_noio_restore(mddev->noio_flag);
 
 	percpu_ref_resurrect(&mddev->active_io);
@@ -498,7 +498,7 @@ void __mddev_resume(struct mddev *mddev)
 
 	mutex_unlock(&mddev->suspend_mutex);
 }
-EXPORT_SYMBOL_GPL(__mddev_resume);
+EXPORT_SYMBOL_GPL(mddev_resume);
 
 /*
  * Generic flush handling for md
@@ -5216,12 +5216,12 @@ suspend_lo_store(struct mddev *mddev, const char *buf, size_t len)
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	err = __mddev_suspend(mddev, true);
+	err = mddev_suspend(mddev, true);
 	if (err)
 		return err;
 
 	WRITE_ONCE(mddev->suspend_lo, new);
-	__mddev_resume(mddev);
+	mddev_resume(mddev);
 
 	return len;
 }
@@ -5247,12 +5247,12 @@ suspend_hi_store(struct mddev *mddev, const char *buf, size_t len)
 	if (new != (sector_t)new)
 		return -EINVAL;
 
-	err = __mddev_suspend(mddev, true);
+	err = mddev_suspend(mddev, true);
 	if (err)
 		return err;
 
 	WRITE_ONCE(mddev->suspend_hi, new);
-	__mddev_resume(mddev);
+	mddev_resume(mddev);
 
 	return len;
 }
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 4c5f3f032656..55d01d431418 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -804,8 +804,8 @@ extern int md_rdev_init(struct md_rdev *rdev);
 extern void md_rdev_clear(struct md_rdev *rdev);
 
 extern void md_handle_request(struct mddev *mddev, struct bio *bio);
-extern int __mddev_suspend(struct mddev *mddev, bool interruptible);
-extern void __mddev_resume(struct mddev *mddev);
+extern int mddev_suspend(struct mddev *mddev, bool interruptible);
+extern void mddev_resume(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
@@ -853,27 +853,27 @@ static inline int mddev_suspend_and_lock(struct mddev *mddev)
 {
 	int ret;
 
-	ret = __mddev_suspend(mddev, true);
+	ret = mddev_suspend(mddev, true);
 	if (ret)
 		return ret;
 
 	ret = mddev_lock(mddev);
 	if (ret)
-		__mddev_resume(mddev);
+		mddev_resume(mddev);
 
 	return ret;
 }
 
 static inline void mddev_suspend_and_lock_nointr(struct mddev *mddev)
 {
-	__mddev_suspend(mddev, false);
+	mddev_suspend(mddev, false);
 	mutex_lock(&mddev->reconfig_mutex);
 }
 
 static inline void mddev_unlock_and_resume(struct mddev *mddev)
 {
 	mddev_unlock(mddev);
-	__mddev_resume(mddev);
+	mddev_resume(mddev);
 }
 
 struct mdu_array_info_s;
diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 9909110262ee..6157f5beb9fe 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -699,9 +699,9 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 
 	log = READ_ONCE(conf->log);
 	if (log) {
-		__mddev_suspend(mddev, false);
+		mddev_suspend(mddev, false);
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

