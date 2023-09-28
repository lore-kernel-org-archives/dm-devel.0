Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7515CE7B02
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695882323;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=yxR0FyOLXXKTrEyl4v9fMquwiEH0BZVRdPS7kGNnsSI=;
	b=E9l4k7ij+1juQI1Sn7yLUs6bfwGdcFDgXeK4E/L+KieDLtE1DM/5O4VDV2fLZhy9YoPYL4
	fMfhse+1o4JQrv82CFOnGFkVozdnuTtAc+nt2P+R+kLrY/zD7iUy3zVCf8GaA6EcCe1are
	NFPnN3VLKLhqNFjiUbSkYrzH2zBuAv8=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-530-ofoPkgNINKalUjF8wPteiw-1; Thu, 28 Sep 2023 02:25:20 -0400
X-MC-Unique: ofoPkgNINKalUjF8wPteiw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 4E9F7280D214;
	Thu, 28 Sep 2023 06:25:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3862C1005E29;
	Thu, 28 Sep 2023 06:25:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 8AEFC1946587;
	Thu, 28 Sep 2023 06:25:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.rdu2.redhat.com
 [10.11.54.2])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id BF9AF1946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id A209D40C6E77; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast06.extmail.prod.ext.rdu2.redhat.com [10.11.55.22])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 9B41E40C6E76
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7736A185A797
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-486-q2IZ7iIUMuedWH6-CXrIrw-1; Thu, 28 Sep 2023 02:22:10 -0400
X-MC-Unique: q2IZ7iIUMuedWH6-CXrIrw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kj1NFpz4f3jMD;
 Thu, 28 Sep 2023 14:22:01 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S25;
 Thu, 28 Sep 2023 14:22:05 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:39 +0800
Message-Id: <20230928061543.1845742-22-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S25
X-Coremail-Antispam: 1UD129KBjvJXoW3GryUCw1UZrWUKFy8CFy8Zrb_yoWxtr1fpw
 4aqa4rWr4UZ3y5Ww1UCayDG3WYvw1ktrZ7try3u3yfXw43twn3KF1rWa45tr98Zas5Ar1U
 X3WUur4kCr1fKFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.2
Subject: [dm-devel] [PATCH -next v3 21/25] md: cleanup
 mddev_create/destroy_serial_pool()
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

Now that except for stopping the array, all the callers already suspend
the array, there is no need to suspend anymore, hence remove the second
parameter.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c |  8 ++++----
 drivers/md/md.c        | 33 ++++++++++-----------------------
 drivers/md/md.h        |  7 +++----
 3 files changed, 17 insertions(+), 31 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index b3d701c5c461..9672f75c3050 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -1861,7 +1861,7 @@ void md_bitmap_destroy(struct mddev *mddev)
 
 	md_bitmap_wait_behind_writes(mddev);
 	if (!mddev->serialize_policy)
-		mddev_destroy_serial_pool(mddev, NULL, true);
+		mddev_destroy_serial_pool(mddev, NULL);
 
 	mutex_lock(&mddev->bitmap_info.mutex);
 	spin_lock(&mddev->lock);
@@ -1977,7 +1977,7 @@ int md_bitmap_load(struct mddev *mddev)
 		goto out;
 
 	rdev_for_each(rdev, mddev)
-		mddev_create_serial_pool(mddev, rdev, true);
+		mddev_create_serial_pool(mddev, rdev);
 
 	if (mddev_is_clustered(mddev))
 		md_cluster_ops->load_bitmaps(mddev, mddev->bitmap_info.nodes);
@@ -2562,11 +2562,11 @@ backlog_store(struct mddev *mddev, const char *buf, size_t len)
 	if (!backlog && mddev->serial_info_pool) {
 		/* serial_info_pool is not needed if backlog is zero */
 		if (!mddev->serialize_policy)
-			mddev_destroy_serial_pool(mddev, NULL, true);
+			mddev_destroy_serial_pool(mddev, NULL);
 	} else if (backlog && !mddev->serial_info_pool) {
 		/* serial_info_pool is needed since backlog is not zero */
 		rdev_for_each(rdev, mddev)
-			mddev_create_serial_pool(mddev, rdev, true);
+			mddev_create_serial_pool(mddev, rdev);
 	}
 	if (old_mwb != backlog)
 		md_bitmap_update_sb(mddev->bitmap);
diff --git a/drivers/md/md.c b/drivers/md/md.c
index f8d92d745105..c3a51d309063 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -206,8 +206,7 @@ static int rdev_need_serial(struct md_rdev *rdev)
  * 1. rdev is the first device which return true from rdev_enable_serial.
  * 2. rdev is NULL, means we want to enable serialization for all rdevs.
  */
-void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
-			      bool is_suspend)
+void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	int ret = 0;
 
@@ -215,15 +214,12 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 	    !test_bit(CollisionCheck, &rdev->flags))
 		return;
 
-	if (!is_suspend)
-		mddev_suspend(mddev);
-
 	if (!rdev)
 		ret = rdevs_init_serial(mddev);
 	else
 		ret = rdev_init_serial(rdev);
 	if (ret)
-		goto abort;
+		return;
 
 	if (mddev->serial_info_pool == NULL) {
 		/*
@@ -238,10 +234,6 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 			pr_err("can't alloc memory pool for serialization\n");
 		}
 	}
-
-abort:
-	if (!is_suspend)
-		mddev_resume(mddev);
 }
 
 /*
@@ -250,8 +242,7 @@ void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
  * 2. when bitmap is destroyed while policy is not enabled.
  * 3. for disable policy, the pool is destroyed only when no rdev needs it.
  */
-void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
-			       bool is_suspend)
+void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev)
 {
 	if (rdev && !test_bit(CollisionCheck, &rdev->flags))
 		return;
@@ -260,8 +251,6 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 		struct md_rdev *temp;
 		int num = 0; /* used to track if other rdevs need the pool */
 
-		if (!is_suspend)
-			mddev_suspend(mddev);
 		rdev_for_each(temp, mddev) {
 			if (!rdev) {
 				if (!mddev->serialize_policy ||
@@ -283,8 +272,6 @@ void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
 			mempool_destroy(mddev->serial_info_pool);
 			mddev->serial_info_pool = NULL;
 		}
-		if (!is_suspend)
-			mddev_resume(mddev);
 	}
 }
 
@@ -2557,7 +2544,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	pr_debug("md: bind<%s>\n", b);
 
 	if (mddev->raid_disks)
-		mddev_create_serial_pool(mddev, rdev, true);
+		mddev_create_serial_pool(mddev, rdev);
 
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
@@ -2610,7 +2597,7 @@ static void md_kick_rdev_from_array(struct md_rdev *rdev)
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
 	pr_debug("md: unbind<%pg>\n", rdev->bdev);
-	mddev_destroy_serial_pool(rdev->mddev, rdev, false);
+	mddev_destroy_serial_pool(rdev->mddev, rdev);
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
@@ -3077,11 +3064,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
 		}
 	} else if (cmd_match(buf, "writemostly")) {
 		set_bit(WriteMostly, &rdev->flags);
-		mddev_create_serial_pool(rdev->mddev, rdev, true);
+		mddev_create_serial_pool(rdev->mddev, rdev);
 		need_update_sb = true;
 		err = 0;
 	} else if (cmd_match(buf, "-writemostly")) {
-		mddev_destroy_serial_pool(rdev->mddev, rdev, true);
+		mddev_destroy_serial_pool(rdev->mddev, rdev);
 		clear_bit(WriteMostly, &rdev->flags);
 		need_update_sb = true;
 		err = 0;
@@ -5588,9 +5575,9 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 
 	if (value)
-		mddev_create_serial_pool(mddev, NULL, true);
+		mddev_create_serial_pool(mddev, NULL);
 	else
-		mddev_destroy_serial_pool(mddev, NULL, true);
+		mddev_destroy_serial_pool(mddev, NULL);
 	mddev->serialize_policy = value;
 unlock:
 	mddev_unlock_and_resume(mddev);
@@ -6356,7 +6343,7 @@ static void __md_stop_writes(struct mddev *mddev)
 	}
 	/* disable policy to guarantee rdevs free resources for serialization */
 	mddev->serialize_policy = 0;
-	mddev_destroy_serial_pool(mddev, NULL, true);
+	mddev_destroy_serial_pool(mddev, NULL);
 }
 
 void md_stop_writes(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 5c8f3f045e78..63b4c393b1ee 100644
--- a/drivers/md/md.h
+++ b/drivers/md/md.h
@@ -817,10 +817,9 @@ extern void __mddev_resume(struct mddev *mddev);
 
 extern void md_reload_sb(struct mddev *mddev, int raid_disk);
 extern void md_update_sb(struct mddev *mddev, int force);
-extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
-				     bool is_suspend);
-extern void mddev_destroy_serial_pool(struct mddev *mddev, struct md_rdev *rdev,
-				      bool is_suspend);
+extern void mddev_create_serial_pool(struct mddev *mddev, struct md_rdev *rdev);
+extern void mddev_destroy_serial_pool(struct mddev *mddev,
+				      struct md_rdev *rdev);
 struct md_rdev *md_find_rdev_nr_rcu(struct mddev *mddev, int nr);
 struct md_rdev *md_find_rdev_rcu(struct mddev *mddev, dev_t dev);
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

