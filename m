Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE48CE7B00
	for <dm-devel@archiver.kernel.org>; Thu, 28 Sep 2023 06:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1695883598;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=gg/nKLeI2UeExFKT5ztvYYr/UXjlU99R2X9hUmCTmVs=;
	b=Zjq4bbnHfHlJmPqUtjDU5o586tbamXHR0kdoCI8MTn9pn0cjaV5Ovr3JNZ+/0DCWD14l9F
	8stfP7EtL4XQivMjCexwGkF6+HSu3fTmUINR+pzJUvDOTcrn8W9D/6ZSjYijGbUOjoKN5k
	xEbSQxEqE4uCTMHPrd9AcNUE8ejMhDk=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-684-RWDi5IrAM6awqjXgCbAj8w-1; Thu, 28 Sep 2023 02:46:35 -0400
X-MC-Unique: RWDi5IrAM6awqjXgCbAj8w-1
Received: from smtp.corp.redhat.com (int-mx09.intmail.prod.int.rdu2.redhat.com [10.11.54.9])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 549B2811E96;
	Thu, 28 Sep 2023 06:46:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 3FCAF492B16;
	Thu, 28 Sep 2023 06:46:33 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id A5B8419465B3;
	Thu, 28 Sep 2023 06:46:32 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com
 [10.11.54.6])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 628A61946587
 for <dm-devel@listman.corp.redhat.com>; Thu, 28 Sep 2023 06:22:13 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id 45B6B215670B; Thu, 28 Sep 2023 06:22:13 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast03.extmail.prod.ext.rdu2.redhat.com [10.11.55.19])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id 3E76D2156702
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:13 +0000 (UTC)
Received: from us-smtp-inbound-delivery-1.mimecast.com (us-smtp-1.mimecast.com
 [205.139.110.61])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2350E811E8D
 for <dm-devel@redhat.com>; Thu, 28 Sep 2023 06:22:13 +0000 (UTC)
Received: from dggsgout12.his.huawei.com (hwsga02-in.huaweimarine.com
 [45.249.212.56]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-608-hyrrxa_8NzuJUuWJ7gAnwg-1; Thu, 28 Sep 2023 02:22:08 -0400
X-MC-Unique: hyrrxa_8NzuJUuWJ7gAnwg-1
Received: from mail02.huawei.com (unknown [172.30.67.143])
 by dggsgout12.his.huawei.com (SkyGuard) with ESMTP id 4Rx3Kg2Wwhz4f3kF9;
 Thu, 28 Sep 2023 14:21:59 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnvdyCGxVl3v1WBg--.22861S21;
 Thu, 28 Sep 2023 14:22:03 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: xni@redhat.com, agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com,
 song@kernel.org
Date: Thu, 28 Sep 2023 14:15:35 +0800
Message-Id: <20230928061543.1845742-18-yukuai1@huaweicloud.com>
In-Reply-To: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
References: <20230928061543.1845742-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnvdyCGxVl3v1WBg--.22861S21
X-Coremail-Antispam: 1UD129KBjvJXoWxWFykZr18Cry7tr1kGFWfZrb_yoW5Xr4Dpw
 s0gFsrXr4UWF9xu34DZa1kWFyrK3yUKrWkKryxW39Yva47Gr4kurWfJw45ZFy7G34FyFs7
 t3y5J34kZFWvqrDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Subject: [dm-devel] [PATCH -next v3 17/25] md/raid5: replace suspend with
 quiesce() callback
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

raid5 is the only personality to suspend array in check_reshape() and
start_reshape() callback, suspend and quiesce() callback can both wait
for all normal io to be done, and prevent new io to be dispatched, the
difference is that suspend is implemented in common layer, and quiesce()
callback is implemented in raid5.

In order to cleanup all the usage of mddev_suspend(), the new apis
__mddev_suspend() need to be called before 'reconfig_mutex' is held,
and it's not good to affect all the personalities in common layer just
for raid5. Hence replace suspend with quiesce() callaback, prepare to
reomove all the users of mddev_suspend().

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index e6b8c0145648..d6de084a85e5 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -70,6 +70,8 @@ MODULE_PARM_DESC(devices_handle_discard_safely,
 		 "Set to Y if all devices in each array reliably return zeroes on reads from discarded regions");
 static struct workqueue_struct *raid5_wq;
 
+static void raid5_quiesce(struct mddev *mddev, int quiesce);
+
 static inline struct hlist_head *stripe_hash(struct r5conf *conf, sector_t sect)
 {
 	int hash = (sect >> RAID5_STRIPE_SHIFT(conf)) & HASH_MASK;
@@ -2492,15 +2494,12 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 	unsigned long cpu;
 	int err = 0;
 
-	/*
-	 * Never shrink. And mddev_suspend() could deadlock if this is called
-	 * from raid5d. In that case, scribble_disks and scribble_sectors
-	 * should equal to new_disks and new_sectors
-	 */
+	/* Never shrink. */
 	if (conf->scribble_disks >= new_disks &&
 	    conf->scribble_sectors >= new_sectors)
 		return 0;
-	mddev_suspend(conf->mddev);
+
+	raid5_quiesce(conf->mddev, true);
 	cpus_read_lock();
 
 	for_each_present_cpu(cpu) {
@@ -2514,7 +2513,8 @@ static int resize_chunks(struct r5conf *conf, int new_disks, int new_sectors)
 	}
 
 	cpus_read_unlock();
-	mddev_resume(conf->mddev);
+	raid5_quiesce(conf->mddev, false);
+
 	if (!err) {
 		conf->scribble_disks = new_disks;
 		conf->scribble_sectors = new_sectors;
@@ -8551,8 +8551,8 @@ static int raid5_start_reshape(struct mddev *mddev)
 	 * the reshape wasn't running - like Discard or Read - have
 	 * completed.
 	 */
-	mddev_suspend(mddev);
-	mddev_resume(mddev);
+	raid5_quiesce(mddev, true);
+	raid5_quiesce(mddev, false);
 
 	/* Add some new drives, as many as will fit.
 	 * We know there are enough to make the newly sized array work.
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

