Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3FC5EEE49A0
	for <dm-devel@archiver.kernel.org>; Fri, 25 Aug 2023 03:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692933271;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=8XHFcU9ayHgHfHgyleeY8iw3wmq7DTMqzlmhlVYBYpg=;
	b=W2mInkiNA9bYnFT2bJGQpMGCR33X59aRJxVpudLwB8eYa0lP/4mQ+at0leGngl/hqeJcgu
	V5wqAh4BQTfLsoAcyKD8Z1w1AkJXLJWCnZ6L/fZe3Pz/iT41yLeujrxmcZEZG02kw9Xrv9
	EaZsqNliuSW/QJbGT/fiPyXWCji77Io=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-199-g6cFTfe5P2eQ6smM52k47A-1; Thu, 24 Aug 2023 23:14:28 -0400
X-MC-Unique: g6cFTfe5P2eQ6smM52k47A-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2E0838564F0;
	Fri, 25 Aug 2023 03:14:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 1CFE6140E962;
	Fri, 25 Aug 2023 03:14:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id ED75919465A3;
	Fri, 25 Aug 2023 03:14:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com
 [10.11.54.8])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id AB4241946589
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Aug 2023 03:14:22 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 9D627C1602E; Fri, 25 Aug 2023 03:14:22 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 95199C1602B
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 03:14:22 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 6E4363804522
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 03:14:22 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-296-Ao6hd0FZMsCEuJmTD1gVVQ-1; Thu, 24 Aug 2023 23:14:18 -0400
X-MC-Unique: Ao6hd0FZMsCEuJmTD1gVVQ-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RX4mg0CWjz4f3lCp;
 Fri, 25 Aug 2023 11:14:11 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBah_HOhkveEWBg--.3212S5;
 Fri, 25 Aug 2023 11:14:12 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Fri, 25 Aug 2023 11:09:50 +0800
Message-Id: <20230825030956.1527023-2-yukuai1@huaweicloud.com>
In-Reply-To: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
References: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBah_HOhkveEWBg--.3212S5
X-Coremail-Antispam: 1UD129KBjvJXoWxKF4xCr43Gw1UZrW3Cr4rXwb_yoW7tw1kpa
 1Iqas5Jr4UJFZIqrW3JF4Dua45Ww1kKrWkKry3Gwn3AF1akr1DG3WYqFW8ZrykCayrC3W5
 Xw1FgFWUuF18Gr7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUBK14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_Jr4l82xGYIkIc2
 x26xkF7I0E14v26r4j6ryUM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2z4x0
 Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6rxdM2
 8EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0DM2AI
 xVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjxv20x
 vE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xv
 r2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2IY04
 v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_
 Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x
 0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8
 JVWxJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIx
 AIcVC2z280aVCY1x0267AKxVW8JVW8JrUvcSsGvfC2KfnxnUUI43ZEXa7VUjeWlDUUUUU=
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Subject: [dm-devel] [PATCH -next v2 1/7] md: initialize 'active_io' while
 allocating mddev
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

'active_io' is used for mddev_suspend() and it's initialized in
md_run(), this restrict that 'reconfig_mutex' must be held and
"mddev->pers" must be set before calling mddev_suspend().

Initialize 'active_io' early so that mddev_suspend() is safe to call
once mddev is allocated, this will be helpful to refactor
mddev_suspend() in following patches.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/dm-raid.c |  7 +++++-
 drivers/md/md.c      | 53 +++++++++++++++++++++++++++-----------------
 drivers/md/md.h      |  3 ++-
 3 files changed, 41 insertions(+), 22 deletions(-)

diff --git a/drivers/md/dm-raid.c b/drivers/md/dm-raid.c
index 1f22bef27841..020598c10db0 100644
--- a/drivers/md/dm-raid.c
+++ b/drivers/md/dm-raid.c
@@ -749,7 +749,11 @@ static struct raid_set *raid_set_alloc(struct dm_target *ti, struct raid_type *r
 		return ERR_PTR(-ENOMEM);
 	}
 
-	mddev_init(&rs->md);
+	if (mddev_init(&rs->md)) {
+		kfree(rs);
+		ti->error = "Cannot initialize raid context";
+		return ERR_PTR(-ENOMEM);
+	}
 
 	rs->raid_disks = raid_devs;
 	rs->delta_disks = 0;
@@ -798,6 +802,7 @@ static void raid_set_free(struct raid_set *rs)
 			dm_put_device(rs->ti, rs->dev[i].data_dev);
 	}
 
+	mddev_destroy(&rs->md);
 	kfree(rs);
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index 4e5bca33f559..9974cf45f9d0 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -639,8 +639,20 @@ void mddev_put(struct mddev *mddev)
 static void md_safemode_timeout(struct timer_list *t);
 static void md_start_sync(struct work_struct *ws);
 
-void mddev_init(struct mddev *mddev)
+static void active_io_release(struct percpu_ref *ref)
 {
+	struct mddev *mddev = container_of(ref, struct mddev, active_io);
+
+	wake_up(&mddev->sb_wait);
+}
+
+int mddev_init(struct mddev *mddev)
+{
+
+	if (percpu_ref_init(&mddev->active_io, active_io_release,
+			    PERCPU_REF_ALLOW_REINIT, GFP_KERNEL))
+		return -ENOMEM;
+
 	mutex_init(&mddev->open_mutex);
 	mutex_init(&mddev->reconfig_mutex);
 	mutex_init(&mddev->sync_mutex);
@@ -665,9 +677,17 @@ void mddev_init(struct mddev *mddev)
 
 	INIT_WORK(&mddev->sync_work, md_start_sync);
 	INIT_WORK(&mddev->del_work, mddev_delayed_delete);
+
+	return 0;
 }
 EXPORT_SYMBOL_GPL(mddev_init);
 
+void mddev_destroy(struct mddev *mddev)
+{
+	percpu_ref_exit(&mddev->active_io);
+}
+EXPORT_SYMBOL_GPL(mddev_destroy);
+
 static struct mddev *mddev_find_locked(dev_t unit)
 {
 	struct mddev *mddev;
@@ -711,13 +731,16 @@ static struct mddev *mddev_alloc(dev_t unit)
 	new = kzalloc(sizeof(*new), GFP_KERNEL);
 	if (!new)
 		return ERR_PTR(-ENOMEM);
-	mddev_init(new);
+
+	error = mddev_init(new);
+	if (error)
+		goto out_free_new;
 
 	spin_lock(&all_mddevs_lock);
 	if (unit) {
 		error = -EEXIST;
 		if (mddev_find_locked(unit))
-			goto out_free_new;
+			goto out_destroy_new;
 		new->unit = unit;
 		if (MAJOR(unit) == MD_MAJOR)
 			new->md_minor = MINOR(unit);
@@ -728,7 +751,7 @@ static struct mddev *mddev_alloc(dev_t unit)
 		error = -ENODEV;
 		new->unit = mddev_alloc_unit();
 		if (!new->unit)
-			goto out_free_new;
+			goto out_destroy_new;
 		new->md_minor = MINOR(new->unit);
 		new->hold_active = UNTIL_STOP;
 	}
@@ -736,8 +759,11 @@ static struct mddev *mddev_alloc(dev_t unit)
 	list_add(&new->all_mddevs, &all_mddevs);
 	spin_unlock(&all_mddevs_lock);
 	return new;
-out_free_new:
+
+out_destroy_new:
 	spin_unlock(&all_mddevs_lock);
+	mddev_destroy(new);
+out_free_new:
 	kfree(new);
 	return ERR_PTR(error);
 }
@@ -748,6 +774,7 @@ static void mddev_free(struct mddev *mddev)
 	list_del(&mddev->all_mddevs);
 	spin_unlock(&all_mddevs_lock);
 
+	mddev_destroy(mddev);
 	kfree(mddev);
 }
 
@@ -5778,12 +5805,6 @@ static void md_safemode_timeout(struct timer_list *t)
 }
 
 static int start_dirty_degraded;
-static void active_io_release(struct percpu_ref *ref)
-{
-	struct mddev *mddev = container_of(ref, struct mddev, active_io);
-
-	wake_up(&mddev->sb_wait);
-}
 
 int md_run(struct mddev *mddev)
 {
@@ -5864,15 +5885,10 @@ int md_run(struct mddev *mddev)
 		nowait = nowait && bdev_nowait(rdev->bdev);
 	}
 
-	err = percpu_ref_init(&mddev->active_io, active_io_release,
-				PERCPU_REF_ALLOW_REINIT, GFP_KERNEL);
-	if (err)
-		return err;
-
 	if (!bioset_initialized(&mddev->bio_set)) {
 		err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
 		if (err)
-			goto exit_active_io;
+			return err;
 	}
 	if (!bioset_initialized(&mddev->sync_set)) {
 		err = bioset_init(&mddev->sync_set, BIO_POOL_SIZE, 0, BIOSET_NEED_BVECS);
@@ -6069,8 +6085,6 @@ int md_run(struct mddev *mddev)
 	bioset_exit(&mddev->sync_set);
 exit_bio_set:
 	bioset_exit(&mddev->bio_set);
-exit_active_io:
-	percpu_ref_exit(&mddev->active_io);
 	return err;
 }
 EXPORT_SYMBOL_GPL(md_run);
@@ -6286,7 +6300,6 @@ static void __md_stop(struct mddev *mddev)
 	module_put(pers->owner);
 	clear_bit(MD_RECOVERY_FROZEN, &mddev->recovery);
 
-	percpu_ref_exit(&mddev->active_io);
 	bioset_exit(&mddev->bio_set);
 	bioset_exit(&mddev->sync_set);
 	bioset_exit(&mddev->io_clone_set);
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 64d05cb65287..f6b64b0e92c7 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -795,7 +795,8 @@ extern int md_integrity_register(struct mddev *mddev);
 extern int md_integrity_add_rdev(struct md_rdev *rdev, struct mddev *mddev);
 extern int strict_strtoul_scaled(const char *cp, unsigned long *res, int scale);
 
-extern void mddev_init(struct mddev *mddev);
+extern int mddev_init(struct mddev *mddev);
+extern void mddev_destroy(struct mddev *mddev);
 struct mddev *md_alloc(dev_t dev, char *name);
 void mddev_put(struct mddev *mddev);
 extern int md_run(struct mddev *mddev);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

