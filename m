Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0821ECE7B0A
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 07:05:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695884741;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=wbuvBdU/lQL1GNf4c+pI5s9TWVBbDeTgBnw1/sdbxXg=;
	b=BnBO1YPe3QB9pGPOH3zhlUhoATyaSvSSCyixPgaE/93aSM5FEG7d9SBZMJMCdwWtVQPwsj
	mUiuD/Hp8Zfl1ovIFnRJn6pRigKXhHnCb5lSNRGA6h9Ros0voDXs2KJZXmIc0CXGQgCho0
	/LELoW4row0yr5PK0VR3tRowl0/Yb6M=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-599-sVH_Iv31Ndmy37hVtOGDpA-1; Thu, 28 Sep 2023 03:05:37 -0400
X-MC-Unique: sVH_Iv31Ndmy37hVtOGDpA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 377BB1871DB6;
	Thu, 28 Sep 2023 07:05:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 25735176EA;
	Thu, 28 Sep 2023 07:05:35 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AA8E31946A42;
	Thu, 28 Sep 2023 07:05:33 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com
 [10.11.54.1])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 5B84A1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:14 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 4FBE340C2064; Thu, 28 Sep 2023 06:22:14 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast08.extmail.prod.ext.rdu2.redhat.com [10.11.55.24])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 488EA40C2070
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:14 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-2.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2DA013811715
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:14 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-502-G88_kAUuOe6o-bpJJmgaAw-1; Thu, 28 Sep 2023 02:22:09 -0400
X-MC-Unique: G88_kAUuOe6o-bpJJmgaAw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kl1DLwz4f3m7L;
 Thu, 28 Sep 2023 14:22:03 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S24;
 Thu, 28 Sep 2023 14:22:05 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:38 +0800
Message-Id: <20230928061543.1845742-21-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S24
X-Coremail-Antispam: 1UD129KBjvJXoW3Ar45Jr1xGr4rGry3KF45KFg_yoW7Ww1xpr
 s3Ka4fWrWUX343Jw1UZan7uFy5Jw18KrZrtry7Xa4fu3W3XwnxGr4FgFy5Jr1v9as5JF15
 Ja15Ww4kAry8GFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Subject: [dm-devel] [PATCH -next v3 20/25] md: use new apis to suspend array
 before mddev_create/destroy_serial_pool
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

mddev_create/destroy_serial_pool() will be called from several places
where mddev_suspend() will be called later.

Prepare to remove the mddev_suspend() from
mddev_create/destroy_serial_pool().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-autodetect.c |  4 ++--
 drivers/md/md-bitmap.c     |  8 ++++----
 drivers/md/md.c            | 22 ++++++++++++----------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/drivers/md/md-autodetect.c b/drivers/md/md-autodetect.c
index 6eaa0eab40f9..4b80165afd23 100644
--- a/drivers/md/md-autodetect.c
+++ b/drivers/md/md-autodetect.c
@@ -175,7 +175,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 		return;
 	}
 
-	err = mddev_lock(mddev);
+	err = mddev_suspend_and_lock(mddev);
 	if (err) {
 		pr_err("md: failed to lock array %s\n", name);
 		goto out_mddev_put;
@@ -221,7 +221,7 @@ static void __init md_setup_drive(struct md_setup_args *args)
 	if (err)
 		pr_warn("md: starting %s failed\n", name);
 out_unlock:
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 out_mddev_put:
 	mddev_put(mddev);
 }
diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index 7d21e2a5b06e..b3d701c5c461 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2537,7 +2537,7 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (backlog > COUNTER_MAX)
 		return -EINVAL;
 
-	rv = mddev_lock(mddev);
+	rv = mddev_suspend_and_lock(mddev);
 	if (rv)
 		return rv;
 
@@ -2562,16 +2562,16 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
 		if (!mddev->serialize_policy)
-			mddev_destroy_serial_pool(mddev, NULL, false);
+			mddev_destroy_serial_pool(mddev, NULL, true);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
 		rdev_for_each(rdev, mddev)
-			mddev_create_serial_pool(mddev, rdev, false);
+			mddev_create_serial_pool(mddev, rdev, true);
 	}
 	if (old_mwb != backlog)
 		md_bitmap_update_sb(mddev->bitmap);
 
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	return len;
 }
 
diff --git a/drivers/md/md.c b/drivers/md/md.c
index c5fb75b066b5..f8d92d745105 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -2557,7 +2557,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	pr_debug("md: bind<%s>\n", b);
 
 	if (mddev->raid_disks)
-		mddev_create_serial_pool(mddev, rdev, false);
+		mddev_create_serial_pool(mddev, rdev, true);
 
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
@@ -3077,11 +3077,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		}
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
-		mddev_create_serial_pool(rdev->mddev, rdev, false);
+		mddev_create_serial_pool(rdev->mddev, rdev, true);
 		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-writemostly")) {
-		mddev_destroy_serial_pool(rdev->mddev, rdev, false);
+		mddev_destroy_serial_pool(rdev->mddev, rdev, true);
 		clear_bit(WriteMostly, &rdev->flags);
 		need_update_sb = true;
 		err = 0;
@@ -3707,7 +3707,9 @@ rdev_attr_store(struct kobject *kobj, struct attribute *attr,
 	if (entry->store == state_store) {
 		if (cmd_match(page, "remove"))
 			kn = sysfs_break_active_protection(kobj, attr);
-		if (cmd_match(page, "remove") || cmd_match(page, "re-add"))
+		if (cmd_match(page, "remove") || cmd_match(page, "re-add") ||
+		    cmd_match(page, "writemostly") ||
+		    cmd_match(page, "-writemostly"))
 			suspend = true;
 	}
 
@@ -4681,7 +4683,7 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 	    minor != MINOR(dev))
 		return -EOVERFLOW;
 
-	err = mddev_lock(mddev);
+	err = mddev_suspend_and_lock(mddev);
 	if (err)
 		return err;
 	if (mddev->persistent) {
@@ -4702,14 +4704,14 @@ new_dev_store(struct mddev *mddev, const char *buf, size_t len)
 		rdev = md_import_device(dev, -1, -1);
 
 	if (IS_ERR(rdev)) {
-		mddev_unlock(mddev);
+		mddev_unlock_and_resume(mddev);
 		return PTR_ERR(rdev);
 	}
 	err = bind_rdev_to_array(rdev, mddev);
  out:
 	if (err)
 		export_rdev(rdev, mddev);
-	mddev_unlock(mddev);
+	mddev_unlock_and_resume(mddev);
 	if (!err)
 		md_new_event();
 	return err ? err : len;
@@ -6646,13 +6648,13 @@ static void autorun_devices(int part)
 		if (IS_ERR(mddev))
 			break;
 
-		if (mddev_lock(mddev))
+		if (mddev_suspend_and_lock(mddev))
 			pr_warn("md: %s locked, cannot run\n", mdname(mddev));
 		else if (mddev->raid_disks || mddev->major_version
 			 || !list_empty(&mddev->disks)) {
 			pr_warn("md: %s already running, cannot run %pg\n",
 				mdname(mddev), rdev0->bdev);
-			mddev_unlock(mddev);
+			mddev_unlock_and_resume(mddev);
 		} else {
 			pr_debug("md: created %s\n", mdname(mddev));
 			mddev->persistent = 1;
@@ -6662,7 +6664,7 @@ static void autorun_devices(int part)
 					export_rdev(rdev, mddev);
 			}
 			autorun_array(mddev);
-			mddev_unlock(mddev);
+			mddev_unlock_and_resume(mddev);
 		}
 		/* on success, candidates will be empty, on error
 		 * it won't...
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

