Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B5B4CE7AFD
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:23:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695882212;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=kMGTXHHPcE4uBNmxPX2TBEdCNqANDDC1LEtrXlSx7LU=;
	b=RMFG2DTMGAOVCBoS1rdxY7xRCQrmEiOfIbMdwkF/Pwmf1l4w09se5PI/B2sJS4ePEKg9CP
	l12Y0r1irqwS9eZJ11h6H03l6wzzV98dKWciHFwAmkD/jF90E4HUgiCjxAAZ48n577A1h3
	3bk33GX4uq0fbkBukXPWbDVFCpevPHU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-295-9y8qmQ78PwaqrYS63qOIrQ-1; Thu, 28 Sep 2023 02:23:28 -0400
X-MC-Unique: 9y8qmQ78PwaqrYS63qOIrQ-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 369EE811E7E;
	Thu, 28 Sep 2023 06:23:27 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 5A808492B16;
	Thu, 28 Sep 2023 06:23:25 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id 0BC351946588;
	Thu, 28 Sep 2023 06:23:25 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.rdu2.redhat.com
 [10.11.54.7])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 91F961946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:16 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 86C27140273E; Thu, 28 Sep 2023 06:22:16 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast09.extmail.prod.ext.rdu2.redhat.com [10.11.55.25])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 7F3E4140273D
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:16 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com
 (us-smtp-delivery-1.mimecast.com [205.139.110.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 63A2D2801591
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:16 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-252-MyZI17GANq2xphh2tXK-rw-1; Thu, 28 Sep 2023 02:22:10 -0400
X-MC-Unique: MyZI17GANq2xphh2tXK-rw-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kn4v2pz4f3k6C;
 Thu, 28 Sep 2023 14:22:05 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S27;
 Thu, 28 Sep 2023 14:22:06 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:41 +0800
Message-Id: <20230928061543.1845742-24-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S27
X-Coremail-Antispam: 1UD129KBjvJXoW7AF13ZryrJw1rur47Gr47CFg_yoW8WF45pF
 4SyF93Cr4UXayfZ3yUW3Z5uFy5Jw10grZFyFW7uas5Z3Z3trnrGr13ur1DZrWkKa4ftF90
 qws0q3WUAr1UKw7anT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.7
Subject: [dm-devel] [PATCH -next v3 23/25] md: suspend array in
 md_start_sync() if array need reconfiguration
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.9
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: huaweicloud.com
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit

From: Yu Kuai <yukuai3@huawei.com>

So that io won't concurrent with array reconfiguration, and it's safe to
suspend the array directly because normal io won't rely on
md_start_sync().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/md.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/drivers/md/md.c b/drivers/md/md.c
index c3a51d309063..a3b62c6c5332 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -9414,8 +9414,13 @@ static void md_start_sync(struct work_struct *ws)
 {
 	struct mddev *mddev = container_of(ws, struct mddev, sync_work);
 	int spares = 0;
+	bool suspend = false;
 
-	mddev_lock_nointr(mddev);
+	if (md_spares_need_change(mddev))
+		suspend = true;
+
+	suspend ? mddev_suspend_and_lock_nointr(mddev) :
+		  mddev_lock_nointr(mddev);
 
 	if (!md_is_rdwr(mddev)) {
 		/*
@@ -9451,7 +9456,7 @@ static void md_start_sync(struct work_struct *ws)
 		goto not_running;
 	}
 
-	mddev_unlock(mddev);
+	suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 	md_wakeup_thread(mddev->sync_thread);
 	sysfs_notify_dirent_safe(mddev->sysfs_action);
 	md_new_event();
@@ -9463,7 +9468,7 @@ static void md_start_sync(struct work_struct *ws)
 	clear_bit(MD_RECOVERY_REQUESTED, &mddev->recovery);
 	clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
 	clear_bit(MD_RECOVERY_RUNNING, &mddev->recovery);
-	mddev_unlock(mddev);
+	suspend ? mddev_unlock_and_resume(mddev) : mddev_unlock(mddev);
 
 	wake_up(&resync_wait);
 	if (test_and_clear_bit(MD_RECOVERY_RECOVER, &mddev->recovery) &&
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

