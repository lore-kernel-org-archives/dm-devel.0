Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BBC1C83F15
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188319;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=i3qkIDeUhs/e1sBOBzhXXKcd7CNiQZHrfX6JkKV0+D4=;
	b=EuC017BvDY4GexiUW9lxEUMQ80g70AgZGnVCtNCvY3bMhD5zJbbC29nJJVYX8Ex6vgQ0B6
	HY0m6ZEhJaYnPPUFno6eHnsI/CiPeoyyCUh2RwOyARzqiIRs1VNg0MZgPo34Y04HpTqmNd
	ewm+53xslaOSHWKCKVQHZOFk9vNdsRk=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-3-zQ1upiavPYWedXyhz5jPug-1; Sun, 27 Aug 2023 22:05:16 -0400
X-MC-Unique: zQ1upiavPYWedXyhz5jPug-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A03903C0F673;
	Mon, 28 Aug 2023 02:05:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 8E0A7C1602B;
	Mon, 28 Aug 2023 02:05:14 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 81A5219465BC;
	Mon, 28 Aug 2023 02:05:14 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com
 [10.11.54.10])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 75D5919465BA
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:05:06 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 683F64021B9; Mon, 28 Aug 2023 02:05:06 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 5FBCB401051
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:06 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-inbound-delivery-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 451581C02CAD
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:05:06 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-310-MDwVKrU0MGKIrzBQNpRkTw-1; Sun, 27 Aug 2023 22:05:01 -0400
X-MC-Unique: MDwVKrU0MGKIrzBQNpRkTw-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4RYv5J5Wd6z4f3nqt;
 Mon, 28 Aug 2023 10:04:52 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S29;
 Mon, 28 Aug 2023 10:04:56 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 10:00:18 +0800
Message-Id: <20230828020021.2489641-26-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S29
X-Coremail-Antispam: 1UD129KBjvJXoW3GryUCw1UZrWUKFy8CFy8Zrb_yoWxtr1fpw
 4aqa4rWr4UZ3y5Ww1UCayDG3WYvw1ktrs7try3u3yfXw43twn3KF1rWa45tr98Zas5Ar1U
 X3WUur4kCr1fGFUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_Ar0_tr1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW5JVW7JwCI42IY6xIIjxv20xvEc7CjxVAF
 wI0_Gr1j6F4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Gr
 0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQ
 SdkUUUUU=
X-CM-SenderInfo: 51xn3trlr6x35dzhxuhorxvhhfrp/
X-CFilter-Loop: Reflected
X-Mimecast-Impersonation-Protect: Policy=CLT - Impersonation Protection
 Definition; Similar Internal Domain=false;
 Similar Monitored External Domain=false; Custom External Domain=false;
 Mimecast External Domain=false; Newly Observed Domain=false;
 Internal User Name=false; Custom Display Name List=false;
 Reply-to Address Mismatch=false; Targeted Threat Dictionary=false;
 Mimecast Threat Dictionary=false; Custom Threat Dictionary=false
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Subject: [dm-devel] [PATCH -next v2 25/28] md: cleanup
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
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
index 0bb4c59543aa..53133b37c9b9 100644
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
 
@@ -2535,7 +2522,7 @@ static int bind_rdev_to_array(struct md_rdev *rdev, struct mddev *mddev)
 	pr_debug("md: bind<%s>\n", b);
 
 	if (mddev->raid_disks)
-		mddev_create_serial_pool(mddev, rdev, true);
+		mddev_create_serial_pool(mddev, rdev);
 
 	if ((err = kobject_add(&rdev->kobj, &mddev->kobj, "dev-%s", b)))
 		goto fail;
@@ -2588,7 +2575,7 @@ static void md_kick_rdev_from_array(struct md_rdev *rdev)
 	bd_unlink_disk_holder(rdev->bdev, rdev->mddev->gendisk);
 	list_del_rcu(&rdev->same_set);
 	pr_debug("md: unbind<%pg>\n", rdev->bdev);
-	mddev_destroy_serial_pool(rdev->mddev, rdev, false);
+	mddev_destroy_serial_pool(rdev->mddev, rdev);
 	rdev->mddev = NULL;
 	sysfs_remove_link(&rdev->kobj, "block");
 	sysfs_put(rdev->sysfs_state);
@@ -3055,11 +3042,11 @@ state_store(struct md_rdev *rdev, const char *buf, size_t len)
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
@@ -5563,9 +5550,9 @@ serialize_policy_store(struct mddev *mddev, const char *buf, size_t len)
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
@@ -6331,7 +6318,7 @@ static void __md_stop_writes(struct mddev *mddev)
 	}
 	/* disable policy to guarantee rdevs free resources for serialization */
 	mddev->serialize_policy = 0;
-	mddev_destroy_serial_pool(mddev, NULL, true);
+	mddev_destroy_serial_pool(mddev, NULL);
 }
 
 void md_stop_writes(struct mddev *mddev)
diff --git a/drivers/md/md.h b/drivers/md/md.h
index 07496179084a..73334034e880 100644
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

