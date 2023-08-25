Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3EB8C71133
	for <dm-devel@archiver.kernel.org>; Fri, 25 Aug 2023 03:14:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1692933272;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=zCD8FQyhzRpgrP3hNgoMY7JoiUkBHzGlOEA7cir5tlE=;
	b=XrWv0M+JGF2Ty7fIQy1AoFsxERhT3FoDw0Wo6QI4vypFXhyTEjyDMkgiVmwgj8MNzxfty7
	u7MODkRx6kqFD+0GyzeY1QmkPZRviPK4n9Xs4GyQ1tnBSn0Wla5f0V2WrJ/XdsNemieLqw
	qdw1V5Ak2/9RNFBG6mOZUfvkNti7KCw=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-53-pyUXE0i5N4GI6d-YNE0odw-1; Thu, 24 Aug 2023 23:14:28 -0400
X-MC-Unique: pyUXE0i5N4GI6d-YNE0odw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com [10.11.54.7])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id A404B101CC9C;
	Fri, 25 Aug 2023 03:14:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5552B140E963;
	Fri, 25 Aug 2023 03:14:26 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 254131946589;
	Fri, 25 Aug 2023 03:14:26 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id F2FF119465B9
 for <dm-devel@listman.corp.redhat.com>; Fri, 25 Aug 2023 03:14:23 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E5FC5140E963; Fri, 25 Aug 2023 03:14:23 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DB659140E962
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 03:14:23 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id BD9698022E4
 for <dm-devel@redhat.com>; Fri, 25 Aug 2023 03:14:23 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (hwsga01-in.huaweimarine.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-E1DUXpxiMeC0Q5-L07K6dw-1; Thu, 24 Aug 2023 23:14:19 -0400
X-MC-Unique: E1DUXpxiMeC0Q5-L07K6dw-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RX4mh63nzz4f3lfb;
 Fri, 25 Aug 2023 11:14:12 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBah_HOhkveEWBg--.3212S9;
 Fri, 25 Aug 2023 11:14:14 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Fri, 25 Aug 2023 11:09:54 +0800
Message-Id: <20230825030956.1527023-6-yukuai1@huaweicloud.com>
In-Reply-To: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
References: <20230825030956.1527023-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBah_HOhkveEWBg--.3212S9
X-Coremail-Antispam: 1UD129KBjvJXoW7Kry7KFW7KrWUAr1kJrWkWFg_yoW5Jr48pa
 n3ta4rtr1rXFW3Xr17t3yv9FyrWw4kKrZrtrWxWwn5G3ZaywnxWF4rWF15J348K34rAFs8
 Jw45JF18Gr1UWFJanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
 9KBjDU0xBIdaVrnRJUUUPY14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
 rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
 kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
 z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Cr1j6r
 xdM28EF7xvwVC2z280aVAFwI0_GcCE3s1l84ACjcxK6I8E87Iv6xkF7I0E14v26rxl6s0D
 M2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40Ex7xfMcIj6xIIjx
 v20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x0Yz7v_Jr0_Gr1l
 F7xvr2IYc2Ij64vIr41lF7I21c0EjII2zVCS5cI20VAGYxC7M4IIrI8v6xkF7I0E8cxan2
 IY04v7MxAIw28IcxkI7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAF
 wI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc4
 0Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1I6r4UMIIF0xvE2Ix0cI8IcVCY1x0267AK
 xVWxJVW8Jr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvEx4A2jsIE14v26r1j6r
 4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvjDU0xZFpf9x0JUQSdkU
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH -next v2 5/7] md-bitmap: suspend array earlier in
 location_store()
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

Now that mddev_suspend() doean't rely on 'mddev->pers' to be set, it's
safe to call mddev_suspend() earlier.

This will also be helper to refactor mddev_suspend() later.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md-bitmap.c | 43 ++++++++++++++++++++----------------------
 1 file changed, 20 insertions(+), 23 deletions(-)

diff --git a/drivers/md/md-bitmap.c b/drivers/md/md-bitmap.c
index f38c7f3156cb..0c661e5036bb 100644
--- a/drivers/md/md-bitmap.c
+++ b/drivers/md/md-bitmap.c
@@ -2351,6 +2351,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	rv = mddev_lock(mddev);
 	if (rv)
 		return rv;
+
+	mddev_suspend(mddev);
 	if (mddev->pers) {
 		if (mddev->recovery || mddev->sync_thread) {
 			rv = -EBUSY;
@@ -2365,11 +2367,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 			rv = -EBUSY;
 			goto out;
 		}
-		if (mddev->pers) {
-			mddev_suspend(mddev);
-			md_bitmap_destroy(mddev);
-			mddev_resume(mddev);
-		}
+
+		md_bitmap_destroy(mddev);
 		mddev->bitmap_info.offset = 0;
 		if (mddev->bitmap_info.file) {
 			struct file *f = mddev->bitmap_info.file;
@@ -2379,6 +2378,8 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	} else {
 		/* No bitmap, OK to set a location */
 		long long offset;
+		struct bitmap *bitmap;
+
 		if (strncmp(buf, "none", 4) == 0)
 			/* nothing to be done */;
 		else if (strncmp(buf, "file:", 5) == 0) {
@@ -2402,25 +2403,20 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 				rv = -EINVAL;
 				goto out;
 			}
+
 			mddev->bitmap_info.offset = offset;
-			if (mddev->pers) {
-				struct bitmap *bitmap;
-				bitmap = md_bitmap_create(mddev, -1);
-				mddev_suspend(mddev);
-				if (IS_ERR(bitmap))
-					rv = PTR_ERR(bitmap);
-				else {
-					mddev->bitmap = bitmap;
-					rv = md_bitmap_load(mddev);
-					if (rv)
-						mddev->bitmap_info.offset = 0;
-				}
-				if (rv) {
-					md_bitmap_destroy(mddev);
-					mddev_resume(mddev);
-					goto out;
-				}
-				mddev_resume(mddev);
+			bitmap = md_bitmap_create(mddev, -1);
+			if (IS_ERR(bitmap)) {
+				rv = PTR_ERR(bitmap);
+				goto out;
+			}
+
+			mddev->bitmap = bitmap;
+			rv = md_bitmap_load(mddev);
+			if (rv) {
+				mddev->bitmap_info.offset = 0;
+				md_bitmap_destroy(mddev);
+				goto out;
 			}
 		}
 	}
@@ -2433,6 +2429,7 @@ location_store(struct mddev *mddev, const char *buf, size_t len)
 	}
 	rv = 0;
 out:
+	mddev_resume(mddev);
 	mddev_unlock(mddev);
 	if (rv)
 		return rv;
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

