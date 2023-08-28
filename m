Return-Path: <dm-devel-bounces@redhat.com>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34C4CC83F14
	for <dm-devel@archiver.kernel.org>; Mon, 28 Aug 2023 02:05:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1693188306;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:list-id:list-help:
	 list-unsubscribe:list-subscribe:list-post;
	bh=x9Z2O6ptSa3imiLh7DdFBcIr+O7kR+r34TgcOEry/g8=;
	b=J7zXtcfVQlu3MhqWRdRwRkCuOsZ4fdxo4oLtszRFHpfhLUoqx+lAD7VuSole1Itd4/sfwj
	c3p2kZR+tPEb9zp5cQmsoGKp92NBjMIGKG9Db4y6ydr/VklbtVXsQT9E7K/YiLCWWZg/sP
	8WNgVL6+3GumD333iGWXs/1zS5CpFtI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-635-ao7qAVNsPB6YAc22zLPbtA-1; Sun, 27 Aug 2023 22:05:03 -0400
X-MC-Unique: ao7qAVNsPB6YAc22zLPbtA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
	(using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 37A6B8D40C2;
	Mon, 28 Aug 2023 02:05:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com [10.30.29.100])
	by smtp.corp.redhat.com (Postfix) with ESMTP id 2331240C2070;
	Mon, 28 Aug 2023 02:05:01 +0000 (UTC)
Received: from mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (localhost [IPv6:::1])
	by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with ESMTP id D31681946A46;
	Mon, 28 Aug 2023 02:05:00 +0000 (UTC)
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com
 [10.11.54.3])
 by mm-prod-listman-01.mail-001.prod.us-east-1.aws.redhat.com (Postfix) with
 ESMTP id 1349E19465A8
 for <dm-devel@listman.corp.redhat.com>; Mon, 28 Aug 2023 02:04:57 +0000 (UTC)
Received: by smtp.corp.redhat.com (Postfix)
 id E6313112131B; Mon, 28 Aug 2023 02:04:56 +0000 (UTC)
Received: from mimecast-mx02.redhat.com
 (mimecast02.extmail.prod.ext.rdu2.redhat.com [10.11.55.18])
 by smtp.corp.redhat.com (Postfix) with ESMTPS id DECB41121319
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:56 +0000 (UTC)
Received: from us-smtp-1.mimecast.com (us-smtp-delivery-1.mimecast.com
 [207.211.31.120])
 (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
 (No client certificate requested)
 by mimecast-mx02.redhat.com (Postfix) with ESMTPS id C44C3810C2B
 for <dm-devel@redhat.com>; Mon, 28 Aug 2023 02:04:56 +0000 (UTC)
Received: from dggsgout11.his.huawei.com (dggsgout11.his.huawei.com
 [45.249.212.51]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-631-O8Yy6WVfO7aRRZ40gK7Ycg-1; Sun, 27 Aug 2023 22:04:54 -0400
X-MC-Unique: O8Yy6WVfO7aRRZ40gK7Ycg-1
Received: from mail02.huawei.com (unknown [172.30.67.169])
 by dggsgout11.his.huawei.com (SkyGuard) with ESMTP id 4RYv5F3Vjdz4f3kpV;
 Mon, 28 Aug 2023 10:04:49 +0800 (CST)
Received: from huaweicloud.com (unknown [10.175.104.67])
 by APP4 (Coremail) with SMTP id gCh0CgAnBai7AOxk9qcCBw--.25880S15;
 Mon, 28 Aug 2023 10:04:49 +0800 (CST)
From: Yu Kuai <yukuai1@huaweicloud.com>
To: agk@redhat.com, snitzer@kernel.org, dm-devel@redhat.com, song@kernel.org,
 xni@redhat.com
Date: Mon, 28 Aug 2023 10:00:04 +0800
Message-Id: <20230828020021.2489641-12-yukuai1@huaweicloud.com>
In-Reply-To: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
References: <20230828020021.2489641-1-yukuai1@huaweicloud.com>
MIME-Version: 1.0
X-CM-TRANSID: gCh0CgAnBai7AOxk9qcCBw--.25880S15
X-Coremail-Antispam: 1UD129KBjvJXoW7WF4fZrW7WFy7tw17Ary3XFb_yoW8Gry7pa
 1IqFWFvw18uFyFvF4UGr4DGFy5Ga10grWIkr9xGan5ZayrZryxGF1rWryUJrykAFyfZr43
 Jw45tw18Ar18trUanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
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
Subject: [dm-devel] [PATCH -next v2 11/28] md/raid5-cache: use new apis to
 suspend array for r5c_disable_writeback_async()
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

Convert to use new apis, the old apis will be removed eventually.

Signed-off-by: Yu Kuai <yukuai3@huawei.com>
---
 drivers/md/raid5-cache.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 889bba60d6ff..109367fec7c0 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -686,7 +686,6 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 					   disable_writeback_work);
 	struct mddev *mddev = log->rdev->mddev;
 	struct r5conf *conf = mddev->private;
-	int locked = 0;
 
 	if (log->r5c_journal_mode == R5C_JOURNAL_MODE_WRITE_THROUGH)
 		return;
@@ -696,13 +695,12 @@ static void r5c_disable_writeback_async(struct work_struct *work)
 	/* wait superblock change before suspend */
 	wait_event(mddev->sb_wait,
 		   !READ_ONCE(conf->log) ||
-		   (!test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags) &&
-		    (locked = mddev_trylock(mddev))));
-	if (locked) {
-		mddev_suspend(mddev);
+		   !test_bit(MD_SB_CHANGE_PENDING, &mddev->sb_flags));
+
+	if (READ_ONCE(conf->log)) {
+		__mddev_suspend(mddev);
 		log->r5c_journal_mode = R5C_JOURNAL_MODE_WRITE_THROUGH;
-		mddev_resume(mddev);
-		mddev_unlock(mddev);
+		__mddev_resume(mddev);
 	}
 }
 
-- 
2.39.2

--
dm-devel mailing list
dm-devel@redhat.com
https://listman.redhat.com/mailman/listinfo/dm-devel

