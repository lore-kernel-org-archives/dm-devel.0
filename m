Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB1CBCE7B03
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:25:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695882324;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=2hsh5MhZRLISVOvk1U3sQCyS7JheeSOiN68A64+mfDg=;
	b=ItNkwh+jQdxsGpR1VjarkIWSZ9mbeink83RGMuRZciH96lYE2kgY3afBQa6o0Vgnxsh56E
	o+a54WtbvGbdCSWUisBFnwYg0Pz0ArzJsSkHsZDOYErdaO11Ml0JrZleSpun+934kPNkb/
	wJ7NyQ+CaoFtiIg1ZUFK0ryv3iqOtHA=
Received: from mimecast-mx02.redhat.com (mx-ext.redhat.com [66.187.233.73])
 by relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-440-4iW9zDRVPLqHqN2S_v89Mg-1; Thu, 28 Sep 2023 02:25:21 -0400
X-MC-Unique: 4iW9zDRVPLqHqN2S_v89Mg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A59823C0DF9E;
	Thu, 28 Sep 2023 06:25:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 908D140C2070;
	Thu, 28 Sep 2023 06:25:18 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id AEEEA19466EB;
	Thu, 28 Sep 2023 06:25:17 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 228C21946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 110B110EE402; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast10.extmail.prod.ext.rdu2.redhat.com [10.11.55.26])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 090EF10EE6C9
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:12 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-inbound-delivery-1.mimecast.com [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id DEFD31C07835
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:11 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-563-FyseXWCSMuCKyxOg5ugbeQ-1; Thu, 28 Sep 2023 02:22:09 -0400
X-MC-Unique: FyseXWCSMuCKyxOg5ugbeQ-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kk1rTQz4f3mHq;
 Thu, 28 Sep 2023 14:22:02 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S22;
 Thu, 28 Sep 2023 14:22:04 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:36 +0800
Message-Id: <20230928061543.1845742-19-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S22
X-Coremail-Antispam: 1UD129KBjvJXoWxGF13Cw43KryDJw1UKr43Awb_yoW5Cw1fpr
 Wxtan5Kr45tFy3WrWUXa4v9a4rXwnrKrZFyrWxW3Z8G3WxArnxuF1ruF18Ar10k34fJF1D
 Jw4Yk3W8Ga17WFDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPI14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
 4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq
 3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7
 IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFVCjc4AY6r1j6r4U
 M4x0Y48IcxkI7VAKI48JM4x0x7Aq67IIx4CEVc8vx2IErcIFxwACI402YVCY1x02628vn2
 kIc2xKxwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E
 14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_Jw0_GFylIx
 kGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVW8JVW5JwCI42IY6xIIjxv20xvEc7CjxVAF
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Subject: [dm-devel] [PATCH -next v3 18/25] md: use new apis to suspend array
 for ioctls involed array reconfiguration
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

'reconfig_mutex' will be grabbed before these ioctls, suspend array
before holding the lock, so that io won't concurrent with array
reconfiguration through ioctls.

This is not hot path, so performance is not concerned.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 30 ++++++++++++++++++++----------
 1 file changed, 20 insertions(+), 10 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index 0c5a6169453c..957813b7d7e5 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -7209,7 +7209,6 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 			struct bitmap *bitmap;
 
 			bitmap = md_bitmap_create(mddev, -1);
-			mddev_suspend(mddev);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
 				err = md_bitmap_load(mddev);
@@ -7219,11 +7218,8 @@ static int set_bitmap_file(struct mddev *mddev, int fd)
 				md_bitmap_destroy(mddev);
 				fd = -1;
 			}
-			mddev_resume(mddev);
 		} else if (fd < 0) {
-			mddev_suspend(mddev);
 			md_bitmap_destroy(mddev);
-			mddev_resume(mddev);
 		}
 	}
 	if (fd < 0) {
@@ -7512,7 +7508,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 			mddev->bitmap_info.space =
 				mddev->bitmap_info.default_space;
 			bitmap = md_bitmap_create(mddev, -1);
-			mddev_suspend(mddev);
 			if (!IS_ERR(bitmap)) {
 				mddev->bitmap = bitmap;
 				rv = md_bitmap_load(mddev);
@@ -7520,7 +7515,6 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				rv = PTR_ERR(bitmap);
 			if (rv)
 				md_bitmap_destroy(mddev);
-			mddev_resume(mddev);
 		} else {
 			/* remove the bitmap */
 			if (!mddev->bitmap) {
@@ -7545,9 +7539,7 @@ static int update_array_info(struct mddev *mddev, mdu_array_info_t *info)
 				module_put(md_cluster_mod);
 				mddev->safemode_delay = DEFAULT_SAFEMODE_DELAY;
 			}
-			mddev_suspend(mddev);
 			md_bitmap_destroy(mddev);
-			mddev_resume(mddev);
 			mddev->bitmap_info.offset = 0;
 		}
 	}
@@ -7618,6 +7610,20 @@ static inline bool md_ioctl_valid(unsigned int cmd)
 	}
 }
 
+static bool md_ioctl_need_suspend(unsigned int cmd)
+{
+	switch (cmd) {
+	case ADD_NEW_DISK:
+	case HOT_ADD_DISK:
+	case HOT_REMOVE_DISK:
+	case SET_BITMAP_FILE:
+	case SET_ARRAY_INFO:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static int __md_set_array_info(struct mddev *mddev, void __user *argp)
 {
 	mdu_array_info_t info;
@@ -7750,7 +7756,8 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (!md_is_rdwr(mddev))
 		flush_work(&mddev->sync_work);
 
-	err = mddev_lock(mddev);
+	err = md_ioctl_need_suspend(cmd) ? mddev_suspend_and_lock(mddev) :
+					   mddev_lock(mddev);
 	if (err) {
 		pr_debug("md: ioctl lock interrupted, reason %d, cmd %d\n",
 			 err, cmd);
@@ -7878,7 +7885,10 @@ static int md_ioctl(struct block_device *bdev, blk_mode_t mode,
 	if (mddev->hold_active == UNTIL_IOCTL &&
 	    err != -EINVAL)
 		mddev->hold_active = 0;
-	mddev_unlock(mddev);
+
+	md_ioctl_need_suspend(cmd) ? mddev_unlock_and_resume(mddev) :
+				     mddev_unlock(mddev);
+
 out:
 	if(did_set_md_closing)
 		clear_bit(MD_CLOSING, &mddev->flags);
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

